import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';

void main() {
  test('Conversation.empty has no timeline items and idle SessionState', () {
    expect(Conversation.empty.timeline, isEmpty);
    expect(Conversation.empty.sessionState.isRunning, isFalse);
    expect(Conversation.empty.sessionState.runError, isNull);
  });

  test('TextTimelineItem carries kind/role/text', () {
    const item = TimelineItem.text(
      id: 'm1',
      kind: ChatMessageKind.text,
      role: 'assistant',
      text: 'hi',
    );
    expect(item, isA<TextTimelineItem>());
    expect((item as TextTimelineItem).text, 'hi');
  });
}
