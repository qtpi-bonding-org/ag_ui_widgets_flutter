# `ag_ui_widgets_flutter` — First-Class, Payload-Carrying ACP Request/Response Model

**Status:** draft (opus-reviewed, two passes)
**Repos affected:** this repo (`ag_ui_widgets_flutter`), episutra (`/Users/aicoder/Documents/episutra`),
pocketcoder (`/Users/aicoder/Documents/pocketcoder`)

## Problem

`ag_ui_widgets_flutter`'s `ConversationReducer` already normalizes generic AG-UI wire events
(text, tool-call, run-lifecycle) into one canonical `Conversation`/`TimelineItem` model shared by
both consuming apps. But **permission, elicitation, and client-executed-tool requests** — concepts
AG-UI's protocol has no native vocabulary for at all (`package:ag_ui` defines zero permission/
elicitation types; confirmed by full-tree grep) — are not actually unified today. Each app's real
backend independently invented its own encoding for these, because each backend is a different
hand-rolled ACP→AG-UI bridge:

- **pocketcoder** (Go backend, bridging a real Goose/ACP connection via `acp-go-sdk`): emits
  `StateDeltaEvent`/`StateSnapshotEvent` JSON-Patch operations at paths `/pocketcoder/permission`,
  `/pocketcoder/elicitation` (`services/pocketbase/internal/agent/agui/bridge.go:108-510`,
  `state.go:58,77,91`). This is real, currently-shipped wire traffic, not a design placeholder —
  pocketcoder's Flutter client (`pocketcoder_flutter`) is already fully migrated onto
  `ag_ui_widgets_flutter` and has no fallback mechanism.
- **episutra** (Rust bridge, `episutra-frb/src/ag_ui_bridge.rs`, bridging its own ACP session via
  `agent-client-protocol` 0.11): emits generic `CustomEvent`s named `epi.permission_request` /
  `epi.tool_request`, entirely independent of pocketcoder's StateDelta convention.

The reducer today only recognizes pocketcoder's convention (`_syncPermission`/`_syncElicitation`
watching a `pocketcoder`-namespaced state key), and even there it discards the payload down to a
bare `requestId` marker (`TimelineItem.permission(requestId)`) — forcing each app to separately
re-parse the raw event stream itself to recover the payload (pocketcoder: its own
`PermissionCubit`/`ElicitationCubit`; episutra: ad hoc `CustomEvent(name: 'epi.permission_request')`
handling inside `ChatCubit._onEvent`, `chat_cubit.dart:120-135`). Net effect: episutra's mechanism
is currently **inert** — its bridge never emits the shape the reducer listens for, so
`TimelineItem.permission` is never actually constructed for episutra today; only the ad hoc payload
map gets populated, with nothing wiring it into the rendered timeline.

This spec fixes both problems at once: normalize **both** real backend conventions into one
canonical, **payload-carrying** model, so every consumer (present: pocketcoder, episutra; future:
any other ACP-backed app) gets permission/elicitation/tool-request as first-class `TimelineItem`
concepts without re-parsing anything itself.

## Scope

**In scope:**
- New payload-carrying `TimelineItem` variants for permission request, elicitation request, and
  (new) tool request — replacing today's marker-only `.permission`/`.elicitation`.
- Reducer support for **two** wire adapters feeding the same canonical variants: pocketcoder's
  existing `/pocketcoder/<ns>` StateDelta/Snapshot convention (unchanged wire format — no
  pocketcoder backend change required) and a new canonical `CustomEvent`-based convention
  (`acp.permission_request` / `acp.elicitation_request` / `acp.tool_request`) that episutra's Rust
  bridge adopts, renamed from its current app-specific `epi.*` names.
