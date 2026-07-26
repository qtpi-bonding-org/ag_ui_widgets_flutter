# ACP Request/Response Modeling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make permission-request, elicitation-request, and tool-request first-class,
payload-carrying `TimelineItem` concepts in `ag_ui_widgets_flutter`, normalizing pocketcoder's
real Go/StateDelta wire convention and a new episutra Rust/CustomEvent convention into one
canonical model — replacing today's marker-only, effectively-inert-for-episutra design.

**Architecture:** Two "adapters" inside `ConversationReducer` (pocketcoder's existing
`/pocketcoder/<ns>` StateDelta path; a new canonical `acp.*` CustomEvent path) both populate the
same payload-carrying `TimelineItem` variants, tagged internally by origin so neither adapter's
removal logic can delete the other's items. Resolution is explicit (`resolveRequest`), not purely
event-driven, because pocketcoder's backend never clears its own state server-side today.

**Tech Stack:** Dart (Freezed sealed unions) for the shared package; small coordinated Go changes
in pocketcoder (`agent-client-protocol` via `acp-go-sdk`); small coordinated Rust changes in
episutra (`agent-client-protocol` via `acp-core`/`episutra-frb`).

## Global Constraints

- Spec: `/Users/aicoder/Documents/ag_ui_widgets_flutter/docs/superpowers/specs/2026-07-25-acp-request-response-design.md`
  — read it in full before starting; every task below implements a specific numbered section of it.
- **Three repos, coordinated but independently committed:** `ag_ui_widgets_flutter`
  (`/Users/aicoder/Documents/ag_ui_widgets_flutter`, primary — Phase 1), pocketcoder
  (`/Users/aicoder/Documents/pocketcoder` — Phase 2), episutra
  (`/Users/aicoder/Documents/episutra` — Phase 3). **Phase 1 must land and be version-pinnable
  before Phase 2/3 start** — both apps' changes depend on the new `TimelineItem` variants and
  `IAgUiTransport.submitToolResult` existing.
- **Nullable fields stay nullable.** `toolTitle`/`toolKind`/`description` on
  `PermissionRequestTimelineItem`/`ToolRequestTimelineItem` are genuinely optional on the ACP
  wire (verified against both SDKs) — never make them `required` even if it's tempting to
  simplify a builder signature.
- **No behavior change to Adapter A's wire format.** Pocketcoder's `/pocketcoder/<ns>` StateDelta
  convention is real, shipped Go backend traffic — the reducer reads more of what's already sent,
  it does not ask pocketcoder's backend to send anything differently shaped (except the one named
  `title`/`kind` addition in Phase 2, Task 9).
- **`_reset()` must exclude the resolved-id set.** This is the single most important correctness
  requirement in this plan — get it wrong and every pocketcoder reconnect resurrects resolved
  permission/elicitation cards. Task 4 has a dedicated test for this.
- Freezed codegen command for this package: `dart run build_runner build --delete-conflicting-outputs`
  (run from `/Users/aicoder/Documents/ag_ui_widgets_flutter`).
- Test command: `flutter test` (run from the same directory).

---

## Phase 1 — `ag_ui_widgets_flutter` (this repo)

### Task 1: `PermissionOption` + payload-carrying `TimelineItem` variants

**Files:**
- Modify: `lib/src/model/conversation.dart`
- Test: `test/model/conversation_test.dart`

**Interfaces:**
- Produces: `PermissionOption{optionId, label, kind}` (all required — always present on the ACP
  wire in both SDKs); `PermissionRequestTimelineItem{requestId (required), toolTitle (nullable),
  toolKind (nullable), description (nullable), options (required List<PermissionOption>)}`;
  `ElicitationRequestTimelineItem{requestId (required), message (required), mode (required),
  schema (nullable Map<String,dynamic>), url (nullable String)}`; `ToolRequestTimelineItem{requestId
  (required), toolTitle (nullable), toolKind (nullable), argsJson (required)}`.

- [ ] **Step 1: Write the failing test**

```dart
// test/model/conversation_test.dart — add to existing file
test('PermissionRequestTimelineItem allows null toolTitle/toolKind/description', () {
  const item = TimelineItem.permissionRequest(
    requestId: 'p1',
    options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
  );
  expect(item, isA<PermissionRequestTimelineItem>());
  final p = item as PermissionRequestTimelineItem;
  expect(p.toolTitle, isNull);
  expect(p.toolKind, isNull);
  expect(p.description, isNull);
  expect(p.options.single.optionId, 'allow');
});

test('ElicitationRequestTimelineItem carries message/mode/schema/url', () {
  const item = TimelineItem.elicitationRequest(
    requestId: 'e1',
    message: 'Enter a value',
    mode: 'form',
    schema: {'type': 'object'},
  );
  final e = item as ElicitationRequestTimelineItem;
  expect(e.message, 'Enter a value');
  expect(e.mode, 'form');
  expect(e.schema, {'type': 'object'});
  expect(e.url, isNull);
});

test('ToolRequestTimelineItem requires only requestId and argsJson', () {
  const item = TimelineItem.toolRequest(requestId: 't1', argsJson: '{}');
  final t = item as ToolRequestTimelineItem;
  expect(t.toolTitle, isNull);
  expect(t.argsJson, '{}');
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /Users/aicoder/Documents/ag_ui_widgets_flutter && flutter test test/model/conversation_test.dart`
Expected: FAIL — `TimelineItem.permissionRequest`/`.elicitationRequest`/`.toolRequest`/
`PermissionOption` don't exist yet.

- [ ] **Step 3: Add the new types**

In `lib/src/model/conversation.dart`, add `PermissionOption` as a new top-level `@freezed` class
(alongside `ToolDiff`), and add three new factories to the existing `TimelineItem` sealed class.
**Do not remove `TimelineItem.permission`/`.elicitation` yet** — Task 3/Task 2 replace their
producers; removing the old factories is folded into those tasks, not this one, so the reducer
keeps compiling at every intermediate step.

```dart
@freezed
abstract class PermissionOption with _$PermissionOption {
  const factory PermissionOption({
    required String optionId,
    required String label,
    required String kind,
  }) = _PermissionOption;
}
```

Add to the `TimelineItem` sealed class body (after the existing `.elicitation` factory):

```dart
  const factory TimelineItem.permissionRequest({
    required String requestId,
    String? toolTitle,
    String? toolKind,
    String? description,
    required List<PermissionOption> options,
  }) = PermissionRequestTimelineItem;

  const factory TimelineItem.elicitationRequest({
    required String requestId,
    required String message,
    required String mode,
    Map<String, dynamic>? schema,
    String? url,
  }) = ElicitationRequestTimelineItem;

  const factory TimelineItem.toolRequest({
    required String requestId,
    String? toolTitle,
    String? toolKind,
    required String argsJson,
  }) = ToolRequestTimelineItem;
```

- [ ] **Step 4: Regenerate Freezed code**

