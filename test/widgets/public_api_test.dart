// test/widgets/public_api_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void _ignore(Object? _) {}

void main() {
  test('barrel exports the new style configs, callbacks, and builder classes', () {
    const stackedStyle = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
    );
    const bubbleStyle = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 260,
    );
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
    );
    final stackedBuilders = StackedChatBuilders(stackedStyle, callbacks);
    final bubbleBuilders = BubbleChatBuilders(bubbleStyle, callbacks);

    expect(stackedBuilders.textMessageBuilder, isNotNull);
    expect(bubbleBuilders.textMessageBuilder, isNotNull);
  });

  test('barrel exposes the 0.4.0 style fields on both chat styles', () {
    const stackedStyle = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
    );
    const bubbleStyle = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 260,
    );

    // Touch every new field on each style just to confirm it's reachable
    // from the barrel — values are unused.
    _ignore(stackedStyle.diffAddedColor);
    _ignore(stackedStyle.diffRemovedColor);
    _ignore(stackedStyle.reasoningTextStyle);
    _ignore(stackedStyle.roleHeaderBuilder);

    _ignore(bubbleStyle.diffAddedColor);
    _ignore(bubbleStyle.diffRemovedColor);
    _ignore(bubbleStyle.reasoningTextStyle);
    _ignore(bubbleStyle.roleHeaderBuilder);

    // Setting via copyWith must also compile, proving the new fields are
    // full first-class style members (not just getters).
    final styled = stackedStyle.copyWith(
      diffAddedColor: Colors.green,
      diffRemovedColor: Colors.red,
      reasoningTextStyle: const TextStyle(fontStyle: FontStyle.italic),
      roleHeaderBuilder: (context, {required role, required isSentByMe, required isReasoning}) =>
          Text('$role/$isSentByMe/$isReasoning'),
    );
    _ignore(styled);

    final bubbleStyled = bubbleStyle.copyWith(
      diffAddedColor: Colors.green,
      diffRemovedColor: Colors.red,
      reasoningTextStyle: const TextStyle(fontStyle: FontStyle.italic),
      roleHeaderBuilder: (context, {required role, required isSentByMe, required isReasoning}) =>
          Text('$role/$isSentByMe/$isReasoning'),
    );
    _ignore(bubbleStyled);
  });

  test('barrel exposes the 0.4.0 ChatActionCallbacks escape hatches', () {
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
      toolCallOverrides: {
        'edit_file': (context, message) => const Text('edit_file override'),
      },
      permissionCardBuilder: (context, item) => Text('permission ${item.requestId}'),
      elicitationCardBuilder: (context, item) => Text('elicitation ${item.requestId}'),
    );

    _ignore(callbacks.toolCallOverrides);
    _ignore(callbacks.permissionCardBuilder);
    _ignore(callbacks.elicitationCardBuilder);
  });

  test('barrel exposes AgUiChat.textStreamMessageBuilder', () {
    // No rendering here — just confirm the constructor accepts the new
    // slot and the field is readable. The widget itself is exercised
    // end-to-end in test/widgets/ag_ui_chat_test.dart.
    AgUiChat(
      conversation: const Conversation(timeline: []),
      currentUserId: 'user',
      onSendMessage: (_) {},
      textStreamMessageBuilder: (context, message, index, {required isSentByMe, groupStatus, required streamState}) =>
          Text('stream ${message.id}'),
    );
  });

  testWidgets('chatMarkdownBody is reachable from the barrel', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Builder(builder: (context) => chatMarkdownBody(context, 'hi')),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('hi'), findsWidgets);
  });
}