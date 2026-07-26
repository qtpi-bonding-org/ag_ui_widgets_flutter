// lib/src/widgets/markdown_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// Renders [text] as GFM markdown, shared by every builder family's
/// text-message rendering. `selectable: false` matches plain-`Text`
/// behavior (chat bubbles aren't currently selectable anywhere this
/// package is consumed) — revisit only if a future spec asks for
/// text selection.
Widget chatMarkdownBody(
  BuildContext context,
  String text, {
  MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder,
}) {
  return MarkdownBody(
    data: text,
    selectable: false,
    styleSheet: styleSheetBuilder?.call(context) ?? MarkdownStyleSheet.fromTheme(Theme.of(context)),
  );
}
