// test/model/diff_stats_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/diff_stats.dart';

void main() {
  test('identical text produces no added/removed lines', () {
    final stats = computeDiffStats('a\nb\n', 'a\nb\n');
    expect(stats.added, 0);
    expect(stats.removed, 0);
  });

  test('counts added and removed lines separately', () {
    final stats = computeDiffStats('a\nb\nc\n', 'a\nx\nc\n');
    expect(stats.removed, 1);
    expect(stats.added, 1);
  });

  test('new-file diff (empty oldText) counts every line as added', () {
    final stats = computeDiffStats('', 'a\nb\n');
    expect(stats.added, 2);
    expect(stats.removed, 0);
  });
}
