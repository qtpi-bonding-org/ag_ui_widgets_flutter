import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

StateSnapshotEvent _snap(Map<String, dynamic> state) =>
    StateSnapshotEvent(snapshot: {_ns: state});

void main() {
  test('a permission keeps content, meta, sessionId and unknown keys', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'permissions': {
          'by-id': {
            'tc1': {
              'requestId': 'req-1',
              'status': 'pending',
              'request': {
                'sessionId': 's1',
                'toolCall': {
                  'toolCallId': 'tc1',
                  'title': 'Edit a.txt',
                  'content': [
                    {
                      'toolCallId': 'tc1',
                      'path': 'a.txt',
                      'oldText': 'x',
                      'newText': 'y'
                    },
                    {'toolCallId': 'tc1', 'terminalId': 't1'},
                  ],
                },
                'options': [
                  {
                    'optionId': 'ok',
                    'name': 'Allow',
                    'kind': 'allow_once',
                    '_meta': {'o': 1}
                  },
                ],
                '_meta': {'m': 1},
              },
              'futureKey': 7,
            },
          },
        },
      }));
    final p =
        r.current.timeline.whereType<PermissionRequestTimelineItem>().single;
    expect(p.sessionId, 's1');
    expect(p.meta, {'m': 1});
    expect(p.content, hasLength(2));
    expect(p.content.first, isA<ToolContentDiff>());
    expect(p.content.last, isA<ToolContentTerminal>());
    expect(p.options.single.extras, {
      '_meta': {'o': 1}
    });
    expect(p.extras, {'requestId': 'req-1', 'futureKey': 7});
  });

  test('an elicitation keeps its scope, meta and unknown request keys', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e1': {
              'requestId': 'e1',
              'request': {
                'mode': 'weird',
                'message': 'm',
                'sessionId': 's',
                'toolCallId': 'tc',
                '_meta': {'z': 1},
                'futureKey': 3,
              },
            },
          },
        },
      }));
    final e =
        r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.mode, 'weird');
    expect(e.scope!.kind, 'tool');
    expect(e.scope!.sessionId, 's');
    expect(e.scope!.toolCallId, 'tc');
    expect(e.meta, {'z': 1});
    expect(e.extras, {'requestId': 'e1', 'futureKey': 3});
  });

  test('a url elicitation keeps its elicitationId in extras', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e2': {
              'requestId': 'e2',
              'request': {
                'mode': 'url',
                'message': 'Sign in',
                'url': 'https://example.com/auth',
                'elicitationId': 'e2',
                'requestId': 'r2',
              },
            },
          },
        },
      }));
    final e =
        r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.url, 'https://example.com/auth');
    expect(e.extras['elicitationId'], 'e2');
    expect(e.scope!.requestId, 'r2');
  });

  test('a content entry that is not a map is kept as a diagnostic, once', () {
    final state = {
      'permissions': {
        'by-id': {
          'tc1': {
            'requestId': 'r',
            'request': {
              'toolCall': {
                'toolCallId': 'tc1',
                'content': [
                  'junk',
                  {'terminalId': 't'}
                ],
              },
              'options': [],
            },
          },
        },
      },
    };
    final r = ConversationReducer(namespace: _ns)..apply(_snap(state));
    // A whole-namespace replace arrives on every state change; it must not
    // re-report the same junk entry.
    for (var i = 0; i < 3; i++) {
      r.apply(StateDeltaEvent(delta: [
        {'op': 'replace', 'path': '/$_ns', 'value': state},
      ]));
    }
    final p =
        r.current.timeline.whereType<PermissionRequestTimelineItem>().single;
    expect(p.content, hasLength(1));
    final junk = r.current.diagnostics.where((d) => d.payload == 'junk');
    expect(junk, hasLength(1));
  });
}
