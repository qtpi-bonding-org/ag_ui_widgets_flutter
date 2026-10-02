# Lossless Reducer State Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `ConversationReducer` keep every piece of data `acp-agui-adapter` emits — typed with Freezed models, nothing silently dropped — and make anything it still cannot interpret visible as a diagnostic.

**Architecture:** New Freezed value models (session state, tool content, diagnostics) with tolerant static `parse` functions that retain unknown keys in an `extras` map. The reducer parses the adapter's `/<namespace>` state tree into those models when state changes, attaches tool/permission/elicitation detail to timeline items, and records anything unrecognised in a bounded `Conversation.diagnostics` list. A fixture exported from the adapter's own projector drives a contract test that fails if the adapter emits something the reducer neither handles nor deliberately diagnoses.

**Tech Stack:** Dart / Flutter, `freezed` 3 + `freezed_annotation`, `build_runner`, `ag_ui` 0.3.0, `flutter_test`. One Rust task in the sibling repo `acp-agui-adapter` (`cargo test`).

**Spec:** None written. Requirements come from the adapter's emitted vocabulary: `/Users/aicoder/Documents/my-libs/acp-agui-adapter/src/ag_ui_projector.rs` (`to_ag_ui_event`, `apply_state_change`, `AgUiBatchProjector::project`) and `src/semantic.rs` / `src/content.rs` (payload types). The drop inventory in "Appendix A" is the requirement list. Builds on branch `feat/configurable-namespace` (configurable `namespace`, `acp.client_execute_request`, by-id permission/elicitation sync are already committed there).

## Global Constraints

