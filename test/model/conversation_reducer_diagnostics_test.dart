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