Run: `cd /Users/aicoder/Documents/ag_ui_widgets_flutter && dart run build_runner build --delete-conflicting-outputs`
Expected: `conversation.freezed.dart` regenerates with no errors.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/model/conversation_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/src/model/conversation.dart lib/src/model/conversation.freezed.dart test/model/conversation_test.dart
git commit -m "feat: add payload-carrying permission/elicitation/tool-request TimelineItem variants"
```

---

### Task 2: Adapter A (pocketcoder) — carry full elicitation payload

**Files:**
- Modify: `lib/src/model/conversation_reducer.dart`
- Test: `test/model/conversation_reducer_test.dart`

**Interfaces:**
- Consumes: `TimelineItem.elicitationRequest` from Task 1.
- Produces: `_syncElicitation()` now inserts `ElicitationRequestTimelineItem` instead of the old
  marker-only `ElicitationTimelineItem`.

Pocketcoder's real wire payload (`bridge.go:500-511`) is `{elicitationId, message, mode,
requestedSchema, url?}` — already complete, no backend change needed for this one.

- [ ] **Step 1: Write the failing test**

```dart
// test/model/conversation_reducer_test.dart — add to existing file
group('elicitation (Adapter A: pocketcoder StateDelta)', () {
  test('StateSnapshot with /pocketcoder/elicitation produces a full-payload item', () {
    final r = ConversationReducer();
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'elicitation': {
          'elicitationId': 'e1',
          'message': 'Pick a color',
          'mode': 'form',
          'requestedSchema': {'type': 'object', 'properties': {'color': {'type': 'string'}}},
        }
      }
    }));
    expect(r.current.timeline, hasLength(1));
    final item = r.current.timeline.single as ElicitationRequestTimelineItem;
    expect(item.requestId, 'e1');
    expect(item.message, 'Pick a color');
    expect(item.mode, 'form');
    expect(item.schema, {'type': 'object', 'properties': {'color': {'type': 'string'}}});
    expect(item.url, isNull);
  });

  test('url-mode elicitation carries url, no schema', () {
    final r = ConversationReducer();
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'elicitation': {
          'elicitationId': 'e2',
          'message': 'Open this link',
          'mode': 'url',
          'url': 'https://example.com/auth',
        }
      }
    }));
    final item = r.current.timeline.single as ElicitationRequestTimelineItem;
    expect(item.mode, 'url');
    expect(item.url, 'https://example.com/auth');
    expect(item.schema, isNull);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: FAIL — old `_syncElicitation` only produces marker-only `ElicitationTimelineItem`, not
`ElicitationRequestTimelineItem`.

- [ ] **Step 3: Update `_syncElicitation`**

Replace the existing `_syncElicitation` method body in `conversation_reducer.dart`:

```dart
  void _syncElicitation() {
    _removeAdapterAItemsWhere((item) => item is ElicitationRequestTimelineItem);
    final elicitation = _pocketcoder['elicitation'];
    if (elicitation is! Map) return;
    final requestId = elicitation['elicitationId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    final message = elicitation['message'] as String? ?? '';
    final mode = elicitation['mode'] as String? ?? 'form';
    final schema = elicitation['requestedSchema'];
    final url = elicitation['url'] as String?;
    _insertTimelineItem(
      _timeline.length,
      TimelineItem.elicitationRequest(
        requestId: requestId,
        message: message,
        mode: mode,
        schema: schema is Map ? Map<String, dynamic>.from(schema) : null,
        url: url,
      ),
    );
  }
```

Note: `_removeAdapterAItemsWhere` and `_resolvedIds` don't exist yet — they're introduced in
Task 3 and Task 4 respectively. **This step alone will not compile.** Do Steps 3 of Task 2, Task 3,
and Task 4 as one combined edit before running codegen/tests, OR (simpler for a fresh
implementer) do this task's Step 3 as a temporary `_removeTimelineItemsWhere((item) => item is
ElicitationRequestTimelineItem)` and `if (false)` placeholder-free stand-in using the *existing*
private helper name, then let Task 3 rename it. Concretely: for this task only, write:

```dart
  void _syncElicitation() {
    _removeTimelineItemsWhere((item) => item is ElicitationRequestTimelineItem);
    final elicitation = _pocketcoder['elicitation'];
    if (elicitation is! Map) return;
    final requestId = elicitation['elicitationId'];
    if (requestId is! String) return;
    final message = elicitation['message'] as String? ?? '';
    final mode = elicitation['mode'] as String? ?? 'form';
    final schema = elicitation['requestedSchema'];
    final url = elicitation['url'] as String?;
    _insertTimelineItem(
      _timeline.length,
      TimelineItem.elicitationRequest(
        requestId: requestId,
        message: message,
        mode: mode,
        schema: schema is Map ? Map<String, dynamic>.from(schema) : null,
        url: url,
      ),
    );
  }
```

using the existing `_removeTimelineItemsWhere` helper already defined lower in the file — this
compiles standalone. Task 3 and Task 4 layer the adapter-tagging and resolved-id check on top.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: PASS (both new tests; existing tests in the file must still pass too — run the whole
file, not a filtered subset).

- [ ] **Step 5: Commit**

```bash
git add lib/src/model/conversation_reducer.dart test/model/conversation_reducer_test.dart
git commit -m "feat: Adapter A elicitation carries full payload (message/mode/schema/url)"
```

---

### Task 3: Adapter A (pocketcoder) — carry full permission payload + adapter-origin tagging

**Files:**
- Modify: `lib/src/model/conversation_reducer.dart`
- Test: `test/model/conversation_reducer_test.dart`

**Interfaces:**
- Consumes: `TimelineItem.permissionRequest` from Task 1.
- Produces: `_syncPermission()` inserts `PermissionRequestTimelineItem`; introduces
  `_removeAdapterAItemsWhere(predicate)` — a rename/generalization of the plain
  `_removeTimelineItemsWhere` used specifically for Adapter A's rebuild-from-state removal, so it
  can be told apart from Adapter B's per-`callId` items (added in Task 5). Concretely: track which
  `requestId`s were inserted by Adapter A in a `Set<String> _adapterAIds`, and have
  `_removeAdapterAItemsWhere` filter by `_adapterAIds.contains(item.requestId)` in addition to the
  type check, so it never touches an item Adapter B (Task 5) produced for a different `requestId`.

Pocketcoder's real wire payload today is `{requestId, status, options: [{optionId, name, kind}],
toolCallId?}` — **no `toolName`/`description`** (verified against `bridge.go:280-290`). This task
reads whatever is available now (nothing beyond `toolCallId`→ nowhere useful to map, since ACP's
`title`/`kind` aren't in pocketcoder's payload until Phase 2 Task 9 lands) — `toolTitle`/`toolKind`
will be `null` until then. Do not treat that as a bug in this task; it's the documented
nullable-field behavior.

- [ ] **Step 1: Write the failing test**

```dart
group('permission (Adapter A: pocketcoder StateDelta)', () {
  test('StateSnapshot with /pocketcoder/permission produces a full-payload item (toolTitle null today)', () {
    final r = ConversationReducer();
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'permission': {
          'requestId': 'p1',
          'status': 'pending',
          'options': [
            {'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'},
            {'optionId': 'deny', 'name': 'Deny', 'kind': 'reject_once'},
          ],
        }
      }
    }));
    expect(r.current.timeline, hasLength(1));
    final item = r.current.timeline.single as PermissionRequestTimelineItem;
    expect(item.requestId, 'p1');
    expect(item.toolTitle, isNull); // pocketcoder doesn't send this yet (Phase 2, Task 9)
    expect(item.description, isNull); // never an ACP wire field
    expect(item.options, hasLength(2));
    expect(item.options[0].optionId, 'allow');
    expect(item.options[0].label, 'Allow');
    expect(item.options[0].kind, 'allow_once');
  });

  test('once pocketcoder forwards title/kind (Phase 2), the adapter reads them', () {
    final r = ConversationReducer();
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'permission': {
          'requestId': 'p2',
          'status': 'pending',
          'title': 'Run shell command',
          'kind': 'execute',
          'options': [
            {'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'},
          ],
        }
      }
    }));
    final item = r.current.timeline.single as PermissionRequestTimelineItem;
    expect(item.toolTitle, 'Run shell command');
    expect(item.toolKind, 'execute');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: FAIL

- [ ] **Step 3: Replace `_syncPermission`**

```dart
  final Set<String> _adapterAIds = {};

  void _removeAdapterAItemsWhere(bool Function(TimelineItem) test) {
    _removeTimelineItemsWhere((item) {
      final id = switch (item) {
        PermissionRequestTimelineItem(:final requestId) => requestId,
        ElicitationRequestTimelineItem(:final requestId) => requestId,
        _ => null,
      };
      return test(item) && id != null && _adapterAIds.contains(id);
    });
  }

  void _syncPermission() {
    _removeAdapterAItemsWhere((item) => item is PermissionRequestTimelineItem);
    final permission = _pocketcoder['permission'];
    if (permission is! Map) return;
    final requestId = permission['requestId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    final options = (permission['options'] as List? ?? const [])
        .whereType<Map>()
        .map((o) => PermissionOption(
              optionId: (o['optionId'] as String?) ?? '',
              label: (o['name'] as String?) ?? '',
              kind: (o['kind'] as String?) ?? '',
            ))
        .toList();
    final toolCallId = permission['toolCallId'];
    final toolIdx = toolCallId is String ? _toolTimelineIndex[toolCallId] : null;
    _adapterAIds.add(requestId);
    _insertTimelineItem(
      toolIdx != null ? toolIdx + 1 : _timeline.length,
      TimelineItem.permissionRequest(
        requestId: requestId,
        toolTitle: permission['title'] as String?,
        toolKind: permission['kind'] as String?,
        options: options,
      ),
    );
  }
```