- Repos: package `/Users/aicoder/Documents/my-libs/ag_ui_widgets_flutter` (branch `feat/configurable-namespace`); adapter `/Users/aicoder/Documents/my-libs/acp-agui-adapter` (Task 1–2 only, its own branch `fix/mode-state-and-fixtures`).
- Every new value class is `@freezed` (project rule: Freezed everywhere). Classes that do work (the reducer, `_OpenMessage`) are not values and stay plain.
- Freezed gotchas (from the owner's CLAUDE.md): never name a hand-written constructor `factory X.fromJson` (use `static X? parse(Object?)`); never a leading-underscore factory name; never a field named `required`.
- Parsers never throw and never drop a `Map`: a `Map` always parses to a model; unknown keys land in `extras`; non-`Map` input returns `null`.
- `namespace` default stays `'pocketcoder'`. Existing raw `SessionState` fields (`permission`, `elicitation`, `modes`, `config`, `plan`) and existing public names stay (additive change only), because pocketcoder pins this package.
- Wire key names are exactly the adapter's: camelCase except `session_info.updated_at`, and `by-id`.
- Format only files you create (`dart format <file>`); do NOT run `dart format` over existing files (it reformats unrelated lines and pollutes the diff).
- Codegen: `cd /Users/aicoder/Documents/my-libs/ag_ui_widgets_flutter && dart run build_runner build --delete-conflicting-outputs`. The `*.freezed.dart` files are committed; commit regenerated ones with the task that changed their source.
- A task is done only when `flutter test` (whole package) passes and `flutter analyze lib` reports no issues.
- Commits end with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.

## Review Focus

- A state key present with the wrong type (e.g. `"usage": "oops"`): parse yields `null`, no exception, and a `malformedPayload` diagnostic is recorded. (Task 5, 9)
- A full-namespace replace that no longer contains a key (e.g. `usage` removed): the typed field becomes `null`; state is mirrored, not merged. (Task 5)
- A DiffV2 `:diff` event (`{toolCallId, format, patch}`, no `path`/`newText`): kept as a `ToolPatch`, not dropped. (Task 6)
- `acp:source` volume: the adapter emits one per batch, so source records live in their own capped list (`Conversation.sourceRecords`, 200, oldest dropped) and can never evict a real diagnostic; diagnostics from state re-syncs are deduplicated, because a whole-namespace replace arrives on every state change. (Task 5, 8)
- A `:content`, `:terminal` or `:tool` event arriving for a tool-call id before its `TOOL_CALL_START`: lands on a placeholder tool item exactly like existing `:tool` events do. (Task 6)
- A stray unknown top-level state key (the adapter currently writes `currentModeId` at the top level — see Task 1): reported once as a diagnostic, not silently ignored. (Task 5, 9)

---

## File Structure

| File | Responsibility |
|---|---|
| `lib/src/model/wire_parse.dart` (create) | Tiny tolerant JSON helpers (`asJsonMap`, `asString`, `asInt`, `asJsonMapList`, `extrasOf`). |
| `lib/src/model/tool_models.dart` (create) | `ToolDiff` (moved), `ToolLocation`, `ToolTerminal`, `ToolPatch`, `MediaDescriptor`, `ToolContent` union. |
| `lib/src/model/session_models.dart` (create) | `AgentState`, `ModeState`, `CommandsState`, `ConfigState`, `UsageState`, `SessionInfo`, `PlansState` and their parts. |
| `lib/src/model/diagnostics.dart` (create) | `Diagnostic`, `DiagnosticKind`. |
| `lib/src/model/conversation.dart` (modify) | `OrderKey` → Freezed; new fields on tool/permission/elicitation items; `TimelineItem.media`; new `SessionState` fields; `Conversation.diagnostics`. |
| `lib/src/model/conversation_reducer.dart` (modify) | Parse/attach/diagnose. |
| `lib/src/widgets/timeline_to_messages.dart` (modify) | Forward the new tool data; map `MediaTimelineItem`. |
| `lib/ag_ui_widgets_flutter.dart` (modify) | Export the new model files. |
| `test/model/*_test.dart`, `test/widgets/timeline_to_messages_detail_test.dart`, `test/fixtures/adapter/ag_ui_session.json` (create) | Per-task tests and the contract fixture. |
| `docs/event-vocabulary.md` (create) | The event/state vocabulary table (Task 10). |

---

### Task 1: Adapter — `CurrentModeChanged` must update `mode.currentModeId` (adapter repo, Rust)

`apply_state_change` handles `CurrentModeChanged` in its generic `_ if is_state_change(c)` arm, which inserts at the *last path segment*: the delta path `/acp/mode/currentModeId` becomes a stray top-level key `currentModeId` and `mode.currentModeId` never changes. (`/acp/mode/meta` likewise writes a top-level `meta`.)

**Files:**
- Modify: `/Users/aicoder/Documents/my-libs/acp-agui-adapter/src/ag_ui_projector.rs` (`apply_state_change`, ~line 145; tests module ~line 760+)

**Interfaces:**
- Consumes: `SemanticChange::CurrentModeChanged { mode_id: String, meta: Option<serde_json::Value> }`, `SemanticChange::ModesSeeded { current_mode_id, available_modes: Vec<Value>, meta }`, test helpers `test_source(n)` and `SourcedChangeBatch::new(source, changes)` (already used by neighbouring tests).
- Produces: after a `CurrentModeChanged`, `projector.state["mode"]["currentModeId"] == mode_id` and the state object has no top-level `currentModeId`/`meta` keys.

- [ ] **Step 1: Create the branch**

```bash
cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && git checkout -b fix/mode-state-and-fixtures
```

- [ ] **Step 2: Write the failing test** (insert inside `mod tests` — the module at line 702 that defines the private `test_source` helper — before its closing brace at about line 913. NOT in `mod ported_tests` at line 916: `test_source` is not visible there)

```rust
    #[test]
    fn current_mode_changed_updates_mode_current_mode_id_in_state() {
        let mut projector = AgUiBatchProjector::new("acp", "session-1");
        let seeded = SemanticChange::ModesSeeded {
            current_mode_id: "ask".into(),
            available_modes: vec![
                serde_json::json!({"id": "ask", "name": "Ask"}),
                serde_json::json!({"id": "code", "name": "Code"}),
            ],
            meta: None,
        };
        let changed = SemanticChange::CurrentModeChanged {
            mode_id: "code".into(),
            meta: Some(serde_json::json!({"by": "user"})),
        };
        projector
            .project(&SourcedChangeBatch::new(test_source(1), vec![seeded]))
            .unwrap();
        projector
            .project(&SourcedChangeBatch::new(test_source(2), vec![changed]))
            .unwrap();

        let state = &projector.state;
        assert_eq!(state["mode"]["currentModeId"], "code", "state: {state}");
        assert_eq!(state["mode"]["meta"], serde_json::json!({"by": "user"}));
        assert!(
            state.get("currentModeId").is_none() && state.get("meta").is_none(),
            "must not leak top-level keys: {state}"
        );
        assert_eq!(state["mode"]["availableModes"].as_array().unwrap().len(), 2);
    }
```

- [ ] **Step 3: Run it to confirm it fails**

Run: `cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && cargo test current_mode_changed_updates_mode -- --nocapture`
Expected: FAIL (`state["mode"]["currentModeId"]` is still `"ask"`, or a top-level `currentModeId` exists).

- [ ] **Step 4: Implement** — add this arm in `apply_state_change`, immediately BEFORE the `_ if is_state_change(c) => {` arm:

```rust
        SemanticChange::CurrentModeChanged { mode_id, meta } => {
            let mode = object
                .entry("mode")
                .or_insert_with(|| serde_json::json!({}));
            mode["currentModeId"] = serde_json::json!(mode_id);
            if let Some(m) = meta {
                mode["meta"] = m.clone();
            }
        }
```

- [ ] **Step 5: Run the test and the whole crate suite**

Run: `cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && cargo test`
Expected: PASS (all tests, including the new one).

- [ ] **Step 6: Commit (local; do not push without the owner's go-ahead)**

```bash
cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && git add src/ag_ui_projector.rs && git commit -m "fix(projector): CurrentModeChanged updates mode.currentModeId in state

The generic state arm keyed the update by the last path segment, so a mode
change wrote a stray top-level currentModeId (and meta) and never changed
mode.currentModeId.

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Adapter — export a golden AG-UI session fixture (adapter repo, Rust)

The Dart contract test (Task 10) needs *real* projector output. Add a test that drives `AgUiBatchProjector` with one `SemanticChange` per state/CUSTOM-relevant variant, serialises every projected `Event` to JSON, and writes `tests/fixtures/ag_ui_session.json` when `UPDATE_FIXTURES=1` (otherwise it asserts the file is up to date).

**Files:**
- Create: `/Users/aicoder/Documents/my-libs/acp-agui-adapter/tests/fixtures/ag_ui_session.json` (generated)
- Modify: `/Users/aicoder/Documents/my-libs/acp-agui-adapter/src/ag_ui_projector.rs` (tests module)

**Interfaces:**
- Consumes: `SessionParser` + `SemanticChange` constructors in `src/semantic.rs`, `AgUiBatchProjector::project`, `SourcedAgUiEvent` (serialises with an extra `sourceEventId` key — keep it in the fixture), `test_source(n)`.
- Produces: `tests/fixtures/ag_ui_session.json` — a JSON array of event objects, in emission order, covering at least: `acp:source`, `STATE_SNAPSHOT`, `STATE_DELTA` (whole-namespace replace), `<ns>:tool` (with `locations` and `meta`), `<ns>:diff` (both shapes), `<ns>:terminal`, `<ns>:content` (with `toolCallId` and with `messageId`), `<ns>:response_meta`, `<ns>:sync`, `acp.client_execute_request`, `RAW` (`unmapped`), plus a pending permission carrying `content` and a pending form elicitation, a plan, commands, agent, mode (incl. a mode change), config, session_info and usage in state.

- [ ] **Step 1: Write the exporter test** (insert inside `mod tests`, the module that starts at `ag_ui_projector.rs:702` and already has `use super::*;`, `SessionParser` and the private `test_source(seq)` helper at :734 — before its closing brace at about line 913, not in `mod ported_tests`)

```rust
    /// Regenerate with: UPDATE_FIXTURES=1 cargo test golden_session_fixture
    #[test]
    fn golden_session_fixture_matches_projector_output() {
        let mut projector = AgUiBatchProjector::new("episutra", "session-1");
        let mut events = Vec::new();
        for (i, change) in golden_changes().into_iter().enumerate() {
            let batch = SourcedChangeBatch::new(test_source(i as u64 + 1), vec![change]);
            for sourced in projector.project(&batch).unwrap() {
                events.push(serde_json::to_value(&sourced).unwrap());
            }
        }
        let rendered = serde_json::to_string_pretty(&events).unwrap() + "\n";
        let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("tests/fixtures/ag_ui_session.json");
        if std::env::var("UPDATE_FIXTURES").is_ok() {
            std::fs::create_dir_all(path.parent().unwrap()).unwrap();
            std::fs::write(&path, rendered).unwrap();
        } else {
            let on_disk = std::fs::read_to_string(&path)
                .expect("fixture missing: run with UPDATE_FIXTURES=1");
            assert_eq!(on_disk, rendered, "fixture stale: run with UPDATE_FIXTURES=1");
        }
    }

    /// One change per variant the Dart reducer must understand. `ReplayStarted`
    /// is FIRST on purpose: it projects to `<ns>:sync`, which makes a consumer
    /// reset its state, so it must not come after the state-bearing changes.
    fn golden_changes() -> Vec<SemanticChange> {
        use crate::semantic::{
            ElicitationModeValue, ElicitationScopeValue, MediaKind, PermissionOptionValue,
            ToolCallContentValue, ToolCallLocationValue,
        };
        use serde_json::json;
        let turn = || "turn-1".to_string();
        let media = |kind: &str, mime: &str| crate::content::MediaDescriptor {
            kind: kind.into(),
            mime_type: Some(mime.into()),
            uri: None,
            name: None,
            size: None,
            data: None,
            blob: None,
            title: None,
            description: None,
            annotations: None,
        };
        vec![
            SemanticChange::ReplayStarted,
            SemanticChange::MessageStarted {
                turn_id: turn(),
                message_id: "m1".into(),
                role: "assistant".into(),
            },
            SemanticChange::MessageDelta {
                turn_id: turn(),
                message_id: "m1".into(),
                text: "hello".into(),
            },
            SemanticChange::MediaChunk {
                turn_id: turn(),
                message_id: "m1".into(),
                kind: MediaKind::Message,
                descriptor: media("audio", "audio/wav"),
            },
            SemanticChange::MessageEnded {
                turn_id: turn(),
                message_id: "m1".into(),
            },
            SemanticChange::ToolCallStarted {
                turn_id: turn(),
                tool_call_id: "tc1".into(),
                title: "Edit a.txt".into(),
                kind: Some("edit".into()),
                raw_input: Some(json!({"path": "a.txt"})),
                meta: None,
            },
            SemanticChange::ToolCallProgress {
                turn_id: turn(),
                tool_call_id: "tc1".into(),
                title: "Edit a.txt".into(),
                kind: Some("edit".into()),
                status: Some("in_progress".into()),
                locations: vec![ToolCallLocationValue {
                    path: "a.txt".into(),
                    line: Some(3),
                }],
                // The projector reads `new_content` (not `content`) for tool
                // progress, so the typed content goes there.
                content: vec![],
                new_content: vec![
                    ToolCallContentValue::Diff {
                        path: "a.txt".into(),
                        old_text: None,
                        new_text: "x".into(),
                    },
                    ToolCallContentValue::DiffV2 {
                        format: Some("unified".into()),
                        patch: Some("@@ -1 +1 @@".into()),
                    },
                    ToolCallContentValue::Terminal {
                        terminal_id: "t1".into(),
                        meta: Some(json!({"cwd": "/"})),
                    },
                    ToolCallContentValue::Media(media("image", "image/png")),
                    ToolCallContentValue::Unhandled(json!({"type": "future"})),
                ],
                raw_output: None,
                meta: Some(json!({"k": 1})),
            },
            SemanticChange::ToolCallCompleted {
                turn_id: turn(),
                tool_call_id: "tc1".into(),
                title: "Edit a.txt".into(),
                kind: Some("edit".into()),
                locations: vec![],
                meta: None,
                success: true,
                past_tense_message: "Edited a.txt".into(),
                content: vec![ToolCallContentValue::Text("Edited a.txt".into())],
                raw_output: None,
            },
            SemanticChange::ToolCallRejectedEmptyId {
                turn_id: turn(),
                title: Some("orphan".into()),
                kind: None,
                status: None,
                content: vec![],
                raw_input: None,
                raw_output: None,
                locations: vec![],
                meta: None,
            },
            SemanticChange::ResponseMeta {
                method: "session/new".into(),
                meta: json!({"a": 1}),
            },
            SemanticChange::PermissionPending {
                turn_id: turn(),
                request_id: "req-1".into(),
                session_id: "s1".into(),
                tool_call_id: "tc2".into(),
                title: "Run ls".into(),
                options: vec![PermissionOptionValue {
                    option_id: "allow_once".into(),
                    name: "Allow".into(),
                    kind: "allow_once".into(),
                    meta: None,
                }],
                kind: Some("execute".into()),
                content: vec![ToolCallContentValue::Terminal {
                    terminal_id: "t2".into(),
                    meta: None,
                }],
                raw_input: None,
                meta: Some(json!({"m": 1})),
            },
            SemanticChange::ElicitationPending {
                request_id: "e1".into(),
                mode: ElicitationModeValue::Form {
                    schema: json!({"type": "object"}),
                },
                scope: ElicitationScopeValue::Request {
                    request_id: "req-2".into(),
                },
                message: "Need input".into(),
                meta: None,
            },
            SemanticChange::PlanEntriesSet {
                plan_id: Some("p1".into()),
                entries: vec![json!({"content": "do it", "priority": "high", "status": "pending"})],
                meta: None,
            },
            SemanticChange::PlanFileSet {
                plan_id: "p2".into(),
                uri: "file:///plan.md".into(),
                meta: None,
            },
            SemanticChange::PlanMarkdownSet {
                plan_id: "p3".into(),
                content: "# plan".into(),
                meta: None,
            },
            SemanticChange::AvailableCommandsSet {
                commands: vec![json!({"name": "plan", "description": "make a plan"})],
                meta: None,
            },
            SemanticChange::AgentInitialized {
                protocol_version: 1,
                agent_info: Some(json!({"name": "claude", "title": "Claude", "version": "2"})),
                capabilities: json!({"loadSession": true}),
                auth_methods: vec![json!({"id": "oauth", "name": "OAuth"})],
                meta: None,
            },
            SemanticChange::ModesSeeded {
                current_mode_id: "ask".into(),
                available_modes: vec![
                    json!({"id": "ask", "name": "Ask"}),
                    json!({"id": "code", "name": "Code"}),
                ],
                meta: None,
            },
            SemanticChange::CurrentModeChanged {
                mode_id: "code".into(),
                meta: None,
            },
            SemanticChange::ConfigOptionsSet {
                options: vec![json!({
                    "id": "model", "name": "Model", "type": "select",
                    "currentValue": "a", "options": [{"value": "a", "name": "A"}]
                })],
                meta: None,
            },
            SemanticChange::SessionInfoSet {
                title: Some(Some("Hello".into())),
                updated_at: Some(Some("2026-10-01T00:00:00Z".into())),
                meta: None,
            },
            SemanticChange::UsageSet {
                turn_id: turn(),
                used: 10,
                size: 100,
                cost: Some(json!({"amount": 0.5, "currency": "USD"})),
                meta: None,
            },
            SemanticChange::ClientExecuteRequested {
                call_id: "c1".into(),
                tool_name: "create_note".into(),
                args: json!({"title": "x"}),
            },
            SemanticChange::Unmapped {
                kind: "future_update".into(),
                payload: json!({"a": 1}),
            },
            SemanticChange::RunFinished {
                turn_id: turn(),
                stop_reason: "end_turn".into(),
                duration_ms: 1,
            },
        ]
    }

    /// Compile-time guard: adding a `SemanticChange` variant makes this `match`
    /// fail to compile until the new variant is either put in `golden_changes`
    /// or explicitly listed as not-in-the-fixture. No wildcard arm, on purpose.
    #[allow(dead_code)]
    fn every_variant_is_acknowledged(c: &SemanticChange) {
        use SemanticChange::*;
        match c {
            // In the fixture:
            ReplayStarted | MessageStarted { .. } | MessageDelta { .. } | MediaChunk { .. }
            | MessageEnded { .. } | ToolCallStarted { .. } | ToolCallProgress { .. }
            | ToolCallCompleted { .. } | ToolCallRejectedEmptyId { .. } | ResponseMeta { .. }
            | PermissionPending { .. } | ElicitationPending { .. } | PlanEntriesSet { .. }
            | PlanFileSet { .. } | PlanMarkdownSet { .. } | AvailableCommandsSet { .. }
            | AgentInitialized { .. } | ModesSeeded { .. } | CurrentModeChanged { .. }
            | ConfigOptionsSet { .. } | SessionInfoSet { .. } | UsageSet { .. }
            | ClientExecuteRequested { .. } | Unmapped { .. } | RunFinished { .. } => {}
            // Not in the fixture: they project to standard AG-UI events or only
            // remove state, and RunStarted needs a heavyweight AHP message.
            RunStarted { .. } | RunError { .. } | ReasoningStarted { .. }
            | ReasoningDelta { .. } | ReasoningEnded { .. } | ToolCallArgsDelta { .. }
            | PermissionResolved { .. } | ElicitationResolved { .. } | PlanRemoved { .. }
            | StateSnapshotTaken { .. } => {}
        }
    }
```

  If a field list does not compile, `src/semantic.rs` (the `SemanticChange` enum, lines 1–215) and `src/content.rs` (`MediaDescriptor`, line 25) are the source of truth; fix the literal to match, do not weaken the test.

- [ ] **Step 2: Run it to confirm it fails** (fixture missing)

Run: `cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && cargo test golden_session_fixture`
Expected: FAIL with "fixture missing".

- [ ] **Step 3: Generate the fixture**

Run: `cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && UPDATE_FIXTURES=1 cargo test golden_session_fixture && cargo test`
Expected: PASS. Open `tests/fixtures/ag_ui_session.json` and confirm it contains each name listed under "Produces". It MUST include `episutra:diff` in both shapes (one with `path`, one with `patch`), `episutra:terminal`, a tool-level `episutra:content` (has `toolCallId`) and a message-level one (has `messageId`), a `TOOL_CALL_RESULT`, and RAW events with `unmapped` of `tool_call_content`, `tool_call_empty_id` and `future_update`; if any is missing, `golden_changes` is wrong, so fix it and regenerate. (grep: `grep -o '"name": "[^"]*"' tests/fixtures/ag_ui_session.json | sort | uniq -c`).

- [ ] **Step 4: Commit (local)**

```bash
cd /Users/aicoder/Documents/my-libs/acp-agui-adapter && git add src/ag_ui_projector.rs tests/fixtures/ag_ui_session.json && git commit -m "test(projector): golden AG-UI session fixture for downstream contract tests

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 3: `OrderKey` becomes Freezed (package)

**Files:**
- Modify: `lib/src/model/conversation.dart` (the `OrderKey` class, ~line 43)
- Create: `test/model/order_key_test.dart`
- Regenerate: `lib/src/model/conversation.freezed.dart`

**Interfaces:**
- Produces: `OrderKey(int seq, [int sub = 0])` — same call shape as today (`OrderKey(5)`, `OrderKey(anchor.seq, 1)`), `Comparable<OrderKey>`, value `==`/`hashCode`, `copyWith`.

- [ ] **Step 1: Write the failing test** `test/model/order_key_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';

void main() {
  test('orders by seq, then sub', () {
    expect(const OrderKey(1).compareTo(const OrderKey(2)), isNegative);
    expect(const OrderKey(2, 1).compareTo(const OrderKey(2)), isPositive);
    expect(const OrderKey(2, 1).compareTo(const OrderKey(2, 1)), isZero);
  });

  test('has value equality and defaults sub to 0', () {
    expect(const OrderKey(3), const OrderKey(3, 0));
    expect(const OrderKey(3).hashCode, const OrderKey(3, 0).hashCode);
    expect(const OrderKey(3, 1), isNot(const OrderKey(3, 2)));
  });

  test('copyWith changes one component', () {
    expect(const OrderKey(3, 1).copyWith(sub: 2), const OrderKey(3, 2));
  });
}
```

- [ ] **Step 2: Run to confirm it fails**

Run: `cd /Users/aicoder/Documents/my-libs/ag_ui_widgets_flutter && flutter test test/model/order_key_test.dart`
Expected: FAIL (`copyWith` isn't defined on `OrderKey`).

- [ ] **Step 3: Replace the class** in `conversation.dart`:

```dart
/// Total order over timeline items. `seq` is the reducer's monotonic
/// event-arrival counter, bumped once per `apply()` call. `sub` orders
/// items correlated to the same anchor (e.g. a permission card pinned
/// just after its tool call) without needing a fractional key.
@freezed
abstract class OrderKey with _$OrderKey implements Comparable<OrderKey> {
  const OrderKey._();
  const factory OrderKey(int seq, [@Default(0) int sub]) = _OrderKey;

  @override
  int compareTo(OrderKey other) =>
      seq != other.seq ? seq.compareTo(other.seq) : sub.compareTo(other.sub);
}
```

- [ ] **Step 4: Regenerate and run the whole suite**

Run: `cd /Users/aicoder/Documents/my-libs/ag_ui_widgets_flutter && dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib`
Expected: PASS, no analyzer issues.

- [ ] **Step 5: Commit**

```bash
git add lib/src/model/conversation.dart lib/src/model/conversation.freezed.dart test/model/order_key_test.dart && git commit -m "refactor(model): OrderKey is a Freezed value class

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 4: Tolerant parse helpers + tool content models (package)

**Files:**
- Create: `lib/src/model/wire_parse.dart`, `lib/src/model/tool_models.dart`
- Modify: `lib/src/model/conversation.dart` (remove `ToolDiff`; add `export 'tool_models.dart';` and `import 'tool_models.dart';`)
- Modify: `lib/ag_ui_widgets_flutter.dart` (add `export 'src/model/tool_models.dart';` — keep existing exports)
- Test: `test/model/tool_models_test.dart`

**Interfaces:**
- Produces (`wire_parse.dart`): `Map<String,dynamic>? asJsonMap(Object?)`, `String? asString(Object?)`, `int? asInt(Object?)`, `List<Map<String,dynamic>> asJsonMapList(Object?)`, `Map<String,dynamic> extrasOf(Map<String,dynamic>, Set<String> known)`.
- Produces (`tool_models.dart`): `ToolDiff({required path, @Default('') oldText, required newText})` (unchanged shape, moved); `ToolLocation({required String path, int? line, extras})`; `ToolTerminal({required String terminalId, Map<String,dynamic>? meta, extras})`; `ToolPatch({String? format, required String patch, extras})`; `MediaDescriptor({required String kind, String? mimeType, uri, name, title, description, data, blob, messageId, toolCallId, int? size, extras})`; sealed `ToolContent` = `.diff(ToolDiff)` / `.patch(ToolPatch)` / `.terminal(ToolTerminal)` / `.media(MediaDescriptor)` / `.unknown(Map<String,dynamic>)`. Each of `ToolLocation`, `ToolTerminal`, `ToolPatch`, `MediaDescriptor`, `ToolContent` has `static X? parse(Object?)` returning `null` only for a non-`Map`. `extras` is `Map<String,dynamic>` defaulting to `{}`.

- [ ] **Step 1: Write the failing test** `test/model/tool_models_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/tool_models.dart';

void main() {
  group('ToolLocation.parse', () {
    test('reads path and line, keeps unknown keys', () {
      final l = ToolLocation.parse({'path': 'a.dart', 'line': 7, 'x': 1})!;
      expect(l.path, 'a.dart');
      expect(l.line, 7);
      expect(l.extras, {'x': 1});
    });
    test('line is optional; non-map is null', () {
      expect(ToolLocation.parse({'path': 'a'})!.line, isNull);
      expect(ToolLocation.parse('nope'), isNull);
    });
    test('a missing path becomes empty, not a dropped entry', () {
      expect(ToolLocation.parse({'line': 3})!.path, '');
    });
  });

  test('ToolTerminal.parse keeps meta', () {
    final t = ToolTerminal.parse(
        {'toolCallId': 'tc', 'terminalId': 't1', 'meta': {'k': 1}})!;
    expect(t.terminalId, 't1');
    expect(t.meta, {'k': 1});
    expect(t.extras, isEmpty, reason: 'toolCallId is routing, not data');
  });

  test('ToolPatch.parse reads format and patch', () {
    final p = ToolPatch.parse(
        {'toolCallId': 'tc', 'format': 'unified', 'patch': '@@ -1 +1 @@'})!;
    expect(p.format, 'unified');
    expect(p.patch, '@@ -1 +1 @@');
  });

  test('MediaDescriptor.parse reads every adapter field', () {
    final m = MediaDescriptor.parse({
      'kind': 'image',
      'mimeType': 'image/png',
      'uri': 'file:///a.png',
      'name': 'a.png',
      'size': 12,
      'data': 'AAAA',
      'title': 'T',
      'description': 'D',
      'messageId': 'm1',
      'other': true,
    })!;
    expect(m.kind, 'image');
    expect(m.mimeType, 'image/png');
    expect(m.size, 12);
    expect(m.messageId, 'm1');
    expect(m.extras, {'other': true});
  });

  group('ToolContent.parse', () {
    test('diff', () {
      final c = ToolContent.parse(
          {'toolCallId': 't', 'path': 'a', 'oldText': null, 'newText': 'b'});
      expect(c, isA<ToolContentDiff>());
      expect((c as ToolContentDiff).diff.oldText, '');
      expect(c.diff.extras, isEmpty);
    });
    test('patch (DiffV2: no path, no newText)', () {
      expect(ToolContent.parse({'toolCallId': 't', 'patch': 'p'}),
          isA<ToolContentPatch>());
    });
    test('terminal', () {
      expect(ToolContent.parse({'toolCallId': 't', 'terminalId': 'x'}),
          isA<ToolContentTerminal>());
    });
    test('media', () {
      expect(ToolContent.parse({'toolCallId': 't', 'kind': 'image'}),
          isA<ToolContentMedia>());
    });
    test('anything else is kept as unknown, never dropped', () {
      final c = ToolContent.parse({'weird': 1});
      expect(c, isA<ToolContentUnknown>());
      expect((c as ToolContentUnknown).raw, {'weird': 1});
    });
    test('non-map is null', () => expect(ToolContent.parse(3), isNull));
  });
}
```

- [ ] **Step 2: Run to confirm it fails**

Run: `flutter test test/model/tool_models_test.dart`
Expected: FAIL (file `tool_models.dart` does not exist).

- [ ] **Step 3: Create `lib/src/model/wire_parse.dart`**

```dart
// lib/src/model/wire_parse.dart
// Tolerant JSON readers for wire payloads. They never throw: a value of the
// wrong type reads as null (or empty), so a malformed field cannot take the
// reducer down. Callers decide whether a null means "absent" or "malformed".

Map<String, dynamic>? asJsonMap(Object? v) =>
    v is Map ? Map<String, dynamic>.from(v) : null;

String? asString(Object? v) => v is String ? v : null;

int? asInt(Object? v) => v is num ? v.toInt() : null;

List<Map<String, dynamic>> asJsonMapList(Object? v) => v is List
    ? [
        for (final e in v)
          if (e is Map) Map<String, dynamic>.from(e),
      ]
    : const [];

/// Every entry of [m] whose key is not in [known] — what a model keeps in its
/// `extras` so an unknown wire field is retained, never discarded.
Map<String, dynamic> extrasOf(Map<String, dynamic> m, Set<String> known) => {
      for (final e in m.entries)
        if (!known.contains(e.key)) e.key: e.value,
    };
```

- [ ] **Step 4: Create `lib/src/model/tool_models.dart`**

```dart
// lib/src/model/tool_models.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'wire_parse.dart';

part 'tool_models.freezed.dart';

/// One diff hunk from a tool call's result — the full before/after text for
/// one file. [oldText] is empty for new-file diffs (the wire's `oldText` is
/// absent or null for a new file).
@freezed
abstract class ToolDiff with _$ToolDiff {
  const factory ToolDiff({
    required String path,
    @Default('') String oldText,
    required String newText,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolDiff;
}

/// A file location a tool call touches (`{path, line?}`).
@freezed
abstract class ToolLocation with _$ToolLocation {
  const ToolLocation._();
  const factory ToolLocation({
    required String path,
    int? line,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolLocation;

  static const _known = {'path', 'line'};

  static ToolLocation? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolLocation(
      path: asString(m['path']) ?? '',
      line: asInt(m['line']),
      extras: extrasOf(m, _known),
    );
  }
}

/// A terminal attached to a tool call (`{terminalId, meta?}`).
@freezed
abstract class ToolTerminal with _$ToolTerminal {
  const ToolTerminal._();
  const factory ToolTerminal({
    required String terminalId,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolTerminal;

  // `toolCallId` is the routing key the reducer uses to attach this to a tool
  // item; it is not data of the terminal itself, so it is not an extra.
  static const _known = {'terminalId', 'meta', 'toolCallId'};

  static ToolTerminal? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolTerminal(
      terminalId: asString(m['terminalId']) ?? '',
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

/// A patch-style diff (ACP DiffV2): `{format?, patch}` with no per-file
/// before/after text.
@freezed
abstract class ToolPatch with _$ToolPatch {
  const ToolPatch._();
  const factory ToolPatch({
    String? format,
    required String patch,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolPatch;

  static const _known = {'format', 'patch', 'toolCallId'};

  static ToolPatch? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolPatch(
      format: asString(m['format']),
      patch: asString(m['patch']) ?? '',
      extras: extrasOf(m, _known),
    );
  }
}

/// A non-text content block (image, audio, resource link, ...) as the
/// adapter summarises it. [messageId] is set when it belongs to a message,
/// [toolCallId] when it belongs to a tool call.
@freezed
abstract class MediaDescriptor with _$MediaDescriptor {
  const MediaDescriptor._();
  const factory MediaDescriptor({
    required String kind,
    String? mimeType,
    String? uri,
    String? name,
    String? title,
    String? description,
    String? data,
    String? blob,
    int? size,
    String? messageId,
    String? toolCallId,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _MediaDescriptor;

  static const _known = {
    'kind', 'mimeType', 'uri', 'name', 'title', 'description', 'data', 'blob',
    'size', 'messageId', 'toolCallId',
  };

  static MediaDescriptor? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return MediaDescriptor(
      kind: asString(m['kind']) ?? '',
      mimeType: asString(m['mimeType']),
      uri: asString(m['uri']),
      name: asString(m['name']),
      title: asString(m['title']),
      description: asString(m['description']),
      data: asString(m['data']),
      blob: asString(m['blob']),
      size: asInt(m['size']),
      messageId: asString(m['messageId']),
      toolCallId: asString(m['toolCallId']),
      extras: extrasOf(m, _known),
    );
  }
}

/// One entry of a tool call's content as it appears on a permission request:
/// the same payload shapes the adapter sends as `<ns>:diff`, `<ns>:terminal`
/// and `<ns>:content`.
@freezed
sealed class ToolContent with _$ToolContent {
  const ToolContent._();
  const factory ToolContent.diff(ToolDiff diff) = ToolContentDiff;
  const factory ToolContent.patch(ToolPatch patch) = ToolContentPatch;
  const factory ToolContent.terminal(ToolTerminal terminal) =
      ToolContentTerminal;
  const factory ToolContent.media(MediaDescriptor media) = ToolContentMedia;
  const factory ToolContent.unknown(Map<String, dynamic> raw) =
      ToolContentUnknown;

  static ToolContent? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    if (m['terminalId'] is String) {
      return ToolContent.terminal(ToolTerminal.parse(m)!);
    }
    if (m['patch'] is String) return ToolContent.patch(ToolPatch.parse(m)!);
    if (m['path'] is String && m['newText'] is String) {
      return ToolContent.diff(ToolDiff(
        path: m['path'] as String,
        oldText: asString(m['oldText']) ?? '',
        newText: m['newText'] as String,
        extras: extrasOf(m, const {'path', 'oldText', 'newText', 'toolCallId'}),
      ));
    }
    if (m['kind'] is String) {
      return ToolContent.media(MediaDescriptor.parse(m)!);
    }
    return ToolContent.unknown(m);
  }
}
```

- [ ] **Step 5: Move `ToolDiff` out of `conversation.dart`.** Delete its `@freezed abstract class ToolDiff ...` block there, add `import 'tool_models.dart';` and `export 'tool_models.dart';` below the `part` line's imports, and add `export 'src/model/tool_models.dart';` to `lib/ag_ui_widgets_flutter.dart`.

- [ ] **Step 6: Regenerate and run everything**

Run: `dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib`
Expected: PASS (the new tests plus all existing ones).

- [ ] **Step 7: Commit**

```bash
git add lib test && git commit -m "feat(model): tolerant wire helpers and Freezed tool content models

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Typed session state models and reducer wiring (package)

**Files:**
- Create: `lib/src/model/session_models.dart`, `lib/src/model/diagnostics.dart`
- Modify: `lib/src/model/conversation.dart` (`SessionState` fields; `Conversation.diagnostics`), `lib/src/model/conversation_reducer.dart`, `lib/ag_ui_widgets_flutter.dart`
- Test: `test/model/session_models_test.dart`, `test/model/conversation_reducer_session_state_test.dart`

**Interfaces:**
- Produces (`diagnostics.dart`):
  ```dart
  enum DiagnosticKind { unknownCustom, unhandledEvent, raw, malformedPayload, unknownStateKey }
  @freezed abstract class Diagnostic { const factory Diagnostic({required DiagnosticKind kind, required String name, Object? payload, required int index}) }  // index: monotonic, never reset by a replay
  ```
- Produces (`session_models.dart`), every class has `extras` and `static X? parse(Object?)` (null only for non-`Map`); list entries never fail to parse:
  `AuthMethod({String? id, name, description})`, `AgentInfo({String? name, title, version})`, `AgentState({int? protocolVersion, AgentInfo? agentInfo, Map<String,dynamic>? agentCapabilities, List<AuthMethod> authMethods, Map? meta})`, `SessionMode({String? id, name, description})`, `ModeState({String? currentModeId, List<SessionMode> availableModes, Map? meta})`, `AvailableCommand({String? name, description, Map<String,dynamic>? input})`, `CommandsState({List<AvailableCommand> commands, Map? meta})`, `ConfigOption({String? id, name, description, category, type, Object? currentValue, List<Map<String,dynamic>> choices})`, `ConfigState({List<ConfigOption> options, Map? meta})`, `UsageCost({num? amount, String? currency})`, `UsageState({int? used, int? size, UsageCost? cost, Map? meta})`, `SessionInfo({String? title, String? updatedAt, Map? meta})`, `PlanEntry({String? content, priority, status})`, `PlanState({List<PlanEntry>? entries, String? uri, String? markdown, Map? meta})`, `PlansState({Map<String,PlanState> byId = {}, PlanState? legacy})`.
- Produces (`SessionState`, new fields, all default `null`/empty): `AgentState? agent`, `ModeState? mode`, `CommandsState? commands`, `ConfigState? configState`, `UsageState? usage`, `SessionInfo? sessionInfo`, `PlansState plans` (default `PlansState()`), `Map<String,dynamic> responseMeta` (default `{}`; filled in Task 6). Existing fields unchanged.
- Produces: `Conversation.diagnostics: List<Diagnostic>` and `Conversation.sourceRecords: List<Map<String, dynamic>>` (the `acp:source` wire records, kept separately so their volume cannot evict diagnostics), both default `[]`.
- Wire keys read from `/<ns>`: `agent` `{protocolVersion, agentInfo, agentCapabilities, authMethods, meta}`, `mode` `{currentModeId, availableModes, meta}`, `commands` `{commands, meta}`, `config` `{options, meta}`, `usage` `{used, size, cost, meta}`, `session_info` `{title, updated_at, meta}`, `plans` `{by-id: {<id>: {entries|uri|markdown, meta}}, legacy: {...}}`.

- [ ] **Step 1: Write the failing model tests** `test/model/session_models_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/session_models.dart';

void main() {
  test('ModeState.parse reads current mode and keeps every mode', () {
    final m = ModeState.parse({
      'currentModeId': 'code',
      'availableModes': [
        {'id': 'ask', 'name': 'Ask', 'description': 'd', '_meta': {'a': 1}},
        {'id': 'code', 'name': 'Code'},
      ],
      'meta': {'by': 'u'},
    })!;
    expect(m.currentModeId, 'code');
    expect(m.availableModes.map((x) => x.id), ['ask', 'code']);
    expect(m.availableModes.first.extras, {'_meta': {'a': 1}});
    expect(m.meta, {'by': 'u'});
  });

  test('a list entry without an id is kept, not dropped', () {
    final m = ModeState.parse({'availableModes': [{'name': 'x'}]})!;
    expect(m.availableModes.single.id, isNull);
    expect(m.availableModes.single.name, 'x');
  });

  test('AgentState.parse reads agentInfo, capabilities and auth methods', () {
    final a = AgentState.parse({
      'protocolVersion': 1,
      'agentInfo': {'name': 'claude', 'title': 'Claude', 'version': '2'},
      'agentCapabilities': {'loadSession': true},
      'authMethods': [{'id': 'oauth', 'name': 'OAuth'}],
      'meta': {'m': 1},
      'future': 'kept',
    })!;
    expect(a.protocolVersion, 1);
    expect(a.agentInfo!.title, 'Claude');
    expect(a.agentCapabilities, {'loadSession': true});
    expect(a.authMethods.single.id, 'oauth');
    expect(a.extras, {'future': 'kept'});
  });

  test('CommandsState and ConfigState keep their entries', () {
    final c = CommandsState.parse({
      'commands': [{'name': 'plan', 'description': 'd', 'input': {'hint': 'h'}}],
    })!;
    expect(c.commands.single.input, {'hint': 'h'});
    final cfg = ConfigState.parse({
      'options': [
        {
          'id': 'model', 'name': 'Model', 'category': 'model', 'type': 'select',
          'currentValue': 'a',
          'options': [{'value': 'a', 'name': 'A'}],
        },
      ],
    })!;
    expect(cfg.options.single.currentValue, 'a');
    expect(cfg.options.single.choices.single['value'], 'a');
  });

  test('UsageState.parse reads used, size and cost', () {
    final u = UsageState.parse({
      'used': 10, 'size': 100, 'cost': {'amount': 0.5, 'currency': 'USD'},
    })!;
    expect(u.used, 10);
    expect(u.size, 100);
    expect(u.cost!.currency, 'USD');
  });

  test('SessionInfo.parse maps updated_at', () {
    final s = SessionInfo.parse({'title': 'T', 'updated_at': '2026-10-01'})!;
    expect(s.title, 'T');
    expect(s.updatedAt, '2026-10-01');
  });

  test('PlansState.parse reads by-id and legacy plans', () {
    final p = PlansState.parse({
      'by-id': {
        'p1': {'entries': [{'content': 'do', 'priority': 'high', 'status': 'pending'}]},
        'p2': {'uri': 'file:///plan.md'},
        'p3': {'markdown': '# plan'},
      },
      'legacy': {'entries': []},
    })!;
    expect(p.byId['p1']!.entries!.single.priority, 'high');
    expect(p.byId['p2']!.uri, 'file:///plan.md');
    expect(p.byId['p3']!.markdown, '# plan');
    expect(p.legacy!.entries, isEmpty);
  });

  test('parse returns null only for non-maps', () {
    expect(ModeState.parse('x'), isNull);
    expect(UsageState.parse(null), isNull);
    expect(UsageState.parse({}), isNotNull);
  });
}
```

- [ ] **Step 2: Run to confirm it fails** — `flutter test test/model/session_models_test.dart` — Expected: FAIL (file missing).

- [ ] **Step 3: Create `lib/src/model/diagnostics.dart`**

```dart
// lib/src/model/diagnostics.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnostics.freezed.dart';

/// Why the reducer recorded an item instead of folding it into the
/// conversation.
enum DiagnosticKind {
  /// A CUSTOM event whose name the reducer does not know.
  unknownCustom,

  /// A standard AG-UI event type the reducer does not fold (e.g. a step or
  /// activity event).
  unhandledEvent,

  /// A RAW event (the adapter uses these for content it could not type).
  raw,

  /// A recognised event, state key or patch whose payload was the wrong type
  /// or shape.
  malformedPayload,

  /// A top-level state key under `/<namespace>` the reducer does not read, or
  /// a patch aimed outside the namespace.
  unknownStateKey,
}

/// Something the reducer saw but did not fold into the timeline or session
/// state. Kept (bounded) so nothing is silently lost.
@freezed
abstract class Diagnostic with _$Diagnostic {
  const factory Diagnostic({
    required DiagnosticKind kind,
    required String name,
    Object? payload,

    /// Monotonic over the reducer's whole life — a replay reset does not
    /// restart it — so diagnostics stay ordered.
    required int index,
  }) = _Diagnostic;
}
```

- [ ] **Step 4: Create `lib/src/model/session_models.dart`.** Every class follows this exact pattern (shown in full for the first two; write the rest the same way with the field lists in **Interfaces**, `_known` = the wire keys the class reads, wire key `updated_at` → `updatedAt`, `options` → `choices` for `ConfigOption`, `by-id` → `byId`):

```dart
// lib/src/model/session_models.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'wire_parse.dart';

part 'session_models.freezed.dart';

@freezed
abstract class AuthMethod with _$AuthMethod {
  const AuthMethod._();
  const factory AuthMethod({
    String? id,
    String? name,
    String? description,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AuthMethod;

  static const _known = {'id', 'name', 'description'};

  static AuthMethod? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AuthMethod(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ModeState with _$ModeState {
  const ModeState._();
  const factory ModeState({
    String? currentModeId,
    @Default(<SessionMode>[]) List<SessionMode> availableModes,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ModeState;

  static const _known = {'currentModeId', 'availableModes', 'meta'};

  static ModeState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ModeState(
      currentModeId: asString(m['currentModeId']),
      availableModes: [
        for (final e in asJsonMapList(m['availableModes'])) SessionMode.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class SessionMode with _$SessionMode {
  const SessionMode._();
  const factory SessionMode({
    String? id,
    String? name,
    String? description,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _SessionMode;

  static const _known = {'id', 'name', 'description'};

  static SessionMode? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return SessionMode(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AgentInfo with _$AgentInfo {
  const AgentInfo._();
  const factory AgentInfo({
    String? name,
    String? title,
    String? version,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AgentInfo;

  static const _known = {'name', 'title', 'version'};

  static AgentInfo? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AgentInfo(
      name: asString(m['name']),
      title: asString(m['title']),
      version: asString(m['version']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AgentState with _$AgentState {
  const AgentState._();
  const factory AgentState({
    int? protocolVersion,
    AgentInfo? agentInfo,
    Map<String, dynamic>? agentCapabilities,
    @Default(<AuthMethod>[]) List<AuthMethod> authMethods,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AgentState;

  static const _known = {
    'protocolVersion', 'agentInfo', 'agentCapabilities', 'authMethods', 'meta',
  };

  static AgentState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AgentState(
      protocolVersion: asInt(m['protocolVersion']),
      agentInfo: AgentInfo.parse(m['agentInfo']),
      agentCapabilities: asJsonMap(m['agentCapabilities']),
      authMethods: [
        for (final e in asJsonMapList(m['authMethods'])) AuthMethod.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AvailableCommand with _$AvailableCommand {
  const AvailableCommand._();
  const factory AvailableCommand({
    String? name,
    String? description,
    Map<String, dynamic>? input,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AvailableCommand;

  static const _known = {'name', 'description', 'input'};

  static AvailableCommand? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AvailableCommand(
      name: asString(m['name']),
      description: asString(m['description']),
      input: asJsonMap(m['input']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class CommandsState with _$CommandsState {
  const CommandsState._();
  const factory CommandsState({
    @Default(<AvailableCommand>[]) List<AvailableCommand> commands,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _CommandsState;

  static const _known = {'commands', 'meta'};

  static CommandsState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return CommandsState(
      commands: [
        for (final e in asJsonMapList(m['commands'])) AvailableCommand.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ConfigOption with _$ConfigOption {
  const ConfigOption._();
  const factory ConfigOption({
    String? id,
    String? name,
    String? description,
    String? category,
    String? type,
    Object? currentValue,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> choices,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ConfigOption;

  static const _known = {
    'id', 'name', 'description', 'category', 'type', 'currentValue', 'options',
  };

  static ConfigOption? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ConfigOption(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      category: asString(m['category']),
      type: asString(m['type']),
      currentValue: m['currentValue'],
      choices: asJsonMapList(m['options']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ConfigState with _$ConfigState {
  const ConfigState._();
  const factory ConfigState({
    @Default(<ConfigOption>[]) List<ConfigOption> options,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ConfigState;

  static const _known = {'options', 'meta'};

  static ConfigState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ConfigState(
      options: [
        for (final e in asJsonMapList(m['options'])) ConfigOption.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class UsageCost with _$UsageCost {
  const UsageCost._();
  const factory UsageCost({
    num? amount,
    String? currency,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _UsageCost;

  static const _known = {'amount', 'currency'};

  static UsageCost? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    final amount = m['amount'];
    return UsageCost(
      amount: amount is num ? amount : null,
      currency: asString(m['currency']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class UsageState with _$UsageState {
  const UsageState._();
  const factory UsageState({
    int? used,
    int? size,
    UsageCost? cost,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _UsageState;

  static const _known = {'used', 'size', 'cost', 'meta'};

  static UsageState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return UsageState(
      used: asInt(m['used']),
      size: asInt(m['size']),
      cost: UsageCost.parse(m['cost']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class SessionInfo with _$SessionInfo {
  const SessionInfo._();
  const factory SessionInfo({
    String? title,
    String? updatedAt,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _SessionInfo;

  static const _known = {'title', 'updated_at', 'meta'};

  static SessionInfo? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return SessionInfo(
      title: asString(m['title']),
      updatedAt: asString(m['updated_at']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class PlanEntry with _$PlanEntry {
  const PlanEntry._();
  const factory PlanEntry({
    String? content,
    String? priority,
    String? status,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlanEntry;

  static const _known = {'content', 'priority', 'status'};

  static PlanEntry? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return PlanEntry(
      content: asString(m['content']),
      priority: asString(m['priority']),
      status: asString(m['status']),
      extras: extrasOf(m, _known),
    );
  }
}

/// One plan: entries, or a file (`uri`), or markdown. [entries] is null for a
/// file or markdown plan.
@freezed
abstract class PlanState with _$PlanState {
  const PlanState._();
  const factory PlanState({
    List<PlanEntry>? entries,
    String? uri,
    String? markdown,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlanState;

  static const _known = {'entries', 'uri', 'markdown', 'meta'};

  static PlanState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return PlanState(
      entries: m['entries'] is List
          ? [for (final e in asJsonMapList(m['entries'])) PlanEntry.parse(e)!]
          : null,
      uri: asString(m['uri']),
      markdown: asString(m['markdown']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class PlansState with _$PlansState {
  const PlansState._();
  const factory PlansState({
    @Default(<String, PlanState>{}) Map<String, PlanState> byId,
    PlanState? legacy,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlansState;

  static const _known = {'by-id', 'legacy'};

  static PlansState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    final byId = asJsonMap(m['by-id']) ?? const <String, dynamic>{};
    return PlansState(
      byId: {
        for (final e in byId.entries)
          if (PlanState.parse(e.value) case final plan?) e.key: plan,
      },
      legacy: PlanState.parse(m['legacy']),
      extras: extrasOf(m, _known),
    );
  }
}
```

The file above is the complete content of `session_models.dart` (the first fence's `AuthMethod` and `ModeState` plus these).

- [ ] **Step 5: Run the model tests** — `dart run build_runner build --delete-conflicting-outputs && flutter test test/model/session_models_test.dart` — Expected: PASS.

- [ ] **Step 6: Write the failing reducer test** `test/model/conversation_reducer_session_state_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';
import 'package:ag_ui_widgets_flutter/src/model/diagnostics.dart';

const _ns = 'episutra';

StateSnapshotEvent _snap(Map<String, dynamic> state) =>
    StateSnapshotEvent(snapshot: {_ns: state});

StateDeltaEvent _replaceAll(Map<String, dynamic> state) => StateDeltaEvent(
      delta: [
        {'op': 'replace', 'path': '/$_ns', 'value': state},
      ],
    );

void main() {
  test('typed session state is populated from the namespace state tree', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'agent': {'protocolVersion': 1, 'agentInfo': {'name': 'claude'}},
        'mode': {'currentModeId': 'ask', 'availableModes': []},
        'commands': {'commands': [{'name': 'plan'}]},
        'config': {'options': [{'id': 'model'}]},
        'usage': {'used': 5, 'size': 100},
        'session_info': {'title': 'Hello', 'updated_at': 'now'},
        'plans': {'by-id': {'p': {'entries': []}}},
      }));
    final s = r.current.sessionState;
    expect(s.agent!.agentInfo!.name, 'claude');
    expect(s.mode!.currentModeId, 'ask');
    expect(s.commands!.commands.single.name, 'plan');
    expect(s.configState!.options.single.id, 'model');
    expect(s.usage!.used, 5);
    expect(s.sessionInfo!.updatedAt, 'now');
    expect(s.plans.byId.keys, ['p']);
    expect(s.title, 'Hello', reason: 'the existing title field still works');
  });

  test('a whole-namespace replace mirrors state: a removed key becomes null',
      () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': {'used': 1, 'size': 2}}))
      ..apply(_replaceAll({'mode': {'currentModeId': 'x'}}));
    expect(r.current.sessionState.usage, isNull);
    expect(r.current.sessionState.mode!.currentModeId, 'x');
  });

  test('a wrong-typed state key reads as null and is reported once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(_replaceAll({'usage': 'oops'}));
    expect(r.current.sessionState.usage, isNull);
    final d = r.current.diagnostics
        .where((d) => d.kind == DiagnosticKind.malformedPayload)
        .toList();
    expect(d, hasLength(1));
    expect(d.single.name, '$_ns/usage');
    expect(d.single.payload, 'oops');
  });

  test('a key that is fixed and then breaks again is reported again', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(_replaceAll({'usage': {'used': 1}}))
      ..apply(_replaceAll({'usage': 'oops'}));
    expect(
      r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload),
      hasLength(2),
    );
  });

  test('diagnostic indexes keep increasing across a replay reset', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(const CustomEvent(name: '$_ns:sync', value: {'mode': 'replace'}))
      ..apply(_snap({'currentModeId': 'x'}));
    final idx = r.current.diagnostics.map((d) => d.index).toList();
    expect(idx, [...idx]..sort());
    expect(idx.toSet(), hasLength(idx.length));
  });

  test('an unknown top-level state key is reported once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'currentModeId': 'code'}))
      ..apply(_replaceAll({'currentModeId': 'code'}));
    final d = r.current.diagnostics
        .where((d) => d.kind == DiagnosticKind.unknownStateKey)
        .toList();
    expect(d, hasLength(1));
    expect(d.single.name, '$_ns/currentModeId');
  });

  test('a fine-grained patch refreshes typed state', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({}))
      ..apply(StateDeltaEvent(delta: [
        {'op': 'add', 'path': '/$_ns/usage', 'value': {'used': 3, 'size': 9}},
      ]));
    expect(r.current.sessionState.usage!.used, 3);
  });

  test('the legacy single-slot shape (pocketcoder) is unaffected', () {
    final r = ConversationReducer()
      ..apply(StateSnapshotEvent(snapshot: {
        'pocketcoder': {'session_info': {'title': 'PC'}, 'modes': {'x': 1}},
      }));
    expect(r.current.sessionState.title, 'PC');
    expect(r.current.sessionState.modes, {'x': 1});
    expect(r.current.diagnostics, isEmpty);
  });
}
```

- [ ] **Step 7: Run to confirm it fails** — `flutter test test/model/conversation_reducer_session_state_test.dart` — Expected: FAIL (new fields do not exist).

- [ ] **Step 8: Implement.**
  1. `conversation.dart`: `import 'session_models.dart'; import 'diagnostics.dart';`, add `export 'session_models.dart'; export 'diagnostics.dart';`. Add the new fields to `SessionState` (after `plan`): `AgentState? agent, ModeState? mode, CommandsState? commands, ConfigState? configState, UsageState? usage, SessionInfo? sessionInfo, @Default(PlansState()) PlansState plans, @Default(<String, dynamic>{}) Map<String, dynamic> responseMeta,`. Add to `Conversation`: `@Default(<Diagnostic>[]) List<Diagnostic> diagnostics, @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> sourceRecords,`. (`diagnostics.dart` does not import `conversation.dart`, so there is no import cycle.)
  2. `conversation_reducer.dart`: add private members and methods:

```dart
  static const int _maxDiagnostics = 200;
  static const int _maxSourceRecords = 200;
  final List<Diagnostic> _diagnostics = [];
  final List<Map<String, dynamic>> _sourceRecords = [];
  int _diagnosticCount = 0; // never reset: Diagnostic.index stays monotonic

  // What is currently reported. A whole-namespace replace arrives on every
  // state change, so a re-sync must not re-report the same problem; an entry
  // leaves its set when the problem goes away, so it is reported again if it
  // comes back.
  final Set<String> _reportedMalformed = {};
  final Set<String> _reportedUnknown = {};
  final Set<String> _reportedContent = {};

  AgentState? _agent;
  ModeState? _mode;
  CommandsState? _commands;
  ConfigState? _configState;
  UsageState? _usage;
  SessionInfo? _sessionInfo;
  PlansState _plans = const PlansState();

  void _diagnose(DiagnosticKind kind, String name, [Object? payload]) {
    _diagnostics.add(Diagnostic(
      kind: kind,
      name: name,
      payload: payload,
      index: _diagnosticCount++,
    ));
    if (_diagnostics.length > _maxDiagnostics) {
      _diagnostics.removeRange(0, _diagnostics.length - _maxDiagnostics);
    }
  }

  /// Keeps an `acp:source` wire record. Kept apart from [_diagnostics]: there
  /// is one per batch, so sharing a bounded list would let routine traffic
  /// evict real diagnostics.
  void _recordSource(Object? value) {
    final record = asJsonMap(value);
    if (record == null) {
      _diagnose(DiagnosticKind.malformedPayload, 'acp:source', value);
      return;
    }
    _sourceRecords.add(record);
    if (_sourceRecords.length > _maxSourceRecords) {
      _sourceRecords.removeRange(0, _sourceRecords.length - _maxSourceRecords);
    }
  }

  /// Re-reads the typed models from the raw `/<namespace>` map. Called after
  /// every state change. State is mirrored: a key that is gone becomes null.
  void _onStateChanged() {
    T? typed<T>(String key, T? Function(Object?) parse) {
      final raw = _pocketcoder[key];
      if (raw == null) {
        _reportedMalformed.remove(key);
        return null;
      }
      final value = parse(raw);
      if (value == null) {
        if (_reportedMalformed.add(key)) {
          _diagnose(DiagnosticKind.malformedPayload, '$namespace/$key', raw);
        }
      } else {
        _reportedMalformed.remove(key);
      }
      return value;
    }

    _agent = typed('agent', AgentState.parse);
    _mode = typed('mode', ModeState.parse);
    _commands = typed('commands', CommandsState.parse);
    _configState = typed('config', ConfigState.parse);
    _usage = typed('usage', UsageState.parse);
    _sessionInfo = typed('session_info', SessionInfo.parse);
    _plans = typed('plans', PlansState.parse) ?? const PlansState();

    final unknownNow = {
      for (final k in _pocketcoder.keys)
        if (!_knownStateKeys.contains(k)) k,
    };
    _reportedUnknown.retainAll(unknownNow);
    for (final key in unknownNow) {
      if (_reportedUnknown.add(key)) {
        _diagnose(DiagnosticKind.unknownStateKey, '$namespace/$key',
            _pocketcoder[key]);
      }
    }
  }

  static const _knownStateKeys = {
    'agent', 'mode', 'commands', 'config', 'usage', 'session_info', 'plans',
    'permissions', 'elicitations',
    // legacy single-slot shape
    'permission', 'elicitation', 'modes', 'plan',
  };
```

  3. Call `_onStateChanged()` at the end of the `StateSnapshotEvent` case (after `_syncElicitation()`) and at the end of every branch of `_applyPatch` that changes `_pocketcoder` (the one-segment branch after `_syncElicitation()`, and the 2- and 3-segment branches). In `_reset()` reset the typed fields only: `_agent = null; _mode = null; _commands = null; _configState = null; _usage = null; _sessionInfo = null; _plans = const PlansState();`. Do NOT clear `_diagnostics`, `_sourceRecords`, `_diagnosticCount` or the `_reported*` sets: they describe what the reducer has seen, and a replay re-sends the same state.
  4. `_sessionState()` returns the new fields: `agent: _agent, mode: _mode, commands: _commands, configState: _configState, usage: _usage, sessionInfo: _sessionInfo, plans: _plans,`. `current` returns `Conversation(timeline: ..., sessionState: ..., diagnostics: List.unmodifiable(_diagnostics), sourceRecords: List.unmodifiable(_sourceRecords))`.

- [ ] **Step 9: Regenerate and run everything** — `dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib` — Expected: PASS.

- [ ] **Step 10: Commit**

```bash
git add lib test && git commit -m "feat(model): typed, lossless session state from the adapter's state tree

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Tool call detail — locations, meta, terminals, media, patches, response meta (package)

**Files:**
- Modify: `lib/src/model/conversation.dart` (`TimelineItem.toolCall`, new `TimelineItem.media`, `itemId`), `lib/src/model/conversation_reducer.dart`
- Modify: `lib/src/widgets/timeline_to_messages.dart` (the new item type must be handled here in the same task, or the tree does not compile)
- Test: `test/model/conversation_reducer_tool_detail_test.dart`, `test/widgets/timeline_to_messages_detail_test.dart` (created here; Task 9 adds to it)

**Interfaces:**
- Consumes: `ToolLocation.parse`, `ToolTerminal.parse`, `ToolPatch.parse`, `MediaDescriptor.parse`, `asJsonMapList`, `asString`, `asJsonMap` (Task 4), `_diagnose` (Task 5).
- Produces: new Freezed `ToolResultPart({required String messageId, required String content})` in `tool_models.dart`. `ToolCallTimelineItem` gains `@Default(<ToolResultPart>[]) List<ToolResultPart> resultParts` (every `TOOL_CALL_RESULT`, in order; `result` stays the latest content), plus `@Default(<ToolLocation>[]) List<ToolLocation> locations`, `@Default(<ToolTerminal>[]) List<ToolTerminal> terminals`, `@Default(<ToolPatch>[]) List<ToolPatch> patches`, `@Default(<MediaDescriptor>[]) List<MediaDescriptor> media`, `Map<String,dynamic>? meta`. New `TimelineItem.media({required String id, String? messageId, required MediaDescriptor media, required OrderKey order}) = MediaTimelineItem`, `itemId` = `id`. `SessionState.responseMeta` is filled from `<ns>:response_meta` (`{method, meta}` → `responseMeta[method] = meta`).
- Event handling: `<ns>:tool` now also reads `locations` (list) and `meta`; `<ns>:diff` with `path`+`newText` → `ToolDiff` (as today) else with `patch` → `ToolPatch`; `<ns>:terminal` → `ToolTerminal`; `<ns>:content` with `toolCallId` → appended to that tool's `media`, with `messageId` (and no `toolCallId`) → a new `MediaTimelineItem`.

- [ ] **Step 1: Write the failing test** `test/model/conversation_reducer_tool_detail_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

ConversationReducer _r() => ConversationReducer(namespace: _ns)
  ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'));

ToolCallTimelineItem _tool(ConversationReducer r) =>
    r.current.timeline.whereType<ToolCallTimelineItem>().single;

void main() {
  test('<ns>:tool keeps locations and meta', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool', value: {
        'toolCallId': 'tc1',
        'kind': 'edit',
        'status': 'in_progress',
        'locations': [{'path': 'a.dart', 'line': 3}, {'path': 'b.dart'}],
        'meta': {'k': 'v'},
      }));
    final t = _tool(r);
    expect(t.locations.map((l) => l.path), ['a.dart', 'b.dart']);
    expect(t.locations.first.line, 3);
    expect(t.meta, {'k': 'v'});
  });

  test('a later <ns>:tool without locations keeps the earlier ones', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool', value: {
        'toolCallId': 'tc1',
        'locations': [{'path': 'a'}],
      }))
      ..apply(const CustomEvent(
          name: '$_ns:tool', value: {'toolCallId': 'tc1', 'status': 'completed'}));
    expect(_tool(r).locations, hasLength(1));
  });

  test('DiffV2 {format, patch} is kept as a ToolPatch', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:diff', value: {
        'toolCallId': 'tc1',
        'format': 'unified',
        'patch': '@@ -1 +1 @@',
      }));
    expect(_tool(r).patches.single.patch, '@@ -1 +1 @@');
    expect(_tool(r).diffs, isEmpty);
  });

  test('a diff with a null oldText is a new-file diff', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:diff', value: {
        'toolCallId': 'tc1', 'path': 'n.txt', 'oldText': null, 'newText': 'x',
      }));
    expect(_tool(r).diffs.single.oldText, '');
  });

  test('<ns>:terminal attaches a terminal', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {
        'toolCallId': 'tc1', 'terminalId': 't1', 'meta': {'cwd': '/'},
      }));
    expect(_tool(r).terminals.single.terminalId, 't1');
    expect(_tool(r).terminals.single.meta, {'cwd': '/'});
  });

  test('<ns>:content with a toolCallId attaches media to the tool', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:content', value: {
        'toolCallId': 'tc1', 'kind': 'image', 'mimeType': 'image/png',
      }));
    expect(_tool(r).media.single.mimeType, 'image/png');
  });

  test('<ns>:content with a messageId becomes a MediaTimelineItem', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:content', value: {
        'messageId': 'm1', 'kind': 'audio', 'mimeType': 'audio/wav',
      }));
    final item = r.current.timeline.single as MediaTimelineItem;
    expect(item.messageId, 'm1');
    expect(item.media.kind, 'audio');
  });

  test('tool detail arriving before TOOL_CALL_START lands on a placeholder', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {
        'toolCallId': 'early', 'terminalId': 't',
      }))
      ..apply(const ToolCallStartEvent(toolCallId: 'early', toolCallName: 'sh'));
    final t = r.current.timeline.single as ToolCallTimelineItem;
    expect(t.name, 'sh');
    expect(t.terminals, hasLength(1));
  });

  test('<ns>:response_meta is kept per method', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:response_meta', value: {
        'method': 'session/new', 'meta': {'a': 1},
      }));
    expect(r.current.sessionState.responseMeta, {'session/new': {'a': 1}});
  });

  test('every TOOL_CALL_RESULT is kept; result stays the latest', () {
    final r = _r()
      ..apply(const ToolCallResultEvent(
          messageId: 'r1', toolCallId: 'tc1', content: 'A'))
      ..apply(const ToolCallResultEvent(
          messageId: 'r2', toolCallId: 'tc1', content: 'B'));
    expect(_tool(r).result, 'B');
    expect(_tool(r).resultParts.map((p) => p.messageId), ['r1', 'r2']);
    expect(_tool(r).resultParts.map((p) => p.content), ['A', 'B']);
  });

  test('a malformed tool-detail payload is ignored for the timeline', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:terminal', value: 'not a map'))
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {'terminalId': 't'}));
    expect(_tool(r).terminals, isEmpty);
  });
}
```

- [ ] **Step 2: Run to confirm it fails** — `flutter test test/model/conversation_reducer_tool_detail_test.dart` — Expected: FAIL (fields/event handling missing).

- [ ] **Step 3: Model changes.** In `tool_models.dart` add `@freezed abstract class ToolResultPart with _$ToolResultPart { const factory ToolResultPart({required String messageId, required String content}) = _ToolResultPart; }`. In `conversation.dart`, in `TimelineItem.toolCall` add the following AFTER the existing `String? status,` line (keep that line):

```dart
    @Default(<ToolLocation>[]) List<ToolLocation> locations,
    @Default(<ToolTerminal>[]) List<ToolTerminal> terminals,
    @Default(<ToolPatch>[]) List<ToolPatch> patches,
    @Default(<MediaDescriptor>[]) List<MediaDescriptor> media,
    @Default(<ToolResultPart>[]) List<ToolResultPart> resultParts,
    Map<String, dynamic>? meta,
