// The state shape acp-agui-adapter's AgUiBatchProjector emits: one
// STATE_SNAPSHOT `{<ns>: state}` on the first state change, then every later
// change as a single `replace` of the WHOLE `/<ns>` path with the full state.
// Pending permissions/elicitations live under `permissions.by-id` /
// `elicitations.by-id`, keyed by tool-call id / request id, so several can be
// pending at once.
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
      'sessionId': 's1',
      'toolCallId': toolCallId,
      'status': 'pending',
      'title': title,
      'kind': 'execute',
      'options': [
        {'optionId': 'allow_once', 'name': 'Allow', 'kind': 'allow_once'},
        {'optionId': 'reject_once', 'name': 'Deny', 'kind': 'reject_once'},
      ],
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
      expect(card.requestId, 'req-1');
      expect(card.toolCallId, 'tc1');
      expect(card.toolTitle, 'Run ls');
      expect(card.toolKind, 'execute');
      expect(card.options.map((o) => o.optionId), ['allow_once', 'reject_once']);
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
      expect(_permissions(r).map((p) => p.requestId).toSet(), {'req-1', 'req-2'});
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
      expect(_permissions(r).single.requestId, 'req-2');
    });

    test('a locally resolved request is not resurrected by the next replace',
        () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(_snapshot(_state(permissions: {'tc1': _permission('tc1')})));
      r.resolveRequest('req-1');
      expect(_permissions(r), isEmpty);
      r.apply(_replaceAll(_state(permissions: {'tc1': _permission('tc1')})));
      expect(_permissions(r), isEmpty);
    });

    test('toolArgs are correlated from the matching tool call', () {
      final r = ConversationReducer(namespace: _ns)
        ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'bash'))
        ..apply(const ToolCallArgsEvent(toolCallId: 'tc1', delta: '{"cmd":"ls"}'))
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

    test('the single-slot `permission` shape still works (episutra)', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateSnapshotEvent(snapshot: {
          'episutra': {'permission': _permission('tc1')},
        }));
      expect(_permissions(r).single.requestId, 'req-1');
    });
  });

  group('elicitations.by-id (adapter state shape)', () {
    Map<String, dynamic> form() => {
          'elicitationId': 'e1',
          'message': 'Need input',
          'mode': {
            'kind': 'form',
            'schema': {'type': 'object'},
          },
          'scope': {'kind': 'request', 'request_id': 'r1'},
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
            'elicitationId': 'e2',
            'message': 'Sign in',
            'mode': {
              'kind': 'url',
              'url': 'https://example.com/auth',
              'elicitation_id': 'e2',
            },
            'scope': {'kind': 'request', 'request_id': 'r2'},
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

    test('the legacy string `mode` shape still works (episutra)', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateSnapshotEvent(snapshot: {
          'episutra': {
            'elicitation': {
              'elicitationId': 'e9',
              'message': 'hi',
              'mode': 'form',
              'requestedSchema': {'type': 'object'},
            },
          },
        }));
      final e = _elicitations(r).single;
      expect(e.mode, 'form');
      expect(e.schema, {'type': 'object'});
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