- `IAgUiTransport.submitToolResult(String callId, String resultJson)` — new method, mapping (on
  episutra's side) to the already-existing `acp_submit_mcp_tool_result` FRB call.
- `AgUiChat` builder slots updated to receive the full payload directly
  (`permissionBuilder(context, PermissionRequestPayload)`, etc.), not just a bare id.
- Coordinated updates to both apps' call sites (episutra's Rust bridge rename + `ChatCubit`
  simplification; pocketcoder's `PermissionCard`/`ElicitationCard` reading inline payload instead
  of its own cubits) as part of this spec's rollout — both repos are controlled together via the
  existing `sibling-versions.lock` pattern.

**Explicitly out of scope** (depends on this spec landing first, tracked as separate follow-up
projects, in episutra's own `docs/superpowers/specs/`):
- Migrating `NoteChatCubit`/`document_chat_section.dart` off `AgentSessionCubit`/`IAgentService`
  onto `IAgUiTransport`. That migration is what actually *uses* the new `toolRequest` concept for
  episutra's five client-executed tools (`propose_edit`, `reply_comment`, `resolve_comment`,
  `add_comment`, `render_surface`) — this spec only builds the plumbing it needs.
- The shared markdown-rendering + layout-mode (full-width-alternating vs. iMessage-bubble) message
  widget work for episutra's two chat surfaces (global chat, doc chat).
- Any change to `acp-core`/pocketcoder's Go backend's actual ACP session handling, agent selection,
  or transport resilience (reconnect/cache) machinery.

## Design

### 1. Canonical, payload-carrying `TimelineItem` variants

**Ground truth, verified against both SDKs' actual source, not assumed:** `agent-client-protocol`
(Rust, pinned by `acp-core`) and `acp-go-sdk` (Go, pinned by pocketcoder) are **field-identical** —
there is no SDK-level divergence. `RequestPermissionRequest.tool_call` is typed `ToolCallUpdate`,
whose `title`/`kind` fields are `Option<String>`/`*string` — **optional on the wire in both
languages**. There is **no `description` field anywhere in the ACP protocol**, on `ToolCall`,
`ToolCallUpdate`, or `PermissionOption`. Confirmed by reading `tool_call.rs`/`client.rs` (Rust) and
`types_gen.go` (Go) directly:

- Episutra's Rust bridge (`acp-core/src/transport/stdio.rs:809-826`) synthesizes `description` as
  `"{title}: {raw_input}"` client-side — it is not something the protocol sends.
- Pocketcoder's Go bridge (`coordinator/run.go:406-420`, `agui/bridge.go:280-290`) **drops
  `req.ToolCall.Title`/`.Kind` entirely** even though they're present on the inbound struct —
  `PermissionPending`'s own function signature doesn't accept them. This is a real, fixable
  oversight in pocketcoder's bridge code, not a protocol limitation — see rollout step 2.

Given that, only fields genuinely guaranteed by the wire protocol can be `required`; everything
else must be nullable. Replace the marker-only pair with full payload types (still a `@freezed
sealed class`, same file):

```dart
const factory TimelineItem.permissionRequest({
  required String requestId,
  String? toolTitle,        // ACP's optional `title` — human-readable, NOT a machine tool name
  String? toolKind,          // ACP's optional `kind` on ToolCallUpdate
  String? description,       // never protocol-native; present only if a bridge synthesizes one
                             // (episutra does; pocketcoder doesn't, until its bridge is fixed)
  required List<PermissionOption> options,
}) = PermissionRequestTimelineItem;

const factory TimelineItem.elicitationRequest({
  required String requestId,
  required String message,   // ACP's UnstableCreateElicitationRequest.message — always present
  required String mode,      // "form" | "url"
  Map<String, dynamic>? schema,  // present for mode == "form" — note the rename: pocketcoder's
                                  // wire key is `requestedSchema` (bridge.go:507), canonical
                                  // field here is `schema`; Adapter A does the rename on the way in
  String? url,                    // present for mode == "url"
}) = ElicitationRequestTimelineItem;

const factory TimelineItem.toolRequest({
  required String requestId,
  String? toolTitle,
  String? toolKind,
  required String argsJson,
}) = ToolRequestTimelineItem;

@freezed
abstract class PermissionOption with _$PermissionOption {
  const factory PermissionOption({
    required String optionId,
    required String label,
    required String kind,   // "allow_once" | "allow_always" | "reject_once" | "reject_always"
  }) = _PermissionOption;
}
```

