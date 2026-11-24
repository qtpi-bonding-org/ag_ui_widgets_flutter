// lib/src/widgets/markdown_body.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

import 'card_builders.dart';
import 'transcript_selection.dart';

/// Renders [text] as GFM markdown, shared by every builder family's
/// text-message rendering. `selectable: false`: selection comes from the
/// transcript's own `SelectionArea`, so it can span paragraphs and messages.
/// A [copyButtonBuilder] adds a copy control to every code block.
Widget chatMarkdownBody(
  BuildContext context,
  String text, {
  MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder,
  CopyButtonBuilder? copyButtonBuilder,
  String messageId = '',
}) {
  final styleSheet =
      styleSheetBuilder?.call(context) ?? markdownStyleSheetFromTheme(Theme.of(context));
  return MarkdownBody(
    data: text,
    selectable: false,
    styleSheet: styleSheet,
    builders: {
      if (copyButtonBuilder != null) 'pre': _CodeBlockBuilder(styleSheet, copyButtonBuilder, messageId),
    },
  );
}

class _CodeBlockBuilder extends MarkdownElementBuilder {
  _CodeBlockBuilder(this.styleSheet, this.copyButtonBuilder, this.messageId);

  final MarkdownStyleSheet styleSheet;
  final CopyButtonBuilder copyButtonBuilder;
  final String messageId;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final code = element.textContent.replaceFirst(RegExp(r'\n$'), '');
    if (code.trim().isEmpty) return _CodeScroll(styleSheet: styleSheet, code: code);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _CodeScroll(styleSheet: styleSheet, code: code)),
        TranscriptControl(
          child: copyButtonBuilder(
            context,
            code,
            id: '$messageId.${code.hashCode}',
            isCode: true,
          ),
        ),
      ],
    );
  }
}

class _CodeScroll extends StatefulWidget {
  const _CodeScroll({required this.styleSheet, required this.code});

  final MarkdownStyleSheet styleSheet;
  final String code;

  @override
  State<_CodeScroll> createState() => _CodeScrollState();
}

class _CodeScrollState extends State<_CodeScroll> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: widget.styleSheet.codeblockPadding,
          child: Text(widget.code, style: widget.styleSheet.code),
        ),
      );
}

/// Same values as [MarkdownStyleSheet.fromTheme], from a material_ui
/// [ThemeData]. flutter_markdown_plus 1.0.12 still takes the theme type from
/// `package:flutter/material.dart`, which is a different class. Delete this
/// when it moves to material_ui.
MarkdownStyleSheet markdownStyleSheetFromTheme(ThemeData theme) {
  assert(theme.textTheme.bodyMedium?.fontSize != null);
  return MarkdownStyleSheet(
    a: const TextStyle(color: Colors.blue),
    p: theme.textTheme.bodyMedium,
    pPadding: EdgeInsets.zero,
    code: theme.textTheme.bodyMedium!.copyWith(
      backgroundColor: theme.cardTheme.color,
      fontFamily: 'monospace',
      fontSize: theme.textTheme.bodyMedium!.fontSize! * 0.85,
    ),
    h1: theme.textTheme.headlineSmall,
    h1Padding: EdgeInsets.zero,
    h2: theme.textTheme.titleLarge,
    h2Padding: EdgeInsets.zero,
    h3: theme.textTheme.titleMedium,
    h3Padding: EdgeInsets.zero,
    h4: theme.textTheme.bodyLarge,
    h4Padding: EdgeInsets.zero,
    h5: theme.textTheme.bodyLarge,
    h5Padding: EdgeInsets.zero,
    h6: theme.textTheme.bodyLarge,
    h6Padding: EdgeInsets.zero,
    em: const TextStyle(fontStyle: FontStyle.italic),
    strong: const TextStyle(fontWeight: FontWeight.bold),
    del: const TextStyle(decoration: TextDecoration.lineThrough),
    blockquote: theme.textTheme.bodyMedium,
    img: theme.textTheme.bodyMedium,
    checkbox: theme.textTheme.bodyMedium!.copyWith(
      color: theme.primaryColor,
    ),
    blockSpacing: 8.0,
    listIndent: 24.0,
    listBullet: theme.textTheme.bodyMedium,
    listBulletPadding: const EdgeInsets.only(right: 4),
    tableHead: const TextStyle(fontWeight: FontWeight.w600),
    tableBody: theme.textTheme.bodyMedium,
    tableHeadAlign: TextAlign.center,
    tablePadding: const EdgeInsets.only(bottom: 4.0),
    tableBorder: TableBorder.all(
      color: theme.dividerColor,
    ),
    tableColumnWidth: const FlexColumnWidth(),
    tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    tableCellsDecoration: const BoxDecoration(),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    blockquoteDecoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(3),
      border: Border(
        left: BorderSide(
          color: theme.colorScheme.primary,
          width: 3,
        ),
      ),
    ),
    codeblockPadding: const EdgeInsets.all(8.0),
    codeblockDecoration: BoxDecoration(
      color: theme.cardTheme.color ?? theme.cardColor,
      borderRadius: BorderRadius.circular(2.0),
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          width: 5.0,
          color: theme.dividerColor,
        ),
      ),
    ),
  );
}
