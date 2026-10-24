// The AG-UI shapes acp-agui-adapter's ProtocolBridge emits that the golden
// fixture does not exercise end to end.
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

ConversationReducer _reducer() => ConversationReducer(namespace: 'episutra');

BaseEvent _e(Map<String, dynamic> json) => decodeAgUiWire(json);

Map<String, dynamic> _runStarted(String runId, {int? timestamp}) => {
      'type': 'RUN_STARTED',
      'threadId': 's1',
      'runId': runId,
      if (timestamp != null) 'timestamp': timestamp,
      'input': {
        'threadId': 's1',
        'runId': runId,
        'messages': [
          {
            'id': '$runId:user',
            'role': 'user',
            'content': [
              {'type': 'text', 'text': 'hi'},
            ],
          },
        ],
        'tools': [],
        'context': [],
        'state': {},
        'forwardedProps': {},
      },
    };

Map<String, dynamic> _snapshotWithPermission({String status = 'pending'}) => {
      'type': 'STATE_SNAPSHOT',
      'snapshot': {
        'episutra': {
          'permissions': {
            'by-id': {
              'tc1': {
                'requestId': 'rpc-7',
                'status': status,
                'request': {
                  'sessionId': 's1',
                  'toolCall': {
                    'toolCallId': 'tc1',
                    'title': 'Run ls',
                    'kind': 'execute',
                    'rawInput': {'cmd': 'ls'},
                  },
                  'options': [
                    {'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'},
                  ],
                },
              },
            },
          },
        },
      },
    };

