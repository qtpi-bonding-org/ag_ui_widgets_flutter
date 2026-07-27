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
  }) = _StackedChatStyle;
}
