# Event vocabulary

What `ConversationReducer` folds, and where each piece ends up. Anything not
listed here is recorded as a `Diagnostic` (never silently dropped).

## Namespace rule

`acp.*` and `acp:source` names are fixed protocol events and do not depend on
configuration. `<namespace>:*` CUSTOM event names and the `/<namespace>` state
tree (STATE_SNAPSHOT key, STATE_DELTA path prefix) belong to the backend and
are selected with `ConversationReducer(namespace:)` (default `pocketcoder`;
acp-agui-adapter backends such as episutra pass `episutra`). `isReplaceMarker`
takes the same `namespace`.

The contract test (`test/model/adapter_contract_test.dart`) feeds the
adapter's golden fixture through the reducer and fails on any new event name or
state key; update this file when it does.

## CUSTOM events

| Wire name | Payload | Folded into | Notes |
|---|---|---|---|
| `<ns>:tool` | `{toolCallId, title?, kind?, status?, locations?, meta?}` | `ToolCallTimelineItem` `name` (only if still empty), `toolKind`, `status`, `locations`, `meta` | Missing `toolCallId` is a `malformedPayload`. Creates the tool item if the call has not started yet. |
| `<ns>:diff` | `{toolCallId, ...}` as a tool-content object | `ToolCallTimelineItem.diffs` (`ToolDiff`) or `.patches` (`ToolPatch`, the `{format, patch}` shape) | Appends. Unknown keys kept in `extras`. Anything else is `malformedPayload`. |
| `<ns>:terminal` | `{toolCallId, terminalId, ...}` | `ToolCallTimelineItem.terminals` | Appends. Missing/empty `terminalId` is `malformedPayload`. |
| `<ns>:content` | media descriptor `{kind, toolCallId?, messageId?, ...}` | `ToolCallTimelineItem.media` when `toolCallId` is set, otherwise a standalone `MediaTimelineItem` | Empty `kind` is `malformedPayload`. |
| `<ns>:response_meta` | `{method, meta}` | `SessionState.responseMeta[method]` | Later value for the same method replaces the earlier. |
| `<ns>:sync` | `{mode: replace}` | Reset: clears timeline, run state, typed state and open streams | Keeps diagnostics, source records and the resolved-request set. Any other `mode` is an `unknownCustom` diagnostic. |
| `acp.permission_request` | `{callId, optionsJson, toolName?, description?}` | `PermissionRequestTimelineItem` (key `perm:<callId>`) | Direct-event path, anchored right after its tool call. |
| `acp.elicitation_request` | `{requestId, message?, mode?, schema?, url?}` | `ElicitationRequestTimelineItem` | Direct-event path. |
| `acp.client_execute_request` | `{callId, toolName, args}` | `ToolRequestTimelineItem` (key `req:<callId>`) | Skipped (marked resolved) when `autoResolveToolRequest(toolName)` is true. |
| `acp.session_phase` | `{phase: starting\|ready}` | `SessionState.isStarting` | Other phases are ignored. |
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
| `commands` | available commands | `SessionState.commands` (`CommandsState`) | |
| `config` | config options | `SessionState.configState` (`ConfigState`) | `SessionState.config` stays the legacy raw map of the same key. |
| `usage` | token/context usage | `SessionState.usage` (`UsageState`) | |
| `session_info` | title, `updated_at`, `meta` | `SessionState.sessionInfo` (`SessionInfo`); `title` also at `SessionState.title` | |
| `plans` | `{by-id, ...}` (or legacy list shape) | `SessionState.plans` (`PlansState`) | |
| `permissions` | `{by-id: {requestId: {...}}}` | `PermissionRequestTimelineItem` per entry (content, meta, sessionId, option extras, unknown keys in `extras`) | Cards no longer pending are removed; others updated in place. |
| `elicitations` | `{by-id: {elicitationId: {...}}}` | `ElicitationRequestTimelineItem` per entry (`scope`, `meta`, tagged `mode` object kept as `rawMode`) | Same pending/removal rule. |
| `permission` | single request map (legacy, pocketcoder) | same as one `permissions` entry; also `SessionState.permission` raw | |
| `elicitation` | single request map (legacy) | same as one `elicitations` entry; also `SessionState.elicitation` raw | `mode` is a plain string with `requestedSchema`/`url` beside it. |
| `modes` | raw map (legacy) | `SessionState.modes` raw | Not typed. |
| `plan` | raw map (legacy) | `SessionState.plan` raw | Not typed. |
| any other key | any | `Diagnostic(unknownStateKey)` `<namespace>/<key>`, once per key while present | |

Requests the app resolves via `resolveRequest(id)` stay suppressed across
resets and replays.
