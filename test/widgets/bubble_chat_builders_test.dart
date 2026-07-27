// test/widgets/bubble_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/bubble_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/bubble_chat_builders.dart';

void main() {
  const style = BubbleChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
    maxWidth: 260,
  );

  Widget host(Conversation conversation, BubbleChatBuilders builders) {
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

  testWidgets('sent message aligns to centerRight, received to centerLeft', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'user', text: 'hi'),
        TimelineItem.text(id: 'm2', kind: ChatMessageKind.text, role: 'assistant', text: 'hello'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    final sentAlign = tester.widget<Align>(find.ancestor(of: find.text('hi'), matching: find.byType(Align)).first);
    final receivedAlign = tester.widget<Align>(find.ancestor(of: find.text('hello'), matching: find.byType(Align)).first);
    expect(sentAlign.alignment, Alignment.centerRight);
    expect(receivedAlign.alignment, Alignment.centerLeft);
  });

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = BubbleChatBuilders(
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

  testWidgets('elicitation builder fires onElicitationRespond', (tester) async {
    String? gotRequestId;
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (requestId, response) => gotRequestId = requestId,
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(requestId: 'e1', message: 'Pick one', mode: 'url', url: 'https://example.com'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    expect(gotRequestId, 'e1');
  });

  testWidgets('toolCallBuilder renders a diff summary when diffs are present', (tester) async {
    final builders = BubbleChatBuilders(
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

  testWidgets('reasoning messages render with reasoningTextStyle', (tester) async {
    // `chatMarkdownBody` renders into a `MarkdownBody` widget whose
    // `styleSheet.p` carries the paragraph style — inspect that directly
    // rather than the plain text, since reasoning styling flows through
    // the markdown style sheet, not a `Text` widget.
    const reasoningStyle = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(fontSize: 14),
      maxWidth: 260,
      reasoningTextStyle: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.orange),
    );
    final builders = BubbleChatBuilders(
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
    final builders = BubbleChatBuilders(
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

  testWidgets('toolCallBuilder dispatches to a registered toolCallOverrides entry', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
        toolCallOverrides: {'edit_file': (context, message) => const Text('CUSTOM TOOL CALL')},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [TimelineItem.toolCall(id: 't1', name: 'edit_file')]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('CUSTOM TOOL CALL'), findsOneWidget);
  });
}