```

  Add a new factory after `toolRequest`:

```dart
  /// A non-text content block that belongs to a message (not to a tool call).
  const factory TimelineItem.media({
    required String id,
    String? messageId,
    required MediaDescriptor media,
    required OrderKey order,
  }) = MediaTimelineItem;
```

  and `MediaTimelineItem(:final id) => id,` in the `itemId` switch. (`storageKey` falls through to `itemId`.)

- [ ] **Step 4: Reducer changes.**
  1. Replace the existing `<ns>:tool` case body so it also merges `locations`/`meta`:

```dart
      case ag_ui.CustomEvent(name: final name) when name == '$namespace:tool':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        if (value == null || toolCallId == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          final title = value['title'];
          final kind = value['kind'];
          final status = value['status'];
          final locations = value.containsKey('locations')
              ? [
                  for (final l in asJsonMapList(value['locations']))
                    ToolLocation.parse(l)!,
                ]
              : null;
          final meta = asJsonMap(value['meta']);
          _updateTool(
            toolCallId,
            (t) => t.copyWith(
              name: t.name.isEmpty && title is String && title.isNotEmpty
                  ? title
                  : t.name,
              toolKind: kind is String && kind.isNotEmpty ? kind : t.toolKind,
              status: status is String && status.isNotEmpty ? status : t.status,
              locations: locations ?? t.locations,
              meta: meta ?? t.meta,
            ),
          );
        }
