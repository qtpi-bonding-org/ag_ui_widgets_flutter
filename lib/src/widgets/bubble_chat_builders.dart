// lib/src/widgets/bubble_chat_builders.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import '../model/conversation.dart';
import '../style/bubble_chat_style.dart';
import '../style/chat_action_callbacks.dart';
import 'ag_ui_chat.dart' show CustomCardBuilder;
import 'chat_action_cards.dart';
import 'markdown_body.dart';

/// Aligned, max-width-constrained bubble builder family for [AgUiChat]'s
/// five builder slots. Sent messages align right, received align left.
class BubbleChatBuilders {
  BubbleChatBuilders(this.style, this.callbacks);

  final BubbleChatStyle style;
  final ChatActionCallbacks callbacks;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: style.receivedBackground,
        border: style.receivedBorder != null ? Border.all(color: style.receivedBorder!) : null,
        borderRadius: style.receivedRadius,
      );

  chat_core.TextMessageBuilder get textMessageBuilder =>
      (context, message, index, {required isSentByMe, groupStatus}) {
        return Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: style.maxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: style.padding,
              decoration: BoxDecoration(
                color: isSentByMe ? style.sentBackground : style.receivedBackground,
                border: (isSentByMe ? style.sentBorder : style.receivedBorder) != null
                    ? Border.all(color: (isSentByMe ? style.sentBorder : style.receivedBorder)!)
                    : null,
                borderRadius: isSentByMe ? style.sentRadius : style.receivedRadius,
              ),
              child: chatMarkdownBody(context, message.text, styleSheetBuilder: style.markdownStyleSheetBuilder),
            ),
          ),
        );
      };

  CustomCardBuilder get toolCallBuilder => (context, message, index, {required isSentByMe, groupStatus}) {
        final name = message.metadata?['name'] as String? ?? '';
        final result = message.metadata?['result'] as String?;
        final diffs = (message.metadata?['diffs'] as List<dynamic>?) ?? const [];
        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: style.maxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            ),
          ),
        );
      };

  /// Wraps card content the same way [toolCallBuilder] wraps its own
  /// output — Align(left) + maxWidth constraint — so permission/
  /// elicitation/toolRequest cards stay visually consistent with the
  /// rest of this bubble-family's width-constrained shells. There's no
  /// `isSentByMe` here (AgUiChat's permission/elicitation/toolRequest
  /// slots don't receive it), so these always align left, matching
  /// toolCallBuilder.
  Widget _leftAlignedBubble(Widget child) => Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: style.maxWidth),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: child),
        ),
      );

  Widget Function(BuildContext, TimelineItem) get permissionBuilder => (context, item) {
        final permission = item as PermissionRequestTimelineItem;
        return _leftAlignedBubble(buildPermissionCardContent(
          context, permission,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onSelect: callbacks.onPermissionOptionSelected,
        ));
      };

  Widget Function(BuildContext, TimelineItem) get elicitationBuilder => (context, item) {
        final elicitation = item as ElicitationRequestTimelineItem;
        return _leftAlignedBubble(buildElicitationCardContent(
          context, elicitation,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onRespond: callbacks.onElicitationRespond,
        ));
      };

  Widget Function(BuildContext, TimelineItem) get toolRequestBuilder => (context, item) {
        final toolRequest = item as ToolRequestTimelineItem;
        return _leftAlignedBubble(buildToolRequestCardContent(
          context, toolRequest,
          decoration: _cardDecoration, textStyle: style.textStyle,
          overrides: callbacks.toolRequestOverrides,
        ));
      };
}
