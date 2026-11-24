import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _style = StackedChatStyle(
  sentBackground: Colors.white,
  receivedBackground: Colors.white,
  textStyle: TextStyle(fontSize: 14),
  padding: EdgeInsets.all(4),
  cardRadius: BorderRadius.zero,
);

Widget _chat(List<(String, String)> messages, {CopyButtonBuilder? copy}) {
  final builders = StackedChatBuilders(
    _style,
    ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
      copyButtonBuilder: copy,
    ),
  );
  return MaterialApp(
    home: Scaffold(
      body: AgUiTranscript(
        conversation: Conversation(timeline: [
          for (final (i, (role, text)) in messages.indexed)
            TimelineItem.text(
              id: 'm$i',
              kind: ChatMessageKind.text,
              role: role,
              text: text,
              order: OrderKey(i),
            ),
        ]),
        currentUserId: 'user',
        textMessageBuilder: builders.textMessageBuilder,
        textStreamMessageBuilder: builders.textStreamMessageBuilder,
        composerBuilder: (_) => const TextField(),
      ),
    ),
  );
}

void main() {
  testWidgets('transcript text can be selected and copied', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    await tester.pumpWidget(_chat([
      ('assistant', 'first paragraph\n\nsecond paragraph'),
    ]));
    await tester.pumpAndSettle();
    final from = tester.getTopLeft(find.textContaining('first paragraph'));
    final to = tester.getBottomRight(find.textContaining('second paragraph'));
    final mouse = await tester.startGesture(
      from + const Offset(1, 2),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    await mouse.moveTo(to - const Offset(1, 2));
    await tester.pump();
    await mouse.up();
    await tester.pumpAndSettle();
    final region = tester.state<SelectableRegionState>(
      find.byType(SelectableRegion),
    );
    region.copySelection(SelectionChangedCause.toolbar);
    await tester.pump();
    expect(copied, contains('first paragraph'));
    expect(copied, contains('second paragraph'));
  });

  testWidgets('every message has a copy button with its raw text',
      (tester) async {
    final got = <(String, bool)>[];
    await tester.pumpWidget(_chat(
      [('user', 'ask'), ('assistant', '**bold** answer')],
      copy: (context, text, {required isCode}) => TextButton(
        onPressed: () => got.add((text, isCode)),
        child: const Text('COPY'),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('COPY'), findsNWidgets(2));
    await tester.tap(find.text('COPY').last);
    expect(got, [('**bold** answer', false)]);
  });

  testWidgets('a code block has its own copy button', (tester) async {
    final got = <(String, bool)>[];
    await tester.pumpWidget(_chat(
      [('assistant', 'run:\n\n```dart\nfinal a = 1;\nfinal b = 2;\n```\n')],
      copy: (context, text, {required isCode}) => TextButton(
        onPressed: () => got.add((text, isCode)),
        child: Text(isCode ? 'CODE' : 'MESSAGE'),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('final a = 1;'), findsOneWidget);
    await tester.tap(find.text('CODE'));
    expect(got, [('final a = 1;\nfinal b = 2;', true)]);
  });

  testWidgets('no copy buttons when the app supplies none', (tester) async {
    await tester.pumpWidget(_chat([('assistant', '```\nx\n```')]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
