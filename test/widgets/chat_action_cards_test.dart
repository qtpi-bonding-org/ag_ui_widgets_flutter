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
      ],
    );
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
    const item = ElicitationRequestTimelineItem(requestId: 'e1', message: 'Pick a color', mode: 'url', url: 'https://example.com');
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
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'render_surface', argsJson: '{}');
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
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'unknown_tool', toolTitle: 'Unknown Tool', argsJson: '{}');
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
}
