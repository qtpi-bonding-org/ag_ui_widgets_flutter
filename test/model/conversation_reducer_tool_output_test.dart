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
  _resolutionTests();
  test('<ns>:tool keeps rawOutput, success and pastTenseMessage', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool', value: {
        'toolCallId': 'tc1',
        'status': 'completed',
        'success': true,
        'pastTenseMessage': 'Ran bash',
        'rawOutput': {'exit': 0},
      }));
    final t = _tool(r);
    expect(t.rawOutput, {'exit': 0});
    expect(t.success, isTrue);
    expect(t.pastTenseMessage, 'Ran bash');
  });

  test('payloads without the new keys leave them null', () {
    final r = _r()
      ..apply(const CustomEvent(
          name: '$_ns:tool',
          value: {'toolCallId': 'tc1', 'status': 'pending'}));
    final t = _tool(r);
    expect(t.rawOutput, isNull);
    expect(t.success, isNull);
    expect(t.pastTenseMessage, isNull);
  });

  test('a refined title replaces the earlier name', () {
    final r = _r()
      ..apply(const CustomEvent(
          name: '$_ns:tool',
          value: {'toolCallId': 'tc1', 'title': 'Run ls -la'}));
    expect(_tool(r).name, 'Run ls -la');
  });

  test('an empty title never erases the name', () {
    final r = _r()
      ..apply(const CustomEvent(
          name: '$_ns:tool', value: {'toolCallId': 'tc1', 'title': ''}));
    expect(_tool(r).name, 'bash');
  });

  test('partial tool text is kept, then replaced by the final result', () {
    final r = _r()
      ..apply(const CustomEvent(
          name: '$_ns:tool_text',
          value: {'toolCallId': 'tc1', 'text': 'partial'}));
    expect(_tool(r).partialText, 'partial');
    expect(_tool(r).result, isNull);

    r.apply(const ToolCallResultEvent(
        messageId: 'm1', toolCallId: 'tc1', content: 'final'));
    final t = _tool(r);
    expect(t.result, 'final');
    expect(t.resultParts, hasLength(1),
        reason: 'partial text is not a result part');
    expect(t.partialText, isNull,
        reason: 'the final result replaces partial text');
  });

  test('partial text of a call that never completes stays available', () {
    final r = _r()
      ..apply(const CustomEvent(
          name: '$_ns:tool_text',
          value: {'toolCallId': 'tc1', 'text': 'half done'}))
      ..apply(const ToolCallEndEvent(toolCallId: 'tc1'));
    expect(_tool(r).partialText, 'half done');
  });

  test('a malformed tool_text payload is a diagnostic, not a crash', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool_text', value: 'junk'));
    expect(r.current.diagnostics, isNotEmpty);
  });
}

void _resolutionTests() {
  test('permission and elicitation resolutions are kept on the session state',
      () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc1',
        'resolution': {
          'kind': 'user_selected',
          'optionId': 'allow',
          'approved': true
        },
      }))
      ..apply(const CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc2',
        'resolution': {'kind': 'cancelled'},
      }))
      ..apply(const CustomEvent(name: '$_ns:elicitation_resolved', value: {
        'elicitationId': 'e1',
        'resolution': {'kind': 'declined'},
      }));
    final res = r.current.sessionState.resolutions;
    expect(res['permission:tc1'],
        {'kind': 'user_selected', 'optionId': 'allow', 'approved': true});
    expect(res['permission:tc2'], {'kind': 'cancelled'});
    expect(res['elicitation:e1'], {'kind': 'declined'});
    expect(r.current.diagnostics, isEmpty);
  });

  test('resolutions are bounded and a malformed one is a diagnostic', () {
    final r = ConversationReducer(namespace: _ns);
    for (var i = 0; i < 130; i++) {
      r.apply(CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc$i',
        'resolution': {'kind': 'cancelled'},
      }));
    }
    final res = r.current.sessionState.resolutions;
    expect(res.length, 100);
    expect(res.containsKey('permission:tc0'), isFalse);
    expect(res.containsKey('permission:tc129'), isTrue);
    r.apply(const CustomEvent(name: '$_ns:permission_resolved', value: 'junk'));
    expect(r.current.diagnostics, isNotEmpty);
  });
}