```

  2. Replace the `<ns>:diff` case:

```dart
      case ag_ui.CustomEvent(name: final name) when name == '$namespace:diff':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        final content = value == null ? null : ToolContent.parse(value);
        if (toolCallId == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else if (content is ToolContentDiff) {
          _updateTool(toolCallId,
              (t) => t.copyWith(diffs: [...t.diffs, content.diff]));
        } else if (content is ToolContentPatch) {
          _updateTool(toolCallId,
              (t) => t.copyWith(patches: [...t.patches, content.patch]));
        } else {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        }
```

  3. Add these cases next to it:

```dart
      case ag_ui.CustomEvent(name: final name) when name == '$namespace:terminal':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        final terminal = ToolTerminal.parse(value);
        if (toolCallId == null || terminal == null || terminal.terminalId.isEmpty) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          _updateTool(toolCallId,
              (t) => t.copyWith(terminals: [...t.terminals, terminal]));
        }
      case ag_ui.CustomEvent(name: final name) when name == '$namespace:content':
        final media = MediaDescriptor.parse(event.value);
        if (media == null || media.kind.isEmpty) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else if (media.toolCallId != null) {
          _updateTool(media.toolCallId!,
              (t) => t.copyWith(media: [...t.media, media]));
        } else {
          final id = 'media:${_mediaCount++}';
          _upsert(
            id,
            (order) => TimelineItem.media(
              id: id,
              messageId: media.messageId,
              media: media,
              order: order,
            ),
          );
        }
      case ag_ui.CustomEvent(name: final name)
          when name == '$namespace:response_meta':
        final value = asJsonMap(event.value);
        final method = asString(value?['method']);
        if (method == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          _responseMeta = {..._responseMeta, method: value!['meta']};
        }
