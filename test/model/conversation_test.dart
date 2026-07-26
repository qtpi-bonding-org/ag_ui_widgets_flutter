import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';

void main() {
  test('Conversation.empty has no timeline items and idle SessionState', () {
    expect(Conversation.empty.timeline, isEmpty);
    expect(Conversation.empty.sessionState.isRunning, isFalse);
    expect(Conversation.empty.sessionState.runError, isNull);
  });

  test('TextTimelineItem carries kind/role/text', () {
    const item = TimelineItem.text(
      id: 'm1',
      kind: ChatMessageKind.text,
      role: 'assistant',
      text: 'hi',
    );
    expect(item, isA<TextTimelineItem>());
    expect((item as TextTimelineItem).text, 'hi');
  });

  test('PermissionRequestTimelineItem allows null toolTitle/toolKind/description', () {
    const item = TimelineItem.permissionRequest(
      requestId: 'p1',
      options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
    );
    expect(item, isA<PermissionRequestTimelineItem>());
    final p = item as PermissionRequestTimelineItem;
    expect(p.toolTitle, isNull);
    expect(p.toolKind, isNull);
    expect(p.description, isNull);
    expect(p.options.single.optionId, 'allow');
  });

  test('ElicitationRequestTimelineItem carries message/mode/schema/url', () {
    const item = TimelineItem.elicitationRequest(
      requestId: 'e1',
      message: 'Enter a value',
      mode: 'form',
      schema: {'type': 'object'},
    );
    final e = item as ElicitationRequestTimelineItem;
    expect(e.message, 'Enter a value');
    expect(e.mode, 'form');
    expect(e.schema, {'type': 'object'});
    expect(e.url, isNull);
  });

  test('ToolRequestTimelineItem requires requestId, toolName, argsJson; toolTitle/toolKind stay nullable', () {
    const item = TimelineItem.toolRequest(requestId: 't1', toolName: 'propose_edit', argsJson: '{}');
    final t = item as ToolRequestTimelineItem;
    expect(t.toolName, 'propose_edit');
    expect(t.toolTitle, isNull);
    expect(t.argsJson, '{}');
  });
}