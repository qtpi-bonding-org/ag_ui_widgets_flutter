import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

ToolCallTimelineItem _tool(ConversationReducer r, String id) =>
    r.current.timeline.whereType<ToolCallTimelineItem>().firstWhere(
          (t) => t.id == id,
        );

ConversationReducer _withTool(String namespace) {
  return ConversationReducer(namespace: namespace)
    ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'));
}

void main() {
  group('configurable namespace', () {
    test('defaults to pocketcoder', () {
      expect(ConversationReducer().namespace, 'pocketcoder');
    });

    test('<ns>:tool sets toolKind and status for a custom namespace', () {
      final r = _withTool('episutra')
        ..apply(const CustomEvent(name: 'episutra:tool', value: {
          'toolCallId': 'tc1',
          'kind': 'execute',
          'status': 'failed',
        }));
      expect(_tool(r, 'tc1').toolKind, 'execute');
      expect(_tool(r, 'tc1').isFailed, isTrue);
    });

    test('events from a different namespace are ignored', () {
      final r = _withTool('episutra')
        ..apply(const CustomEvent(name: 'pocketcoder:tool', value: {
          'toolCallId': 'tc1',
          'kind': 'execute',
        }));
      expect(_tool(r, 'tc1').toolKind, isNull);
    });

    test('the default namespace ignores a custom namespace', () {
      final r = _withTool('pocketcoder')
        ..apply(const CustomEvent(name: 'episutra:tool', value: {
          'toolCallId': 'tc1',
          'kind': 'execute',
        }));
      expect(_tool(r, 'tc1').toolKind, isNull);
    });

    test('<ns>:diff appends a ToolDiff for a custom namespace', () {
      final r = _withTool('episutra')
        ..apply(const CustomEvent(name: 'episutra:diff', value: {
          'toolCallId': 'tc1',
          'path': 'a.txt',
          'oldText': 'x',
          'newText': 'y',
        }));
      expect(_tool(r, 'tc1').diffs.single.path, 'a.txt');
    });

    test('<ns>:sync with mode replace resets the timeline', () {
      final r = _withTool('episutra')
        ..apply(const CustomEvent(
            name: 'episutra:sync', value: {'mode': 'replace'}));
      expect(r.current.timeline, isEmpty);
    });

    test('a different namespace sync marker does not reset the timeline', () {
      final r = _withTool('episutra')
        ..apply(const CustomEvent(
            name: 'pocketcoder:sync', value: {'mode': 'replace'}));
      expect(r.current.timeline, isNotEmpty);
    });

    test('STATE_SNAPSHOT is read from the namespace key', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const StateSnapshotEvent(snapshot: {
          'episutra': {
            'session_info': {'title': 'Hello'},
          },
        }));
      expect(r.current.sessionState.title, 'Hello');
    });

    test('STATE_SNAPSHOT under another namespace key is ignored', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const StateSnapshotEvent(snapshot: {
          'pocketcoder': {
            'session_info': {'title': 'Hello'},
          },
        }));
      expect(r.current.sessionState.title, isNull);
    });

    test('STATE_DELTA paths are matched against the namespace', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateDeltaEvent(delta: [
          {
            'op': 'add',
            'path': '/episutra/session_info',
            'value': {'title': 'Delta'},
          },
        ]));
      expect(r.current.sessionState.title, 'Delta');
    });

    test('STATE_DELTA for another namespace is ignored', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateDeltaEvent(delta: [
          {
            'op': 'add',
            'path': '/pocketcoder/session_info',
            'value': {'title': 'Delta'},
          },
        ]));
      expect(r.current.sessionState.title, isNull);
    });

    test('reduce() accepts a namespace', () {
      final c = reduce(const [
        ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'),
        CustomEvent(
            name: 'episutra:tool', value: {'toolCallId': 'tc1', 'kind': 'read'}),
      ], namespace: 'episutra');
      expect(
        c.timeline.whereType<ToolCallTimelineItem>().single.toolKind,
        'read',
      );
    });
  });
}
