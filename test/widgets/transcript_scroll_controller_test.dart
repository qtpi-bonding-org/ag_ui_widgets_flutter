import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/transcript_scroll_controller.dart';

/// Harness: a list whose item count grows via setState, which is the same
/// shape as a streaming rebuild (and, per the spec, the shape that never
/// dispatches ScrollMetricsNotification).
class _Harness extends StatefulWidget {
  const _Harness({required this.policy});
  final TranscriptScrollController policy;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  // MUST overflow the viewport. The default test surface is 800x600, so at
  // 200px per item anything under 4 items gives maxScrollExtent == 0 — the
  // list is unscrollable, every position reads as "at the end", and the
  // disarm tests would pass or fail for entirely the wrong reason.
  int _count = 8;

  void grow(int by) => setState(() => _count += by);

  @override
  Widget build(BuildContext context) {
    widget.policy.scheduleStick();
    return MaterialApp(
      home: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            widget.policy.handleNotification(n);
            return false;
          },
          child: ListView.builder(
            controller: widget.policy.controller,
            itemCount: _count,
            itemBuilder: (_, i) => SizedBox(height: 200, child: Text('item $i')),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('sticks to the end when content grows while armed',
      (tester) async {
    final policy = TranscriptScrollController();
    addTearDown(policy.dispose);

    await tester.pumpWidget(_Harness(policy: policy));
    await tester.pumpAndSettle();

    final state = tester.state<_HarnessState>(find.byType(_Harness));
    state.grow(10);
    await tester.pumpAndSettle();

    final position = policy.controller.position;
    expect(position.pixels, moreOrLessEquals(position.maxScrollExtent, epsilon: 1));
  });

  testWidgets('does not scroll after the user drags away from the end',
      (tester) async {
    final policy = TranscriptScrollController();
    addTearDown(policy.dispose);

    await tester.pumpWidget(_Harness(policy: policy));
    await tester.pumpAndSettle();

    // Drag downward (finger down = content moves down = scroll toward start).
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(policy.isArmed, isFalse);

    final before = policy.controller.position.pixels;
    tester.state<_HarnessState>(find.byType(_Harness)).grow(10);
    await tester.pumpAndSettle();

    expect(policy.controller.position.pixels, before);
  });

  testWidgets('rearm() restores following', (tester) async {
    final policy = TranscriptScrollController();
    addTearDown(policy.dispose);

    await tester.pumpWidget(_Harness(policy: policy));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(policy.isArmed, isFalse);

    policy.rearm();
    tester.state<_HarnessState>(find.byType(_Harness)).grow(10);
    await tester.pumpAndSettle();

    final position = policy.controller.position;
    expect(position.pixels, moreOrLessEquals(position.maxScrollExtent, epsilon: 1));
  });

  testWidgets('scrolling back to the end rearms automatically',
      (tester) async {
    final policy = TranscriptScrollController();
    addTearDown(policy.dispose);

    await tester.pumpWidget(_Harness(policy: policy));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(policy.isArmed, isFalse);

    policy.controller.jumpTo(policy.controller.position.maxScrollExtent);
    await tester.pumpAndSettle();

    expect(policy.isArmed, isTrue);
  });
}
