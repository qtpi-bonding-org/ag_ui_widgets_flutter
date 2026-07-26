import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

BaseEvent _sync() =>
    const CustomEvent(name: 'pocketcoder:sync', value: {'mode': 'replace'});

StateDeltaEvent _delta(String path, {String op = 'add', dynamic value}) {
  return StateDeltaEvent(delta: [
    {'op': op, 'path': path, if (value != null) 'value': value},
  ]);
}

void main() {
  group('text messages', () {
    test('START -> textStream item; CONTENT x2 -> grows in place; END -> replaced by text item', () {
      final r = ConversationReducer();
      r.apply(const TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant));
      expect(r.current.timeline, hasLength(1));
      expect(r.current.timeline.single, isA<TextStreamTimelineItem>());

      r.apply(const TextMessageContentEvent(messageId: 'm1', delta: 'Hello, '));
      expect((r.current.timeline.single as TextStreamTimelineItem).text, 'Hello, ');

      r.apply(const TextMessageContentEvent(messageId: 'm1', delta: 'world!'));
      r.apply(const TextMessageEndEvent(messageId: 'm1'));
      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as TextTimelineItem;
      expect(item.kind, ChatMessageKind.text);
      expect(item.role, 'assistant');
      expect(item.text, 'Hello, world!');
    });
  });

  group('reasoning messages', () {
    test('START/CONTENT/END -> one reasoning text item (no streaming placeholder)', () {
      final r = ConversationReducer()
        ..apply(const ReasoningMessageStartEvent(messageId: 'r1'))
        ..apply(const ReasoningMessageContentEvent(messageId: 'r1', delta: 'thinking...'))
        ..apply(const ReasoningMessageEndEvent(messageId: 'r1'));

      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as TextTimelineItem;
      expect(item.kind, ChatMessageKind.reasoning);
      expect(item.text, 'thinking...');
    });
  });

  group('tool calls', () {
    test('START/ARGS/RESULT builds one toolCall item in place', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'search'))
        ..apply(const ToolCallArgsEvent(toolCallId: 't1', delta: '{"q":'))
        ..apply(const ToolCallArgsEvent(toolCallId: 't1', delta: '"x"}'))
        ..apply(const ToolCallResultEvent(messageId: 'm1', toolCallId: 't1', content: 'ok'));

      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.name, 'search');
      expect(item.args, '{"q":"x"}');
      expect(item.result, 'ok');
    });
  });

  group('tool call diffs', () {
    BaseEvent diffEvent(String toolCallId, String path,
            {String? oldText, required String newText}) =>
        CustomEvent(name: 'pocketcoder:diff', value: {
          'toolCallId': toolCallId,
          'path': path,
          if (oldText != null) 'oldText': oldText,
          'newText': newText,
        });

    test('pocketcoder:diff event appends a ToolDiff to the matching tool call', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'edit_file'))
        ..apply(diffEvent('t1', 'lib/foo.dart', oldText: 'a', newText: 'b'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, hasLength(1));
      expect(item.diffs.single.path, 'lib/foo.dart');
      expect(item.diffs.single.oldText, 'a');
      expect(item.diffs.single.newText, 'b');
    });

    test('a second diff event for the same tool call appends rather than replaces', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'multi_edit'))
        ..apply(diffEvent('t1', 'lib/a.dart', newText: 'a2'))
        ..apply(diffEvent('t1', 'lib/b.dart', newText: 'b2'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, hasLength(2));
      expect(item.diffs[0].path, 'lib/a.dart');
      expect(item.diffs[1].path, 'lib/b.dart');
    });

    test('diff event for an unknown toolCallId creates an orphan entry, same as args/result would', () {
      final r = ConversationReducer()..apply(diffEvent('unknown', 'lib/c.dart', newText: 'c'));

      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.id, 'unknown');
      expect(item.name, '');
      expect(item.diffs.single.path, 'lib/c.dart');
    });

    test('new-file diff (no oldText in the event) defaults oldText to empty string', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'write_file'))
        ..apply(diffEvent('t1', 'lib/new.dart', newText: 'content'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs.single.oldText, '');
    });

    test('a malformed diff event (missing newText) is ignored, not crashed on', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'edit_file'))
        ..apply(const CustomEvent(
            name: 'pocketcoder:diff', value: {'toolCallId': 't1', 'path': 'lib/x.dart'}));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, isEmpty);
    });
  });

  group('permission/elicitation via state delta', () {
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

    test('permission sub-path add inserts a marker after its correlated tool call', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'write_file'))
        ..apply(_delta('/pocketcoder/permission',
            value: {'requestId': 'p1', 'toolCallId': 't1'}));

      expect(r.current.timeline, hasLength(2));
      expect(r.current.timeline[0], isA<ToolCallTimelineItem>());
      final marker = r.current.timeline[1] as PermissionTimelineItem;
      expect(marker.requestId, 'p1');
    });

    test('elicitation sub-path add appends a marker at the end', () {
      final r = ConversationReducer()
        ..apply(_delta('/pocketcoder/elicitation', value: {'elicitationId': 'e1'}));

      expect(r.current.timeline, hasLength(1));
      expect((r.current.timeline.single as ElicitationRequestTimelineItem).requestId, 'e1');
    });
  });

  group('cold replay', () {
    test('sync replace marker resets the accumulator; only post-marker events survive', () {
      final r = ConversationReducer()
        ..apply(const TextMessageStartEvent(messageId: 'stale', role: TextMessageRole.assistant))
        ..apply(const TextMessageEndEvent(messageId: 'stale'))
        ..apply(_sync())
        ..apply(const TextMessageStartEvent(messageId: 'fresh', role: TextMessageRole.assistant))
        ..apply(const TextMessageEndEvent(messageId: 'fresh'));

      expect(r.current.timeline, hasLength(1));
      expect((r.current.timeline.single as TextTimelineItem).id, 'fresh');
    });
  });

  group('run lifecycle (new — pocketcoder had no equivalent before this package)', () {
    // NOTE: RunStartedEvent/RunFinishedEvent require threadId/runId (not
    // const-constructible with zero args) and ToolCallResultEvent requires
    // messageId in ag_ui 0.3.0 — verified against the real package source
    // during plan review. The values below are arbitrary test fixtures,
    // not meaningful IDs.
    test('RUN_STARTED sets isRunning true and clears any prior error', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'));
      expect(r.current.sessionState.isRunning, isTrue);
      expect(r.current.sessionState.runError, isNull);
    });

    test('RUN_FINISHED sets isRunning false', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunFinishedEvent(threadId: 'th1', runId: 'run1'));
      expect(r.current.sessionState.isRunning, isFalse);
    });

    test('RUN_ERROR sets isRunning false and records the error message', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunErrorEvent(message: 'boom'));
      expect(r.current.sessionState.isRunning, isFalse);
      expect(r.current.sessionState.runError, 'boom');
    });

    test('cold replay resets isRunning/runError along with the timeline', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunErrorEvent(message: 'boom'))
        ..apply(_sync());
      expect(r.current.sessionState.isRunning, isFalse);
      expect(r.current.sessionState.runError, isNull);
    });
  });

  group('reduce() convenience wrapper', () {
    test('folds a full event list identically to sequential apply() calls', () {
      final events = [
        const TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant),
        const TextMessageContentEvent(messageId: 'm1', delta: 'hi'),
        const TextMessageEndEvent(messageId: 'm1'),
      ];
      final viaReduce = reduce(events);
      final r = ConversationReducer();
      for (final e in events) {
        r.apply(e);
      }
      expect(viaReduce, r.current);
    });
  });
}