```

  4. Add members `int _mediaCount = 0;` and `Map<String, dynamic> _responseMeta = const {};`; reset both in `_reset()`; pass `responseMeta: _responseMeta` in `_sessionState()`. Add imports for `wire_parse.dart`, `tool_models.dart` (already exported via `conversation.dart`), `diagnostics.dart`.
  5. Replace the `ToolCallResultEvent` case so every result part is kept:

```dart
      case ag_ui.ToolCallResultEvent():
        _updateTool(
          event.toolCallId,
          (t) => t.copyWith(
            result: event.content,
            resultParts: [
              ...t.resultParts,
              ToolResultPart(messageId: event.messageId, content: event.content),
            ],
          ),
        );
```

  6. In `lib/src/widgets/timeline_to_messages.dart`, add the `MediaTimelineItem` arm to `_toMessage` and the helper (without this the switch is non-exhaustive and nothing compiles):

```dart
    MediaTimelineItem(:final id, :final messageId, :final media) =>
      chat_core.Message.custom(
        id: id,
        authorId: kAgentAuthorId,
        metadata: {
          'kind': 'media',
          'messageId': messageId,
          'media': _mediaToMap(media),
        },
      ),
```

```dart
Map<String, dynamic> _mediaToMap(MediaDescriptor d) => {
      'kind': d.kind,
      'mimeType': d.mimeType,
      'uri': d.uri,
      'name': d.name,
      'title': d.title,
      'description': d.description,
      'data': d.data,
      'blob': d.blob,
      'size': d.size,
      'messageId': d.messageId,
      'toolCallId': d.toolCallId,
      ...d.extras,
    };
