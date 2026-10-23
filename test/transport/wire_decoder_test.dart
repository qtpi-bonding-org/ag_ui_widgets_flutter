import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  test('TOOL_CALL_RESULT content parts become text and the parts are kept', () {
    final parts = [
      {'type': 'text', 'text': 'Edited a.txt'},
      {
        'type': 'document',
        'source': {'type': 'url', 'value': 'file:///clip'},
      },
    ];
    final event = decodeAgUiWire({
      'type': 'TOOL_CALL_RESULT',
      'messageId': 'tool-result-tc1',
      'toolCallId': 'tc1',
      'content': parts,
    }) as ToolCallResultEvent;
    expect(event.content, 'Edited a.txt');
    expect((event.rawEvent as Map)['parts'], parts);
  });

  test('a string content is passed through unchanged', () {
    final event = decodeAgUiWire({
      'type': 'TOOL_CALL_RESULT',
      'messageId': 'm',
      'toolCallId': 'tc1',
      'content': 'plain',
    }) as ToolCallResultEvent;
    expect(event.content, 'plain');
    expect(event.rawEvent, isNull);
  });

  test('a RUN_STARTED with the full input decodes', () {
    final event = decodeAgUiWire({
      'type': 'RUN_STARTED',
      'threadId': 't',
      'runId': 'synthetic-src-1',
      'input': {
        'threadId': 't',
        'runId': 'synthetic-src-1',
        'messages': [],
        'tools': [],
        'context': [],
        'state': {},
        'forwardedProps': {},
      },
    });
    expect(event, isA<RunStartedEvent>());
  });

  test('the reducer keeps the parts of a result', () {
    final r = ConversationReducer(namespace: 'episutra');
    r.apply(decodeAgUiWire({
      'type': 'TOOL_CALL_START',
      'toolCallId': 'tc1',
      'toolCallName': 'x',
    }));
    r.apply(decodeAgUiWire({
      'type': 'TOOL_CALL_RESULT',
      'messageId': 'm1',
      'toolCallId': 'tc1',
      'content': [
        {'type': 'text', 'text': 'hi'},
        {'type': 'image', 'source': {'type': 'url', 'value': 'file:///i'}},
      ],
    }));
    final tool = r.current.timeline.whereType<ToolCallTimelineItem>().single;
    expect(tool.result, 'hi');
    expect(tool.resultParts.single.parts, hasLength(2));
  });
}
