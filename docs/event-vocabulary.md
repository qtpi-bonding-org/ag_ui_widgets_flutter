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
adapter's golden fixture through `decodeAgUiWire` and the reducer and fails on
any new event name or state key; update this file when it does. Every event must
be decoded with `decodeAgUiWire` (not `BaseEvent.fromJson`): `ag_ui` 0.3.0 reads
`TOOL_CALL_RESULT.content` as a string and the adapter sends content parts.

## CUSTOM events

| Wire name | Payload | Folded into | Notes |
|---|---|---|---|
| `<ns>:tool` | `{toolCallId, title?, kind?, status?, locations?, _meta?, rawOutput?, success?, pastTenseMessage?}` | `ToolCallTimelineItem` `name` (a non-empty `title` replaces it), `toolKind`, `status`, `locations`, `meta`, `rawOutput`, `success`, `pastTenseMessage` | Missing `toolCallId` is a `malformedPayload`. Creates the tool item if the call has not started yet. An update carrying a `locations` key replaces the earlier locations (an empty list clears them); an update without the key leaves them alone. Non-map `locations` entries are diagnosed (`malformedPayload`, `<ns>/locations`). The completion event carries `success` and `pastTenseMessage`. `meta` is read as a fallback for `_meta`. |
| `<ns>:permission_resolved` | `{toolCallId, response:{outcome:{outcome: selected\|cancelled, optionId?}}, approved?}` | `SessionState.resolutions['permission:<id>']` = `{kind: user_selected\|auto_approved\|cancelled, optionId?, approved?, response}` | `cancelled` for a cancelled outcome; `auto_approved` when a selection has no `approved` (nobody chose). The card is removed by the state delta; this keeps how it was resolved. Bounded to 100. |
| `<ns>:elicitation_resolved` | `{requestId, action?, content?, elicitationId?, _meta?}` | `SessionState.resolutions['elicitation:<requestId>']` = the payload without `requestId` | Same, for elicitations. |
| `<ns>:diff` | `{toolCallId, ...}` as a tool-content object | `ToolCallTimelineItem.diffs` (`ToolDiff`: `path`, `newText`) or `.patches` (`ToolPatch`: `{format, patch}` or diff-v2 `{changes, patch:{format, text}}`) | Appends. Unknown keys kept in `extras`. Anything else is `malformedPayload`. |
| `<ns>:terminal` | `{toolCallId, terminalId, ...}` | `ToolCallTimelineItem.terminals` | Appends. Missing/empty `terminalId` is `malformedPayload`. |
| `<ns>:media` | `{turnId, messageId, channel, content, toolCallId?}`; `content` is an ACP content block (`type`, `uri`, `mimeType`, ...) | `ToolCallTimelineItem.media` when `toolCallId` is set, otherwise a standalone `MediaTimelineItem` | A missing/empty `content.type` is `malformedPayload`. |
| `<ns>:message_replaced` | `{turnId, messageId, sessionUpdate: agent_message\|agent_thought\|user_message, content:[parts]}` | Replaces the text of that message (a reasoning item for `agent_thought`) with the joined text parts; creates it when missing | Closes an open stream for the id. |
| `<ns>:session_creation_failed` | `{method, error:{code, message}}` | `runError`, `runErrorCode`, `runOutcome: failed`, `isRunning=false` | Missing `error` is `malformedPayload`. |
| `<ns>:response_meta` | `{method, _meta}` | `SessionState.responseMeta[method]` | Later value for the same method replaces the earlier. `meta` is read as a fallback. |
| `<ns>:sync` | `{mode: replace}` | Reset: clears timeline, run state, typed state and open streams | **Not sent by the adapter.** The host emits it locally whenever it (re)subscribes to a full replay. Keeps diagnostics, source records and the resolved-request set. Any other `mode` is an `unknownCustom` diagnostic. |
| `acp.permission_request` | `{callId, optionsJson, toolName?, description?}` | `PermissionRequestTimelineItem` (key `perm:<callId>`) | Locally produced by the host, anchored right after its tool call. A non-map payload or missing `callId` is `malformedPayload`; `optionsJson` that is not a string or not valid JSON is `malformedPayload` (`acp.permission_request/optionsJson`) and yields no options. |
| `acp.elicitation_request` | `{requestId, message?, mode?, schema?, url?}` | `ElicitationRequestTimelineItem` | Locally produced. `mode` defaults to `form`. A non-map payload or missing `requestId` is `malformedPayload`. |
| `acp.client_execute_request` | `{callId, toolName, args}` | `ToolRequestTimelineItem` (key `req:<callId>`) | Locally produced. Skipped (marked resolved) when `autoResolveToolRequest(toolName)` is true. A non-map payload or missing `callId` is `malformedPayload`. |
| `acp.session_phase` | `{phase: starting\|ready}` | `SessionState.isStarting` | Locally produced. An unknown phase is `unknownCustom`; a non-map payload is `malformedPayload`. |
| `acp:source` | wire record map | `Conversation.sourceRecords` (bounded) | Not emitted by the adapter any more (envelope ids ride in each event's `metadata.acpEnvelope`); still folded when a host sends it. Non-map payload is `malformedPayload`. |
| any other CUSTOM | any | `Diagnostic(unknownCustom)` | `<ns>:run` (removed) lands here. |

## Standard AG-UI events

| Event | Folded into | Notes |
|---|---|---|
| `RUN_STARTED` | `SessionState.isRunning`, `threadId`, `runId`; clears `runError`, `stopReason`, `runErrorCode`; `runInfo` = `{runId, startedAt?, message?}` | A run whose `runId` starts `synthetic-` (`kSyntheticRunPrefix`) wraps a session-level event: only `threadId` is taken, run state is untouched. `input` must carry `tools`, `context`, `state`, `forwardedProps` (`ag_ui` requires them; the adapter sends them empty). |
| `RUN_FINISHED` | `isRunning=false`, raw `stopReason`, `runOutcome` (`cancelled` or `success`), `runInfo.durationMs` | Ignored for a synthetic run. |
| `ACTIVITY_SNAPSHOT` | `activityType: plan` with `content:{planId, body:{kind: entries\|file\|markdown}}` into `SessionState.plans.byId[planId]` | Kept apart from the state tree's plans, so a `STATE_SNAPSHOT` does not drop it. Other activity types are `unhandledEvent`. |
| `RUN_ERROR` | `runError`, `runErrorCode`, `runOutcome` (`interrupted` for code `connection_interrupted`, else `failed`) | |
| `TEXT_MESSAGE_START/CONTENT/END` | text `TimelineItem` keyed by message id | Streams while open. |
| `REASONING_MESSAGE_START/CONTENT/END` | reasoning `TimelineItem` | |
| `TOOL_CALL_START/ARGS/END` | `ToolCallTimelineItem` (`name`, `args`, `hasEnded`) | |
| `TOOL_CALL_RESULT` | `result` (latest, the joined text parts) and `resultParts` (every result, in order, each with its AG-UI `parts`) | `decodeAgUiWire` turns a content-part list into text and keeps the list in `rawEvent.parts`. |
| `STATE_SNAPSHOT` | replaces the `/<namespace>` tree and re-derives typed state; a pending permission arrives this way | Other top-level keys: `unknownStateKey` diagnostic, once per key. Non-map snapshot: `malformedPayload`. |
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
| `permissions` | `{by-id: {toolCallId: {requestId (JSON-RPC id), status, request:{sessionId, toolCall:{toolCallId, title, kind, content, rawInput, _meta}, options, _meta}}}}` | `PermissionRequestTimelineItem` per entry, card id = the `by-id` key (the tool call id), timeline key `perm:<id>` (the bare id is the tool call's own key); unknown entry keys and the JSON-RPC `requestId` in `extras` | An entry whose `status` is not `pending` is not a card. Cards no longer pending are removed; others updated in place. `toolArgs` come from the correlated tool call, else the JSON of `rawInput`. |
| `elicitations` | `{by-id: {id: {requestId, request:{mode (string), requestId?, toolCallId?, sessionId?, message, requestedSchema?, url?, _meta?}}}}` | `ElicitationRequestTimelineItem` per entry (`mode`, `schema` from `requestedSchema`, `url`, `meta`; `scope` is `request`, `tool` or `session` by which id the request names) | Same pending/removal rule. A non-string `mode` is `malformedPayload` (`<ns>/elicitations/mode`) and shows as a form. |
| `client`, `session_setup`, `working_directories`, `session`, `activity` | session facts the adapter records (`initialize` client info, `session/new` setup, directories, the session id, `{state: running\|...}`) | Read into the state tree only; no typed field yet | Known keys, so no diagnostic. |
| any other key | any | `Diagnostic(unknownStateKey)` `<namespace>/<key>`, once per key while present | The former single-slot `permission`/`elicitation` and raw `modes`/`plan` keys land here. |

Requests the app resolves via `resolveRequest(id)` stay suppressed across
resets and replays.

## Lossy-by-design notes

- List-valued fields inside session models (modes, auth methods, commands,
  config options and their choices, plan entries, and `PlansState.byId`) are
  read with `asJsonMapList`, which silently drops entries that are not maps.
- Elicitation `mode` is a plain string (`form` when absent), in the state tree and on the direct `acp.elicitation_request` event alike.
- Typed fields read with `asString` are null when the wire value has the wrong
  type; the original value is not kept (only unknown keys are, in `extras`).
