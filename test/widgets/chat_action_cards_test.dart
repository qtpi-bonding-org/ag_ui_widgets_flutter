// test/widgets/chat_action_cards_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/chat_action_cards.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
  const decoration = BoxDecoration(color: Colors.white);
  const textStyle = TextStyle();

  testWidgets('permission card renders one button per option and calls onSelect with its optionId', (tester) async {
    String? gotRequestId;
    String? gotOptionId;
    const item = PermissionRequestTimelineItem(
      requestId: 'p1',
      toolTitle: 'bash',
      options: [
        PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once'),
        PermissionOption(optionId: 'deny', label: 'Deny', kind: 'reject_once'),
      ], order: OrderKey(0),);
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildPermissionCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        onSelect: (requestId, {optionId, cancelled = false}) {
          gotRequestId = requestId;
          gotOptionId = optionId;
        },
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Allow'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
    await tester.tap(find.text('Allow'));
    expect(gotRequestId, 'p1');
    expect(gotOptionId, 'allow');
  });

  testWidgets('elicitation card renders the message and calls onRespond on submit', (tester) async {
    String? gotRequestId;
    Map<String, dynamic>? gotResponse;
    const item = ElicitationRequestTimelineItem(requestId: 'e1', message: 'Pick a color', mode: 'url', url: 'https://example.com', order: OrderKey(0));
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildElicitationCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        onRespond: (requestId, response) {
          gotRequestId = requestId;
          gotResponse = response;
        },
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Pick a color'), findsOneWidget);
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    expect(gotRequestId, 'e1');
    expect(gotResponse, isNotNull);
  });

  testWidgets('toolRequest card dispatches to a registered override', (tester) async {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'render_surface', argsJson: '{}', order: OrderKey(0));
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildToolRequestCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        overrides: {'render_surface': (context, item) => const Text('SURFACE')},
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.text('SURFACE'), findsOneWidget);
  });

  testWidgets('toolRequest card falls back to a generic card for an unregistered tool name', (tester) async {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'unknown_tool', toolTitle: 'Unknown Tool', argsJson: '{}', order: OrderKey(0));
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildToolRequestCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        overrides: const {},
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unknown Tool'), findsOneWidget);
  });

  group('prettifyToolResult', () {
    test('extracts and joins text blocks from the MCP content-array wire format', () {
      expect(
        prettifyToolResult('[{"type":"text","text":"hello"}]'),
        'hello',
      );
    });

    test('joins multiple text blocks with a newline', () {
      expect(
        prettifyToolResult(
          '[{"type":"text","text":"first"},{"type":"text","text":"second"}]',
        ),
        'first\nsecond',
      );
    });

    test('an empty content array produces an empty string, not "[]"', () {
      expect(prettifyToolResult('[]'), '');
    });

    test('falls back to the raw string for an unrecognized block shape', () {
      const raw = '[{"type":"image","data":"..."}]';
      expect(prettifyToolResult(raw), raw);
    });

    test('falls back to the raw string when it is not valid JSON at all', () {
      const raw = 'plain text result, not MCP-wrapped';
      expect(prettifyToolResult(raw), raw);
    });

    test('falls back to the raw string when JSON-valid but not a list', () {
      const raw = '{"status":"ok"}';
      expect(prettifyToolResult(raw), raw);
    });
  });

  testWidgets(
    'buildToolCallCardContent renders the prettified result, not the raw '
    'MCP content-array JSON',
    (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildToolCallCardContent(
          context,
          name: 'fetch',
          result: '[{"type":"text","text":"note body here"}]',
          diffs: const [],
          decoration: decoration,
          textStyle: textStyle,
          diffAddedColor: Colors.green,
          diffRemovedColor: Colors.red,
        ),
      )));
      await tester.pumpAndSettle();

      expect(find.text('note body here'), findsOneWidget);
      expect(find.textContaining('"type":"text"'), findsNothing);
    },
  );
}
