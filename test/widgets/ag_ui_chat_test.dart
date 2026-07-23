// test/widgets/ag_ui_chat_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  Widget host(Conversation conversation, {
    Widget Function(BuildContext, String)? permissionBuilder,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          permissionBuilder: permissionBuilder,
        ),
      ),
    );
  }

  testWidgets('renders a completed text message via the default bubble', (tester) async {
    await tester.pumpWidget(host(const Conversation(
      timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello'),
      ],
    )));
    await tester.pumpAndSettle();
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('invokes the caller-supplied permissionBuilder with only the requestId', (tester) async {
    String? seenId;
    await tester.pumpWidget(host(
      const Conversation(timeline: [TimelineItem.permission(requestId: 'p1')]),
      permissionBuilder: (context, requestId) {
        seenId = requestId;
        return const Text('PERMISSION CARD');
      },
    ));
    await tester.pumpAndSettle();
    expect(seenId, 'p1');
    expect(find.text('PERMISSION CARD'), findsOneWidget);
  });

  testWidgets('renders nothing for a permission item when no builder is supplied', (tester) async {
    await tester.pumpWidget(host(
      const Conversation(timeline: [TimelineItem.permission(requestId: 'p1')]),
    ));
    await tester.pumpAndSettle();
    expect(find.text('PERMISSION CARD'), findsNothing);
  });
}
