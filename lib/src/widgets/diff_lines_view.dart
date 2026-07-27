// lib/src/widgets/diff_lines_view.dart
import 'package:flutter/material.dart';
import '../model/diff_stats.dart';

const int kDiffLineCap = 300;

/// Renders one tool-call diff hunk: a tappable "path (+N -M)" summary line
/// that expands to the full line-by-line diff. Colors/font come from the
/// caller's style object so this stays app-agnostic — see
/// `StackedChatStyle.diffAddedColor`/`.diffRemovedColor`.
class DiffLinesView extends StatefulWidget {
  const DiffLinesView({
    super.key,
    required this.path,
    required this.oldText,
    required this.newText,
    required this.textStyle,
    required this.addedColor,
    required this.removedColor,
  });

  final String path;
  final String oldText;
  final String newText;
  final TextStyle textStyle;
  final Color addedColor;
  final Color removedColor;

  @override
  State<DiffLinesView> createState() => _DiffLinesViewState();
}

class _DiffLinesViewState extends State<DiffLinesView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isNewFile = widget.oldText.isEmpty;
    final stats = computeDiffStats(widget.oldText, widget.newText);
    final label =
        isNewFile ? '${widget.path} (new file)' : '${widget.path} (+${stats.added} -${stats.removed})';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 14, color: widget.textStyle.color),
              const SizedBox(width: 4),
              Expanded(child: Text(label, style: widget.textStyle)),
            ],
          ),
        ),
        if (_expanded)
          _DiffBody(
            lines: stats.lines,
            textStyle: widget.textStyle,
            addedColor: widget.addedColor,
            removedColor: widget.removedColor,
          ),
      ],
    );
  }
}

class _DiffBody extends StatelessWidget {
  const _DiffBody({
    required this.lines,
    required this.textStyle,
    required this.addedColor,
    required this.removedColor,
  });

  final List<DiffLine> lines;
  final TextStyle textStyle;
  final Color addedColor;
  final Color removedColor;

  @override
  Widget build(BuildContext context) {
    final capped = lines.length > kDiffLineCap ? lines.sublist(0, kDiffLineCap) : lines;
    final omitted = lines.length - capped.length;

    Color colorFor(DiffLineKind kind) => switch (kind) {
          DiffLineKind.added => addedColor,
          DiffLineKind.removed => removedColor,
          DiffLineKind.context => textStyle.color?.withValues(alpha: 0.7) ?? const Color(0x99000000),
        };
    String prefixFor(DiffLineKind kind) => switch (kind) {
          DiffLineKind.added => '+ ',
          DiffLineKind.removed => '- ',
          DiffLineKind.context => '  ',
        };

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in capped)
            Text('${prefixFor(line.kind)}${line.text}', style: textStyle.copyWith(color: colorFor(line.kind))),
          if (omitted > 0)
            Text(
              '… $omitted more lines omitted',
              style: textStyle.copyWith(color: textStyle.color?.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }
}
