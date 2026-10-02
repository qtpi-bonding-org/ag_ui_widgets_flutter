# Event vocabulary

What `ConversationReducer` folds, and where each piece ends up. Anything not
listed here is recorded as a `Diagnostic` (never silently dropped). Malformed
`acp.*` payloads and unknown `acp.session_phase` phases are diagnosed once per
distinct payload (the dedupe set is bounded).

## Namespace rule

`acp.*` and `acp:source` names are fixed protocol events and do not depend on
configuration. `<namespace>:*` CUSTOM event names and the `/<namespace>` state
tree (STATE_SNAPSHOT key, STATE_DELTA path prefix) belong to the backend and
are selected with `ConversationReducer(namespace:)`, which is required (no
default; acp-agui-adapter backends such as episutra pass `episutra`).
`isReplaceMarker` and `reduce` take the same required `namespace`.

The contract test (`test/model/adapter_contract_test.dart`) feeds the
adapter's golden fixture through the reducer and fails on any new event name or
state key; update this file when it does.

## CUSTOM events

| Wire name | Payload | Folded into | Notes |
|---|---|---|---|
| `<ns>:tool` | `{toolCallId, title?, kind?, status?, locations?, meta?}` | `ToolCallTimelineItem` `name` (only if still empty), `toolKind`, `status`, `locations`, `meta` | Missing `toolCallId` is a `malformedPayload`. Creates the tool item if the call has not started yet. By design: a `title` arriving after the item already has a name is lost (the name is never overwritten). An update carrying a `locations` key replaces the earlier locations (an empty list clears them); an update without the key leaves them alone. Non-map `locations` entries are diagnosed (`malformedPayload`, `<ns>/locations`). |
| `<ns>:diff` | `{toolCallId, ...}` as a tool-content object | `ToolCallTimelineItem.diffs` (`ToolDiff`) or `.patches` (`ToolPatch`, the `{format, patch}` shape) | Appends. Unknown keys kept in `extras`. Anything else is `malformedPayload`. |
| `<ns>:terminal` | `{toolCallId, terminalId, ...}` | `ToolCallTimelineItem.terminals` | Appends. Missing/empty `terminalId` is `malformedPayload`. |
| `<ns>:content` | media descriptor `{kind, toolCallId?, messageId?, ...}` | `ToolCallTimelineItem.media` when `toolCallId` is set, otherwise a standalone `MediaTimelineItem` | Empty `kind` is `malformedPayload`. |
| `<ns>:response_meta` | `{method, meta}` | `SessionState.responseMeta[method]` | Later value for the same method replaces the earlier. |
| `<ns>:sync` | `{mode: replace}` | Reset: clears timeline, run state, typed state and open streams | Keeps diagnostics, source records and the resolved-request set. Any other `mode` is an `unknownCustom` diagnostic. |
| `acp.permission_request` | `{callId, optionsJson, toolName?, description?}` | `PermissionRequestTimelineItem` (key `perm:<callId>`) | Direct-event path, anchored right after its tool call. A non-map payload or missing `callId` is `malformedPayload`; `optionsJson` that is not a string or not valid JSON is `malformedPayload` (`acp.permission_request/optionsJson`) and yields no options. |
| `acp.elicitation_request` | `{requestId, message?, mode?, schema?, url?}` | `ElicitationRequestTimelineItem` | Direct-event path. `mode` defaults to `form`. A non-map payload or missing `requestId` is `malformedPayload`. |
| `acp.client_execute_request` | `{callId, toolName, args}` | `ToolRequestTimelineItem` (key `req:<callId>`) | Skipped (marked resolved) when `autoResolveToolRequest(toolName)` is true. A non-map payload or missing `callId` is `malformedPayload`. |
| `acp.session_phase` | `{phase: starting\|ready}` | `SessionState.isStarting` | An unknown phase is `unknownCustom`; a non-map payload is `malformedPayload`. |
| `acp:source` | wire record map | `Conversation.sourceRecords` (bounded) | Not a diagnostic. Non-map payload is `malformedPayload`. |
| any other CUSTOM | any | `Diagnostic(unknownCustom)` | |

