// test/widgets/stacked_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/style/stacked_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/stacked_chat_builders.dart';

void main() {
  const style = StackedChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
  );

  Widget host(Conversation conversation, StackedChatBuilders builders) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          textMessageBuilder: builders.textMessageBuilder,
          toolCallBuilder: builders.toolCallBuilder,
          permissionBuilder: builders.permissionBuilder,
          elicitationBuilder: builders.elicitationBuilder,
          toolRequestBuilder: builders.toolRequestBuilder,
          textStreamMessageBuilder: builders.textStreamMessageBuilder,
        ),
      ),
    );
  }

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello **world**'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('permission builder fires onPermissionOptionSelected with the tapped optionId', (tester) async {
    String? gotOptionId;
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (requestId, {optionId, cancelled = false}) => gotOptionId = optionId,
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.permissionRequest(
          requestId: 'p1',
          toolTitle: 'bash',
          options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
        ),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    expect(gotOptionId, 'allow');
  });

  testWidgets('toolRequest builder dispatches to a registered override', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
        toolRequestOverrides: {'render_surface': (context, item) => const Text('SURFACE')},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'render_surface', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('SURFACE'), findsOneWidget);
  });

  testWidgets('unregistered toolRequest falls back to the generic card', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'other_tool', toolTitle: 'Other Tool', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('Other Tool'), findsOneWidget);
  });

  testWidgets('toolCallBuilder renders a diff summary when diffs are present', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolCall(id: 't1', name: 'edit_file', diffs: [ToolDiff(path: 'lib/a.dart', oldText: 'a', newText: 'b')]),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('lib/a.dart'), findsOneWidget);
  });

  testWidgets('elicitation form renders a checkbox for boolean properties', (tester) async {
    Map<String, dynamic>? gotResponse;
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, response) => gotResponse = response,
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(
          requestId: 'e1',
          message: 'Configure',
          mode: 'form',
          schema: {
            'type': 'object',
            'properties': {
              'enabled': {'type': 'boolean', 'title': 'Enabled'},
            },
          },
        ),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile), findsOneWidget);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit'));
    expect(gotResponse, {'enabled': true});
  });

  testWidgets('elicitation form renders a numeric field for integer properties', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(
          requestId: 'e2',
          message: 'Configure',
          mode: 'form',
          schema: {
            'type': 'object',
            'properties': {
              'count': {'type': 'integer', 'title': 'Count'},
            },
          },
        ),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    // `flutter_chat_core` mounts its own composer `TextField` underneath
    // the elicitation card, so `find.byType(TextField)` matches two
    // widgets — the elicitation one (our `_ElicitationForm` field) and
    // the composer one. Both have a default `TextInputType.text`, so we
    // assert specifically on the *numeric* one (i.e. the elicitation
    // field) to disambiguate.
    final numericFields = tester
        .widgetList<TextField>(
          find.byWidgetPredicate(
            (w) => w is TextField && w.keyboardType == TextInputType.number,
          ),
        )
        .toList();
    expect(numericFields, hasLength(1));
  });

  testWidgets('reasoning messages render with reasoningTextStyle', (tester) async {
    // `chatMarkdownBody` renders into a `MarkdownBody` widget whose
    // `styleSheet.p` carries the paragraph style — inspect that directly
    // rather than the plain text, since reasoning styling flows through
    // the markdown style sheet, not a `Text` widget.
    const reasoningStyle = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(fontSize: 14),
      reasoningTextStyle: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.orange),
    );
    final builders = StackedChatBuilders(
      reasoningStyle,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.reasoning, role: 'assistant', text: 'thinking...'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    final markdownBody = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdownBody.styleSheet?.p?.fontStyle, FontStyle.italic);
    expect(markdownBody.styleSheet?.p?.color, Colors.orange);
  });

  testWidgets('roleHeaderBuilder receives role/isSentByMe/isReasoning', (tester) async {
    final calls = <({String role, bool isSentByMe, bool isReasoning})>[];
    final styleWithHeader = style.copyWith(
      roleHeaderBuilder: (context, {required role, required isSentByMe, required isReasoning}) {
        calls.add((role: role, isSentByMe: isSentByMe, isReasoning: isReasoning));
        return Text('HEADER:$role');
      },
    );
    final builders = StackedChatBuilders(
      styleWithHeader,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.reasoning, role: 'assistant', text: 'thinking'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('HEADER:assistant'), findsOneWidget);
    expect(calls.single, (role: 'assistant', isSentByMe: false, isReasoning: true));
  });
}
