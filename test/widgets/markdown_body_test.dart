// test/widgets/markdown_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/markdown_body.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders bold text without literal asterisks', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, 'hello **world**'),
    )));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('renders a fenced code block', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, '```\nconst x = 1;\n```'),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('const x = 1;'), findsWidgets);
  });

  testWidgets('falls back to MarkdownStyleSheet.fromTheme when no styleSheetBuilder is given', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, 'plain text'),
    )));
    await tester.pumpAndSettle();
    final markdownBody = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdownBody.styleSheet, isNotNull);
  });

  testWidgets('uses a custom styleSheetBuilder when supplied', (tester) async {
    late MarkdownStyleSheet expectedSheet;
    await tester.pumpWidget(host(Builder(
      builder: (context) {
        expectedSheet = MarkdownStyleSheet(p: const TextStyle(fontSize: 42));
        return chatMarkdownBody(context, 'plain text', styleSheetBuilder: (_) => expectedSheet);
      },
    )));
    await tester.pumpAndSettle();
    final markdownBody = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdownBody.styleSheet!.p!.fontSize, 42);
  });
}
