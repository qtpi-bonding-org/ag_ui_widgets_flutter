// lib/src/widgets/stacked_chat_builders.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;
import '../model/conversation.dart';
import '../style/chat_action_callbacks.dart';
import '../style/stacked_chat_style.dart';
import 'ag_ui_chat.dart' show CustomCardBuilder, TextStreamCardBuilder;
import 'chat_action_cards.dart';
import 'markdown_body.dart';

/// Full-width, vertically-alternating builder family for [AgUiChat]'s
/// five builder slots. Sender is differentiated by background tint and
/// an optional leading icon — no left/right alignment.
class StackedChatBuilders {
  StackedChatBuilders(this.style, this.callbacks);

  final StackedChatStyle style;
  final ChatActionCallbacks callbacks;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: style.receivedBackground,
        border: style.cardBorderColor != null ? Border.all(color: style.cardBorderColor!) : null,
        borderRadius: style.cardRadius,
      );

  chat_core.TextMessageBuilder get textMessageBuilder =>
      (context, message, index, {required isSentByMe, groupStatus}) {
        final isReasoning = message.metadata?['kind'] == 'reasoning';
        final role = message.metadata?['role'] as String? ?? (isSentByMe ? 'user' : 'assistant');
        final effectiveStyle = isReasoning
            ? (style.reasoningTextStyle ?? style.textStyle.copyWith(fontStyle: FontStyle.italic))
            : style.textStyle;
        final styleSheetBuilder = style.markdownStyleSheetBuilder ??
            (isReasoning
                ? (ctx) => MarkdownStyleSheet.fromTheme(Theme.of(ctx)).copyWith(p: effectiveStyle)
                : null);
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: style.padding,
          color: isSentByMe ? style.sentBackground : style.receivedBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (style.roleHeaderBuilder != null)
                style.roleHeaderBuilder!(context, role: role, isSentByMe: isSentByMe, isReasoning: isReasoning),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSentByMe && style.aiLeadingIconBuilder != null) ...[
                    style.aiLeadingIconBuilder!(context),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: chatMarkdownBody(
                      context,
                      message.text,
                      styleSheetBuilder: styleSheetBuilder,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      };

  TextStreamCardBuilder get textStreamMessageBuilder =>
      (context, message, index, {required isSentByMe, groupStatus, required streamState}) {
        final role = message.metadata?['role'] as String? ?? (isSentByMe ? 'user' : 'assistant');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (style.roleHeaderBuilder != null)
              style.roleHeaderBuilder!(context, role: role, isSentByMe: isSentByMe, isReasoning: false),
            chat_stream.FlyerChatTextStreamMessage(
              message: message,
              index: index,
              streamState: streamState,
              sentTextStyle: style.textStyle,
              receivedTextStyle: style.textStyle,
            ),
          ],
        );
      };

  CustomCardBuilder get toolCallBuilder => (context, message, index, {required isSentByMe, groupStatus}) {
        final name = message.metadata?['name'] as String? ?? '';
        final override = callbacks.toolCallOverrides[name];
        if (override != null) return override(context, message);
        final result = message.metadata?['result'] as String?;
        final diffs = (message.metadata?['diffs'] as List<dynamic>?) ?? const [];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: buildToolCallCardContent(
            context,
            name: name,
            result: result,
            diffs: diffs,
            decoration: _cardDecoration,
            textStyle: style.textStyle,
            diffAddedColor: style.diffAddedColor,
            diffRemovedColor: style.diffRemovedColor,
          ),
        );
      };

  Widget Function(BuildContext, TimelineItem) get permissionBuilder => (context, item) {
        final permission = item as PermissionRequestTimelineItem;
        final override = callbacks.permissionCardBuilder;
        if (override != null) return override(context, permission);
        return buildPermissionCardContent(
          context, permission,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onSelect: callbacks.onPermissionOptionSelected,
        );
      };

  Widget Function(BuildContext, TimelineItem) get elicitationBuilder => (context, item) {
        final elicitation = item as ElicitationRequestTimelineItem;
        final override = callbacks.elicitationCardBuilder;
        if (override != null) return override(context, elicitation);
        return buildElicitationCardContent(
          context, elicitation,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onRespond: callbacks.onElicitationRespond,
        );
      };

  Widget Function(BuildContext, TimelineItem) get toolRequestBuilder => (context, item) {
        final toolRequest = item as ToolRequestTimelineItem;
        return buildToolRequestCardContent(
          context, toolRequest,
          decoration: _cardDecoration, textStyle: style.textStyle,
          overrides: callbacks.toolRequestOverrides,
        );
      };
}
