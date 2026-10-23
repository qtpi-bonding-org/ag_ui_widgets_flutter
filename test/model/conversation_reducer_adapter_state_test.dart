// The state shape acp-agui-adapter's ProtocolBridge emits: a STATE_SNAPSHOT
// `{<ns>: state}`, then key-level STATE_DELTA patches (these tests also cover a
// whole-namespace `replace`). Pending permissions/elicitations live under
// `permissions.by-id` / `elicitations.by-id`, keyed by tool-call id / elicitation
// id, so several can be pending at once. Each entry holds the raw ACP request.
import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

Map<String, dynamic> _permission(
  String toolCallId, {
  String requestId = 'req-1',
  String title = 'Run ls',
}) =>
    {
      'requestId': requestId,
      'status': 'pending',
      'request': {
        'sessionId': 's1',
        'toolCall': {
          'toolCallId': toolCallId,
          'title': title,
          'kind': 'execute',
        },
        'options': [
          {'optionId': 'allow_once', 'name': 'Allow', 'kind': 'allow_once'},
          {'optionId': 'reject_once', 'name': 'Deny', 'kind': 'reject_once'},
        ],
      },
    };

Map<String, dynamic> _state({
  Map<String, dynamic> permissions = const {},
  Map<String, dynamic> elicitations = const {},
}) =>
    {
      'plans': {'by-id': <String, dynamic>{}},
      'permissions': {'by-id': permissions},
      'elicitations': {'by-id': elicitations},
    };

StateSnapshotEvent _snapshot(Map<String, dynamic> state) =>
    StateSnapshotEvent(snapshot: {_ns: state});

StateDeltaEvent _replaceAll(Map<String, dynamic> state) => StateDeltaEvent(
      delta: [
        {'op': 'replace', 'path': '/$_ns', 'value': state},
      ],
    );

List<PermissionRequestTimelineItem> _permissions(ConversationReducer r) =>
    r.current.timeline.whereType<PermissionRequestTimelineItem>().toList();

List<ElicitationRequestTimelineItem> _elicitations(ConversationReducer r) =>
    r.current.timeline.whereType<ElicitationRequestTimelineItem>().toList();

