// test/widgets/ag_ui_chat_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  Widget host(Conversation conversation, {
    Widget Function(BuildContext, TimelineItem)? permissionBuilder,
    Widget Function(BuildContext, TimelineItem)? elicitationBuilder,
    Widget Function(BuildContext, TimelineItem)? toolRequestBuilder,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          permissionBuilder: permissionBuilder,
          elicitationBuilder: elicitationBuilder,
          toolRequestBuilder: toolRequestBuilder,
        ),
      ),
    );
  }

  testWidgets('renders a completed text message via the default bubble', (tester) async {
    await tester.pumpWidget(host(const Conversation(
      timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello', order: OrderKey(0)),
      ],
    )));
    await tester.pumpAndSettle();
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('invokes the caller-supplied permissionBuilder with the full TimelineItem', (tester) async {
    PermissionRequestTimelineItem? received;
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.permissionRequest(
          requestId: 'p1',
          toolTitle: 'bash',
          options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')], order: OrderKey(0),),
      ]),
      permissionBuilder: (context, item) {
        received = item as PermissionRequestTimelineItem;
        return const Text('PERMISSION CARD');
      },
    ));
    await tester.pumpAndSettle();
    expect(received?.requestId, 'p1');
    expect(received?.toolTitle, 'bash');
    expect(received?.options.single.optionId, 'allow');
    expect(find.text('PERMISSION CARD'), findsOneWidget);
  });

  testWidgets('renders nothing for a permission item when no builder is supplied', (tester) async {
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.permissionRequest(
          requestId: 'p1',
          options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')], order: OrderKey(0),),
      ]),
    ));
    await tester.pumpAndSettle();
    expect(find.text('PERMISSION CARD'), findsNothing);
  });

  testWidgets('elicitationBuilder receives the full TimelineItem', (tester) async {
    ElicitationRequestTimelineItem? received;
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(
          requestId: 'e1',
          message: 'Pick a color',
          mode: 'form', order: OrderKey(0),),
      ]),
      elicitationBuilder: (context, item) {
        received = item as ElicitationRequestTimelineItem;
        return const Text('ELICITATION CARD');
      },
    ));
    await tester.pumpAndSettle();
    expect(received?.requestId, 'e1');
    expect(received?.message, 'Pick a color');
    expect(received?.mode, 'form');
    expect(find.text('ELICITATION CARD'), findsOneWidget);
  });

  testWidgets('toolRequestBuilder receives the full TimelineItem', (tester) async {
    ToolRequestTimelineItem? received;
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(
          requestId: 't1',
          toolName: 'propose_edit',
          argsJson: '{"changeId":"c1"}', order: OrderKey(0),),
      ]),
      toolRequestBuilder: (context, item) {
        received = item as ToolRequestTimelineItem;
        return const Text('TOOL REQUEST CARD');
      },
    ));
    await tester.pumpAndSettle();
    expect(received?.requestId, 't1');
    expect(received?.toolName, 'propose_edit');
    expect(received?.argsJson, '{"changeId":"c1"}');
    expect(find.text('TOOL REQUEST CARD'), findsOneWidget);
  });

  testWidgets('toolRequestBuilder defaults to rendering nothing', (tester) async {
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(
          requestId: 't1',
          toolName: 'noop',
          argsJson: '{}', order: OrderKey(0),),
      ]),
    ));
    await tester.pumpAndSettle();
    // Default SizedBox.shrink renders without crashing; tool request card
    // should not be in the tree.
    expect(find.text('TOOL REQUEST CARD'), findsNothing);
  });

  testWidgets('uses the caller-supplied textStreamMessageBuilder when set', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: const Conversation(timeline: [
            TimelineItem.textStream(id: 's1', role: 'assistant', text: 'partial', order: OrderKey(0)),
          ]),
          currentUserId: 'user',
          onSendMessage: (_) {},
          textStreamMessageBuilder: (context, message, index, {required isSentByMe, groupStatus, required streamState}) =>
              const Text('CUSTOM STREAM'),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('CUSTOM STREAM'), findsOneWidget);
  });
}