```

  7. Create `test/widgets/timeline_to_messages_detail_test.dart` with the media mapping test (Task 9 appends the tool-call test to this file):

```dart
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  test('a message-level media item becomes a custom media message', () {
    final item = TimelineItem.media(
      id: 'media:0',
      messageId: 'm1',
      media: const MediaDescriptor(kind: 'audio', mimeType: 'audio/wav'),
      order: const OrderKey(2),
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect(m.id, 'media:0');
    expect(m.metadata!['kind'], 'media');
    expect(m.metadata!['messageId'], 'm1');
    expect((m.metadata!['media'] as Map)['kind'], 'audio');
  });
}
```

- [ ] **Step 5: Regenerate and run everything** — `dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib` — Expected: PASS. This is green only because sub-step 4.6 handled `MediaTimelineItem` in `timeline_to_messages.dart`; if the analyzer still names a non-exhaustive `switch` over `TimelineItem` somewhere else, add the arm there too.

- [ ] **Step 6: Commit**

```bash
git add lib test && git commit -m "feat(reducer): keep tool locations, meta, terminals, media and patch diffs

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 7: Permission and elicitation detail (package)

**Files:**
- Modify: `lib/src/model/conversation.dart` (`PermissionOption`, `permissionRequest`, `elicitationRequest`), `lib/src/model/conversation_reducer.dart` (`_upsertPermission`, `_upsertElicitation`)
- Test: `test/model/conversation_reducer_request_detail_test.dart`

**Interfaces:**
- Consumes: `ToolContent.parse` (Task 4), the existing by-id sync (`_stateEntries`, `_upsertPermission`, `_upsertElicitation`).
- Produces: `PermissionOption` gains `@Default(<String,dynamic>{}) Map<String,dynamic> extras`. `PermissionRequestTimelineItem` gains `@Default(<ToolContent>[]) List<ToolContent> content`, `Map<String,dynamic>? meta`, `String? sessionId`, `@Default(<String,dynamic>{}) Map<String,dynamic> extras`. New Freezed `ElicitationScope({String? kind, String? requestId, String? sessionId, String? toolCallId, extras})` with `static ElicitationScope? parse(Object?)` (wire keys `kind`, `request_id`, `session_id`, `tool_call_id`). `ElicitationRequestTimelineItem` gains `ElicitationScope? scope`, `Map<String,dynamic>? meta`, `Map<String,dynamic>? rawMode` (the full `mode` object whenever it is a map: it carries `elicitation_id` for url mode and `{mode, raw}` for other modes), `@Default(<String,dynamic>{}) Map<String,dynamic> extras`.

- [ ] **Step 1: Write the failing test** `test/model/conversation_reducer_request_detail_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

StateSnapshotEvent _snap(Map<String, dynamic> state) =>
    StateSnapshotEvent(snapshot: {_ns: state});

void main() {
  test('a permission keeps content, meta, sessionId and unknown keys', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'permissions': {
          'by-id': {
            'tc1': {
              'requestId': 'req-1',
              'sessionId': 's1',
              'toolCallId': 'tc1',
              'status': 'pending',
              'title': 'Edit a.txt',
              'options': [
                {'optionId': 'ok', 'name': 'Allow', 'kind': 'allow_once', 'meta': {'o': 1}},
              ],
              'content': [
                {'toolCallId': 'tc1', 'path': 'a.txt', 'oldText': 'x', 'newText': 'y'},
                {'toolCallId': 'tc1', 'terminalId': 't1'},
              ],
              'meta': {'m': 1},
              'futureKey': 7,
            },
          },
        },
      }));
    final p = r.current.timeline.whereType<PermissionRequestTimelineItem>().single;
    expect(p.sessionId, 's1');
    expect(p.meta, {'m': 1});
    expect(p.content, hasLength(2));
    expect(p.content.first, isA<ToolContentDiff>());
    expect(p.content.last, isA<ToolContentTerminal>());
    expect(p.options.single.extras, {'meta': {'o': 1}});
    expect(p.extras, {'status': 'pending', 'futureKey': 7});
  });

  test('an elicitation keeps scope, meta and an unknown mode', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e1': {
              'elicitationId': 'e1',
              'message': 'm',
              'mode': {'kind': 'other', 'mode': 'weird', 'raw': {'a': 1}},
              'scope': {'kind': 'session', 'session_id': 's', 'tool_call_id': 'tc'},
              'meta': {'z': 1},
            },
          },
        },
      }));
    final e = r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.mode, 'other');
    expect(e.rawMode, {'kind': 'other', 'mode': 'weird', 'raw': {'a': 1}});
    expect(e.scope!.kind, 'session');
    expect(e.scope!.sessionId, 's');
    expect(e.scope!.toolCallId, 'tc');
    expect(e.meta, {'z': 1});
  });

  test('a url elicitation keeps its elicitation_id in rawMode', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e2': {
              'elicitationId': 'e2',
              'message': 'Sign in',
              'mode': {
                'kind': 'url',
                'url': 'https://example.com/auth',
                'elicitation_id': 'e2',
              },
              'scope': {'kind': 'request', 'request_id': 'r2'},
            },
          },
        },
      }));
    final e = r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.url, 'https://example.com/auth');
    expect(e.rawMode!['elicitation_id'], 'e2');
  });

  test('a content entry that is not a map is kept as a diagnostic, once', () {
    final state = {
      'permissions': {
        'by-id': {
          'tc1': {
            'requestId': 'r', 'toolCallId': 'tc1', 'options': [],
            'content': ['junk', {'terminalId': 't'}],
          },
        },
      },
    };
    final r = ConversationReducer(namespace: _ns)..apply(_snap(state));
    // A whole-namespace replace arrives on every state change; it must not
    // re-report the same junk entry.
    for (var i = 0; i < 3; i++) {
      r.apply(StateDeltaEvent(delta: [
        {'op': 'replace', 'path': '/$_ns', 'value': state},
      ]));
    }
    final p = r.current.timeline.whereType<PermissionRequestTimelineItem>().single;
    expect(p.content, hasLength(1));
    final junk = r.current.diagnostics.where((d) => d.payload == 'junk');
    expect(junk, hasLength(1));
  });
}
```

- [ ] **Step 2: Run to confirm it fails** — `flutter test test/model/conversation_reducer_request_detail_test.dart` — Expected: FAIL.

- [ ] **Step 3: Model changes.** Add `ElicitationScope` to `session_models.dart` (template as Task 5; `_known = {'kind', 'request_id', 'session_id', 'tool_call_id'}`). Add the new fields listed in **Interfaces** to `PermissionOption`, `permissionRequest` and `elicitationRequest` in `conversation.dart`.

- [ ] **Step 4: Reducer changes.** In `_upsertPermission`, replace the option mapping and the `TimelineItem.permissionRequest(...)` construction so they carry the new data:

```dart
    const permissionKnown = {
      'requestId', 'sessionId', 'toolCallId', 'title', 'kind', 'options',
      'content', 'meta',
    };
    final options = [
      for (final o in asJsonMapList(permission['options']))
        PermissionOption(
          optionId: asString(o['optionId']) ?? '',
          label: asString(o['name']) ?? '',
          kind: asString(o['kind']) ?? '',
          extras: extrasOf(o, const {'optionId', 'name', 'kind'}),
        ),
    ];
    final content = <ToolContent>[];
    final rawContent = permission['content'];
    if (rawContent is List) {
      for (final c in rawContent) {
        final parsed = ToolContent.parse(c);
        if (parsed == null) {
          if (_reportedContent.add('$requestId|$c')) {
            _diagnose(DiagnosticKind.malformedPayload,
                '$namespace/permissions/content', c);
          }
        } else {
          content.add(parsed);
        }
      }
    }
```

  and pass `content: content, meta: asJsonMap(permission['meta']), sessionId: asString(permission['sessionId']), extras: extrasOf(Map<String, dynamic>.from(permission), permissionKnown),` to `TimelineItem.permissionRequest(...)`. In `_upsertElicitation`, keep the existing mode/schema/url normalization and additionally pass `scope: ElicitationScope.parse(elicitation['scope']), meta: asJsonMap(elicitation['meta']), rawMode: rawMode is Map ? Map<String, dynamic>.from(rawMode) : null, extras: extrasOf(Map<String, dynamic>.from(elicitation), const {'elicitationId', 'message', 'mode', 'scope', 'meta', 'requestedSchema', 'url'}),`. (`permission` is a `Map` here; wrap with `Map<String, dynamic>.from` before `extrasOf`.)

- [ ] **Step 5: Regenerate and run everything** — `dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib` — Expected: PASS (including the earlier by-id tests).

- [ ] **Step 6: Commit**

```bash
git add lib test && git commit -m "feat(reducer): keep permission content/meta and elicitation scope/meta

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 8: Diagnostics, source records and strict state patches (package)

**Files:**
- Modify: `lib/src/model/conversation_reducer.dart` (`apply`'s tail, `_applyPatch`, the `StateSnapshotEvent` case)
- Test: `test/model/conversation_reducer_diagnostics_test.dart`, `test/model/conversation_reducer_patch_test.dart`

**Interfaces:**
- Consumes: `_diagnose`, `_recordSource`, `_onStateChanged`, `_syncPermission`, `_syncElicitation`, `DiagnosticKind` (Task 5).
- Produces: `acp:source` → appended to `Conversation.sourceRecords` (not to `diagnostics`); `RawEvent` → `DiagnosticKind.raw` (payload = `event.event`); any other `CustomEvent` → `unknownCustom` (name = the event name); any other unhandled event type → `unhandledEvent` (name = `event.eventType.value`). `_applyPatch` applies `add`/`replace`/`remove` at ANY depth under `/<namespace>` (JSON-pointer segments unescaped: `~1` → `/`, `~0` → `~`); a patch with no/invalid path, an unsupported op, or a path outside the namespace is recorded (`malformedPayload` / `unknownStateKey`), never silently ignored. A `StateSnapshotEvent` key other than the namespace is recorded once as `unknownStateKey` named `snapshot/<key>`.

- [ ] **Step 1: Write the failing diagnostics test** `test/model/conversation_reducer_diagnostics_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

