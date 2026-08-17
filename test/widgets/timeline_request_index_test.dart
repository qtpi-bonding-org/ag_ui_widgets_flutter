import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/timeline_request_index.dart';

void main() {
  test('indexes all three request kinds by requestId', () {
    final timeline = <TimelineItem>[
      const TimelineItem.text(
        id: 't1',
        kind: ChatMessageKind.text,
        role: 'user',
        text: 'hi',
        order: OrderKey(0),
      ),
      const TimelineItem.permissionRequest(
        requestId: 'p1',
        options: <PermissionOption>[],
        order: OrderKey(1),
      ),
      const TimelineItem.elicitationRequest(
        requestId: 'e1',
        message: 'confirm?',
        mode: 'form',
        order: OrderKey(2),
      ),
      const TimelineItem.toolRequest(
        requestId: 'r1',
        toolName: 'read',
        argsJson: '{}',
        order: OrderKey(3),
      ),
    ];

    final index = timelineRequestIndex(timeline);

    expect(index.keys.toSet(), {'p1', 'e1', 'r1'});
    expect(index['p1'], isA<PermissionRequestTimelineItem>());
    expect(index['e1'], isA<ElicitationRequestTimelineItem>());
    expect(index['r1'], isA<ToolRequestTimelineItem>());
  });

  test('ignores non-request items and returns an empty map for none', () {
    final timeline = <TimelineItem>[
      const TimelineItem.toolCall(id: 'c1', name: 'bash', order: OrderKey(0)),
    ];
    expect(timelineRequestIndex(timeline), isEmpty);
  });
}
