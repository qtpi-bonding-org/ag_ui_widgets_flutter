import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
// StreamState is NOT re-exported by the barrel file — import it directly or
// the streaming test below will not compile.
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

Conversation _conversationWith(List<TimelineItem> items) =>
    Conversation(timeline: items);

void main() {
  testWidgets('pinned: renders each timeline text item via the text builder',
      (tester) async {
    final conversation = _conversationWith([
      const TimelineItem.text(
        id: 'm1',
        kind: ChatMessageKind.text,
        role: 'user',
        text: 'hello',
        order: OrderKey(0),
      ),
      const TimelineItem.text(
        id: 'm2',
        kind: ChatMessageKind.text,
        role: 'assistant',
        text: 'hi back',
        order: OrderKey(1),
      ),
    ]);

    await tester.pumpWidget(_host(AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.pinned,
      composerBuilder: (_) => const Text('COMPOSER'),
      textMessageBuilder: (context, message, index,
              {required isSentByMe, groupStatus}) =>
          Text('${isSentByMe ? "me" : "them"}:${message.text}'),
    )));
    await tester.pumpAndSettle();

    expect(find.text('me:hello'), findsOneWidget);
    expect(find.text('them:hi back'), findsOneWidget);
    expect(find.text('COMPOSER'), findsOneWidget);
  });

  testWidgets('pinned: composer stays visible when scrolled to the top',
      (tester) async {
    final conversation = _conversationWith([
      for (var i = 0; i < 40; i++)
        TimelineItem.text(
          id: 'm$i',
          kind: ChatMessageKind.text,
          role: 'assistant',
          text: 'line $i',
          order: OrderKey(i),
        ),
    ]);

    await tester.pumpWidget(_host(AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.pinned,
      composerBuilder: (_) => const Text('COMPOSER'),
      textMessageBuilder: (context, message, index,
              {required isSentByMe, groupStatus}) =>
          SizedBox(height: 100, child: Text(message.text)),
    )));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 2000));
    await tester.pumpAndSettle();

    expect(find.text('COMPOSER'), findsOneWidget);
  });

  testWidgets('dispatches the three request kinds to their builders',
      (tester) async {
    final conversation = _conversationWith([
      const TimelineItem.permissionRequest(
        requestId: 'p1',
        options: <PermissionOption>[],
        order: OrderKey(0),
      ),
      const TimelineItem.elicitationRequest(
        requestId: 'e1',
        message: 'confirm?',
        mode: 'form',
        order: OrderKey(1),
      ),
      const TimelineItem.toolRequest(
        requestId: 'r1',
        toolName: 'read',
        argsJson: '{}',
        order: OrderKey(2),
      ),
    ]);

    await tester.pumpWidget(_host(AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.pinned,
      composerBuilder: (_) => const SizedBox.shrink(),
      permissionBuilder: (_, item) => const Text('PERM'),
      elicitationBuilder: (_, item) => const Text('ELICIT'),
      toolRequestBuilder: (_, item) => const Text('TOOLREQ'),
    )));
    await tester.pumpAndSettle();

    expect(find.text('PERM'), findsOneWidget);
    expect(find.text('ELICIT'), findsOneWidget);
    expect(find.text('TOOLREQ'), findsOneWidget);
  });

  testWidgets('renders a streaming item through the stream builder',
      (tester) async {
    final conversation = _conversationWith([
      const TimelineItem.textStream(
        id: 's1',
        role: 'assistant',
        text: 'partial',
        order: OrderKey(0),
      ),
    ]);

    await tester.pumpWidget(_host(AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.pinned,
      composerBuilder: (_) => const SizedBox.shrink(),
      textStreamMessageBuilder: (context, message, index,
              {required isSentByMe, groupStatus, required streamState}) =>
          Text('STREAM:${(streamState as StreamStateStreaming).accumulatedText}'),
    )));
    await tester.pumpAndSettle();

    expect(find.text('STREAM:partial'), findsOneWidget);
  });

  testWidgets('a stream item replaced by a completed text item does not duplicate',
      (tester) async {
    Widget build(Conversation conversation) => _host(AgUiTranscript(
          conversation: conversation,
          currentUserId: 'user',
          placement: ComposerPlacement.pinned,
          composerBuilder: (_) => const SizedBox.shrink(),
          textMessageBuilder: (context, message, index,
                  {required isSentByMe, groupStatus}) =>
              Text('DONE:${message.text}'),
          textStreamMessageBuilder: (context, message, index,
                  {required isSentByMe, groupStatus, required streamState}) =>
              const Text('STREAMING'),
        ));

    await tester.pumpWidget(build(_conversationWith([
      const TimelineItem.textStream(
        id: 's1',
        role: 'assistant',
        text: 'part',
        order: OrderKey(0),
      ),
    ])));
    await tester.pumpAndSettle();
    expect(find.text('STREAMING'), findsOneWidget);

    // Same id, now completed — the reducer replaces it in place.
    await tester.pumpWidget(build(_conversationWith([
      const TimelineItem.text(
        id: 's1',
        kind: ChatMessageKind.text,
        role: 'assistant',
        text: 'part done',
        order: OrderKey(0),
      ),
    ])));
    await tester.pumpAndSettle();

    expect(find.text('STREAMING'), findsNothing);
    expect(find.text('DONE:part done'), findsOneWidget);
  });

  testWidgets(
      'the real FlyerChatTextStreamMessage renders without a '
      'missing Provider<ChatTheme> exception',
      (tester) async {
    // Regression test: AgUiChat gets Provider<ChatTheme> for free from
    // flutter_chat_ui's Chat widget. AgUiTranscript bypasses Chat entirely,
    // so it must supply that provider itself, or any caller-supplied builder
    // that constructs FlyerChatTextStreamMessage directly (as pocketcoder's
    // own builders do) throws ProviderNotFoundException at runtime — a gap
    // the stubbed textStreamMessageBuilder in the other tests above can't
    // catch, since it never actually builds a FlyerChatTextStreamMessage.
    final conversation = _conversationWith([
      const TimelineItem.textStream(
        id: 's1',
        role: 'assistant',
        text: 'partial',
        order: OrderKey(0),
      ),
    ]);

    await tester.pumpWidget(_host(AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.pinned,
      composerBuilder: (_) => const SizedBox.shrink(),
      textStreamMessageBuilder: (context, message, index,
              {required isSentByMe, groupStatus, required streamState}) =>
          FlyerChatTextStreamMessage(
        message: message,
        index: index,
        streamState: streamState,
      ),
    )));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