void main() {
  test('acp:source is kept as a source record, not a diagnostic', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const CustomEvent(
          name: 'acp:source',
          value: {'sourceEventId': 's1', 'method': 'session/update'}));
    expect(r.current.diagnostics, isEmpty);
    expect(r.current.sourceRecords.single['sourceEventId'], 's1');
  });

  test('source volume cannot evict a real diagnostic', () {
    final r = ConversationReducer()
      ..apply(const CustomEvent(name: 'something:new', value: 1));
    for (var i = 0; i < 250; i++) {
      r.apply(CustomEvent(name: 'acp:source', value: {'sourceEventId': 's$i'}));
    }
    expect(r.current.diagnostics.single.name, 'something:new');
    expect(r.current.sourceRecords, hasLength(200));
    expect(r.current.sourceRecords.first['sourceEventId'], 's50');
  });

  test('a RAW event is recorded with its payload', () {
    final r = ConversationReducer()
      ..apply(const RawEvent(
          event: {'unmapped': 'tool_call_content', 'raw': {'a': 1}}));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.raw);
    expect((d.payload as Map)['unmapped'], 'tool_call_content');
  });

  test('an unknown CUSTOM event is recorded by name', () {
    final r = ConversationReducer()
      ..apply(const CustomEvent(name: 'something:new', value: 1));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.unknownCustom);
    expect(r.current.diagnostics.single.name, 'something:new');
  });

  test("another namespace's events are recorded, not silently ignored", () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const CustomEvent(
          name: 'pocketcoder:tool', value: {'toolCallId': 't'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.unknownCustom);
  });

  test('an unhandled standard event type is recorded by type', () {
    final r = ConversationReducer()
      ..apply(const StepStartedEvent(stepName: 'plan'));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.unhandledEvent);
    expect(d.name, 'STEP_STARTED');
  });

  test('handled events record nothing', () {
    final r = ConversationReducer()
      ..apply(const ToolCallStartEvent(toolCallId: 't', toolCallName: 'x'))
      ..apply(const CustomEvent(
          name: 'acp.session_phase', value: {'phase': 'ready'}));
    expect(r.current.diagnostics, isEmpty);
  });

  test('diagnostics are capped, oldest dropped', () {
    final r = ConversationReducer();
    for (var i = 0; i < 250; i++) {
      r.apply(CustomEvent(name: 'n$i', value: i));
    }
    final d = r.current.diagnostics;
    expect(d, hasLength(200));
    expect(d.first.name, 'n50');
    expect(d.last.name, 'n249');
  });

  test('diagnostics and source records survive a replay reset', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const CustomEvent(name: 'x:y', value: 1))
      ..apply(const CustomEvent(name: 'acp:source', value: {'sourceEventId': 's'}))
      ..apply(const CustomEvent(
          name: 'episutra:sync', value: {'mode': 'replace'}));
    expect(r.current.diagnostics, hasLength(1));
    expect(r.current.sourceRecords, hasLength(1));
  });

  test('a <ns>:sync that is not a replace is recorded, not a reset', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const ToolCallStartEvent(toolCallId: 't', toolCallName: 'x'))
      ..apply(const CustomEvent(name: 'episutra:sync', value: {'mode': 'merge'}));
    expect(r.current.timeline, isNotEmpty);
    expect(r.current.diagnostics.single.name, 'episutra:sync');
  });
}
```

- [ ] **Step 2: Write the failing patch test** `test/model/conversation_reducer_patch_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

StateDeltaEvent _op(Map<String, dynamic> op) => StateDeltaEvent(delta: [op]);

Map<String, dynamic> _permission(String id) =>
    {'requestId': 'r-$id', 'toolCallId': id, 'options': <dynamic>[]};

List<PermissionRequestTimelineItem> _cards(ConversationReducer r) =>
    r.current.timeline.whereType<PermissionRequestTimelineItem>().toList();