void main() {
  group('permissions.by-id (adapter state shape)', () {
    test('a STATE_SNAPSHOT with a pending permission renders a card', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})));
      final card = _permissions(r).single;
      expect(card.requestId, 'tc1', reason: 'the by-id key');
      expect(card.extras['requestId'], 'req-1', reason: 'the JSON-RPC id');
      expect(card.toolCallId, 'tc1');
      expect(card.toolTitle, 'Run ls');
      expect(card.toolKind, 'execute');
      expect(
          card.options.map((o) => o.optionId), ['allow_once', 'reject_once']);
      expect(card.options.map((o) => o.label), ['Allow', 'Deny']);
    });

    test('a whole-namespace replace delta adds a card', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state()))
        ..apply(_replaceAll(_state(permissions: {'tc1': _permission('tc1')})));
      expect(_permissions(r), hasLength(1));
    });

    test('a later replace without the permission removes the card', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})))
        ..apply(_replaceAll(_state()));
      expect(_permissions(r), isEmpty);
    });

    test('concurrent pending permissions are all shown', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {
          'tc1': _permission('tc1', requestId: 'req-1'),
          'tc2': _permission('tc2', requestId: 'req-2', title: 'Write file'),
        })));
      expect(
          _permissions(r).map((p) => p.requestId).toSet(), {'tc1', 'tc2'});
    });

    test('resolving one of several leaves the others', () {
      final both = {
        'tc1': _permission('tc1', requestId: 'req-1'),
        'tc2': _permission('tc2', requestId: 'req-2'),
      };
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: both)))
        ..apply(_replaceAll(
            _state(permissions: {'tc2': both['tc2'] as Map<String, dynamic>})));
      expect(_permissions(r).single.requestId, 'tc2');
    });

    test('a locally resolved request is not resurrected by the next replace',
        () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})));
      r.resolveRequest('tc1');
      expect(_permissions(r), isEmpty);
      r.apply(_replaceAll(_state(permissions: {'tc1': _permission('tc1')})));
      expect(_permissions(r), isEmpty);
    });

    test('toolArgs are correlated from the matching tool call', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(
            const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'))
        ..apply(
            const ToolCallArgsEvent(toolCallId: 'tc1', delta: '{"cmd":"ls"}'))
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})));
      expect(_permissions(r).single.toolArgs, '{"cmd":"ls"}');
    });

    test('an unrelated state replace does not move a pending card', () {
      final withPermission = _state(permissions: {'tc1': _permission('tc1')});
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(withPermission))
        ..apply(const TextMessageStartEvent(messageId: 'm1'))
        ..apply(const TextMessageContentEvent(messageId: 'm1', delta: 'later'))
        ..apply(const TextMessageEndEvent(messageId: 'm1'))
        // e.g. a usage tick: same pending permission, extra state key.
        ..apply(_replaceAll({
          ...withPermission,
          'usage': {'used': 1, 'size': 100},
        }));
      final kinds = r.current.timeline.map((i) => i.runtimeType).toList();
      expect(kinds.first, PermissionRequestTimelineItem,
          reason: 'the card keeps its original slot, before the later message');
      expect(kinds, hasLength(2));
    });

    test(
        'the legacy single-slot `permission` key is reported once and '
        'renders nothing', () {
      final slot = {
        'episutra': {'permission': _permission('tc1')}
      };
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateSnapshotEvent(snapshot: slot))
        ..apply(StateSnapshotEvent(snapshot: slot));
      expect(_permissions(r), isEmpty);
      final d = r.current.diagnostics.single;
      expect(d.kind, DiagnosticKind.unknownStateKey);
      expect(d.name, 'episutra/permission');
    });
  });

  group('elicitations.by-id (adapter state shape)', () {
    Map<String, dynamic> form() => {
          'requestId': 'e1',
          'request': {
            'mode': 'form',
            'requestId': 'r1',
            'message': 'Need input',
            'requestedSchema': {'type': 'object'},
          },
        };

    test('a form elicitation renders with its schema', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(elicitations: {'e1': form()})));
      final e = _elicitations(r).single;
      expect(e.requestId, 'e1');
      expect(e.message, 'Need input');
      expect(e.mode, 'form');
      expect(e.schema, {'type': 'object'});
    });

    test('a url elicitation renders with its url', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(elicitations: {
          'e2': {
            'requestId': 'e2',
            'request': {
              'mode': 'url',
              'requestId': 'r2',
              'message': 'Sign in',
              'url': 'https://example.com/auth',
              'elicitationId': 'e2',
            },
          },
        })));
      final e = _elicitations(r).single;
      expect(e.mode, 'url');
      expect(e.url, 'https://example.com/auth');
    });

    test('a replace without the elicitation removes the card', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(elicitations: {'e1': form()})))
        ..apply(_replaceAll(_state()));
      expect(_elicitations(r), isEmpty);
    });

    test(
        'the legacy single-slot `elicitation` key is reported once and '
        'renders nothing', () {
      final slot = {
        'episutra': {
          'elicitation': {
            'elicitationId': 'e9',
            'message': 'hi',
            'mode': 'form',
            'requestedSchema': {'type': 'object'},
          },
        },
      };
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateSnapshotEvent(snapshot: slot))
        ..apply(StateSnapshotEvent(snapshot: slot));
      expect(_elicitations(r), isEmpty);
      final d = r.current.diagnostics.single;
      expect(d.kind, DiagnosticKind.unknownStateKey);
      expect(d.name, 'episutra/elicitation');
    });

    test('a mode that is not a string is diagnosed once and shown as a form',
        () {
      final state = _state(elicitations: {
        'e9': {
          'requestId': 'e9',
          'request': {
            'mode': {'kind': 'url'},
            'message': 'hi',
            'toolCallId': 'tc9',
          },
        },
      });
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(state))
        ..apply(_replaceAll(state));
      final e = _elicitations(r).single;
      expect(e.mode, 'form');
      expect(e.scope!.kind, 'tool');
      final d = r.current.diagnostics.single;
      expect(d.kind, DiagnosticKind.malformedPayload);
      expect(d.name, 'episutra/elicitations/mode');
    });

    test('an absent `mode` is a form card with no diagnostic', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(elicitations: {
          'e8': {
            'requestId': 'e8',
            'request': {'message': 'hi'},
          },
        })));
      expect(_elicitations(r).single.mode, 'form');
      expect(r.current.diagnostics, isEmpty);
    });
  });

  group('whole-namespace replace', () {
    test('a remove of the namespace clears state-sourced cards', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})))
        ..apply(StateDeltaEvent(delta: [
          {'op': 'remove', 'path': '/$_ns'},
        ]));
      expect(_permissions(r), isEmpty);
    });
  });
}
