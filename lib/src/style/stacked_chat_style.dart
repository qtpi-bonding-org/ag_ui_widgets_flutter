// lib/src/style/stacked_chat_style.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stacked_chat_style.freezed.dart';

/// Visual configuration for [StackedChatBuilders] (full-width,
/// vertically-alternating message layout). Raw Flutter types only — no
/// app-specific theming types, so this package stays app-agnostic.
@freezed
abstract class StackedChatStyle with _$StackedChatStyle {
  const factory StackedChatStyle({
    required Color sentBackground,
    required Color receivedBackground,
    required TextStyle textStyle,
    Widget Function(BuildContext)? aiLeadingIconBuilder,
    @Default(EdgeInsets.symmetric(vertical: 8, horizontal: 12)) EdgeInsets padding,
    Color? cardBorderColor,
    @Default(BorderRadius.all(Radius.circular(8))) BorderRadius cardRadius,
    @Default(Color(0xFF2E7D32)) Color diffAddedColor,
    @Default(Color(0xFFC62828)) Color diffRemovedColor,
    MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
    TextStyle? reasoningTextStyle,
    Widget Function(BuildContext context, {required String role, required bool isSentByMe, required bool isReasoning})? roleHeaderBuilder,
    // Opt-in — default false, zero behavior change unless set. When true,
    // StackedChatBuilders.textStreamMessageBuilder renders the streaming
    // message through chatMarkdownBody (flutter_markdown_plus) directly
    // instead of FlyerChatTextStreamMessage, so it renders through the
    // exact same call the completed-message view uses — see
    // streaming_markdown_content.dart's doc comment for the full
    // rationale (this was built to fix a real observed inconsistency
    // between "streaming" and "just finished" styling in episutra, one of
    // this package's consumers).
    @Default(false) bool markdownWhileStreaming,
    // Only consulted when markdownWhileStreaming is true. Null falls back
    // to a plain low-opacity '...' placeholder — callers wanting a
    // product-specific loading treatment (e.g. episutra's own animated
    // dots) provide their own here instead of writing a full custom
    // textStreamMessageBuilder from scratch.
    Widget Function(BuildContext context, TextStyle? paragraphStyle)? streamingLoadingBuilder,
  }) = _StackedChatStyle;
}
