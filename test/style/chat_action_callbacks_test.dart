// test/style/chat_action_callbacks_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';

void main() {
  test('defaults toolRequestOverrides to an empty map', () {
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
    );
    expect(callbacks.toolRequestOverrides, isEmpty);
  });

  test('onPermissionOptionSelected is invoked with the given args', () {
    String? gotRequestId;
    String? gotOptionId;
    bool? gotCancelled;
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (requestId, {optionId, cancelled = false}) {
        gotRequestId = requestId;
        gotOptionId = optionId;
        gotCancelled = cancelled;
      },
      onElicitationRespond: (_, __) {},
    );
    callbacks.onPermissionOptionSelected('p1', optionId: 'allow');
    expect(gotRequestId, 'p1');
    expect(gotOptionId, 'allow');
    expect(gotCancelled, false);
  });

  test('toolRequestOverrides dispatches by toolName', () {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'render_surface', argsJson: '{}');
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
      toolRequestOverrides: {
        'render_surface': (context, item) => const Text('SURFACE'),
      },
    );
    expect(callbacks.toolRequestOverrides['render_surface'], isNotNull);
    expect(callbacks.toolRequestOverrides[item.toolName], isNotNull);
    expect(callbacks.toolRequestOverrides['other_tool'], isNull);
  });
}