`optionId`/`label`/`kind` are safe to require — all three are always present on the ACP wire
(`PermissionOption{option_id, name, kind}` in both SDKs) and both real bridges already forward all
three today (episutra renames to `{id, label, kind}`; pocketcoder passes `{optionId, name, kind}`
verbatim) — a rename-only mapping, not a missing-data problem. `toolTitle`/`toolKind`/`description`
must stay nullable: renaming episutra's `toolName` to `toolTitle` here is deliberate — it's ACP's
`title` field, not a distinct machine tool identifier, on both backends; the old name conflated the
two.

This is a breaking change to the sealed union — anywhere pattern-matching exhaustively on
`TimelineItem` (today: only inside `ag_ui_widgets_flutter` itself, per the base spec's blast-radius
check) must add the new cases. Both apps are controlled together via `sibling-versions.lock`, so
this ships as one coordinated version bump, not a staged deprecation.

### 2. Two wire adapters, one canonical model

`ConversationReducer.apply` gains recognition for both real conventions, each producing the *same*
canonical `TimelineItem` variants:

**Adapter A — pocketcoder's StateDelta/Snapshot convention:**
`_syncPermission`/`_syncElicitation` already watch `_pocketcoder['permission']`/`['elicitation']`
populated from `StateSnapshotEvent`/`StateDeltaEvent` at path `/pocketcoder/<ns>`. Elicitation's
existing payload (`{elicitationId, message, mode, requestedSchema, url?}`, `bridge.go:500-511`) is
already complete — read it straight into the new `TimelineItem.elicitationRequest`, no backend
change needed there. **Permission is not a zero-backend-change fix**, correcting the earlier draft:
`Bridge.PermissionPending(requestID string, options []acpsdk.PermissionOption, toolCallID string)`
(`bridge.go:280-290`) doesn't accept `title`/`kind` params at all, even though
`req.ToolCall.Title`/`.Kind` are sitting right there on the inbound struct at the one call site
(`coordinator/run.go:406-420`) and simply never get read. This needs a small, real change on
pocketcoder's Go side: widen `PermissionPending`'s signature to accept and forward `title *string`/
`kind *string`, update the one call site to pass `req.ToolCall.Title`/`.Kind`. Small, mechanical,
in pocketcoder's own repo — but real, not "zero."

Adapter A is inherently **single-slot per session** — `/pocketcoder/permission` is one namespace
key, overwritten on each new request, matching Goose's actual UX (one pending permission blocks
further execution). This produces at most one `permissionRequest`/`elicitationRequest` item in the
timeline at a time for a pocketcoder-backed session. That's a real, acceptable constraint of this
adapter specifically — not a limitation of the canonical model itself, which supports N concurrent
items (Adapter B does, per below). Both adapters produce ordinary list entries in the same
`timeline`; nothing else needs to know one adapter happens to only ever emit one at a time.

**Adapter B — canonical CustomEvent convention (new, episutra adopts it):**
New `apply()` cases recognizing `CustomEvent(name: 'acp.permission_request' | 'acp.elicitation_request' | 'acp.tool_request')`,
constructing the matching `TimelineItem` from `event.value`. Named `acp.*` rather than `epi.*`
because the underlying concepts (permission, tool-call) are ACP-native; elicitation is ACP's own
`Unstable*` extension (real and compiled into pocketcoder's Go SDK pin today — verified directly in
`acp-go-sdk@v0.13.5/agent_gen.go:471-475` — but not yet enabled on episutra's Rust side, see Open
Questions). `optionsJson` needs a `jsonDecode` plus a field rename (`id`→`optionId`) to match the
canonical `PermissionOption` shape — episutra's Rust bridge (`acp-core/src/transport/stdio.rs:809-826`)
renamed ACP's own `option_id`/`name` to `id`/`label` when serializing; Adapter B undoes that rename
on the way in. `description` and `toolTitle`/`toolKind` map straight across (episutra already
synthesizes/forwards them, per the corrected section above).

