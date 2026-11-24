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

Widget _chat(List<(String, String)> messages, {CopyButtonBuilder? copy, ChatMessageKind kind = ChatMessageKind.text}) {
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
              kind: kind,
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
    expect(copied, 'first paragraph\nsecond paragraph');
  });

  testWidgets('every message has a copy button with its raw text',
      (tester) async {
    final got = <(String, bool)>[];
    await tester.pumpWidget(_chat(
      [('user', 'ask'), ('assistant', '**bold** answer')],
      copy: (context, text, {required id, required isCode}) => TextButton(
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
      copy: (context, text, {required id, required isCode}) => TextButton(
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

  Future<String?> selectAllAndCopy(WidgetTester tester) async {
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
    // Nested selection containers register one level per frame, and `pump`
    // draws none unless one is scheduled.
    for (var i = 0; i < 5; i++) {
      tester.binding.scheduleFrame();
      await tester.pump();
    }
    final region =
        tester.state<SelectableRegionState>(find.byType(SelectableRegion));
    region.selectAll(SelectionChangedCause.keyboard);
    await tester.pump();
    region.copySelection(SelectionChangedCause.toolbar);
    await tester.pump();
    return copied;
  }

  testWidgets('copied messages, lists and code keep their line breaks',
      (tester) async {
    await tester.pumpWidget(_chat([
      ('user', 'ask'),
      ('assistant', 'intro\n\n- one\n- two\n\n```\na\nb\n```'),
    ]));
    await tester.pumpAndSettle();
    expect(
      await selectAllAndCopy(tester),
      'ask\n\nintro\n• one\n• two\na\nb',
    );
  });

  testWidgets('copied table cells are separated', (tester) async {
    await tester.pumpWidget(_chat([
      ('assistant', '| a | b |\n|---|---|\n| c | d |'),
    ]));
    await tester.pumpAndSettle();
    expect(await selectAllAndCopy(tester), 'a\tb\nc\td');
  });

  testWidgets('text inside a paragraph copies unchanged', (tester) async {
    await tester.pumpWidget(_chat([
      ('assistant', 'a **b** `c` [d](http://x.y) e'),
    ]));
    await tester.pumpAndSettle();
    expect(await selectAllAndCopy(tester), 'a b c d e');
  });

  testWidgets('no copy button for blank text, reasoning or an empty fence',
      (tester) async {
    Widget copy(BuildContext c, String text,
            {required String id, required bool isCode}) =>
        const Text('COPY');
    await tester.pumpWidget(_chat([('assistant', '  ')], copy: copy));
    await tester.pumpAndSettle();
    expect(find.text('COPY'), findsNothing);
    await tester.pumpWidget(_chat([('assistant', 'x\n\n```\n```')], copy: copy));
    await tester.pumpAndSettle();
    expect(find.text('COPY'), findsOneWidget);
    await tester.pumpWidget(_chat([('assistant', 'thinking')],
        copy: copy, kind: ChatMessageKind.reasoning));
    await tester.pumpAndSettle();
    expect(find.text('COPY'), findsNothing);
  });

  testWidgets('copy ids are different for every control', (tester) async {
    final ids = <String>{};
    await tester.pumpWidget(_chat(
      [('user', 'q'), ('assistant', '```\na\n```\n\n```\nb\n```')],
      copy: (context, text, {required id, required isCode}) {
        ids.add(id);
        return const SizedBox(width: 10, height: 10);
      },
    ));
    await tester.pumpAndSettle();
    expect(ids, hasLength(4));
  });

  testWidgets('a slow press on a copy button keeps focus in the composer',
      (tester) async {
    await tester.pumpWidget(_chat(
      [('assistant', 'answer')],
      copy: (context, text, {required id, required isCode}) => TextButton(
        focusNode: FocusNode(canRequestFocus: false),
        onPressed: () {},
        child: const Text('COPY'),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pump();
    final before = FocusManager.instance.primaryFocus;
    final mouse = await tester.startGesture(
      tester.getCenter(find.text('COPY')),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await mouse.up();
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus, before);
  });

  testWidgets('a long code line has a horizontal scrollbar, and scrolling it '
      'does not stop the transcript following', (tester) async {
    Widget chat(int n) => _chat([
          for (var i = 0; i < n; i++) ('assistant', 'line $i\n\nmore\n\nmore'),
          ('assistant', '```\n${'x' * 400}\n```'),
        ], copy: (context, text, {required id, required isCode}) =>
            const SizedBox(width: 10, height: 10));
    await tester.pumpWidget(chat(20));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate((w) => w is Scrollbar && w.controller != null),
      findsWidgets,
    );
    final code = tester.getRect(find
        .ancestor(
          of: find.textContaining('xxxx'),
          matching: find.byType(SingleChildScrollView),
        )
        .first);
    for (final dx in [-200.0, 100.0]) {
      await tester.dragFrom(code.center, Offset(dx, 0));
      await tester.pumpAndSettle();
    }
    await tester.pumpWidget(chat(24));
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(find
            .byWidgetPredicate((w) =>
                w is Scrollable && w.axisDirection == AxisDirection.down)
            .first)
        .position;
    expect(position.pixels, closeTo(position.maxScrollExtent, 1));
  });

  testWidgets('new text does not scroll away from a selection in progress',
      (tester) async {
    Widget chat(int n) =>
        _chat([for (var i = 0; i < n; i++) ('assistant', 'message $i')]);
    await tester.pumpWidget(chat(60));
    await tester.pumpAndSettle();
    final scrollable = find
        .byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down)
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.pixels, closeTo(position.maxScrollExtent, 1));
    final box = tester.getRect(scrollable);
    final mouse = await tester.startGesture(
      tester.getCenter(find.textContaining('message 59')),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    await mouse.moveTo(box.topCenter + const Offset(0, 20));
    await tester.pump();
    await mouse.moveTo(box.topCenter + const Offset(0, -30));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    final scrolledTo = position.pixels;
    expect(scrolledTo, lessThan(position.maxScrollExtent - 100),
        reason: 'dragging past the edge scrolls');
    await tester.pumpWidget(chat(61));
    await tester.pump();
    await tester.pump();
    expect(position.pixels, lessThan(position.maxScrollExtent - 100));
    await mouse.up();
    await tester.pumpAndSettle();
  });
}
