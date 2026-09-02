import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/timeline_to_messages.dart';

void main() {
  group('timelineToMessages', () {
    test('toolCall item with diffs produces metadata["diffs"] with path/oldText/newText', () {
      const item = TimelineItem.toolCall(
        id: 't1',
        name: 'edit_file',
        args: '{}',
        result: 'ok',
        diffs: [ToolDiff(path: 'lib/foo.dart', oldText: 'a', newText: 'b')], order: OrderKey(0),);

      final messages = timelineToMessages([item]);
      final message = messages.single as chat_core.CustomMessage;
      final diffs = message.metadata?['diffs'] as List<dynamic>;
      expect(diffs, hasLength(1));
      expect(diffs.single, {'path': 'lib/foo.dart', 'oldText': 'a', 'newText': 'b'});
    });

    test('toolCall item with no diffs produces an empty diffs list', () {
      const item = TimelineItem.toolCall(id: 't1', name: 'search', order: OrderKey(0));
      final messages = timelineToMessages([item]);
      final message = messages.single as chat_core.CustomMessage;
      expect(message.metadata?['diffs'], isEmpty);
    });

    test('toolCall item forwards toolKind in metadata', () {
      const item = TimelineItem.toolCall(
        id: 't1',
        name: 'bash',
        toolKind: 'execute',
        order: OrderKey(0),
      );
      final message = timelineToMessages([item]).single as chat_core.CustomMessage;
      expect(message.metadata?['toolKind'], 'execute');
    });

    test('toolCall item with a null toolKind forwards a null metadata value', () {
      const item = TimelineItem.toolCall(id: 't1', name: 'search', order: OrderKey(0));
      final message = timelineToMessages([item]).single as chat_core.CustomMessage;
      expect(message.metadata?['toolKind'], isNull);
    });

    test('suppresses toolCall bubble when a correlated ToolRequestTimelineItem is live', () {
      // Both items share the id "tc1" - the ToolRequestTimelineItem is the
      // live client-side card representing the call; the raw ToolCallTimelineItem
      // bubble must be filtered out so it doesn't shadow the card.
      const toolCall = TimelineItem.toolCall(
        id: 'tc1',
        name: 'search',
        order: OrderKey(0),
      );
      const toolRequest = TimelineItem.toolRequest(
        requestId: 'tc1',
        toolName: 'search',
        order: OrderKey(1),
        argsJson: '{}',
      );

      final messages = timelineToMessages([toolCall, toolRequest]);

      expect(messages, hasLength(1));
      final message = messages.single as chat_core.CustomMessage;
      expect(message.id, 'tc1');
      expect(message.metadata?['kind'], 'toolRequest');
    });

    test(
      'suppresses toolCall bubble when a correlated PermissionRequestTimelineItem '
      'is live (regression, 2026-08-01) — both now coexist in the timeline since '
      'ConversationReducer stopped storing them at the same key',
      () {
        // Same id "tc1" on purpose — an ACP permission request's callId IS
        // its tool call's own id (see conversation_reducer.dart's
        // acp.permission_request case). Both items now legitimately coexist
        // in the timeline (they no longer overwrite each other in the
        // reducer's storage), so without this filter, converting both to
        // Messages would produce two Message.id 'tc1' entries —
        // InMemoryChatController asserts against duplicate ids.
        const toolCall = TimelineItem.toolCall(
          id: 'tc1',
          name: 'add_comment',
          order: OrderKey(0),
        );
        const permissionRequest = TimelineItem.permissionRequest(
          requestId: 'tc1',
          options: [],
          order: OrderKey(0, 1),
        );

        final messages = timelineToMessages([toolCall, permissionRequest]);

        expect(messages, hasLength(1));
        final message = messages.single as chat_core.CustomMessage;
        expect(message.id, 'tc1');
        expect(message.metadata?['kind'], 'permissionRequest');
      },
    );

    test('keeps toolCall bubble when no correlated request is present', () {
      const toolCall = TimelineItem.toolCall(
        id: 'tc1',
        name: 'search',
        args: '{}',
        result: 'ok',
        order: OrderKey(0),
      );

      final messages = timelineToMessages([toolCall]);

      expect(messages, hasLength(1));
      final message = messages.single as chat_core.CustomMessage;
      expect(message.metadata?['kind'], 'toolCall');
    });
  });
}