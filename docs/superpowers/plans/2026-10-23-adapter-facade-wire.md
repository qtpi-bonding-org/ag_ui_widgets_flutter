---
status: done
completed: 2026-10-23
---

# Adapter facade wire Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** `ConversationReducer` and a new wire decoder consume the AG-UI stream that `acp-agui-adapter` `ProtocolBridge` (adapter commit `ab7ccca`) emits, with `test/fixtures/adapter/ag_ui_session.json` (regenerated from the adapter) as the contract.

**Architecture:** The adapter fixture is a list of `Sourced` envelopes; the AG-UI event is each item's `payload`. A `decodeAgUiWire` function normalises the two shapes `ag_ui` 0.3.0 cannot decode, then calls `BaseEvent.fromJson`. The reducer is updated event by event, driven by the contract test. The replay reset is no longer on the wire: the host emits a local `<ns>:sync {mode: replace}` marker whenever it (re)subscribes, and `isReplaceMarker` stays as the reset.

**Tech Stack:** Dart, `ag_ui` 0.3.0 (latest; `ToolCallResultEvent.content` is `String`), `flutter test`.

**Spec:** `acp-agui-adapter/docs` (adapter owns the wire); Episutra plan `episutra/docs/superpowers/plans/2026-10-23-bridge-facade-migration.md` Task 4b. Vocabulary doc to update: `docs/event-vocabulary.md`.

## Global Constraints

- Namespace stays a required reducer parameter; `acp:*` names are fixed protocol names.
- No silent drops: anything unrecognised is a `Diagnostic`. The contract test fails on any diagnostic other than `raw`.
- Reducer must not break the existing 1288-line reducer tests that are unrelated to the changed events.
- Commits end with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.

## Wire changes found (fixture vs reducer)

| Area | Old | New |
|---|---|---|
| fixture item | event | `Sourced{sourceEventId, sourceSequence, turnId, index, payload}`; event is `payload` |
| `RUN_STARTED.input` | absent | present; needs `tools/context/state/forwardedProps` (adapter fixed in `ab7ccca`) |
| `TOOL_CALL_RESULT.content` | `String` | list of AG-UI content parts; `ag_ui` rejects it |
| runs | only a client-made `RunStarted`; `<ns>:run` custom | real `RUN_STARTED`/`RUN_FINISHED`; session-level events are wrapped in a synthetic run (`runId` starts `synthetic-`) |
| replay reset | `<ns>:sync` from the backend | none on the wire; first events of a rebuilt stream are RUN_STARTED, STATE_SNAPSHOT |
| permission state | `permissions.by-id.<id>` = `{requestId, title, kind, options, content, meta}` | `by-id.<toolCallId>` = `{requestId (JSON-RPC id), status, request:{sessionId, toolCall{toolCallId,title,kind,content,rawInput,_meta}, options, _meta}}` |
| `<ns>:permission_resolved` | `{toolCallId, resolution{kind,optionId,approved}}` | `{toolCallId, response, approved}`; `response` is the ACP response (`outcome.outcome`, `optionId`) |
| elicitation state | `{elicitationId, message, mode{kind..}}` | `by-id.<id>` = `{requestId, request{mode (string), requestId, requestedSchema/url, message}}` |
| `<ns>:content` | media descriptor | `<ns>:media` `{turnId, messageId, channel, content}` |
| `<ns>:tool` | `meta` | `_meta` |
| new events | | `<ns>:message_replaced`, `<ns>:session_creation_failed`, `ACTIVITY_SNAPSHOT` (plans: `activityType: plan`, `content.body.kind` entries/file/markdown) |
| removed | `<ns>:run`, `<ns>:tool_text`, `<ns>:sync` | gone from the adapter |
| new state keys | | `client`, `session_setup`, `working_directories`, `session`, `activity` |

## Review Focus

- A synthetic run around a session-level event must not leave `isRunning` true, and must not clear a real run's `runResult` or `stopReason`.
- A reconnect (local sync marker then full replay) ends with the same state as a never-disconnected reducer, including a still-pending permission card and an already-resolved one staying gone.
- A permission whose `status` is not pending is not shown as a card.
- A `TOOL_CALL_RESULT` with non-text parts keeps those parts, not only the text.

### Task 1: Fixture loader and wire decoder

**Files:** Create `lib/src/transport/wire_decoder.dart` (export from the package barrel); Modify `test/model/adapter_contract_test.dart` (already unwraps `payload`); Test `test/transport/wire_decoder_test.dart`.

**Interfaces:**
- Produces: `BaseEvent decodeAgUiWire(Map<String, dynamic> json)`.