void main() {
  group('runs', () {
    test('a synthetic run does not flip isRunning or touch the last result', () {
      final r = _reducer();
      r.apply(_e(_runStarted('turn-1')));
      r.apply(_e({
        'type': 'RUN_FINISHED',
        'threadId': 's1',
        'runId': 'turn-1',
        'result': {'stopReason': 'end_turn', 'durationMs': 5},
      }));
      r.apply(_e(_runStarted('synthetic-src-2')));
      expect(r.current.sessionState.isRunning, isFalse);
      r.apply(_e({
        'type': 'RUN_FINISHED',
        'threadId': 's1',
        'runId': 'synthetic-src-2',
      }));
      final s = r.current.sessionState;
      expect(s.isRunning, isFalse);
      expect(s.stopReason, 'end_turn');
      expect(s.runInfo['durationMs'], 5);
    });

    test('a real run sets isRunning and records when it started and the prompt',
        () {
      final r = _reducer();
      r.apply(_e(_runStarted('turn-1', timestamp: 1700000000000)));
      final s = r.current.sessionState;
      expect(s.isRunning, isTrue);
      expect(s.runInfo['startedAt'], '2023-11-14T22:13:20.000Z');
      expect(s.runInfo['message'], isNotNull);
    });

    test('a local <ns>:sync still resets the conversation', () {
      final r = _reducer();
      r.apply(_e(_runStarted('turn-1')));
      r.apply(const CustomEvent(name: 'episutra:sync', value: {'mode': 'replace'}));
      expect(r.current.sessionState.isRunning, isFalse);
      expect(r.current.sessionState.runId, isNull);
    });
  });

  group('permissions', () {
    test('a pending permission is a card keyed by the tool call id', () {
      final r = _reducer();
      r.apply(_e(_snapshotWithPermission()));
      final card = r.current.timeline
          .whereType<PermissionRequestTimelineItem>()
          .single;
      expect(card.requestId, 'tc1');
      expect(card.toolArgs, '{"cmd":"ls"}');
      expect(card.extras['requestId'], 'rpc-7');
      expect(r.current.diagnostics, isEmpty);
    });

    test('a permission that is not pending is not a card', () {
      final r = _reducer();
      r.apply(_e(_snapshotWithPermission(status: 'resolved')));
      expect(r.current.timeline.whereType<PermissionRequestTimelineItem>(),
          isEmpty);
    });

    test('the card stays out of the way of the tool call with the same id', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'TOOL_CALL_START',
        'toolCallId': 'tc1',
        'toolCallName': 'Run ls',
      }));
      r.apply(_e(_snapshotWithPermission()));
      expect(r.current.timeline.whereType<ToolCallTimelineItem>(), hasLength(1));
      expect(r.current.timeline.whereType<PermissionRequestTimelineItem>(),
          hasLength(1));
    });

    test('permission_resolved keeps how it was answered', () {
      final r = _reducer();
      r.apply(_e(_snapshotWithPermission()));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:permission_resolved',
        'value': {
          'toolCallId': 'tc1',
          'response': {
            'outcome': {'outcome': 'selected', 'optionId': 'allow'},
          },
          'approved': true,
        },
      }));
      r.apply(_e({
        'type': 'STATE_DELTA',
        'delta': [
          {'op': 'remove', 'path': '/episutra/permissions/by-id/tc1'},
        ],
      }));
      final s = r.current.sessionState;
      expect(s.resolutions['permission:tc1'],
          containsPair('kind', 'user_selected'));
      expect(s.resolutions['permission:tc1'], containsPair('optionId', 'allow'));
      expect(r.current.timeline.whereType<PermissionRequestTimelineItem>(),
          isEmpty);
    });

    test('a cancelled outcome is cancelled, an unchosen selection auto-approved',
        () {
      final r = _reducer();
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:permission_resolved',
        'value': {
          'toolCallId': 'a',
          'response': {
            'outcome': {'outcome': 'cancelled'},
          },
        },
      }));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:permission_resolved',
        'value': {
          'toolCallId': 'b',
          'response': {
            'outcome': {'outcome': 'selected', 'optionId': 'x'},
          },
        },
      }));
      final res = r.current.sessionState.resolutions;
      expect(res['permission:a'], containsPair('kind', 'cancelled'));
      expect(res['permission:b'], containsPair('kind', 'auto_approved'));
    });

    test('elicitation_resolved keeps the response beside the request id', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:elicitation_resolved',
        'value': {'requestId': 'e1', 'action': 'decline'},
      }));
      expect(r.current.sessionState.resolutions['elicitation:e1'],
          {'action': 'decline'});
    });
  });

  group('new events', () {
    test('message_replaced replaces the text of a streamed message', () {
      final r = _reducer();
      r.apply(_e({'type': 'TEXT_MESSAGE_START', 'messageId': 'm1', 'role': 'assistant'}));
      r.apply(_e({'type': 'TEXT_MESSAGE_CONTENT', 'messageId': 'm1', 'delta': 'old'}));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:message_replaced',
        'value': {
          'turnId': 't',
          'messageId': 'm1',
          'sessionUpdate': 'agent_message',
          'content': [
            {'type': 'text', 'text': 'new'},
          ],
        },
      }));
      final text = r.current.timeline.whereType<TextTimelineItem>().single;
      expect(text.text, 'new');
      expect(r.current.timeline, hasLength(1));
    });

    test('media on a message is a standalone item; with a toolCallId it attaches',
        () {
      final r = _reducer();
      r.apply(_e({'type': 'TOOL_CALL_START', 'toolCallId': 't1', 'toolCallName': 'x'}));
      final block = {'type': 'resource_link', 'name': 'clip', 'uri': 'file:///c'};
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:media',
        'value': {'messageId': 'm', 'channel': 'message', 'content': block},
      }));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:media',
        'value': {'toolCallId': 't1', 'content': block},
      }));
      expect(r.current.timeline.whereType<MediaTimelineItem>(), hasLength(1));
      expect(
          r.current.timeline.whereType<ToolCallTimelineItem>().single.media,
          hasLength(1));
    });

    test('a plan activity survives a state snapshot', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'ACTIVITY_SNAPSHOT',
        'messageId': 'p1',
        'activityType': 'plan',
        'content': {
          'planId': 'p1',
          'body': {
            'kind': 'entries',
            'entries': [
              {'content': 'do it', 'priority': 'high', 'status': 'pending'},
            ],
          },
        },
      }));
      r.apply(_e({
        'type': 'STATE_SNAPSHOT',
        'snapshot': {'episutra': {}},
      }));
      expect(r.current.sessionState.plans.byId['p1']!.entries, hasLength(1));
    });

    test('tool _meta and response _meta are read', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:tool',
        'value': {'toolCallId': 't1', 'title': 'x', '_meta': {'k': 1}},
      }));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:response_meta',
        'value': {'method': 'session/new', '_meta': {'a': 1}},
      }));
      expect(r.current.timeline.whereType<ToolCallTimelineItem>().single.meta,
          {'k': 1});
      expect(r.current.sessionState.responseMeta['session/new'], {'a': 1});
    });

    test('tool_text sets the tool call partialText', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'TOOL_CALL_START',
        'toolCallId': 't1',
        'toolCallName': 'search',
      }));
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:tool_text',
        'value': {
          'toolCallId': 't1',
          'type': 'content',
          'content': {'type': 'text', 'text': 'Tool: mcp__episutra-tools__search'},
        },
      }));
      expect(r.current.timeline.whereType<ToolCallTimelineItem>().single.partialText,
          'Tool: mcp__episutra-tools__search');
      expect(r.current.diagnostics, isEmpty);
    });

    test('a tool_text without text is a malformedPayload diagnostic', () {
      final r = _reducer();
      r.apply(_e({
        'type': 'CUSTOM',
        'name': 'episutra:tool_text',
        'value': {'toolCallId': 't1', 'content': {'type': 'image'}},
      }));
      expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
    });
  });
}
