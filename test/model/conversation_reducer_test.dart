import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

BaseEvent _sync() =>
    CustomEvent(name: 'pocketcoder:sync', value: {'mode': 'replace'});

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

  group('permission/elicitation via state delta', () {
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
      expect((r.current.timeline.single as ElicitationTimelineItem).requestId, 'e1');
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