Two adapters, with two different cardinalities, is the honest shape here — each real backend
picked its own wire encoding *and* its own single-slot-vs-per-id modeling for a concept AG-UI
doesn't define; the reducer's job is normalizing both into one canonical, list-shaped model.

**Resolution.** The reducer gains an explicit method:

```dart
class ConversationReducer {
  // ...
  void resolveRequest(String requestId);
}
```

`_syncPermission`/`_syncElicitation` are **derived, not stored** — today's implementation
unconditionally deletes every existing `PermissionTimelineItem` and rebuilds from
`_pocketcoder['permission']` on each call (`conversation_reducer.dart:202-214`). That means calling
`resolveRequest` to remove a list entry is not enough by itself: the very next snapshot/delta
touching that namespace rebuilds the item right back, since pocketcoder's backend never clears the
namespace server-side (see below). **The resolved-id set must be consulted inside
`_syncPermission`/`_syncElicitation` themselves** — they skip rebuilding an item whose id is in the
resolved set — not merely at removal time; a `resolveRequest` that only deletes-once-and-forgets
would regress silently on the next event.

The resolved-id set must also survive `_reset()`. `apply()` calls `_reset()` on the cold-replay
marker (`conversation_reducer.dart:45-49`), which today clears every internal accumulator —
exactly the marker pocketcoder emits at the start of a reconnect replay. If the resolved-id set were
cleared along with everything else, the resurrection bug it exists to prevent would fire on every
reconnect. `_reset()` must explicitly exclude the resolved-id set (it's bounded by requests-per-
session, ids only — not a growth concern).

This is **not** pure client-side optimism papering over nothing: pocketcoder's own
`Bridge.ResolvePermission`/`ResolveElicitation` methods have **zero production callers today**
(confirmed: the only production `ResolveElicitation` call is `Coordinator.ResolveElicitation`,
`run.go:295`, which unblocks a channel and never touches the `/pocketcoder/*` projection) — the
backend never actually clears its own namespace. `resolveRequest`'s resolved-id set is therefore
load-bearing, not cosmetic, and is a workaround for a real pocketcoder backend bug (tracked in Open
Questions), not a replacement for fixing it.

