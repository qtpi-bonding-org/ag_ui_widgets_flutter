// lib/src/style/bubble_chat_style.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bubble_chat_style.freezed.dart';

/// Visual configuration for [BubbleChatBuilders] (aligned,
/// max-width-constrained bubbles). Raw Flutter types only.
@freezed
abstract class BubbleChatStyle with _$BubbleChatStyle {
  const factory BubbleChatStyle({
    required Color sentBackground,
    required Color receivedBackground,
    Color? sentBorder,
    Color? receivedBorder,
    required TextStyle textStyle,
    required double maxWidth,
    @Default(BorderRadius.all(Radius.circular(12))) BorderRadius sentRadius,
    @Default(BorderRadius.all(Radius.circular(12))) BorderRadius receivedRadius,
    @Default(EdgeInsets.symmetric(vertical: 8, horizontal: 12)) EdgeInsets padding,
    @Default(Color(0xFF2E7D32)) Color diffAddedColor,
    @Default(Color(0xFFC62828)) Color diffRemovedColor,
    MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
    TextStyle? reasoningTextStyle,
    Widget Function(BuildContext context, {required String role, required bool isSentByMe, required bool isReasoning})? roleHeaderBuilder,
    // See StackedChatStyle.markdownWhileStreaming's doc comment — same
    // opt-in, same rationale, mirrored here for BubbleChatBuilders.
    @Default(false) bool markdownWhileStreaming,
    // See StackedChatStyle.streamingLoadingBuilder's doc comment.
    Widget Function(BuildContext context, TextStyle? paragraphStyle)? streamingLoadingBuilder,
  }) = _BubbleChatStyle;
}
