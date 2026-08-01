// test/widgets/ag_ui_chat_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui/ag_ui.dart' as ag_ui;

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

  testWidgets(
    'a realistic event burst (tool call starts, streams args, a permission '
    'sharing its callId appears and resolves, the result lands) runs through '
    "AgUiChat end-to-end without error (2026-08-01). NOTE: this does NOT "
    'reliably reproduce the SliverAnimatedList crash itself — confirmed by '
    "running it against the pre-fix _syncMessages (bare setMessages): it "
    "still passed, because the crash is a real Flutter-internal timing race "
    "(a synchronous widget-test pump doesn't hit the same window a live app "
    'does). The actual regression coverage for the crash mechanism is '
    'message_list_sync_test.dart, which asserts the update-not-remove+insert '
    'contract directly and unconditionally. This test instead covers '
    'end-to-end correctness of the new sync path through the real widget '
    'tree (including the reducer key-collision fix — see '
    'conversation_reducer_test.dart).',
    (tester) async {
      final reducer = ConversationReducer();
      Future<void> pumpEvent(ag_ui.BaseEvent event) async {
        reducer.apply(event);
        await tester.pumpWidget(host(reducer.current));
      }

      await tester.pumpWidget(host(reducer.current));
      await pumpEvent(
        const ag_ui.ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'add_comment'),
      );
      await pumpEvent(
        const ag_ui.ToolCallArgsEvent(toolCallId: 'tc1', delta: '{"body":'),
      );
      await pumpEvent(
        const ag_ui.ToolCallArgsEvent(toolCallId: 'tc1', delta: '"hi"}'),
      );
      await pumpEvent(const ag_ui.CustomEvent(
        name: 'acp.permission_request',
        value: {'callId': 'tc1', 'toolName': 'add_comment', 'optionsJson': '[]'},
      ));
      reducer.resolveRequest('tc1');
      await tester.pumpWidget(host(reducer.current));
      await pumpEvent(const ag_ui.ToolCallResultEvent(
        messageId: 'm1',
        toolCallId: 'tc1',
        content: 'ok',
      ));
      // The exact assertion this regresses: 'child == null ||
      // indexOf(child) > index' / 'indexOf(child) == index' in
      // RenderSliverMultiBoxAdaptor, tripped by flutter_chat_ui treating a
      // same-id content change as a same-key remove+insert. pumpAndSettle
      // (not a bare pump) lets any in-flight remove animation finish so the
      // test binding's own end-of-test "no pending timers" invariant check
      // doesn't fail for an unrelated reason.
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Correctness, not just "didn't crash": the tool call's real
      // name/result must be showing on ONE card (the fix that made
      // permission and tool-call coexist instead of overwrite must not
      // have introduced its own duplicate-render bug).
      expect(find.text('add_comment'), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
    },
  );

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