Also update Task 2's `_syncElicitation` to call `_removeAdapterAItemsWhere` instead of the plain
`_removeTimelineItemsWhere`, and add `_adapterAIds.add(requestId);` before its `_insertTimelineItem`
call, for symmetry (both adapter-A producers must register their ids in `_adapterAIds`).

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: PASS. `_resolvedIds` doesn't exist yet (added in Task 4) — for this task, temporarily
stub it as `final Set<String> _resolvedIds = {};` (an always-empty set) so the file compiles; Task
4 replaces the stub with the real resolved-id tracking and its `_reset()` exclusion.

- [ ] **Step 5: Commit**

```bash
git add lib/src/model/conversation_reducer.dart test/model/conversation_reducer_test.dart
git commit -m "feat: Adapter A permission carries full payload + adapter-origin tagging"
```

---

### Task 4: `resolveRequest` + resolved-id set excluded from `_reset()`

**Files:**
- Modify: `lib/src/model/conversation_reducer.dart`
- Test: `test/model/conversation_reducer_test.dart`

**Interfaces:**
- Produces: `ConversationReducer.resolveRequest(String requestId)` — public method. Removes the
  matching `PermissionRequestTimelineItem`/`ElicitationRequestTimelineItem`/`ToolRequestTimelineItem`
  from the timeline and adds `requestId` to the (previously stubbed) `_resolvedIds` set, which
  `_syncPermission`/`_syncElicitation` now check before rebuilding, and which `_reset()` must NOT
  clear.

This is the fix for the resurrection bug found during spec research: pocketcoder's backend never
clears `/pocketcoder/permission` server-side, and replays its whole cached event log (including a
fresh `StateSnapshotEvent`) on reconnect — without this, a resolved card reappears on every
reconnect.

- [ ] **Step 1: Write the failing test**

```dart
group('resolveRequest', () {
  test('resolving a permission removes it and a later replay of the same state does not resurrect it', () {
    final r = ConversationReducer();
    final snapshot = const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'permission': {
          'requestId': 'p1',
          'status': 'pending',
          'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
        }
      }
    });
    r.apply(snapshot);
    expect(r.current.timeline, hasLength(1));

    r.resolveRequest('p1');
    expect(r.current.timeline, isEmpty);

    // Simulate pocketcoder replaying the exact same StateSnapshot (backend
    // never clears its own namespace) — the resolved item must not come back.
    r.apply(snapshot);
    expect(r.current.timeline, isEmpty);
  });

  test('resolved-id set survives the cold-replay reset marker', () {
    final r = ConversationReducer();
    final snapshot = const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'elicitation': {'elicitationId': 'e1', 'message': 'm', 'mode': 'form'}
      }
    });
    r.apply(snapshot);
    r.resolveRequest('e1');
    expect(r.current.timeline, isEmpty);

    // Reconnect replay: cold-replay marker, then the same snapshot again.
    r.apply(const CustomEvent(name: 'pocketcoder:sync', value: {'mode': 'replace'}));
    r.apply(snapshot);
    expect(r.current.timeline, isEmpty,
        reason: 'resolved-id set must survive _reset(), or reconnect resurrects resolved items');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: FAIL — `resolveRequest` doesn't exist; `_resolvedIds` is still the always-empty stub
from Task 3, so the first test's second `r.apply(snapshot)` resurrects the item (timeline is not
empty), failing the assertion.

- [ ] **Step 3: Implement `resolveRequest` and fix `_reset()`**

Replace the Task 3 stub `final Set<String> _resolvedIds = {};` with a real, mutable field, and add
the public method. Also update `_reset()` to explicitly NOT clear it:

```dart
  final Set<String> _resolvedIds = {};

  /// Resolves a pending permission/elicitation/tool-request: removes it from
  /// the timeline immediately, and remembers it as resolved so a later
  /// replay of the same backend state (pocketcoder's backend never clears
  /// its own /pocketcoder/<ns> namespace server-side — see the design spec's
  /// "Resolution" section) does not resurrect it. Survives `_reset()`
  /// deliberately — see that method.
  void resolveRequest(String requestId) {
    _resolvedIds.add(requestId);
    _removeTimelineItemsWhere((item) => switch (item) {
          PermissionRequestTimelineItem(:final requestId2) => requestId2 == requestId,
          ElicitationRequestTimelineItem(:final requestId2) => requestId2 == requestId,
          ToolRequestTimelineItem(:final requestId2) => requestId2 == requestId,
          _ => false,
        });
    _adapterAIds.remove(requestId);
  }
