// test/widgets/diff_lines_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/diff_lines_view.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows path + added/removed counts, collapsed by default', (tester) async {
    await tester.pumpWidget(host(const DiffLinesView(
      path: 'lib/foo.dart',
      oldText: 'a\nb\n',
      newText: 'a\nx\n',
      textStyle: TextStyle(),
      addedColor: Colors.green,
      removedColor: Colors.red,
    )));
    expect(find.textContaining('lib/foo.dart'), findsOneWidget);
    expect(find.textContaining('+1'), findsOneWidget);
    expect(find.textContaining('-1'), findsOneWidget);
    expect(find.text('x'), findsNothing);
  });

  testWidgets('new-file diff (empty oldText) shows "new file" not counts', (tester) async {
    await tester.pumpWidget(host(const DiffLinesView(
      path: 'lib/new.dart',
      oldText: '',
      newText: 'a\n',
      textStyle: TextStyle(),
      addedColor: Colors.green,
      removedColor: Colors.red,
    )));
    expect(find.textContaining('new file'), findsOneWidget);
  });

  testWidgets('tapping the summary expands the full diff body', (tester) async {
    await tester.pumpWidget(host(const DiffLinesView(
      path: 'lib/foo.dart',
      oldText: 'a\nb\n',
      newText: 'a\nx\n',
      textStyle: TextStyle(),
      addedColor: Colors.green,
      removedColor: Colors.red,
    )));
    expect(find.textContaining('+ x'), findsNothing);
    await tester.tap(find.textContaining('lib/foo.dart'));
    await tester.pumpAndSettle();
    expect(find.textContaining('+ x'), findsOneWidget);
    expect(find.textContaining('- b'), findsOneWidget);
  });
}
