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
              'sessionId': 's1',
              'toolCallId': 'tc1',
              'status': 'pending',
              'title': 'Edit a.txt',
              'options': [
                {
                  'optionId': 'ok',
                  'name': 'Allow',
                  'kind': 'allow_once',
                  'meta': {'o': 1}
                },
              ],
              'content': [
                {
                  'toolCallId': 'tc1',
                  'path': 'a.txt',
                  'oldText': 'x',
                  'newText': 'y'
                },
                {'toolCallId': 'tc1', 'terminalId': 't1'},
              ],
              'meta': {'m': 1},
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
      'meta': {'o': 1}
    });
    expect(p.extras, {'status': 'pending', 'futureKey': 7});
  });

  test('an elicitation keeps scope, meta and an unknown mode', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e1': {
              'elicitationId': 'e1',
              'message': 'm',
              'mode': {
                'kind': 'other',
                'mode': 'weird',
                'raw': {'a': 1}
              },
              'scope': {
                'kind': 'session',
                'session_id': 's',
                'tool_call_id': 'tc'
              },
              'meta': {'z': 1},
            },
          },
        },
      }));
    final e =
        r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.mode, 'other');
    expect(e.rawMode, {
      'kind': 'other',
      'mode': 'weird',
      'raw': {'a': 1}
    });
    expect(e.scope!.kind, 'session');
    expect(e.scope!.sessionId, 's');
    expect(e.scope!.toolCallId, 'tc');
    expect(e.meta, {'z': 1});
  });

  test('a url elicitation keeps its elicitation_id in rawMode', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'elicitations': {
          'by-id': {
            'e2': {
              'elicitationId': 'e2',
              'message': 'Sign in',
              'mode': {
                'kind': 'url',
                'url': 'https://example.com/auth',
                'elicitation_id': 'e2',
              },
              'scope': {'kind': 'request', 'request_id': 'r2'},
            },
          },
        },
      }));
    final e =
        r.current.timeline.whereType<ElicitationRequestTimelineItem>().single;
    expect(e.url, 'https://example.com/auth');
    expect(e.rawMode!['elicitation_id'], 'e2');
  });

  test('a content entry that is not a map is kept as a diagnostic, once', () {
    final state = {
      'permissions': {
        'by-id': {
          'tc1': {
            'requestId': 'r',
            'toolCallId': 'tc1',
            'options': [],
            'content': [
              'junk',
              {'terminalId': 't'}
            ],
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
