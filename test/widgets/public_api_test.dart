// test/widgets/public_api_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

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

  testWidgets('chatMarkdownBody is reachable from the barrel', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Builder(builder: (context) => chatMarkdownBody(context, 'hi')),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('hi'), findsWidgets);
  });
}
