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
  _runResultTests();
  _runInfoTests();
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
}

void _resolutionTests() {
  test('permission and elicitation resolutions are kept on the session state',
      () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc1',
        'response': {
          'outcome': {'outcome': 'selected', 'optionId': 'allow'},
        },
        'approved': true,
      }))
      ..apply(const CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc2',
        'response': {
          'outcome': {'outcome': 'cancelled'},
        },
      }))
      ..apply(const CustomEvent(name: '$_ns:elicitation_resolved', value: {
        'requestId': 'e1',
        'action': 'decline',
      }));
    final res = r.current.sessionState.resolutions;
    expect(res['permission:tc1'], {
      'kind': 'user_selected',
      'optionId': 'allow',
      'approved': true,
      'response': {
        'outcome': {'outcome': 'selected', 'optionId': 'allow'},
      },
    });
    expect(res['permission:tc2']!['kind'], 'cancelled');
    expect(res['elicitation:e1'], {'action': 'decline'});
    expect(r.current.diagnostics, isEmpty);
  });

  test('resolutions are bounded and a malformed one is a diagnostic', () {
    final r = ConversationReducer(namespace: _ns);
    for (var i = 0; i < 130; i++) {
      r.apply(CustomEvent(name: '$_ns:permission_resolved', value: {
        'toolCallId': 'tc$i',
        'response': {
          'outcome': {'outcome': 'cancelled'},
        },
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

void _runResultTests() {
  test('RunFinished keeps the whole result, and the next run clears it', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(RunStartedEvent(threadId: 't', runId: 'r'))
      ..apply(RunFinishedEvent(threadId: 't', runId: 'r', result: {
        'stopReason': 'end_turn',
        'durationMs': 1200,
        'turnId': 'x'
      }));
    final s = r.current.sessionState;
    expect(s.stopReason, 'end_turn');
    expect(s.runResult, {
      'stopReason': 'end_turn',
      'durationMs': 1200,
      'turnId': 'x',
    });
    r.apply(RunStartedEvent(threadId: 't', runId: 'r2'));
    expect(r.current.sessionState.runResult, isNull);
  });

  test('RunFinished without a map result leaves runResult null', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(RunFinishedEvent(threadId: 't', runId: 'r'));
    expect(r.current.sessionState.runResult, isNull);
  });
}

void _runInfoTests() {
  test('run info comes from RUN_STARTED and RUN_FINISHED, and the next run '
      'replaces it', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(RunStartedEvent(
          threadId: 't', runId: 'r1', timestamp: 1700000000000))
      ..apply(RunFinishedEvent(
          threadId: 't', runId: 'r1', result: {'durationMs': 99}));
    expect(r.current.sessionState.runInfo, {
      'runId': 'r1',
      'startedAt': '2023-11-14T22:13:20.000Z',
      'durationMs': 99,
    });
    r.apply(RunStartedEvent(threadId: 't', runId: 'r2'));
    expect(r.current.sessionState.runInfo, {'runId': 'r2'});
  });

  test('a <ns>:run event is no longer folded', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:run', value: {'phase': 'started'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.unknownCustom);
    expect(r.current.sessionState.runInfo, isEmpty);
  });
}