## Standard AG-UI events

| Event | Folded into | Notes |
|---|---|---|
| `RUN_STARTED` | `SessionState.isRunning`, `threadId`, `runId`; clears `runError`, `stopReason`, `runErrorCode` | |
| `RUN_FINISHED` | `isRunning=false`, raw `stopReason`, `runOutcome` (`cancelled` or `success`) | |
| `RUN_ERROR` | `runError`, `runErrorCode`, `runOutcome` (`interrupted` for code `connection_interrupted`, else `failed`) | |
| `TEXT_MESSAGE_START/CONTENT/END` | text `TimelineItem` keyed by message id | Streams while open. |
| `REASONING_MESSAGE_START/CONTENT/END` | reasoning `TimelineItem` | |
| `TOOL_CALL_START/ARGS/END` | `ToolCallTimelineItem` (`name`, `args`, `hasEnded`) | |
| `TOOL_CALL_RESULT` | `result` (latest) and `resultParts` (every result, in order) | |
| `STATE_SNAPSHOT` | replaces the `/<namespace>` tree and re-derives typed state | Other top-level keys: `unknownStateKey` diagnostic, once per key. Non-map snapshot: `malformedPayload`. |
| `STATE_DELTA` | JSON-patch `add`/`replace`/`remove` applied inside `/<namespace>` | Deep paths supported through maps. Path outside the namespace: `unknownStateKey`. Other ops, bad paths, or descending through a non-map: `malformedPayload`. `replace` of `/<namespace>` swaps the whole tree. |
| `RAW` | `Diagnostic(raw)` | Recorded, not folded. |
| any other standard event | `Diagnostic(unhandledEvent)` | |

## State keys under `/<namespace>`

Typed models are mirrored: a key that disappears becomes null (or empty for
`plans`). A key that is present but does not parse is a `malformedPayload`
diagnostic (reported once until it parses again).

| State key | Payload | Folded into | Notes |
|---|---|---|---|
| `agent` | agent info | `SessionState.agent` (`AgentState`) | |
| `mode` | current mode id and available modes | `SessionState.mode` (`ModeState`) | |
| `commands` | available commands: `{commands: [...]}` (a bare list is `malformedPayload`) | `SessionState.commands` (`CommandsState`) | |
| `config` | config options | `SessionState.configState` (`ConfigState`) | |
| `usage` | token/context usage | `SessionState.usage` (`UsageState`) | |
| `session_info` | title, `updated_at`, `meta` | `SessionState.sessionInfo` (`SessionInfo`); `title` also at `SessionState.title` | |
| `plans` | `{by-id: {id: plan}, legacy?: plan}` | `SessionState.plans` (`PlansState`) | A list is `malformedPayload`. |
| `permissions` | `{by-id: {toolCallId: {requestId, ...}}}` | `PermissionRequestTimelineItem` per entry (content, meta, sessionId, option extras, unknown keys in `extras`) | Cards no longer pending are removed; others updated in place. |
| `elicitations` | `{by-id: {elicitationId: {...}}}` | `ElicitationRequestTimelineItem` per entry (`scope`, `meta`, tagged `mode` object kept as `rawMode`) | Same pending/removal rule. |
| any other key | any | `Diagnostic(unknownStateKey)` `<namespace>/<key>`, once per key while present | The former single-slot `permission`/`elicitation` and raw `modes`/`plan` keys are no longer read and land here. |

Requests the app resolves via `resolveRequest(id)` stay suppressed across
resets and replays.

## Lossy-by-design notes

- List-valued fields inside session models (modes, auth methods, commands,
  config options and their choices, plan entries, and `PlansState.byId`) are
  read with `asJsonMapList`, which silently drops entries that are not maps.
- Elicitation `mode` in `elicitations.by-id` is the tagged object `{kind, ...}`; absent or not an object it defaults to `form` with no schema/url. (The direct `acp.elicitation_request` event carries a plain string `mode`, defaulting to `form`.)
- Typed fields read with `asString` are null when the wire value has the wrong
  type; the original value is not kept (only unknown keys are, in `extras`).
