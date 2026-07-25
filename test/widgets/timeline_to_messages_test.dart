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
        diffs: [ToolDiff(path: 'lib/foo.dart', oldText: 'a', newText: 'b')],
      );

      final messages = timelineToMessages([item]);
      final message = messages.single as chat_core.CustomMessage;
      final diffs = message.metadata?['diffs'] as List<dynamic>;
      expect(diffs, hasLength(1));
      expect(diffs.single, {'path': 'lib/foo.dart', 'oldText': 'a', 'newText': 'b'});
    });

    test('toolCall item with no diffs produces an empty diffs list', () {
      const item = TimelineItem.toolCall(id: 't1', name: 'search');
      final messages = timelineToMessages([item]);
      final message = messages.single as chat_core.CustomMessage;
      expect(message.metadata?['diffs'], isEmpty);
    });
  });
}