```

(Rename the pattern-matched field to avoid shadowing the method parameter — use `:final requestId`
inside each case's own scope is fine in Dart since each `case` introduces its own binding; if your
Dart version complains about shadowing, bind as `requestId: final rid` and compare `rid ==
requestId` instead.)

In `_reset()` (the existing method that runs on the `pocketcoder:sync` replace marker), do **not**
add `_resolvedIds.clear()` — every other accumulator (`_timeline`, `_pocketcoder`, `_adapterAIds`,
etc.) gets cleared there; `_resolvedIds` must be the one exception. Add a one-line comment at the
top of `_reset()`:

```dart
  void _reset() {
    // _resolvedIds is deliberately NOT cleared here — see resolveRequest's
    // doc comment. Clearing it would resurrect already-resolved
    // permission/elicitation/tool-request cards on every pocketcoder
    // reconnect replay, since the backend never clears its own state.
    _timeline.clear();
    // ...existing clears...
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: PASS — including all tests from Tasks 1–3, which must still pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/model/conversation_reducer.dart test/model/conversation_reducer_test.dart
git commit -m "feat: add resolveRequest, exclude resolved-id set from _reset()"
```

---

### Task 5: Adapter B — canonical `acp.*` CustomEvent convention

**Files:**
- Modify: `lib/src/model/conversation_reducer.dart`
- Test: `test/model/conversation_reducer_test.dart`

**Interfaces:**
- Produces: `apply()` recognizes `CustomEvent(name: 'acp.permission_request')`,
  `'acp.elicitation_request'`, `'acp.tool_request'`, each inserting the matching payload-carrying
  `TimelineItem`, keyed by `callId`/`requestId` from `event.value` — independent per-id, N
  concurrent items supported (no single-slot constraint, unlike Adapter A).

`acp.permission_request`'s `optionsJson` is a **JSON-encoded string** whose elements are
`{id, label, kind}` (episutra's Rust bridge renames ACP's own `option_id`/`name` — see spec
section 2) — this adapter must `jsonDecode` it and map `id`→`optionId`.

- [ ] **Step 1: Write the failing test**

```dart
group('permission/elicitation/tool-request (Adapter B: canonical CustomEvent)', () {
  test('acp.permission_request decodes optionsJson and remaps id->optionId', () {
    final r = ConversationReducer();
    r.apply(const CustomEvent(name: 'acp.permission_request', value: {
      'callId': 'p1',
      'toolName': 'bash',
      'description': 'bash: run ls',
      'optionsJson': '[{"id":"allow","label":"Allow","kind":"allow_once"}]',
    }));
    expect(r.current.timeline, hasLength(1));
    final item = r.current.timeline.single as PermissionRequestTimelineItem;
    expect(item.requestId, 'p1');
    expect(item.toolTitle, 'bash');
    expect(item.description, 'bash: run ls');
    expect(item.options.single.optionId, 'allow');
    expect(item.options.single.label, 'Allow');
  });

  test('acp.tool_request produces a ToolRequestTimelineItem', () {
    final r = ConversationReducer();
    r.apply(const CustomEvent(name: 'acp.tool_request', value: {
      'callId': 't1',
      'toolName': 'propose_edit',
      'args': '{"changeId":"c1"}',
    }));
    final item = r.current.timeline.single as ToolRequestTimelineItem;
    expect(item.requestId, 't1');
    expect(item.toolTitle, 'propose_edit');
    expect(item.argsJson, '{"changeId":"c1"}');
  });

  test('Adapter B items are independent of Adapter A — resolving one A item does not touch a B item', () {
    final r = ConversationReducer();
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'permission': {
          'requestId': 'a1', 'status': 'pending',
          'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
        }
      }
    }));
    r.apply(const CustomEvent(name: 'acp.permission_request', value: {
      'callId': 'b1', 'toolName': 'x', 'description': 'x', 'optionsJson': '[]',
    }));
    expect(r.current.timeline, hasLength(2));

    // A fresh StateSnapshot rebuild (Adapter A's normal behavior) must not
    // wipe Adapter B's b1 item.
    r.apply(const StateSnapshotEvent(snapshot: {
      'pocketcoder': {
        'permission': {
          'requestId': 'a1', 'status': 'pending',
          'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
        }
      }
    }));
    expect(r.current.timeline, hasLength(2));
    expect(r.current.timeline.any((i) => i is PermissionRequestTimelineItem && i.requestId == 'b1'),
        isTrue);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: FAIL — `apply()` has no case for `acp.*` CustomEvents yet (they fall through to
`default: break`).

- [ ] **Step 3: Add the new `apply()` cases**

In `conversation_reducer.dart`'s `apply()` method, add before the existing
`case ag_ui.CustomEvent(name: 'pocketcoder:diff')` case:

```dart
      case ag_ui.CustomEvent(name: 'acp.permission_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            final optionsJson = value['optionsJson'] as String? ?? '[]';
            final rawOptions = jsonDecode(optionsJson);
            final options = (rawOptions is List ? rawOptions : const [])
                .whereType<Map>()
                .map((o) => PermissionOption(
                      optionId: (o['id'] as String?) ?? '',
                      label: (o['label'] as String?) ?? '',
                      kind: (o['kind'] as String?) ?? '',
                    ))
                .toList();
            _insertTimelineItem(
              _timeline.length,
              TimelineItem.permissionRequest(
                requestId: callId,
                toolTitle: value['toolName'] as String?,
                description: value['description'] as String?,
                options: options,
              ),
            );
          }
        }
      case ag_ui.CustomEvent(name: 'acp.elicitation_request', :final value):
        if (value is Map) {
          final requestId = value['requestId'];
          if (requestId is String) {
            _insertTimelineItem(
              _timeline.length,
              TimelineItem.elicitationRequest(
                requestId: requestId,
                message: (value['message'] as String?) ?? '',
                mode: (value['mode'] as String?) ?? 'form',
                schema: value['schema'] is Map
                    ? Map<String, dynamic>.from(value['schema'] as Map)
                    : null,
                url: value['url'] as String?,
              ),
            );
          }
        }
      case ag_ui.CustomEvent(name: 'acp.tool_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            _insertTimelineItem(
              _timeline.length,
              TimelineItem.toolRequest(
                requestId: callId,
                toolTitle: value['toolName'] as String?,
                argsJson: (value['args'] as String?) ?? '{}',
              ),
            );
          }
        }
```

Add `import 'dart:convert';` to the top of `conversation_reducer.dart` for `jsonDecode`.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/model/conversation_reducer_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/model/conversation_reducer.dart test/model/conversation_reducer_test.dart
git commit -m "feat: Adapter B canonical acp.* CustomEvent recognition"
```

---

### Task 6: `IAgUiTransport.submitToolResult`

**Files:**
- Modify: `lib/src/transport/ag_ui_transport.dart`
- Test: none in this package (interface only — no impl lives here). Both apps' fakes are updated
  in Phase 2/3.

**Interfaces:**
- Produces: `Future<void> submitToolResult(String callId, String resultJson);` added to
  `IAgUiTransport`.

- [ ] **Step 1: Add the method to the interface**

```dart
abstract class IAgUiTransport {
  Stream<BaseEvent> get events;
  Future<void> sendMessage(String text);
  Future<void> cancel();
  Future<void> respondPermission(String callId, {String? optionId, bool cancelled = false});
  Future<void> respondElicitation(String elicitationId, Map<String, dynamic> response);
  Future<void> submitToolResult(String callId, String resultJson);
  Future<void> setMode(String modeId);
  Future<void> setConfigOption(String optionId, String value);
  Future<void> dispose();
}
```

- [ ] **Step 2: Run the package's full test suite**

Run: `flutter test`
Expected: PASS (no in-package implementers of `IAgUiTransport` exist to break — this is a pure
interface addition; downstream breakage in episutra/pocketcoder is expected and handled in
Phase 2/3).

- [ ] **Step 3: Commit**

```bash
git add lib/src/transport/ag_ui_transport.dart
git commit -m "feat: add submitToolResult to IAgUiTransport"
```

---

### Task 7: `AgUiChat` — `toolRequestBuilder` slot + id→item builder dispatch

**Files:**
- Modify: `lib/src/widgets/timeline_to_messages.dart`
- Modify: `lib/src/widgets/ag_ui_chat.dart`
- Test: `test/widgets/timeline_to_messages_test.dart`, `test/widgets/ag_ui_chat_test.dart`

**Interfaces:**
- Consumes: `PermissionRequestTimelineItem`/`ElicitationRequestTimelineItem`/
  `ToolRequestTimelineItem` from Tasks 1–5.
- Produces: `AgUiChat.permissionBuilder`/`elicitationBuilder` change signature from
  `Widget Function(BuildContext, String requestId)` to
  `Widget Function(BuildContext, TimelineItem item)` (callers downcast to the specific variant
  they expect); new `toolRequestBuilder` slot, default `SizedBox.shrink()`.

**Builder dispatch mechanism (per spec section "Builder dispatch"):** `AgUiChat` maintains an
internal `Map<String, TimelineItem> _itemsById`, rebuilt from `widget.conversation.timeline`
whenever it changes, and looks up the full item by id when invoking these three builders — chosen
over embedding the full item in `flutter_chat_core`'s untyped `Message.custom` metadata.

- [ ] **Step 1: Update `timeline_to_messages.dart`'s custom-message metadata**

Replace the `PermissionTimelineItem`/`ElicitationTimelineItem` cases in `_toMessage` with cases for
the new variants (still id-only in the `Message.custom` metadata — the full item comes from
`AgUiChat`'s own lookup map, not from this metadata):

```dart
    PermissionRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'permissionRequest'},
      ),
    ElicitationRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'elicitationRequest'},
      ),
    ToolRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'toolRequest'},
      ),
```

Remove the old `PermissionTimelineItem`/`ElicitationTimelineItem` cases entirely (Task 1 kept the
old factories only so intermediate steps compiled — this is where they stop being produced; if any
other file still constructs `TimelineItem.permission`/`.elicitation` directly, remove those call
sites too, there should be none left after Tasks 2/3/5).

- [ ] **Step 2: Write the failing widget test**

```dart
// test/widgets/ag_ui_chat_test.dart — add to existing file
testWidgets('permissionBuilder receives the full TimelineItem, not just an id', (tester) async {
  PermissionRequestTimelineItem? received;
  const conversation = Conversation(timeline: [
    TimelineItem.permissionRequest(
      requestId: 'p1',
      toolTitle: 'bash',
      options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
    ),
  ]);
  await tester.pumpWidget(MaterialApp(
    home: AgUiChat(
      conversation: conversation,
      currentUserId: 'user',
      onSendMessage: (_) {},
      permissionBuilder: (context, item) {
        received = item as PermissionRequestTimelineItem;
        return const SizedBox.shrink();
      },
    ),
  ));
  await tester.pumpAndSettle();
  expect(received?.requestId, 'p1');
  expect(received?.toolTitle, 'bash');
});

