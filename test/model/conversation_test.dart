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
      order: OrderKey(0),
    );
    expect(item, isA<TextTimelineItem>());
    expect((item as TextTimelineItem).text, 'hi');
  });

  test('PermissionRequestTimelineItem allows null toolTitle/toolKind/description', () {
    const item = TimelineItem.permissionRequest(
      requestId: 'p1',
      options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
      order: OrderKey(1),
    );
    expect(item, isA<PermissionRequestTimelineItem>());
    const p = item as PermissionRequestTimelineItem;
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
      order: OrderKey(2),
    );
    const e = item as ElicitationRequestTimelineItem;
    expect(e.message, 'Enter a value');
    expect(e.mode, 'form');
    expect(e.schema, {'type': 'object'});
    expect(e.url, isNull);
  });

  test('ToolRequestTimelineItem requires requestId, toolName, argsJson; toolTitle/toolKind stay nullable', () {
    const item = TimelineItem.toolRequest(
      requestId: 't1',
      toolName: 'propose_edit',
      argsJson: '{}',
      order: OrderKey(3),
    );
    const t = item as ToolRequestTimelineItem;
    expect(t.toolName, 'propose_edit');
    expect(t.toolTitle, isNull);
    expect(t.argsJson, '{}');
  });

  group('OrderKey', () {
    test('compareTo orders by seq first, then sub', () {
      const a = OrderKey(1, 0);
      const b = OrderKey(1, 1);
      const c = OrderKey(2, 0);

      expect(a.compareTo(b), lessThan(0));
      expect(b.compareTo(a), greaterThan(0));
      expect(a.compareTo(c), lessThan(0));
      expect(c.compareTo(a), greaterThan(0));
      expect(a.compareTo(a), 0);
    });

    test('equality and hashCode match by seq and sub', () {
      const a = OrderKey(5, 3);
      const b = OrderKey(5, 3);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('default sub is 0', () {
      const a = OrderKey(7);
      const b = OrderKey(7, 0);
      expect(a, equals(b));
    });
  });

  group('TimelineItem.itemId', () {
    test('returns id for TextTimelineItem', () {
      const item = TimelineItem.text(
        id: 'msg-42',
        kind: ChatMessageKind.text,
        role: 'assistant',
        text: 'hello',
        order: OrderKey(0),
      );
      expect(item.itemId, 'msg-42');
    });

    test('returns requestId for PermissionRequestTimelineItem', () {
      const item = TimelineItem.permissionRequest(
        requestId: 'perm-99',
        options: [],
        order: OrderKey(1),
      );
      expect(item.itemId, 'perm-99');
    });
  });

  group('TimelineItem.storageKey', () {
    test('identical to itemId for most variants', () {
      const text = TimelineItem.text(
        id: 'm1',
        kind: ChatMessageKind.text,
        role: 'assistant',
        text: 'hi',
        order: OrderKey(0),
      );
      expect(text.storageKey, text.itemId);

      const toolCall = TimelineItem.toolCall(
        id: 'tc-1',
        name: 'edit_file',
        order: OrderKey(2),
      );
      expect(toolCall.storageKey, toolCall.itemId);
    });

    test('ToolCall and its correlated ToolRequest share itemId but have DIFFERENT storageKey', () {
      const toolCall = TimelineItem.toolCall(
        id: 'shared-id',
        name: 'edit_file',
        order: OrderKey(5),
      );
      const toolRequest = TimelineItem.toolRequest(
        requestId: 'shared-id',
        toolName: 'edit_file',
        argsJson: '{}',
        order: OrderKey(6),
      );

      // Same subject on purpose.
      expect(toolCall.itemId, toolRequest.itemId);

      // Distinct entities: storageKey namespaces the request away.
      expect(toolCall.storageKey, isNot(toolRequest.storageKey));
      expect(toolCall.storageKey, 'shared-id');
      expect(toolRequest.storageKey, 'req:shared-id');
    });
  });
}
