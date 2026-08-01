// lib/src/widgets/streaming_markdown_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;

import 'markdown_body.dart';

/// Renders a [chat_stream.StreamState] via [chatMarkdownBody] instead of
/// `flyer_chat_text_stream_message`'s own `FlyerChatTextStreamMessage`
/// widget (specifically its `TextStreamMessageMode.instantMarkdown` mode,
/// which renders via a different package, `gpt_markdown`) — so a message
/// still streaming in renders through the EXACT SAME markdown call as the
/// completed-message view (`chatMarkdownBody`,
/// `flutter_markdown_plus`-based), instead of two different renderers with
/// no guarantee of matching styling. Opt-in via
/// `StackedChatStyle.markdownWhileStreaming`/
/// `BubbleChatStyle.markdownWhileStreaming` (both default `false` — zero
/// behavior change for existing callers unless they turn it on); shared by
/// both builder families rather than duplicating this switch in each.
///
/// Handles empty-`accumulatedText` (a genuinely-open question: an empty
/// [chat_stream.StreamStateStreaming], not a [chat_stream.StreamStateLoading],
/// is how a real turn's very first moment actually looks — confirmed via
/// `ag_ui_widgets_flutter`'s own `streamStatesFromTimeline`, which
/// unconditionally maps every still-open text item to
/// `StreamStateStreaming(text)`, empty or not) the same as genuine loading,
/// rather than rendering an empty markdown body and silently showing
/// nothing.
Widget buildStreamingMarkdownContent(
  BuildContext context,
  chat_stream.StreamState streamState, {
  required TextStyle? paragraphStyle,
  MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder,
  Widget Function(BuildContext context, TextStyle? paragraphStyle)? loadingBuilder,
}) {
  Widget loading() =>
      loadingBuilder?.call(context, paragraphStyle) ??
      Text(
        '...',
        style: paragraphStyle?.copyWith(
          color: paragraphStyle.color?.withValues(alpha: 0.5),
        ),
      );

  return switch (streamState) {
    chat_stream.StreamStateLoading() => loading(),
    chat_stream.StreamStateStreaming(:final accumulatedText) => accumulatedText.isEmpty
        ? loading()
        : chatMarkdownBody(context, accumulatedText, styleSheetBuilder: styleSheetBuilder),
    chat_stream.StreamStateCompleted(:final finalText) =>
      chatMarkdownBody(context, finalText, styleSheetBuilder: styleSheetBuilder),
    chat_stream.StreamStateError(:final accumulatedText, :final error) => chatMarkdownBody(
        context,
        '${accumulatedText ?? ''}\n\nError: $error',
        styleSheetBuilder: styleSheetBuilder,
      ),
  };
}