- [ ] **Step 1:** Test `decodeAgUiWire turns TOOL_CALL_RESULT content parts into text and keeps the parts`: input is the fixture's `tc1` result (a text part and a document part); expect a `ToolCallResultEvent` whose `content` is the joined text (`Edited a.txt`) and whose `rawEvent` is a map holding the original `content` list under `parts`. Test `a string content is passed through unchanged`. Test `a RUN_STARTED with the full input decodes`.
- [ ] **Step 2:** Implement `decodeAgUiWire`: copy the map; when `type == TOOL_CALL_RESULT` and `content` is a `List`, set `content` to the text parts joined with `\n` and put the list in `rawEvent: {'parts': list}`; call `BaseEvent.fromJson`.
- [ ] **Step 3:** In the reducer, `ToolCallResultEvent` stores `ToolResultPart.parts` (the list from `rawEvent['parts']`, else null). Add the field to `ToolResultPart` and regenerate freezed (`dart run build_runner build --delete-conflicting-outputs`).
- [ ] **Step 4:** The contract test's `_fixture()` uses `decodeAgUiWire`. Run `flutter test test/transport test/model/adapter_contract_test.dart`; the loader no longer throws and the contract assertions now show the reducer changes in Tasks 2 to 5.

### Task 2: Runs and the replay marker

**Files:** Modify `lib/src/model/conversation_reducer.dart`, `lib/src/model/conversation.dart` if run info moves; Test `test/model/conversation_reducer_test.dart`.

- [ ] **Step 1:** Tests: `a synthetic run does not flip isRunning`, `a synthetic RUN_FINISHED keeps the previous runResult and stopReason`, `a real RUN_STARTED after a synthetic one sets isRunning`, and `isReplaceMarker still resets on a local <ns>:sync`.
- [ ] **Step 2:** Treat `RUN_STARTED`/`RUN_FINISHED` whose `runId` starts with `synthetic-` as no-ops for run state (still record `threadId`). Define the prefix as a public const `kSyntheticRunPrefix`.
- [ ] **Step 3:** Remove the `<ns>:run` and `<ns>:tool_text` handlers; `partialText` is dropped from `ToolCallTimelineItem` only if nothing in the app reads it (check `grep -rn partialText`); otherwise keep the field. Update `runInfo`: keep `startedAt` from `RUN_STARTED.timestamp`, `durationMs` from `RUN_FINISHED.result`.

### Task 3: Permissions and elicitations

**Files:** Modify `_syncPermission`, `_upsertPermission`, `_syncElicitation`, `_upsertElicitation`, the `permission_resolved` handler; Test `test/model/conversation_reducer_*_test.dart`.

- [ ] **Step 1:** Tests from the fixture shapes in the table above: pending permission becomes a card keyed by the `by-id` key (the toolCallId); `status != pending` is not a card; `permission_resolved {toolCallId, response, approved}` stores a resolution whose `kind` is `cancelled` for `outcome.outcome == cancelled`, else `user_selected` or `auto_approved` as `approved` and the option imply; elicitation card from `request` with `mode` as a string, schema from `requestedSchema`, url from `url`.
- [ ] **Step 2:** `_upsertPermission` reads `request.toolCall.{title,kind,content,rawInput}`, `request.options`, `request._meta`, `request.sessionId`; `requestId` of the card is the `by-id` key, so `resolveRequest(toolCallId)` and the app's `respondPermission(callId)` keep working. Keep the JSON-RPC id in `extras`.
- [ ] **Step 3:** Update `_resolutions` shape consumers (`SessionState.resolutions`, tests) to the new `permission_resolved` payload; document it in `docs/event-vocabulary.md`.

### Task 4: New events and state keys

**Files:** Modify the reducer and `lib/src/model/session_models.dart`; Test reducer tests.

- [ ] **Step 1:** Rename `<ns>:content` to `<ns>:media` (payload `{turnId, messageId, channel, content}` where `content` is the ACP content block); keep standalone `MediaTimelineItem` and tool-attached behaviour.
- [ ] **Step 2:** `<ns>:tool` reads `_meta` (keep `meta` as a fallback key).
- [ ] **Step 3:** `<ns>:message_replaced {turnId, messageId, sessionUpdate, content}` replaces the text of the item with that message id (create it when missing); `<ns>:session_creation_failed {method, error}` sets `runError` and `runOutcome: failed`; `ACTIVITY_SNAPSHOT` with `activityType: plan` populates `SessionState.plans` (`body.kind`: entries/file/markdown); other activity types are `unhandledEvent`.
- [ ] **Step 4:** Accept state keys `client`, `session_setup`, `working_directories`, `session`, `activity` into typed fields on `SessionState` (`activity.state` drives a new `isAgentBusy` only if the app needs it; otherwise just raw maps, no diagnostic).

### Task 5: Contract test, vocabulary doc, version

- [ ] **Step 1:** Update the `known` sets in `adapter_contract_test.dart` to the new names; run `flutter test`. Expected: all green.
- [ ] **Step 2:** Rewrite `docs/event-vocabulary.md` from the table above; add a `CHANGELOG.md` entry and bump `pubspec.yaml`.
- [ ] **Step 3:** Commit per task. Push `ag_ui_widgets_flutter` to main when `flutter test` and `flutter analyze` are clean; then in Episutra repoint the three pubspecs at the new SHA.

## Not covered

Real-session behaviour with a live Claude Code ACP agent (manual smoke) and widget rendering of plans (`ACTIVITY_SNAPSHOT`); the plan only requires the state to be populated.
