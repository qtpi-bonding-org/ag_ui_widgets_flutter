// lib/src/model/diff_stats.dart
import 'package:diff_match_patch/diff_match_patch.dart' as dmp;

/// Kind of one line in a computed diff — used to color/prefix it when
/// rendered (see [DiffLinesView] in `widgets/diff_lines_view.dart`).
enum DiffLineKind { added, removed, context }

/// One line of a computed diff, tagged with how it changed.
class DiffLine {
  const DiffLine(this.text, this.kind);
  final String text;
  final DiffLineKind kind;
}

/// Aggregate stats + full line-by-line breakdown for one diff hunk.
class DiffStats {
  const DiffStats({required this.added, required this.removed, required this.lines});
  final int added;
  final int removed;
  final List<DiffLine> lines;
}

/// Computes a git-style, line-granularity diff between [oldText] and
/// [newText]. `diff_match_patch`'s `diff()` is character-level; this encodes
/// each unique line as a single unicode character first so the underlying
/// diff operates on whole lines, then decodes the result back to text.
DiffStats computeDiffStats(String oldText, String newText) {
  List<String> toLines(String text) {
    if (text.isEmpty) return const <String>[];
    final split = text.split('\n');
    if (split.isNotEmpty && split.last.isEmpty) split.removeLast();
    return split;
  }

  final oldLines = toLines(oldText);
  final newLines = toLines(newText);

  final lineToChar = <String, String>{};
  String encode(List<String> lines) {
    final buffer = StringBuffer();
    for (final line in lines) {
      final code = lineToChar.putIfAbsent(line, () => String.fromCharCode(lineToChar.length));
      buffer.write(code);
    }
    return buffer.toString();
  }

  final oldEncoded = encode(oldLines);
  final newEncoded = encode(newLines);
  final charToLine = {for (final entry in lineToChar.entries) entry.value: entry.key};

  final rawDiffs = dmp.diff(oldEncoded, newEncoded, checklines: false);

  var added = 0;
  var removed = 0;
  final lines = <DiffLine>[];
  for (final d in rawDiffs) {
    final kind = switch (d.operation) {
      dmp.DIFF_INSERT => DiffLineKind.added,
      dmp.DIFF_DELETE => DiffLineKind.removed,
      _ => DiffLineKind.context,
    };
    for (final code in d.text.split('')) {
      final line = charToLine[code] ?? '';
      lines.add(DiffLine(line, kind));
      if (kind == DiffLineKind.added) added++;
      if (kind == DiffLineKind.removed) removed++;
    }
  }
  return DiffStats(added: added, removed: removed, lines: lines);
}
