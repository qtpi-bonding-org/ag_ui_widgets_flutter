import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

Widget _transcript(Conversation conversation) => AgUiTranscript(
      conversation: conversation,
      currentUserId: 'user',
      placement: ComposerPlacement.inline,
      composerBuilder: (_) => const SizedBox(height: 48, child: Text('PROMPT')),
      textMessageBuilder: (context, message, index,
              {required isSentByMe, groupStatus}) =>
          SizedBox(height: 100, child: Text(message.text)),
    );

Conversation _lines(int n) => Conversation(
      timeline: [
        for (var i = 0; i < n; i++)
          TimelineItem.text(
            id: 'm$i',
            kind: ChatMessageKind.text,
            role: 'assistant',
            text: 'line $i',
            order: OrderKey(i),
          ),
      ],
    );

void main() {
  testWidgets('empty conversation puts the prompt at the top of the viewport',
      (tester) async {
    await tester.pumpWidget(_host(_transcript(const Conversation())));
    await tester.pumpAndSettle();

    final promptTop = tester.getTopLeft(find.text('PROMPT')).dy;
    final viewportTop =
        tester.getTopLeft(find.byType(CustomScrollView)).dy;

    expect(promptTop, moreOrLessEquals(viewportTop, epsilon: 4));
  });

  testWidgets('the prompt sits below the messages, not above them',
      (tester) async {
    await tester.pumpWidget(_host(_transcript(_lines(3))));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('PROMPT')).dy,
        greaterThan(tester.getTopLeft(find.text('line 2')).dy));
  });

  testWidgets('the prompt moves down as messages are added', (tester) async {
    await tester.pumpWidget(_host(_transcript(_lines(1))));
    await tester.pumpAndSettle();
    final withOne = tester.getTopLeft(find.text('PROMPT')).dy;

    await tester.pumpWidget(_host(_transcript(_lines(3))));
    await tester.pumpAndSettle();
    final withThree = tester.getTopLeft(find.text('PROMPT')).dy;

    expect(withThree, greaterThan(withOne));
  });

  testWidgets('overflowing content keeps the prompt reachable at the end',
      (tester) async {
    await tester.pumpWidget(_host(_transcript(_lines(40))));
    await tester.pumpAndSettle();

    // Armed by default, so the transcript should already be at the end with
    // the prompt on screen.
    expect(find.text('PROMPT'), findsOneWidget);
  });

  testWidgets('a narrow viewport with large text scale raises no exception',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: Scaffold(body: _transcript(_lines(10))),
      ),
    ));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
