import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

StateSnapshotEvent snap(Map<String, dynamic> ns) =>
    StateSnapshotEvent(snapshot: {'episutra': ns});

StateDeltaEvent delta(List<Map<String, dynamic>> ops) =>
    StateDeltaEvent(delta: ops);

void main() {
  group('I1 wrong-typed wire fields never throw', () {
    test('permission with non-string title/kind applies and later replaces work',
        () {
      final r = ConversationReducer(namespace: 'episutra');
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
      final r = ConversationReducer(namespace: 'episutra');
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
      final r = ConversationReducer(namespace: 'episutra');
      expect(
          () => r.apply(const RunFinishedEvent(
              threadId: 't', runId: 'r', result: {'stopReason': 5})),
          returnsNormally);
      expect(r.current.sessionState.stopReason, isNull);
    });

    test('session_info with a non-string title does not throw', () {
      final r = ConversationReducer(namespace: 'episutra');
      expect(() => r.apply(snap({'session_info': {'title': 5}})),
          returnsNormally);
      expect(() => r.current, returnsNormally);
      expect(r.current.sessionState.title, isNull);
    });

    test('direct permission event with non-string fields applies', () {
      final r = ConversationReducer(namespace: 'episutra');
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
      final r = ConversationReducer(namespace: 'episutra');
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
      final r = ConversationReducer(namespace: 'episutra');
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
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(delta([
        {'op': 'replace', 'path': '/episutra', 'value': 5},
      ]));
      expect(r.current.sessionState.agent?.protocolVersion, 1);
      final d = r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload)
          .single;
      expect(d.name, 'episutra/patch');
    });

    test('I2: remove of the namespace clears, add of a map replaces', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(delta([
        {'op': 'remove', 'path': '/episutra'},
      ]));
      expect(r.current.sessionState.agent, isNull);
      expect(r.current.diagnostics, isEmpty);
      r.apply(delta([
        {
          'op': 'replace',
          'path': '/episutra',
          'value': {
            'agent': {'protocolVersion': 2}
          }
        },
      ]));
      expect(r.current.sessionState.agent?.protocolVersion, 2);
    });

    test('I3: a snapshot whose namespace entry is not a map is diagnosed', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(snap({
          'agent': {'protocolVersion': 1},
        }));
      r.apply(StateSnapshotEvent(snapshot: {'episutra': 5}));
      expect(r.current.sessionState.agent, isNull);
      final d = r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload)
          .single;
      expect(d.name, 'snapshot/episutra');
      expect(d.payload, 5);
    });

    test('I3: a snapshot with no namespace entry records nothing', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(StateSnapshotEvent(snapshot: {'episutra': null}));
      expect(r.current.diagnostics, isEmpty);
    });

    test('I4: remove through a missing parent creates no state', () {
      final r = ConversationReducer(namespace: 'episutra');
      r.apply(delta([
        {'op': 'remove', 'path': '/episutra/usage/used'},
      ]));
      expect(r.current.sessionState.usage, isNull);
      expect(r.current.diagnostics, isEmpty);
    });

    test('I4: remove of an existing nested key still works', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(snap({
          'usage': {'used': 5, 'size': 10},
        }));
      r.apply(delta([
        {'op': 'remove', 'path': '/episutra/usage/used'},
      ]));
      expect(r.current.sessionState.usage?.used, isNull);
      expect(r.current.sessionState.usage?.size, 10);
    });
  });

  group('I5 commands as a bare list', () {
    test('a bare list of commands parses, with no diagnostic', () {
      final r = ConversationReducer(namespace: 'episutra')
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
      final r = ConversationReducer(namespace: 'episutra')
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

  group('I6 malformed direct acp.* events are diagnosed', () {
    for (final name in [
      'acp.permission_request',
      'acp.elicitation_request',
      'acp.client_execute_request',
    ]) {
      test('$name: non-map and missing id are malformedPayload, deduped', () {
        final r = ConversationReducer(namespace: 'episutra');
        r.apply(CustomEvent(name: name, value: 'oops'));
        r.apply(CustomEvent(name: name, value: const {'x': 1}));
        r.apply(CustomEvent(name: name, value: const {'x': 1}));
        final ds = r.current.diagnostics;
        expect(ds, hasLength(2));
        expect(ds.every((d) => d.kind == DiagnosticKind.malformedPayload),
            isTrue);
        expect(ds.every((d) => d.name == name), isTrue);
        expect(r.current.timeline, isEmpty);
      });
    }

    test('acp.session_phase: unknown phase and non-map are diagnosed', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const CustomEvent(
            name: 'acp.session_phase', value: {'phase': 'weird'}))
        ..apply(const CustomEvent(name: 'acp.session_phase', value: 'x'))
        ..apply(const CustomEvent(
            name: 'acp.session_phase', value: {'phase': 'starting'}));
      final ds = r.current.diagnostics;
      expect(ds.map((d) => d.kind),
          [DiagnosticKind.unknownCustom, DiagnosticKind.malformedPayload]);
      expect(r.current.sessionState.isStarting, isTrue);
    });
  });

  group('M2-M4', () {
    test('M2: unhandledEvent diagnostic carries the event payload', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const StepStartedEvent(stepName: 'plan'));
      final d = r.current.diagnostics.single;
      expect(d.kind, DiagnosticKind.unhandledEvent);
      expect((d.payload as Map)['stepName'], 'plan');
    });

    test('M3: non-map location entries are diagnosed, valid ones kept', () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const CustomEvent(name: 'episutra:tool', value: {
          'toolCallId': 't',
          'locations': [
            'junk',
            {'path': 'a.dart', 'line': 2},
          ],
        }));
      final t = r.current.timeline.single as ToolCallTimelineItem;
      expect(t.locations.single.path, 'a.dart');
      final d = r.current.diagnostics.single;
      expect(d.kind, DiagnosticKind.malformedPayload);
      expect(d.name, 'episutra:tool/locations');
    });

    test('M3: a non-list locations value is diagnosed and keeps earlier ones',
        () {
      final r = ConversationReducer(namespace: 'episutra')
        ..apply(const CustomEvent(name: 'episutra:tool', value: {
          'toolCallId': 't',
          'locations': [
            {'path': 'a.dart'}
          ],
        }))
        ..apply(const CustomEvent(
            name: 'episutra:tool',
            value: {'toolCallId': 't', 'locations': 5}));
      final t = r.current.timeline.single as ToolCallTimelineItem;
      expect(t.locations.single.path, 'a.dart');
      expect(r.current.diagnostics.single.name, 'episutra:tool/locations');
    });

    test('M4: an unknown snapshot key is re-reported after it disappears', () {
      final r = ConversationReducer(namespace: 'episutra');
      StateSnapshotEvent s(Map<String, dynamic> m) =>
          StateSnapshotEvent(snapshot: m);
      int count() => r.current.diagnostics
          .where((d) => d.name == 'snapshot/extra')
          .length;
      r.apply(s({'extra': 1}));
      r.apply(s({'extra': 2}));
      expect(count(), 1);
      r.apply(s({'episutra': <String, dynamic>{}}));
      r.apply(s({'extra': 3}));
      expect(count(), 2);
    });

    test('M4: the permission-content dedupe set is bounded', () {
      final r = ConversationReducer(namespace: 'episutra');
      StateSnapshotEvent s() => StateSnapshotEvent(snapshot: {
            'episutra': {
              'permission': {
                'requestId': 'p',
                'content': [for (var i = 0; i < 501; i++) 'bad$i'],
              },
            },
          });
      r.apply(s());
      final first = r.current.diagnostics.last.index;
      r.apply(s());
      // Past the cap the set was cleared, so old entries are reported again
      // instead of the set growing without limit.
      expect(r.current.diagnostics.last.index, greaterThan(first));
    });
  });
}