void main() {
  test('a deep add lands at any depth (permissions/by-id/<id>)', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {
        _ns: {'permissions': {'by-id': {}}},
      }))
      ..apply(_op({
        'op': 'add',
        'path': '/$_ns/permissions/by-id/tc9',
        'value': _permission('tc9'),
      }));
    expect(_cards(r).single.requestId, 'r-tc9');
  });

  test('a deep remove removes the entry', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(StateSnapshotEvent(snapshot: {
        _ns: {'permissions': {'by-id': {'tc9': _permission('tc9')}}},
      }))
      ..apply(_op({'op': 'remove', 'path': '/$_ns/permissions/by-id/tc9'}));
    expect(_cards(r), isEmpty);
  });

  test('escaped pointer segments are unescaped', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {_ns: {}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/a~1b', 'value': 1}));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.unknownStateKey);
    expect(d.name, '$_ns/a/b');
  });

  test('a patch outside the namespace is recorded, not applied', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_op({'op': 'add', 'path': '/other/x', 'value': 1}));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.unknownStateKey);
    expect(d.name, '/other/x');
  });

  test('an unsupported op is recorded', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_op({'op': 'move', 'path': '/$_ns/x', 'from': '/$_ns/y'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('an op without a path is recorded', () {
    final r = ConversationReducer(namespace: _ns)..apply(_op({'op': 'add'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('a snapshot key outside the namespace is recorded once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {'other': {'a': 1}, _ns: {}}))
      ..apply(const StateSnapshotEvent(snapshot: {'other': {'a': 1}, _ns: {}}));
    final d = r.current.diagnostics.where((d) => d.name == 'snapshot/other');
    expect(d, hasLength(1));
  });

  test('a patch that descends into a list is recorded and changes nothing', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {
        _ns: {
          'mode': {
            'currentModeId': 'a',
            'availableModes': [
              {'id': 'a'},
            ],
          },
        },
      }))
      ..apply(_op({
        'op': 'replace',
        'path': '/$_ns/mode/availableModes/0',
        'value': {'id': 'b'},
      }));
    expect(r.current.sessionState.mode!.availableModes.single.id, 'a');
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('2- and 3-segment patches keep working (existing behavior)', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {_ns: {}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/usage', 'value': {'used': 1}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/mode/currentModeId', 'value': 'x'}));
    expect(r.current.sessionState.usage!.used, 1);
    expect(r.current.sessionState.mode!.currentModeId, 'x');
  });
}
```

- [ ] **Step 3: Run both to confirm they fail** — `flutter test test/model/conversation_reducer_diagnostics_test.dart test/model/conversation_reducer_patch_test.dart` — Expected: FAIL.

- [ ] **Step 4: Implement.**
  1. In `apply`, add before `default:` (these must come AFTER every specific `CustomEvent` case so they only see names nothing else claimed; `acp.permission_request`, `acp.elicitation_request`, `acp.client_execute_request`, `acp.session_phase` and every `<ns>:*` case are all earlier in the switch):

```dart
      case ag_ui.CustomEvent(name: 'acp:source', :final value):
        _recordSource(value);
      case ag_ui.RawEvent(:final event):
        _diagnose(DiagnosticKind.raw, 'raw', event);
      case ag_ui.CustomEvent(:final name, :final value):
        _diagnose(DiagnosticKind.unknownCustom, name, value);
```

  and replace the `default:` body with `_diagnose(DiagnosticKind.unhandledEvent, event.eventType.value);`.
  2. Replace `_applyPatch` with the generic version, and add the two helpers:

```dart
  void _applyPatch(Map<String, dynamic> op) {
    final path = op['path'];
    final kind = op['op'];
    if (path is! String ||
        kind is! String ||
        (kind != 'add' && kind != 'replace' && kind != 'remove')) {
      _diagnose(DiagnosticKind.malformedPayload, '$namespace/patch', op);
      return;
    }
    final segments = [
      for (final s in path.split('/'))
        if (s.isNotEmpty) _unescapePointer(s),
    ];
    if (segments.isEmpty || segments.first != namespace) {
      _diagnose(DiagnosticKind.unknownStateKey, path, op);
      return;
    }
    final keys = segments.sublist(1);
    if (keys.isEmpty) {
      // The whole namespace at once — acp-agui-adapter sends every state
      // change as a `replace` of `/<namespace>` carrying the full state.
      _pocketcoder.clear();
      final value = op['value'];
      if (kind != 'remove' && value is Map) {
        _pocketcoder.addAll(Map<String, dynamic>.from(value));
      }
    } else if (!_setAt(_pocketcoder, keys, op['value'],
        remove: kind == 'remove')) {
      // Descends through a value that exists but is not a map (e.g. a list
      // index). Leave the state untouched rather than corrupt it, and say so.
      _diagnose(DiagnosticKind.malformedPayload, '$namespace/patch', op);
      return;
    }
    _syncPermission();
    _syncElicitation();
    _onStateChanged();
  }

  static String _unescapePointer(String s) =>
      s.replaceAll('~1', '/').replaceAll('~0', '~');

  /// Sets or removes [keys] under [root], copying each map on the way so no
  /// map the caller (or a typed model) still holds is mutated. Returns false,
  /// changing nothing, when the path would descend through an existing value
  /// that is not a map (a list, a scalar).
  static bool _setAt(
    Map<String, dynamic> root,
    List<String> keys,
    Object? value, {
    required bool remove,
  }) {
    Object? probe = root;
    for (var i = 0; i < keys.length - 1; i++) {
      probe = (probe as Map)[keys[i]];
      if (probe == null) break;
      if (probe is! Map) return false;
    }
    var current = root;
    for (var i = 0; i < keys.length - 1; i++) {
      final next = current[keys[i]];
      final child =
          next is Map ? Map<String, dynamic>.from(next) : <String, dynamic>{};
      current[keys[i]] = child;
      current = child;
    }
    if (remove) {
      current.remove(keys.last);
    } else {
      current[keys.last] = value;
    }
    return true;
  }
```

  3. In the `StateSnapshotEvent` case, after `_onStateChanged()` (added in Task 5), record foreign keys once. Add the member `final Set<String> _reportedSnapshotKeys = {};` and:

```dart
        if (snapshot is Map) {
          for (final key in snapshot.keys) {
            if (key != namespace && _reportedSnapshotKeys.add('$key')) {
              _diagnose(
                  DiagnosticKind.unknownStateKey, 'snapshot/$key', snapshot[key]);
            }
          }
        } else if (snapshot != null) {
          _diagnose(DiagnosticKind.malformedPayload, 'snapshot', snapshot);
        }
```

- [ ] **Step 5: Run everything** — `flutter test && flutter analyze lib` — Expected: PASS. Existing tests that apply events the reducer ignores still pass (they assert on timeline/session state, not diagnostics); existing 2-/3-segment patch tests pass because the generic path covers them.

- [ ] **Step 6: Commit**

```bash
git add lib test && git commit -m "feat(reducer): record unrecognised events and strict state patches

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 8b: Run lifecycle fields (package)

The reducer reads only `stopReason == 'cancelled'` and `RunErrorEvent.code == 'connection_interrupted'` and discards the rest of `RUN_STARTED` / `RUN_FINISHED` / `RUN_ERROR`.

**Files:**
- Modify: `lib/src/model/conversation.dart` (`SessionState`), `lib/src/model/conversation_reducer.dart` (the three run cases, `_reset`, `_sessionState`)
- Test: `test/model/conversation_reducer_run_test.dart`

**Interfaces:**
- Produces: `SessionState` gains `String? threadId`, `String? runId`, `String? stopReason` (the raw `result.stopReason` string, whatever it is — `end_turn`, `max_tokens`, `refusal`, ...), `String? runErrorCode`. `runOutcome` semantics are unchanged.

- [ ] **Step 1: Write the failing test** `test/model/conversation_reducer_run_test.dart`

```dart
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

void main() {
  test('RUN_STARTED keeps the thread and run ids', () {
    final r = ConversationReducer()
      ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'));
    expect(r.current.sessionState.threadId, 'th1');
    expect(r.current.sessionState.runId, 'run1');
  });

  test('RUN_FINISHED keeps any stopReason verbatim', () {
    final r = ConversationReducer()
      ..apply(RunStartedEvent(threadId: 't', runId: 'r'))
      ..apply(const RunFinishedEvent(
          threadId: 't', runId: 'r', result: {'stopReason': 'max_tokens'}));
    expect(r.current.sessionState.stopReason, 'max_tokens');
    expect(r.current.sessionState.runOutcome, RunOutcome.success,
        reason: 'outcome semantics are unchanged');
  });

  test('RUN_ERROR keeps its code', () {
    final r = ConversationReducer()
      ..apply(const RunErrorEvent(message: 'boom', code: 'rate_limited'));
    expect(r.current.sessionState.runErrorCode, 'rate_limited');
    expect(r.current.sessionState.runError, 'boom');
  });

  test('a new RUN_STARTED clears the previous run result', () {
    final r = ConversationReducer()
      ..apply(const RunErrorEvent(message: 'boom', code: 'c'))
      ..apply(RunStartedEvent(threadId: 't', runId: 'r2'));
    expect(r.current.sessionState.runErrorCode, isNull);
    expect(r.current.sessionState.stopReason, isNull);
    expect(r.current.sessionState.runId, 'r2');
  });
}
```

- [ ] **Step 2: Run to confirm it fails** — `flutter test test/model/conversation_reducer_run_test.dart` — Expected: FAIL (fields missing).

- [ ] **Step 3: Implement.** Add the four fields to `SessionState`. In the reducer add members `String? _threadId; String? _runId; String? _stopReason; String? _runErrorCode;`, set them in the run cases, clear all four in `_reset()`, and pass them in `_sessionState()`:

```dart
      case ag_ui.RunStartedEvent(:final threadId, :final runId):
        _isRunning = true;
        _runError = null;
        _runOutcome = null;
        _threadId = threadId;
        _runId = runId;
        _stopReason = null;
        _runErrorCode = null;
      case ag_ui.RunFinishedEvent(:final result):
        _isRunning = false;
        _isStarting = false;
        final stopReason =
            result is Map ? result['stopReason'] as String? : null;
        _stopReason = stopReason;
        _runOutcome = switch (stopReason) {
          'cancelled' => RunOutcome.cancelled,
          null => RunOutcome.success,
          _ => RunOutcome.success,
        };
      case ag_ui.RunErrorEvent(:final message, :final code):
        _isRunning = false;
        _isStarting = false;
        _runError = message;
        _runErrorCode = code;
        _runOutcome = code == 'connection_interrupted'
            ? RunOutcome.interrupted
            : RunOutcome.failed;
```

- [ ] **Step 4: Regenerate and run everything** — `dart run build_runner build --delete-conflicting-outputs && flutter test && flutter analyze lib` — Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib test && git commit -m "feat(reducer): keep run ids, raw stopReason and run error code

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Forward tool detail through `timelineToMessages` (package)

(The `MediaTimelineItem` mapping was already added in Task 6, where the new item type is introduced.)

**Files:**
- Modify: `lib/src/widgets/timeline_to_messages.dart`
- Test: `test/widgets/timeline_to_messages_detail_test.dart` (created in Task 6 — add this test to its `main`)

**Interfaces:**
- Consumes: the new `ToolCallTimelineItem` fields (Task 6).
- Produces: tool-call `Message.custom` metadata gains `'locations'` (`[{path, line}]`), `'terminals'` (`[{terminalId, meta}]`), `'patches'` (`[{format, patch}]`), `'media'` (descriptor maps), `'resultParts'` (`[{messageId, content}]`), `'meta'`.

- [ ] **Step 1: Add the failing test** to `main()` in `test/widgets/timeline_to_messages_detail_test.dart`

```dart
  test('a tool call forwards locations, terminals, patches, media, results and meta',
      () {
    final item = TimelineItem.toolCall(
      id: 't',
      name: 'edit',
      order: const OrderKey(1),
      locations: const [ToolLocation(path: 'a.dart', line: 3)],
      terminals: const [ToolTerminal(terminalId: 'x')],
      patches: const [ToolPatch(format: 'unified', patch: 'p')],
      media: const [MediaDescriptor(kind: 'image', mimeType: 'image/png')],
      resultParts: const [ToolResultPart(messageId: 'r1', content: 'A')],
      meta: const {'k': 1},
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect(m.metadata!['locations'], [
      {'path': 'a.dart', 'line': 3},
    ]);
    expect((m.metadata!['terminals'] as List).single['terminalId'], 'x');
    expect((m.metadata!['patches'] as List).single['patch'], 'p');
    expect((m.metadata!['media'] as List).single['mimeType'], 'image/png');
    expect((m.metadata!['resultParts'] as List).single['content'], 'A');
    expect(m.metadata!['meta'], {'k': 1});
  });
```

- [ ] **Step 2: Run to confirm it fails** — `flutter test test/widgets/timeline_to_messages_detail_test.dart` — Expected: FAIL (metadata keys missing).

- [ ] **Step 3: Implement.** Extend the `ToolCallTimelineItem(...)` pattern in `_toMessage` with `:final locations, :final terminals, :final patches, :final media, :final resultParts, :final meta,` and add to its metadata map:

```dart
          'locations': [
            for (final l in locations) {'path': l.path, 'line': l.line},
          ],
          'terminals': [
            for (final t in terminals) {'terminalId': t.terminalId, 'meta': t.meta},
          ],
          'patches': [
            for (final p in patches) {'format': p.format, 'patch': p.patch},
          ],
          'media': [for (final d in media) _mediaToMap(d)],
          'resultParts': [
            for (final p in resultParts) {'messageId': p.messageId, 'content': p.content},
          ],
          'meta': meta,
```

- [ ] **Step 4: Run everything** — `flutter test && flutter analyze lib` — Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib test && git commit -m "feat(widgets): forward tool detail through timelineToMessages

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

### Task 10: Adapter contract test, vocabulary doc, version bump (package)

**Files:**
- Create: `test/fixtures/adapter/ag_ui_session.json` (copy of the adapter's fixture), `test/model/adapter_contract_test.dart`, `docs/event-vocabulary.md`
- Modify: `pubspec.yaml` (version), `lib/ag_ui_widgets_flutter.dart` (exports for `session_models.dart`, `diagnostics.dart`)

**Interfaces:**
- Consumes: `/Users/aicoder/Documents/my-libs/acp-agui-adapter/tests/fixtures/ag_ui_session.json` (Task 2), the whole reducer.
- Produces: a test that feeds every fixture event to `ConversationReducer(namespace: 'episutra')` and asserts nothing is unrecognised; the vocabulary table.

- [ ] **Step 1: Copy the fixture**

```bash
mkdir -p test/fixtures/adapter && cp /Users/aicoder/Documents/my-libs/acp-agui-adapter/tests/fixtures/ag_ui_session.json test/fixtures/adapter/ag_ui_session.json
```

- [ ] **Step 2: Write the contract test** `test/model/adapter_contract_test.dart`

```dart
// Feeds the adapter's own projector output (generated by acp-agui-adapter's
// `golden_session_fixture` test) through the reducer. It fails when the adapter
// emits an event name or state key the reducer neither folds nor deliberately
// records, which is how a silent drop starts.
//
// Refresh the fixture: in acp-agui-adapter run
//   UPDATE_FIXTURES=1 cargo test golden_session_fixture
// then copy tests/fixtures/ag_ui_session.json to test/fixtures/adapter/.
import 'dart:convert';
import 'dart:io';

import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

List<BaseEvent> _fixture() {
  final raw = jsonDecode(
          File('test/fixtures/adapter/ag_ui_session.json').readAsStringSync())
      as List;
  return [
    for (final e in raw) BaseEvent.fromJson(Map<String, dynamic>.from(e as Map)),
  ];
}

void main() {
  test('the reducer recognises everything the adapter emits', () {
    final r = ConversationReducer(namespace: 'episutra');
    for (final e in _fixture()) {
      r.apply(e);
    }
    // RAW events are deliberately recorded (not folded) and acp:source goes to
    // sourceRecords; anything else in the diagnostics is a drop.
    final unexpected = r.current.diagnostics
        .where((d) => d.kind != DiagnosticKind.raw)
        .toList();
    expect(unexpected, isEmpty,
        reason: 'unrecognised adapter output: '
            '${unexpected.map((d) => '${d.kind.name}:${d.name}').join(', ')}');
  });

  test('every adapter event name is one the reducer was written against', () {
    final names = {
      for (final e in _fixture())
        if (e is CustomEvent) e.name,
    };
    const known = {
      'acp:source',
      'acp.client_execute_request',
      'episutra:tool',
      'episutra:diff',
      'episutra:terminal',
      'episutra:content',
      'episutra:response_meta',
      'episutra:sync',
    };
    expect(names.difference(known), isEmpty,
        reason: 'a new adapter CUSTOM event: handle it in the reducer, then add '
            'it to this list and to docs/event-vocabulary.md');
  });

  test('every state key the adapter emits is one the reducer reads', () {
    const known = {
      'agent', 'mode', 'commands', 'config', 'usage', 'session_info', 'plans',
      'permissions', 'elicitations',
    };
    final keys = <String>{};
    for (final e in _fixture()) {
      if (e is StateSnapshotEvent) {
        final root = (e.snapshot as Map)['episutra'];
        if (root is Map) keys.addAll(root.keys.cast<String>());
      } else if (e is StateDeltaEvent) {
        for (final op in e.delta) {
          final v = op['value'];
          if (op['path'] == '/episutra' && v is Map) {
            keys.addAll(v.keys.cast<String>());
          }
        }
      }
    }
    expect(keys.difference(known), isEmpty,
        reason: 'the adapter writes a state key the reducer does not read '
            '(this is how the stray top-level currentModeId showed up)');
  });

  test('state and timeline from the fixture are fully populated', () {
    final r = ConversationReducer(namespace: 'episutra');
    for (final e in _fixture()) {
      r.apply(e);
    }
    final c = r.current;
    final s = c.sessionState;
    expect(s.agent!.agentInfo!.title, 'Claude');
    expect(s.mode!.currentModeId, 'code', reason: 'the CurrentModeChanged fix');
    expect(s.mode!.availableModes, hasLength(2));
    expect(s.commands!.commands.single.name, 'plan');
    expect(s.configState!.options.single.id, 'model');
    expect(s.usage!.used, 10);
    expect(s.sessionInfo!.title, 'Hello');
    expect(s.plans.byId.keys, containsAll(['p1', 'p2', 'p3']));
    expect(s.responseMeta, containsPair('session/new', {'a': 1}));
    expect(s.stopReason, 'end_turn');

    final tool =
        c.timeline.whereType<ToolCallTimelineItem>().firstWhere((t) => t.id == 'tc1');
    expect(tool.locations.single.path, 'a.txt');
    expect(tool.diffs, hasLength(1));
    expect(tool.patches, hasLength(1));
    expect(tool.terminals.single.terminalId, 't1');
    expect(tool.media, hasLength(1));
    expect(tool.hasEnded, isTrue);
    expect(tool.resultParts, isNotEmpty);

    final permission =
        c.timeline.whereType<PermissionRequestTimelineItem>().single;
    expect(permission.content.single, isA<ToolContentTerminal>());
    final elicitation =
        c.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(elicitation.scope!.kind, 'request');
    expect(c.timeline.whereType<MediaTimelineItem>(), hasLength(1));
    expect(
        c.timeline.whereType<ToolRequestTimelineItem>().single.toolName,
        'create_note');
    expect(c.sourceRecords, isNotEmpty);
  });
}
```

- [ ] **Step 3: Run it.** `flutter test test/model/adapter_contract_test.dart`
  Expected: PASS if Tasks 1–9 are complete. If it FAILS, the failure message names exactly which adapter output is unhandled — fix the reducer (not the test), unless the fixture legitimately cannot contain a given thing, in which case narrow the assertion with a comment saying why.

- [ ] **Step 4: Write `docs/event-vocabulary.md`** — a table with columns `Wire name / state key | Payload | Folded into | Notes` covering: every `<ns>:*` CUSTOM event, `acp.*` events, `acp:source`, RAW, standard events the reducer folds, and every `/<ns>` state key (`agent`, `mode`, `commands`, `config`, `usage`, `session_info`, `plans`, `permissions`, `elicitations`, plus the legacy single-slot keys). One row each, taken from Appendix A of this plan and the code. State the namespace rule in one paragraph: `acp.*` names are fixed protocol events; `<namespace>:*` names and the `/<namespace>` state tree belong to the backend and are selected with `ConversationReducer(namespace:)`.

- [ ] **Step 5: Bump `pubspec.yaml` `version:` to `0.8.0`** (heads-up: names such as `Diagnostic`, `AgentInfo`, `SessionInfo`, `PlanEntry`, `UsageState` and `MediaDescriptor` become public API of this package, so a downstream app that defines or imports a class with the same name gets an ambiguous-import error. After bumping the pin in episutra and pocketcoder, run `flutter analyze` in both.) and make sure `lib/ag_ui_widgets_flutter.dart` exports `src/model/session_models.dart` and `src/model/diagnostics.dart` (they are also reachable via `conversation.dart`'s exports; the explicit lines keep the barrel honest).

- [ ] **Step 6: Run everything** — `flutter test && flutter analyze lib` — Expected: PASS.

- [ ] **Step 7: Commit (push only after the owner approves)**

```bash
git add lib test docs pubspec.yaml && git commit -m "test: adapter contract test, event vocabulary doc, v0.8.0

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
```

---

## Appendix A — Drop inventory (the requirements this plan meets)

| Adapter output | Before | After (task) |
|---|---|---|
| state `plans` (`by-id`, `legacy`) | ignored (reducer read `plan`) | `SessionState.plans` (5) |
| state `mode` | ignored (reducer read `modes`) | `SessionState.mode` (5) |
| state `commands`, `usage`, `agent` | ignored | typed fields (5) |
| state `config`, `session_info` | raw map / title only | typed `configState`, `sessionInfo` incl. `updated_at`, `meta` (5) |
| `mode.currentModeId` after a mode change | never updated (adapter bug) | fixed in adapter (1) |
| unknown state key | ignored | `unknownStateKey` diagnostic, reported once (5) |
| `<ns>:tool` `locations`, `meta` | ignored | tool item fields (6) |
| `<ns>:diff` DiffV2 `{format, patch}` | ignored (required `path`) | `ToolPatch` (6) |
| `<ns>:terminal` | ignored | `ToolCallTimelineItem.terminals` (6) |
| `<ns>:content` (tool / message) | ignored | `.media` / `MediaTimelineItem` (6) |
| `<ns>:response_meta` | ignored | `SessionState.responseMeta` (6) |
| every `TOOL_CALL_RESULT` | last one overwrote the rest | `resultParts` (6) |
| permission `content`, `meta`, `sessionId`, option extras | ignored | item fields (7) |
| elicitation `scope`, `meta`, `mode` object incl. url `elicitation_id` | ignored | item fields + `rawMode` (7) |
| `acp:source` | ignored | `Conversation.sourceRecords` (8) |
| RAW events | ignored | `raw` diagnostic (8) |
| unknown CUSTOM / standard event types | ignored | `unknownCustom` / `unhandledEvent` (8) |
| state patches: deep paths, other namespaces, unsupported ops, snapshot keys outside the namespace | mis-applied or ignored | applied generically or recorded (8) |
| `RUN_STARTED` ids, raw `stopReason`, `RUN_ERROR` code | ignored / collapsed | `SessionState` fields (8b) |
| malformed known payloads | ignored | `malformedPayload`, deduplicated (5-8) |
| `ToolDiff` unknown keys | n/a | `extras` (4) |

## Appendix B — Known drops this plan does NOT fix (adapter-side; Dart cannot recover them)

Found by the plan review. The projector never emits these as AG-UI events or state, so no reducer change can keep them. They are still present in the raw `acp:source` record (`messageJson`) that Task 8 retains in `Conversation.sourceRecords`, and in the AHP projection; they are only not typed on the AG-UI path. Closing them means extending `AgUiBatchProjector`, which is a separate plan.

- `ToolCallStarted`: `kind`, `raw_input`, `meta`.
- `ToolCallProgress`: `content` (only `new_content` is projected), `raw_output`.
- `ToolCallCompleted`: `success`, `past_tense_message`, `locations`, `meta`, `raw_output`, and all non-text content (only text results and `TOOL_CALL_END` are projected).
- `RunFinished.duration_ms`; `RunStarted.started_at` and `.message`; `RunError.turn_id` and `.duration_ms`.
- `PermissionPending`: `raw_input`, `turn_id`, each option's `meta` (options project as `{optionId, name, kind}` only).
- Permission `content` is built with `filter_map`, so `Unhandled` content and DiffV2-without-patch vanish from permission requests.
- `ReasoningStarted` always projects `role` as `"assistant"`.
- `sourceEventId`: the adapter adds it to every serialised event, but `BaseEvent` has no such field, so it is only recoverable by a transport that reads the raw JSON (episutra's `frb_ag_ui_transport.dart` could pair it with each decoded event). Out of scope here.

## Self-Review notes

- Spec coverage: every row of Appendix A maps to a task above; Appendix B is the explicit, reasoned list of what is not covered and why. The contract test (Task 10) is the standing guard for everything the adapter emits today.
- Type consistency: `ToolContent` variants `ToolContentDiff/Patch/Terminal/Media/Unknown`, `MediaTimelineItem`, `ToolResultPart`, `SessionState.configState` (not `config`, which stays the legacy raw map), `Diagnostic.index` (an `int`, not an `OrderKey`), `Conversation.sourceRecords`, `DiagnosticKind` members (`unknownCustom, unhandledEvent, raw, malformedPayload, unknownStateKey`) — used identically in every task.
- Ordering: Task 6 handles `MediaTimelineItem` in `timeline_to_messages.dart` itself, so no task leaves the tree red; Task 9 only adds metadata keys.
- Review: this plan was reviewed against the real code (scratch copies of both repos); the fixes from that review are folded in above.
- Out of scope (named so nobody assumes otherwise): episutra UI for plans/mode/usage/commands; the adapter-side drops in Appendix B; changing pocketcoder's backend.