testWidgets('toolRequestBuilder defaults to rendering nothing', (tester) async {
  const conversation = Conversation(timeline: [
    TimelineItem.toolRequest(requestId: 't1', argsJson: '{}'),
  ]);
  await tester.pumpWidget(MaterialApp(
    home: AgUiChat(conversation: conversation, currentUserId: 'user', onSendMessage: (_) {}),
  ));
  await tester.pumpAndSettle();
  expect(find.byType(SizedBox), findsWidgets); // default SizedBox.shrink renders, no crash
});
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/widgets/ag_ui_chat_test.dart`
Expected: FAIL — `permissionBuilder`'s current signature takes `String requestId`, not
`TimelineItem`; `toolRequestBuilder` doesn't exist.

- [ ] **Step 4: Update `AgUiChat`**

```dart
class AgUiChat extends StatefulWidget {
  const AgUiChat({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onSendMessage,
    this.textMessageBuilder,
    this.toolCallBuilder,
    this.permissionBuilder,
    this.elicitationBuilder,
    this.toolRequestBuilder,
    this.composerBuilder,
  });

  final Conversation conversation;
  final String currentUserId;
  final void Function(String text) onSendMessage;
  final chat_core.TextMessageBuilder? textMessageBuilder;
  final CustomCardBuilder? toolCallBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? permissionBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? elicitationBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? toolRequestBuilder;
  final WidgetBuilder? composerBuilder;

  @override
  State<AgUiChat> createState() => _AgUiChatState();
}
```

In `_AgUiChatState`, add the lookup map and use it in the `customMessageBuilder` switch:

```dart
  Map<String, TimelineItem> _itemsById = {};

  void _syncMessages() {
    _controller.setMessages(timelineToMessages(widget.conversation.timeline));
    _itemsById = {
      for (final item in widget.conversation.timeline)
        if (item case PermissionRequestTimelineItem(:final requestId) ||
            ElicitationRequestTimelineItem(:final requestId) ||
            ToolRequestTimelineItem(:final requestId))
          requestId: item,
    };
  }
```

(If Dart's or-pattern extraction across different variant types isn't available in the project's
SDK constraint, build the map with an explicit `switch` expression per item instead — same result,
just more verbose; check the `sdk: ^3.5.0` constraint in `pubspec.yaml` for or-pattern support
before choosing.)

Update the `customMessageBuilder` switch inside `build()`:

```dart
        customMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) {
          switch (message.metadata?['kind']) {
            case 'toolCall':
              return (widget.toolCallBuilder ?? defaultToolCallBuilder)(
                  context, message, index, isSentByMe: isSentByMe, groupStatus: groupStatus);
            case 'permissionRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.permissionBuilder?.call(context, item) ?? const SizedBox.shrink();
            case 'elicitationRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.elicitationBuilder?.call(context, item) ?? const SizedBox.shrink();
            case 'toolRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.toolRequestBuilder?.call(context, item) ?? const SizedBox.shrink();
            default:
              return const SizedBox.shrink();
          }
        },
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/widgets/ag_ui_chat_test.dart test/widgets/timeline_to_messages_test.dart`
Expected: PASS. Update any existing tests in these two files that still reference the old
`permissionBuilder(context, String requestId)` signature or `'permission'`/`'elicitation'` metadata
kind strings.

- [ ] **Step 6: Run the full package test suite**

Run: `flutter test`
Expected: PASS, all files.

- [ ] **Step 7: Commit**

```bash
git add lib/src/widgets/ag_ui_chat.dart lib/src/widgets/timeline_to_messages.dart test/widgets/
git commit -m "feat: AgUiChat builders receive full TimelineItem; add toolRequestBuilder"
```

---

### Task 8: Bump package version, update `CHANGELOG.md`

**Files:**
- Modify: `pubspec.yaml` (version field)
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Bump version**

Bump `version: 0.1.0` to `version: 0.2.0` in `pubspec.yaml` (breaking change to the sealed
`TimelineItem` union and `IAgUiTransport` interface — both consumers must update in lockstep, per
`sibling-versions.lock` discipline).

- [ ] **Step 2: Add changelog entry**

```markdown
## 0.2.0

- **Breaking:** `TimelineItem.permission`/`.elicitation` replaced by payload-carrying
  `.permissionRequest`/`.elicitationRequest`; new `.toolRequest` variant.
- **Breaking:** `AgUiChat.permissionBuilder`/`.elicitationBuilder` now receive the full
  `TimelineItem`, not a bare `requestId`. New `toolRequestBuilder` slot (default: renders nothing).
- **Breaking:** `IAgUiTransport` gains `submitToolResult(callId, resultJson)`.
- New: `ConversationReducer.resolveRequest(requestId)` for explicit resolution, safe against
  backend state that's never cleared server-side.
- New: canonical `acp.permission_request`/`acp.elicitation_request`/`acp.tool_request`
  `CustomEvent` recognition, alongside pocketcoder's existing `/pocketcoder/<ns>` StateDelta
  convention — both feed the same canonical model.
```

- [ ] **Step 3: Run full test suite one last time**

Run: `flutter test`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: bump to 0.2.0 for ACP request/response model"
```

---

## Phase 2 — pocketcoder (`/Users/aicoder/Documents/pocketcoder`)

**Precondition:** Phase 1 committed and pinned in pocketcoder's dependency (update its
`ag_ui_widgets_flutter` git pin to Phase 1's final commit before starting).

### Task 9: Forward `title`/`kind` through `PermissionPending`

**Files:**
- Modify: `services/pocketbase/internal/agent/agui/bridge.go`
- Modify: `services/pocketbase/internal/agent/coordinator/run.go`
- Test: existing Go tests for `Bridge.PermissionPending` (find via
  `grep -rn "PermissionPending" services/pocketbase/internal/agent/agui/*_test.go`)

- [ ] **Step 1: Widen `PermissionPending`'s signature**

In `bridge.go`, change:

```go
func (b *Bridge) PermissionPending(requestID string, options []acpsdk.PermissionOption, toolCallID string) events.Event {
	choices := make([]map[string]string, 0, len(options))
	for _, option := range options {
		choices = append(choices, map[string]string{"optionId": string(option.OptionId), "name": option.Name, "kind": string(option.Kind)})
	}
	payload := map[string]any{"requestId": requestID, "status": "pending", "options": choices}
	if toolCallID != "" {
		payload["toolCallId"] = toolCallID
	}
	return b.state.set("permission", payload)
}
```

to:

```go
func (b *Bridge) PermissionPending(requestID string, options []acpsdk.PermissionOption, toolCallID string, title *string, kind *acpsdk.ToolKind) events.Event {
	choices := make([]map[string]string, 0, len(options))
	for _, option := range options {
		choices = append(choices, map[string]string{"optionId": string(option.OptionId), "name": option.Name, "kind": string(option.Kind)})
	}
	payload := map[string]any{"requestId": requestID, "status": "pending", "options": choices}
	if toolCallID != "" {
		payload["toolCallId"] = toolCallID
	}
	if title != nil {
		payload["title"] = *title
	}
	if kind != nil {
		payload["kind"] = string(*kind)
	}
	return b.state.set("permission", payload)
}
```

- [ ] **Step 2: Update the one call site**

In `run.go`, change:

```go
	_ = s.emit(s.bridge.PermissionPending(id, req.Options, string(req.ToolCall.ToolCallId)))
```

to:

```go
	_ = s.emit(s.bridge.PermissionPending(id, req.Options, string(req.ToolCall.ToolCallId), req.ToolCall.Title, req.ToolCall.Kind))
```

- [ ] **Step 3: Update existing Go tests**

