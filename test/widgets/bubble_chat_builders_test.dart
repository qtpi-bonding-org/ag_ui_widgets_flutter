// test/widgets/bubble_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/bubble_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/bubble_chat_builders.dart';

void main() {
  const style = BubbleChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
    maxWidth: 260,
  );

  Widget host(Conversation conversation, BubbleChatBuilders builders) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          textMessageBuilder: builders.textMessageBuilder,
          toolCallBuilder: builders.toolCallBuilder,
          permissionBuilder: builders.permissionBuilder,
          elicitationBuilder: builders.elicitationBuilder,
          toolRequestBuilder: builders.toolRequestBuilder,
        ),
      ),
    );
  }

  testWidgets('sent message aligns to centerRight, received to centerLeft', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'user', text: 'hi'),
        TimelineItem.text(id: 'm2', kind: ChatMessageKind.text, role: 'assistant', text: 'hello'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    final sentAlign = tester.widget<Align>(find.ancestor(of: find.text('hi'), matching: find.byType(Align)).first);
    final receivedAlign = tester.widget<Align>(find.ancestor(of: find.text('hello'), matching: find.byType(Align)).first);
    expect(sentAlign.alignment, Alignment.centerRight);
    expect(receivedAlign.alignment, Alignment.centerLeft);
  });

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello **world**'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('elicitation builder fires onElicitationRespond', (tester) async {
    String? gotRequestId;
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (requestId, response) => gotRequestId = requestId,
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(requestId: 'e1', message: 'Pick one', mode: 'url', url: 'https://example.com'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    expect(gotRequestId, 'e1');
  });
}