**Cross-adapter isolation.** Since both adapters populate the *same* `PermissionRequestTimelineItem`/
`ElicitationRequestTimelineItem` variant, Adapter A's rebuild-from-state logic must not delete items
Adapter B produced. `_syncPermission`'s removal step must filter by adapter origin (e.g. tag each
item internally with which adapter produced it, or maintain Adapter A's own id set separately from
Adapter B's per-`callId` entries) — a same-type-predicate removal (any `is
PermissionRequestTimelineItem`) would wipe both indiscriminately. This is a direct consequence of
unifying two adapters into one variant type and must be handled explicitly, not left implicit.

### 3. `IAgUiTransport` — one new method, no signature changes to existing ones

```dart
abstract class IAgUiTransport {
  // ...existing sendMessage/cancel/respondPermission/respondElicitation/setMode/setConfigOption...
  Future<void> submitToolResult(String callId, String resultJson);
}
```

`respondPermission(callId, {optionId, cancelled})` and `respondElicitation(elicitationId, response)`
keep their current signatures from the base shared-package spec — they're already generic
(`String`/`Map<String, dynamic>` params), no change needed. `submitToolResult` is new, mapping (on
`FrbAgUiTransport`) to the already-existing `acp_submit_mcp_tool_result` FRB call
(`episutra-frb/src/api/mod.rs:322`) — confirmed as a distinct, already-generic-JSON RPC on the Rust
side, not something requiring new Rust surface.

Adding a new method to an `abstract class` interface is a breaking change for implementers — all 7
current implementers (`FrbAgUiTransport` + 6 test fakes, per the base spec's blast-radius list)
need the new override. Mechanical, in-repo, low-risk.

### 4. Builder slots receive full payload, not a bare id

```dart
class AgUiChat extends StatelessWidget {
  const AgUiChat({
    // ...
    this.permissionBuilder,   // Widget Function(BuildContext, PermissionRequestTimelineItem)
    this.elicitationBuilder,  // Widget Function(BuildContext, ElicitationRequestTimelineItem)
    this.toolRequestBuilder,  // Widget Function(BuildContext, ToolRequestTimelineItem)
                              // defaults to SizedBox.shrink() — most client-executed tools
                              // (propose_edit, reply_comment, resolve_comment, add_comment)
                              // render nothing; only render_surface-shaped tool requests need
                              // a visible builder, supplied by the consuming app.
  });
}
```

Since the reducer now carries the payload inline, both apps' separate app-side lookup mechanisms
become redundant:
- **episutra**: `ChatCubit`'s ad hoc `CustomEvent(name: 'epi.permission_request')` handling and
  `ChatState.pendingPermissions` map are deleted — the timeline item already has everything
  `permissionBuilder` needs.
- **pocketcoder**: its `PermissionCubit`/`ElicitationCubit` (if their only job is this same
  lookup-by-id bookkeeping) become candidates for deletion too — flagged here as pocketcoder's own
  follow-up decision, not mandated by this spec, since episutra doesn't own that repo's cubit
  architecture.

### 5. Naming note — why not just rename pocketcoder's wire format too

The `/pocketcoder/<ns>` StateDelta path string is pocketcoder's real, shipped Go backend
convention — renaming it would require a coordinated Go-side change for zero functional benefit
(the Dart-side adapter already isolates the naming quirk). It stays as-is, documented in the
reducer as "pocketcoder/Goose's specific state-sync convention" rather than presented as a generic
default. The new `acp.*` `CustomEvent` names are the only ones chosen fresh here, since episutra's
`epi.*` naming had no other consumer to preserve compatibility with.

## Rollout order

1. **Shared package**: add the new `TimelineItem` variants + `PermissionOption` (all with the
   nullable fields corrected above); extend `_syncElicitation` to carry full payload from the
   already-complete `/pocketcoder/elicitation` value (renaming `requestedSchema`→`schema`); extend
   `_syncPermission` similarly, reading whatever `title`/`kind` pocketcoder's bridge forwards once
   step 2 lands (nullable either way, so this doesn't need to block on step 2 landing first — it'll
   just read `null` until then); tag each produced item by adapter origin internally (Adapter A's
   rebuild-from-state removal step must never delete Adapter B's per-`callId` items, and vice
   versa — see "Cross-adapter isolation" above); add the `acp.*` `CustomEvent` recognition
   (Adapter B); add the `resolveRequest(requestId)` method, its resolved-id set consulted inside
   `_syncPermission`/`_syncElicitation` (not just at removal time), explicitly excluded from
   `_reset()`; add `submitToolResult` to `IAgUiTransport`; add `toolRequestBuilder` slot to
   `AgUiChat`. **Builder dispatch**: `AgUiChat` maintains an internal `Map<String, TimelineItem>`
   keyed by `requestId`, populated as the reducer's timeline updates, and looks up the full item by
   id when invoking `permissionBuilder`/`elicitationBuilder`/`toolRequestBuilder` — chosen over
   embedding the full item in `flutter_chat_core`'s untyped `Message.custom` metadata map, which
   would require serializing/deserializing a Freezed type through a `Map<String, dynamic>` for no
   benefit over an in-memory lookup the widget already has access to (it already holds the full
   `Conversation`/`timeline`). Update the 6 test fakes + package's own widget/reducer tests.
2. **pocketcoder**: widen `Bridge.PermissionPending`'s signature to accept and forward
   `title *string`/`kind *string` from `req.ToolCall` (`coordinator/run.go:406-420`) — a real,
   small Go change, not zero-effort as an earlier draft of this spec claimed; add production callers
   for `Bridge.ResolvePermission`/`ResolveElicitation` (currently dead code — see Open Questions)
   so the backend actually clears its namespace on resolution, rather than relying solely on the
   client-side `resolveRequest` suppression forever; update `PermissionCard`/`ElicitationCard` call
   sites to read inline payload; evaluate whether `PermissionCubit`/`ElicitationCubit` become dead
   code (pocketcoder's own call).
3. **episutra**: rename `episutra-frb/src/ag_ui_bridge.rs`'s `epi.permission_request`/
   `epi.tool_request` `CustomEvent` names to `acp.permission_request`/`acp.tool_request`; adding
   `acp.elicitation_request` requires first enabling elicitation support in episutra's Rust ACP
   stack (the earlier draft's specific claim — a Cargo feature literally named
   `unstable_elicitation` — was checked and is wrong; the mechanism for enabling it wasn't
   identified in this research and needs its own follow-up investigation, not assumed here) — not
   required for this spec's rollout, since elicitation isn't wired into episutra's ACP surface
   today regardless of feature-flag mechanics; delete `ChatCubit`'s now-redundant ad hoc
   `epi.permission_request` parsing and `pendingPermissions` map; wire
   `FrbAgUiTransport.submitToolResult` to `acp_submit_mcp_tool_result`.
4. Pin the new shared-package version in both repos' `sibling-versions.lock`-style files, gated on
   the shared package's own test suite passing at that SHA (existing discipline from the base
   spec's rollout step 3).

`NoteChatCubit` migration and the markdown/layout message-widget work remain separate, subsequent
projects that consume what this spec builds — not part of this rollout.

## Testing

- **Reducer tests** (shared package): both adapters, each producing identical canonical
  `TimelineItem` shapes from their respective wire encodings — one test matrix per concept
  (permission/elicitation/tool-request) × per adapter (pocketcoder StateDelta / canonical
  CustomEvent).
- **Widget tests** (shared package): `AgUiChat` invokes `permissionBuilder`/`elicitationBuilder`/
  `toolRequestBuilder` with the correct payload for each `TimelineItem` variant; default
  `toolRequestBuilder` renders nothing.
- **episutra**: `ChatCubit` tests updated to assert on the new canonical timeline items instead of
  `pendingPermissions`; `FrbAgUiTransport` test coverage for `submitToolResult`.
- **pocketcoder**: existing permission/elicitation UI tests re-pointed at inline payload; should be
  net simpler (removes a cubit-lookup indirection), not more complex.

## Open questions

- **How to enable elicitation on episutra's Rust ACP stack.** `agent-client-protocol` 0.11 (Rust)
  does not expose elicitation under a `unstable_elicitation` Cargo feature (that specific claim in
  an earlier draft was checked directly against the crate and is wrong) — the actual mechanism
  (newer crate version? different feature name? not exposed by the 0.11 line at all?) needs its own
  investigation before `acp.elicitation_request` has a real episutra emitter. Not blocking this
  spec: the reducer case can be added now and simply goes unused by episutra until this is resolved.
- **Pocketcoder's backend never resolves its own permission/elicitation state.**
  `Bridge.ResolvePermission`/`ResolveElicitation` have zero production callers today, discovered
  during this spec's research — meaning `/pocketcoder/permission`/`/elicitation` are never cleared
  server-side once set. This spec's client-side `resolveRequest` suppression works around that, but
  the underlying gap is a real pocketcoder bug worth its own fix (rollout step 2 includes adding
  callers, but the bug predates and is broader than this spec).
- Whether pocketcoder's `PermissionCubit`/`ElicitationCubit` should actually be deleted, once inline
  payload makes their lookup-by-id role redundant — left to pocketcoder's own maintainers/follow-up,
  not decided here.
- **Cardinality asymmetry is accepted, not resolved.** Adapter A (pocketcoder) is structurally
  single-slot-per-session; Adapter B (episutra) is per-`callId`, N-in-flight. Both feed the same
  list-shaped canonical model without conflict, but if pocketcoder's backend ever needs concurrent
  permission requests, Adapter A's single-namespace-key convention would need its own follow-up
  redesign (out of scope here — flagging so it isn't mistaken for solved).
