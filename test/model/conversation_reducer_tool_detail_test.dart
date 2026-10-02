import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

ConversationReducer _r() => ConversationReducer(namespace: _ns)
  ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'));

ToolCallTimelineItem _tool(ConversationReducer r) =>
    r.current.timeline.whereType<ToolCallTimelineItem>().single;

void main() {
  test('<ns>:tool keeps locations and meta', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool', value: {
        'toolCallId': 'tc1',
        'kind': 'edit',
        'status': 'in_progress',
        'locations': [{'path': 'a.dart', 'line': 3}, {'path': 'b.dart'}],
        'meta': {'k': 'v'},
      }));
    final t = _tool(r);
    expect(t.locations.map((l) => l.path), ['a.dart', 'b.dart']);
    expect(t.locations.first.line, 3);
    expect(t.meta, {'k': 'v'});
  });

  test('a later <ns>:tool without locations keeps the earlier ones', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:tool', value: {
        'toolCallId': 'tc1',
        'locations': [{'path': 'a'}],
      }))
      ..apply(const CustomEvent(
          name: '$_ns:tool', value: {'toolCallId': 'tc1', 'status': 'completed'}));
    expect(_tool(r).locations, hasLength(1));
  });

  test('DiffV2 {format, patch} is kept as a ToolPatch', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:diff', value: {
        'toolCallId': 'tc1',
        'format': 'unified',
        'patch': '@@ -1 +1 @@',
      }));
    expect(_tool(r).patches.single.patch, '@@ -1 +1 @@');
    expect(_tool(r).diffs, isEmpty);
  });

  test('a diff with a null oldText is a new-file diff', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:diff', value: {
        'toolCallId': 'tc1', 'path': 'n.txt', 'oldText': null, 'newText': 'x',
      }));
    expect(_tool(r).diffs.single.oldText, '');
  });

  test('<ns>:terminal attaches a terminal', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {
        'toolCallId': 'tc1', 'terminalId': 't1', 'meta': {'cwd': '/'},
      }));
    expect(_tool(r).terminals.single.terminalId, 't1');
    expect(_tool(r).terminals.single.meta, {'cwd': '/'});
  });

  test('<ns>:content with a toolCallId attaches media to the tool', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:content', value: {
        'toolCallId': 'tc1', 'kind': 'image', 'mimeType': 'image/png',
      }));
    expect(_tool(r).media.single.mimeType, 'image/png');
  });

  test('<ns>:content with a messageId becomes a MediaTimelineItem', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:content', value: {
        'messageId': 'm1', 'kind': 'audio', 'mimeType': 'audio/wav',
      }));
    final item = r.current.timeline.single as MediaTimelineItem;
    expect(item.messageId, 'm1');
    expect(item.media.kind, 'audio');
  });

  test('tool detail arriving before TOOL_CALL_START lands on a placeholder', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {
        'toolCallId': 'early', 'terminalId': 't',
      }))
      ..apply(const ToolCallStartEvent(toolCallId: 'early', toolCallName: 'sh'));
    final t = r.current.timeline.single as ToolCallTimelineItem;
    expect(t.name, 'sh');
    expect(t.terminals, hasLength(1));
  });

  test('<ns>:response_meta is kept per method', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const CustomEvent(name: '$_ns:response_meta', value: {
        'method': 'session/new', 'meta': {'a': 1},
      }));
    expect(r.current.sessionState.responseMeta, {'session/new': {'a': 1}});
  });

  test('every TOOL_CALL_RESULT is kept; result stays the latest', () {
    final r = _r()
      ..apply(const ToolCallResultEvent(
          messageId: 'r1', toolCallId: 'tc1', content: 'A'))
      ..apply(const ToolCallResultEvent(
          messageId: 'r2', toolCallId: 'tc1', content: 'B'));
    expect(_tool(r).result, 'B');
    expect(_tool(r).resultParts.map((p) => p.messageId), ['r1', 'r2']);
    expect(_tool(r).resultParts.map((p) => p.content), ['A', 'B']);
  });

  test('a malformed tool-detail payload is ignored for the timeline', () {
    final r = _r()
      ..apply(const CustomEvent(name: '$_ns:terminal', value: 'not a map'))
      ..apply(const CustomEvent(name: '$_ns:terminal', value: {'terminalId': 't'}));
    expect(_tool(r).terminals, isEmpty);
  });
}
