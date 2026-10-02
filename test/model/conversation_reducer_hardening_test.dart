import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

StateSnapshotEvent snap(Map<String, dynamic> ns) =>
    StateSnapshotEvent(snapshot: {'pocketcoder': ns});

StateDeltaEvent delta(List<Map<String, dynamic>> ops) =>
    StateDeltaEvent(delta: ops);

void main() {
  group('I1 wrong-typed wire fields never throw', () {
    test('permission with non-string title/kind applies and later replaces work',
        () {
      final r = ConversationReducer();
      expect(
          () => r.apply(snap({
                'permission': {
                  'requestId': 'p1',
                  'title': 5,
                  'kind': 6,
                  'options': [],
                },
              })),
          returnsNormally);
      var item = r.current.timeline.single as PermissionRequestTimelineItem;
      expect(item.toolTitle, isNull);
      expect(item.toolKind, isNull);
      r.apply(snap({
        'permission': {'requestId': 'p1', 'title': 'ok', 'options': []},
      }));
      item = r.current.timeline.single as PermissionRequestTimelineItem;
      expect(item.toolTitle, 'ok');
    });

    test('elicitation with non-string message/mode/url applies', () {
      final r = ConversationReducer();
      expect(
          () => r.apply(snap({
                'elicitation': {
                  'elicitationId': 'e1',
                  'message': 5,
                  'mode': 7,
                  'url': 8,
                },
              })),
          returnsNormally);
      final e = r.current.timeline.single as ElicitationRequestTimelineItem;
      expect(e.message, '');
      expect(e.mode, 'form');
      expect(e.url, isNull);
      expect(
          () => r.apply(snap({
                'elicitation': {
                  'elicitationId': 'e1',
                  'mode': {'kind': 5, 'url': 6, 'schema': {}},
                },
              })),
          returnsNormally);
    });

    test('RUN_FINISHED with a non-string stopReason does not throw', () {
      final r = ConversationReducer();
      expect(
          () => r.apply(const RunFinishedEvent(
              threadId: 't', runId: 'r', result: {'stopReason': 5})),
          returnsNormally);
      expect(r.current.sessionState.stopReason, isNull);
    });

    test('session_info with a non-string title does not throw', () {
      final r = ConversationReducer();
      expect(() => r.apply(snap({'session_info': {'title': 5}})),
          returnsNormally);
      expect(() => r.current, returnsNormally);
      expect(r.current.sessionState.title, isNull);
    });

    test('direct permission event with non-string fields applies', () {
      final r = ConversationReducer();
      expect(
          () => r.apply(const CustomEvent(name: 'acp.permission_request', value: {
                'callId': 'c1',
                'optionsJson': '[{"id":5,"label":6,"kind":7}]',
                'toolName': 5,
                'description': 6,
              })),
          returnsNormally);
      final p = r.current.timeline.single as PermissionRequestTimelineItem;
      expect(p.toolTitle, isNull);
      expect(p.description, isNull);
    });

    test('malformed optionsJson is diagnosed, not thrown', () {
      final r = ConversationReducer();
      expect(
          () => r.apply(const CustomEvent(name: 'acp.permission_request', value: {
                'callId': 'c1',
                'optionsJson': '{not json',
              })),
          returnsNormally);
      expect(
          () => r.apply(const CustomEvent(name: 'acp.permission_request', value: {
                'callId': 'c2',
                'optionsJson': 5,
              })),
          returnsNormally);
      final ds = r.current.diagnostics;
      expect(ds.where((d) => d.kind == DiagnosticKind.malformedPayload),
          hasLength(2));
      expect(r.current.timeline, hasLength(2));
    });

    test('direct elicitation / execute events with wrong-typed fields apply',
        () {
      final r = ConversationReducer();
      expect(
          () => r.apply(const CustomEvent(name: 'acp.elicitation_request', value: {
                'requestId': 'e1',
                'message': 5,
                'mode': 5,
                'url': 5,
              })),
          returnsNormally);
      expect(
          () => r.apply(const CustomEvent(
              name: 'acp.client_execute_request',
              value: {'callId': 'x', 'toolName': 5})),
          returnsNormally);
    });
  });

  group('I2-I4 state patch / snapshot hardening', () {
    test('I2: replace of the namespace with a non-map is rejected untouched',
        () {
      final r = ConversationReducer()
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(delta([
        {'op': 'replace', 'path': '/pocketcoder', 'value': 5},
      ]));
      expect(r.current.sessionState.agent?.protocolVersion, 1);
      final d = r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload)
          .single;
      expect(d.name, 'pocketcoder/patch');
    });

    test('I2: remove of the namespace clears, add of a map replaces', () {
      final r = ConversationReducer()
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(delta([
        {'op': 'remove', 'path': '/pocketcoder'},
      ]));
      expect(r.current.sessionState.agent, isNull);
      expect(r.current.diagnostics, isEmpty);
      r.apply(delta([
        {
          'op': 'replace',
          'path': '/pocketcoder',
          'value': {
            'agent': {'protocolVersion': 2}
          }
        },
      ]));
      expect(r.current.sessionState.agent?.protocolVersion, 2);
    });

    test('I3: a snapshot whose namespace entry is not a map is diagnosed', () {
      final r = ConversationReducer()
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(StateSnapshotEvent(snapshot: {'pocketcoder': 5}));
      expect(r.current.sessionState.agent, isNull);
      final d = r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload)
          .single;
      expect(d.name, 'snapshot/pocketcoder');
      expect(d.payload, 5);
    });

    test('I3: a snapshot with no namespace entry records nothing', () {
      final r = ConversationReducer()
        ..apply(StateSnapshotEvent(snapshot: {'pocketcoder': null}));
      expect(r.current.diagnostics, isEmpty);
    });

    test('I4: remove through a missing parent creates no state', () {
      final r = ConversationReducer();
      r.apply(delta([
        {'op': 'remove', 'path': '/pocketcoder/usage/used'},
      ]));
      expect(r.current.sessionState.usage, isNull);
      expect(r.current.diagnostics, isEmpty);
    });

    test('I4: remove of an existing nested key still works', () {
      final r = ConversationReducer()
        ..apply(snap({
          'usage': {'used': 5, 'size': 10},
        }));
      r.apply(delta([
        {'op': 'remove', 'path': '/pocketcoder/usage/used'},
      ]));
      expect(r.current.sessionState.usage?.used, isNull);
      expect(r.current.sessionState.usage?.size, 10);
    });
  });

  group('I5 commands as a bare list', () {
    test('a bare list of commands parses, with no diagnostic', () {
      final r = ConversationReducer()
        ..apply(snap({
          'commands': [
            {'name': 'help', 'description': 'Show help'},
            'junk',
            {'name': 'x'},
          ],
        }));
      final c = r.current.sessionState.commands!;
      expect(c.commands.map((e) => e.name), ['help', 'x']);
      expect(c.commands.first.description, 'Show help');
      expect(r.current.diagnostics, isEmpty);
    });

    test('the map shape still parses', () {
      final r = ConversationReducer()
        ..apply(snap({
          'commands': {
            'commands': [
              {'name': 'a'}
            ]
          },
        }));
      expect(r.current.sessionState.commands!.commands.single.name, 'a');
    });
  });
}