Find every existing call site of `PermissionPending(` in `*_test.go` files under
`services/pocketbase/internal/agent/agui/` and `.../coordinator/` and add the two new trailing
arguments (`nil, nil` for tests that don't care about title/kind; real values for any test
asserting on the payload shape). At minimum this means three known call sites in
`bridge_test.go`: `TestBridgePermissionState` (line 36), `TestBridgePermissionStateCarriesToolCallID`
(lines 56 and 64 — it calls `PermissionPending` twice), and `TestBridgeSnapshotOmitsResolvedPermission`
(line 502) — the grep may turn up others; update all of them, not just these three. Add one new
test asserting the new fields appear:

Existing tests in `bridge_test.go` (`TestBridgePermissionState`,
`TestBridgePermissionStateCarriesToolCallID`) call `bridge.PermissionPending("rpc-42", nil, "")`,
`json.Marshal(event)`, and assert on substrings of the marshalled JSON via `strings.Contains` —
match that exact style, not a new assertion helper:

```go
func TestBridgePermissionStateIncludesTitleAndKind(t *testing.T) {
	bridge := NewBridge("chat-1", "run-1")
	title := "Run shell command"
	kind := acpsdk.ToolKindExecute
	event := bridge.PermissionPending("rpc-42", nil, "", &title, &kind)
	b, err := json.Marshal(event)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(b), `"title":"Run shell command"`) {
		t.Fatalf("permission event missing title: %s", b)
	}
	if !strings.Contains(string(b), `"kind":"execute"`) {
		t.Fatalf("permission event missing kind: %s", b)
	}

	// nil title/kind: keys must be absent, not present-as-empty (same
	// no-op-on-absent contract TestBridgePermissionStateCarriesToolCallID
	// already established for toolCallId).
	event2 := bridge.PermissionPending("rpc-43", nil, "", nil, nil)
	b2, err := json.Marshal(event2)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(b2), `"title"`) || strings.Contains(string(b2), `"kind"`) {
		t.Fatalf("permission event should omit title/kind when nil: %s", b2)
	}
}
```

Also update the two existing tests' `PermissionPending(...)` calls (`TestBridgePermissionState`,
`TestBridgePermissionStateCarriesToolCallID`) to pass the two new trailing `nil, nil` arguments —
they don't assert on title/kind, so `nil, nil` preserves their existing behavior unchanged.

- [ ] **Step 4: Run the Go test suite**

