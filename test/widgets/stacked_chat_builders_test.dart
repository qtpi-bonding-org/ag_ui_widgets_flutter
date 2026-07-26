// test/widgets/stacked_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/style/stacked_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/stacked_chat_builders.dart';

void main() {
  const style = StackedChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
  );

  Widget host(Conversation conversation, StackedChatBuilders builders) {
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

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = StackedChatBuilders(
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

  testWidgets('permission builder fires onPermissionOptionSelected with the tapped optionId', (tester) async {
    String? gotOptionId;
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (requestId, {optionId, cancelled = false}) => gotOptionId = optionId,
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.permissionRequest(
          requestId: 'p1',
          toolTitle: 'bash',
          options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
        ),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    expect(gotOptionId, 'allow');
  });

  testWidgets('toolRequest builder dispatches to a registered override', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
        toolRequestOverrides: {'render_surface': (context, item) => const Text('SURFACE')},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'render_surface', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('SURFACE'), findsOneWidget);
  });

  testWidgets('unregistered toolRequest falls back to the generic card', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'other_tool', toolTitle: 'Other Tool', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('Other Tool'), findsOneWidget);
  });
}