Run: `cd /Users/aicoder/Documents/pocketcoder/services/pocketbase && go test ./internal/agent/...`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd /Users/aicoder/Documents/pocketcoder
git add services/pocketbase/internal/agent/agui/bridge.go services/pocketbase/internal/agent/coordinator/run.go services/pocketbase/internal/agent/agui/*_test.go
git commit -m "feat: forward ToolCall.Title/.Kind through PermissionPending"
```

---

### Task 10: Add production callers for `ResolvePermission`/`ResolveElicitation`

**Files:**
- Modify: `services/pocketbase/internal/agent/coordinator/run.go`

**Context:** discovered during spec research — `Bridge.ResolvePermission`/`ResolveElicitation` have
zero production callers today; the backend never clears its own `/pocketcoder/<ns>` state. The
Dart-side `resolveRequest` (Phase 1, Task 4) works around this client-side, but the underlying
backend gap should be fixed too, not left permanently reliant on the client-side workaround.

- [ ] **Step 1: Call `ResolvePermission` after a permission decision resolves**

In `run.go`'s `RequestPermission` method, after the `select` block resolves (both the `d :=
<-p.decision` and `<-ctx.Done()` branches, right before each `return`), emit the resolve event:

`s.emit` is typed `Emit func(events.Event) error` (`run.go:49,349`) — one event per call, not
variadic. `ResolvePermission`/`ResolveElicitation` return `[]events.Event`. This file already has
exactly the right helper for that mismatch: `emitAll(emit Emit, values []events.Event) error`
(`run.go:563`). Use it:

```go
	select {
	case d := <-p.decision:
		s.emitMu.Lock()
		_ = emitAll(s.emit, s.bridge.ResolvePermission(id))
		s.emitMu.Unlock()
		if d.cancelled {
			return acpsdk.RequestPermissionResponse{Outcome: acpsdk.RequestPermissionOutcome{Cancelled: &acpsdk.RequestPermissionOutcomeCancelled{Outcome: "cancelled"}}}, nil
		}
		return acpsdk.RequestPermissionResponse{Outcome: acpsdk.RequestPermissionOutcome{Selected: &acpsdk.RequestPermissionOutcomeSelected{Outcome: "selected", OptionId: acpsdk.PermissionOptionId(d.option)}}}, nil
	case <-ctx.Done():
		s.removePending(id, p)
		s.emitMu.Lock()
		_ = emitAll(s.emit, s.bridge.ResolvePermission(id))
		s.emitMu.Unlock()
		return acpsdk.RequestPermissionResponse{Outcome: acpsdk.RequestPermissionOutcome{Cancelled: &acpsdk.RequestPermissionOutcomeCancelled{Outcome: "cancelled"}}}, nil
	}
```

- [ ] **Step 2: Call `ResolveElicitation` after an elicitation decision resolves**

Same pattern in `UnstableCreateElicitation`'s `select` block (both branches — the decision branch
and the `<-ctx.Done()` branch), replacing `s.bridge.ResolvePermission(id)` with
`s.bridge.ResolveElicitation(id)` (also `[]events.Event`-returning, same `emitAll(s.emit, ...)`
call shape):

```go
	s.emitMu.Lock()
	_ = emitAll(s.emit, s.bridge.ResolveElicitation(id))
	s.emitMu.Unlock()
```

- [ ] **Step 3: Add Go tests asserting the resolve delta is actually emitted**

`bridge_test.go`'s existing tests (e.g. `TestBridgePermissionState`) construct a `Bridge` directly
and call its methods, not `sessionClient.RequestPermission` — there is no existing test exercising
the full decision-channel flow in this file, so add a focused test at the `Bridge` level instead of
threading through `sessionClient`'s channels:

```go
func TestBridgeResolvePermissionEmitsRemoveDelta(t *testing.T) {
	bridge := NewBridge("chat-1", "run-1")
	events := bridge.ResolvePermission("rpc-42")
	if len(events) != 1 {
		t.Fatalf("expected 1 event, got %d", len(events))
	}
	b, err := json.Marshal(events[0])
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(b), `"op":"remove"`) || !strings.Contains(string(b), `"path":"/pocketcoder/permission"`) {
		t.Fatalf("expected a remove delta for /pocketcoder/permission, got: %s", b)
	}
}

func TestBridgeResolveElicitationEmitsRemoveDelta(t *testing.T) {
	bridge := NewBridge("chat-1", "run-1")
	events := bridge.ResolveElicitation("rpc-42")
	if len(events) != 1 {
		t.Fatalf("expected 1 event, got %d", len(events))
	}
	b, err := json.Marshal(events[0])
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(b), `"op":"remove"`) || !strings.Contains(string(b), `"path":"/pocketcoder/elicitation"`) {
		t.Fatalf("expected a remove delta for /pocketcoder/elicitation, got: %s", b)
	}
}
```

These two tests cover `ResolvePermission`/`ResolveElicitation`'s own emitted shape (previously
untested, since nothing called them). They don't exercise `run.go`'s new call sites directly —
covering those requires driving `sessionClient.RequestPermission`'s decision channel end-to-end,
which needs a fuller `sessionClient` test harness this plan doesn't require building; the two unit
tests above are sufficient to confirm Step 1/Step 2's added calls produce the right wire event when
invoked.

- [ ] **Step 4: Run the Go test suite**

Run: `cd /Users/aicoder/Documents/pocketcoder/services/pocketbase && go test ./internal/agent/...`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd /Users/aicoder/Documents/pocketcoder
git add services/pocketbase/internal/agent/coordinator/run.go
git commit -m "fix: emit ResolvePermission/ResolveElicitation on decision (was dead code)"
```

---

### Task 11: Update `PermissionCard`/`ElicitationCard` to read inline payload

**Files:**
- Modify: `client/packages/pocketcoder_flutter/lib/presentation/chat/permission_card.dart`
- Modify: `client/packages/pocketcoder_flutter/lib/presentation/chat/elicitation_card.dart`
- Modify: `client/packages/pocketcoder_flutter/lib/presentation/chat/chat_screen.dart`
- Test: existing widget tests for these two cards (find via
  `grep -rln "PermissionCard\|ElicitationCard" client/packages/pocketcoder_flutter/test`)

**Context:** `PermissionCard`/`ElicitationCard` currently read via `BlocBuilder<PermissionCubit,
PermissionState>`/`BlocBuilder<ElicitationCubit, ElicitationState>`, ignoring the `requestId`
`AgUiChat` already passes them and instead reading `state.permission`/`state.elicitation` (a raw
`Map<String, dynamic>` sourced from `conversation.sessionState.permission`). Now that
`permissionBuilder`/`elicitationBuilder` receive the full `TimelineItem` directly (Phase 1, Task
7), these cards can read typed fields directly instead.

- [ ] **Step 1: Update `chat_screen.dart`'s builder wiring**

```dart
permissionBuilder: (context, item) =>
    PermissionCard(item: item as PermissionRequestTimelineItem),
elicitationBuilder: (context, item) =>
    ElicitationCard(item: item as ElicitationRequestTimelineItem),
```

- [ ] **Step 2: Update `PermissionCard` to take the item directly**

Change the constructor and `build` method:

```dart
class PermissionCard extends StatelessWidget {
  const PermissionCard({super.key, required this.item});

  final PermissionRequestTimelineItem item;

  @override
  Widget build(BuildContext context) {
    return _build(context, item);
  }

  Widget _build(BuildContext context, PermissionRequestTimelineItem item) {
    final colors = context.colorScheme;
    final terminalColors = context.terminalColors;
    final requestId = item.requestId;
    final toolTitle = item.toolTitle;
    final options = item.options;
    // ...rest of the widget body unchanged, replacing every read of
    // `permission['...']`/`toolCall['title']` with the typed `item.*`
    // fields above (toolTitle, options[i].optionId, options[i].label)...
```

Keep `context.read<PermissionCubit>().authorize(optionId)`/`.deny()` as the action call sites —
`PermissionCubit` still owns the transport call, it just no longer needs to be read for *display*
data. If `PermissionCubit`'s `state.permission`/`open()`/`watch()` machinery is now unused for
anything except tracking `_chatId` for `authorize`/`deny`, that's the follow-up simplification
flagged as an open question in the spec — not required by this task, but worth a one-line TODO
comment on `PermissionCubit` noting it.

- [ ] **Step 3: Update `ElicitationCard`** the same way, reading `item.message`/`item.schema`
  instead of `state.elicitation['message']`/`['requestedSchema']`.

- [ ] **Step 4: Update existing widget tests**

Update each test's widget-under-test construction to pass `item: const
PermissionRequestTimelineItem(...)`/`ElicitationRequestTimelineItem(...)` directly instead of
pumping a `BlocProvider<PermissionCubit>`/`BlocProvider<ElicitationCubit>` with a fake state.

- [ ] **Step 5: Run the Flutter test suite**

Run: `cd /Users/aicoder/Documents/pocketcoder/client/packages/pocketcoder_flutter && flutter test`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
cd /Users/aicoder/Documents/pocketcoder
git add client/packages/pocketcoder_flutter/lib/presentation/chat/permission_card.dart client/packages/pocketcoder_flutter/lib/presentation/chat/elicitation_card.dart client/packages/pocketcoder_flutter/lib/presentation/chat/chat_screen.dart client/packages/pocketcoder_flutter/test/
git commit -m "refactor: PermissionCard/ElicitationCard read inline TimelineItem payload"
```

---

## Phase 3 — episutra (`/Users/aicoder/Documents/episutra`, this repo)

**Precondition:** Phase 1 committed and pinned in episutra's `pubspec.yaml`/`pubspec.lock` (update
the `ag_ui_widgets_flutter` git ref pin to Phase 1's final commit before starting).

### Task 12: Rename `epi.*` CustomEvent names to canonical `acp.*`

**Files:**
- Modify: `episutra-frb/src/ag_ui_bridge.rs`
- Test: existing Rust unit tests in the same file (`#[cfg(test)] mod tests`)

- [ ] **Step 1: Update the two `CustomEvent` name strings**

In `episutra-frb/src/ag_ui_bridge.rs`, change:

```rust
            FrbAcpEvent::AgentToolRequest { call_id, tool_name, args, .. } => vec![json!({
                "type": "CUSTOM", "name": "epi.tool_request",
                "value": { "callId": call_id, "toolName": tool_name, "args": args },
            }).to_string()],
            FrbAcpEvent::PermissionRequest { call_id, tool_name, description, options_json, .. } => vec![json!({
                "type": "CUSTOM", "name": "epi.permission_request",
                "value": {
                    "callId": call_id, "toolName": tool_name, "description": description, "optionsJson": options_json,
                },
            }).to_string()],
```

to:

```rust
            FrbAcpEvent::AgentToolRequest { call_id, tool_name, args, .. } => vec![json!({
                "type": "CUSTOM", "name": "acp.tool_request",
                "value": { "callId": call_id, "toolName": tool_name, "args": args },
            }).to_string()],
            FrbAcpEvent::PermissionRequest { call_id, tool_name, description, options_json, .. } => vec![json!({
                "type": "CUSTOM", "name": "acp.permission_request",
                "value": {
                    "callId": call_id, "toolName": tool_name, "description": description, "optionsJson": options_json,
                },
            }).to_string()],
```

- [ ] **Step 2: Update the two existing tests asserting on the old names**

In the same file's `#[cfg(test)] mod tests`, `maps_lifecycle_tools_and_custom_requests` asserts
`parse(&request[0])["name"], "epi.permission_request"` and `custom_requests_preserve_callback_data`
asserts `tool["name"], "epi.tool_request"` and `permission["name"], "epi.permission_request"`.
Update all three assertions to `"acp.permission_request"`/`"acp.tool_request"`.

- [ ] **Step 3: Run the Rust test suite**

Run: `cd /Users/aicoder/Documents/episutra/episutra-frb && cargo test ag_ui_bridge`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add episutra-frb/src/ag_ui_bridge.rs
git commit -m "refactor: rename epi.* CustomEvent names to canonical acp.*"
```

---

### Task 13: `FrbAgUiTransport.submitToolResult` + update the 6 test fakes

**Files:**
- Modify: `packages/episutra_core/lib/data/services/agent/frb_ag_ui_transport.dart`
- Modify: `app/episutra_flutter/test/features/corner_panels/cubits/chat_cubit_test.dart`
- Modify: `app/episutra_flutter/test/features/corner_panels/widgets/chat_transcript_pane_test.dart`
- Modify: `app/episutra_flutter/test/features/corner_panels/widgets/graph_side_panel_test.dart`
- Modify: `app/episutra_flutter/test/features/corner_panels/widgets/chat_panel_text_field_test.dart`
- Modify: `app/episutra_flutter/test/features/editor/widgets/new_tab_view_test.dart`
- Modify: `app/episutra_flutter/test/features/editor/widgets/graph_tab_isolation_test.dart`

**Interfaces:**
- Consumes: `IAgUiTransport.submitToolResult` from Phase 1, Task 6; `IAcpRepository.submitMcpToolResult`
  (already exists: `Future<void> submitMcpToolResult({required int sessionId, required String
  callId, required String result})`, wrapping `acp_api.acpSubmitMcpToolResult`).

- [ ] **Step 1: Implement `submitToolResult` on `FrbAgUiTransport`**

```dart
  @override
  Future<void> submitToolResult(String callId, String resultJson) async {
    final sessionId = _sessionId;
    if (sessionId != null) {
      await _repository.submitMcpToolResult(
        sessionId: sessionId,
        callId: callId,
        result: resultJson,
      );
    }
  }
```

- [ ] **Step 2: Add the same no-op-safe override to each of the 6 test fakes**

In each of the 6 files listed above, add to the `_FakeTransport implements IAgUiTransport` class:

```dart
  @override
  Future<void> submitToolResult(String callId, String resultJson) async {}
```

(Match this file's existing style — some fakes may want to record calls in a list, e.g. `final
toolResults = <(String, String)>[]; ... toolResults.add((callId, resultJson));`, matching however
that file already records `sendMessage` calls into its own `messages` list, for consistency within
each file.)

- [ ] **Step 3: Run the full episutra Flutter test suite**

Run: `cd /Users/aicoder/Documents/episutra/app/episutra_flutter && flutter test`
Expected: PASS — this is the compile-breakage check: before this task, all 6 fakes fail to compile
against the widened `IAgUiTransport` interface from Phase 1; after, they compile and every existing
test in these files still passes unchanged.

- [ ] **Step 4: Commit**

```bash
git add packages/episutra_core/lib/data/services/agent/frb_ag_ui_transport.dart app/episutra_flutter/test/features/corner_panels/ app/episutra_flutter/test/features/editor/widgets/new_tab_view_test.dart app/episutra_flutter/test/features/editor/widgets/graph_tab_isolation_test.dart
git commit -m "feat: implement IAgUiTransport.submitToolResult on FrbAgUiTransport + test fakes"
```

---

### Task 14: Delete `ChatCubit`'s ad hoc `epi.permission_request` parsing; update `chat_transcript_pane.dart`

**Files:**
- Modify: `app/episutra_flutter/lib/features/corner_panels/cubits/chat_cubit.dart`
- Modify: `app/episutra_flutter/lib/features/corner_panels/cubits/chat_state.dart`
- Modify: `app/episutra_flutter/lib/features/corner_panels/widgets/chat_transcript_pane.dart`
- Test: `app/episutra_flutter/test/features/corner_panels/cubits/chat_cubit_test.dart`,
  `.../widgets/chat_transcript_pane_test.dart`

**Context:** with Adapter B (Phase 1, Task 5) now recognizing `acp.permission_request` directly
inside the shared reducer and producing a full-payload `PermissionRequestTimelineItem`,
`ChatCubit`'s hand-rolled `CustomEvent(name: 'epi.permission_request', ...)` interception and its
`ChatState.pendingPermissions` map are redundant — the timeline item already carries everything
`permissionBuilder` needs.

- [ ] **Step 1: Delete the ad hoc `CustomEvent` handling in `ChatCubit._onEvent`**

Remove this block from `chat_cubit.dart` (currently around line 120):

```dart
    if (event case CustomEvent(name: 'epi.permission_request', :final value)) {
      final map = value as Map;
      final callId = map['callId'] as String;
      emit(
        state.copyWith(
          pendingPermissions: {
            ...state.pendingPermissions,
            callId: PendingPermissionPayload(
              toolName: map['toolName'] as String,
              description: map['description'] as String,
              optionsJson: map['optionsJson'] as String,
            ),
          },
        ),
      );
    }
```

Also update `submitPermission` to call the transport directly with the option id it's given (its
current body is unaffected — it already just calls `_transport.respondPermission(requestId,
optionId: optionId)`; no change needed there beyond removing dead references to
`pendingPermissions`, if any).

- [ ] **Step 2: Remove `pendingPermissions`/`PendingPermissionPayload` from `chat_state.dart`**

Delete the `PendingPermissionPayload` class and the `pendingPermissions` field from `ChatState` (and
regenerate Freezed: `cd app/episutra_flutter && dart run build_runner build
--delete-conflicting-outputs`).

- [ ] **Step 3: Update `chat_transcript_pane.dart`'s `permissionBuilder` wiring**

Replace:

```dart
    permissionBuilder: (context, requestId) {
      final payload = state.pendingPermissions[requestId];
      if (payload == null) return const SizedBox.shrink();
      return _EpisutraPermissionCard(
        requestId: requestId,
        payload: payload,
        onDecision: (optionId) =>
            context.read<ChatCubit>().submitPermission(requestId, optionId),
      );
    },
```

with:

```dart
    permissionBuilder: (context, item) {
      final permission = item as PermissionRequestTimelineItem;
      return _EpisutraPermissionCard(
        item: permission,
        onDecision: (optionId) =>
            context.read<ChatCubit>().submitPermission(permission.requestId, optionId),
      );
    },
```

Update `_EpisutraPermissionCard` to take `item: PermissionRequestTimelineItem` instead of
`requestId`/`payload: PendingPermissionPayload`, reading `item.description` (nullable now — guard
with `if (item.description != null)` where the widget currently assumes a non-null description) and
`item.options` (already a `List<PermissionOption>`, not a `jsonDecode`d list — delete the
`jsonDecode(payload.optionsJson)` call entirely, since `AgUiChat`/the reducer already parsed it).

- [ ] **Step 4: Update `chat_cubit_test.dart`/`chat_transcript_pane_test.dart`**

Remove any test assertions referencing `pendingPermissions`/`PendingPermissionPayload`. Add/update
a test asserting that emitting a raw `CustomEvent(name: 'acp.permission_request', value: {...})`
through the fake transport results in `state.conversation.timeline` containing a
`PermissionRequestTimelineItem` with the expected fields (this now happens entirely inside the
shared package's reducer, which `ChatCubit` already calls via `_reducer.apply(event)` — no
episutra-side parsing code to test beyond "the timeline updates").

- [ ] **Step 5: Run the full episutra Flutter test suite**

Run: `cd /Users/aicoder/Documents/episutra/app/episutra_flutter && flutter test`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add app/episutra_flutter/lib/features/corner_panels/ app/episutra_flutter/test/features/corner_panels/
git commit -m "refactor: delete ChatCubit's ad hoc epi.permission_request parsing, use inline TimelineItem payload"
```

---

## Phase 4 — pin the new version everywhere

### Task 15: Update `sibling-versions.lock` in both episutra and pocketcoder

**Files:**
- Modify: `episutra`'s sibling-pin file for `ag_ui_widgets_flutter` (per `scripts/check_sibling_versions.sh`'s convention — find the exact lock file via `grep -rl ag_ui_widgets_flutter sibling-versions.lock` or equivalent).
- Modify: pocketcoder's equivalent pin file (introduced per the base shared-package spec's rollout
  step 3, if it doesn't already exist).

- [ ] **Step 1: Confirm Phase 1's shared-package test suite passes at the exact commit being pinned**

Run: `cd /Users/aicoder/Documents/ag_ui_widgets_flutter && flutter test`
Expected: PASS — this is the gate `sibling-versions.lock --update` is supposed to enforce (per the
base spec); confirm manually before updating either app's pin.

- [ ] **Step 2: Update episutra's pin**

Run: `cd /Users/aicoder/Documents/episutra && scripts/check_sibling_versions.sh --update`
(or the manual equivalent if that script doesn't yet cover this dependency — check its current
scope first).

- [ ] **Step 3: Update episutra's `pubspec.lock`**

Run: `cd /Users/aicoder/Documents/episutra/app/episutra_flutter && flutter pub get` and
`cd /Users/aicoder/Documents/episutra/packages/episutra_core && flutter pub get`, then verify both
`pubspec.lock`s now reference the Phase 1 commit SHA for `ag_ui_widgets_flutter`.

- [ ] **Step 4: Run episutra's full local check suite**

Run: `cd /Users/aicoder/Documents/episutra && scripts/check_all.sh --fast`
Expected: PASS

- [ ] **Step 5: Update pocketcoder's pin the same way**

Follow pocketcoder's equivalent pinning convention (introduced per the base shared-package spec if
not already present) and run its own test suite.

- [ ] **Step 6: Commit in each repo**

```bash
# episutra
cd /Users/aicoder/Documents/episutra
git add sibling-versions.lock app/episutra_flutter/pubspec.lock packages/episutra_core/pubspec.lock
git commit -m "chore: pin ag_ui_widgets_flutter to ACP request/response model version"

# pocketcoder
cd /Users/aicoder/Documents/pocketcoder
git add <pocketcoder's equivalent lock/pubspec files>
git commit -m "chore: pin ag_ui_widgets_flutter to ACP request/response model version"
```
