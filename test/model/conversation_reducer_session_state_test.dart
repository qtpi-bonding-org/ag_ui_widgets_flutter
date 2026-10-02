import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';
import 'package:ag_ui_widgets_flutter/src/model/diagnostics.dart';

const _ns = 'episutra';

StateSnapshotEvent _snap(Map<String, dynamic> state) =>
    StateSnapshotEvent(snapshot: {_ns: state});

StateDeltaEvent _replaceAll(Map<String, dynamic> state) => StateDeltaEvent(
      delta: [
        {'op': 'replace', 'path': '/$_ns', 'value': state},
      ],
    );

void main() {
  test('typed session state is populated from the namespace state tree', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'agent': {
          'protocolVersion': 1,
          'agentInfo': {'name': 'claude'}
        },
        'mode': {'currentModeId': 'ask', 'availableModes': []},
        'commands': {
          'commands': [
            {'name': 'plan'}
          ]
        },
        'config': {
          'options': [
            {'id': 'model'}
          ]
        },
        'usage': {'used': 5, 'size': 100},
        'session_info': {'title': 'Hello', 'updated_at': 'now'},
        'plans': {
          'by-id': {
            'p': {'entries': []}
          }
        },
      }));
    final s = r.current.sessionState;
    expect(s.agent!.agentInfo!.name, 'claude');
    expect(s.mode!.currentModeId, 'ask');
    expect(s.commands!.commands.single.name, 'plan');
    expect(s.configState!.options.single.id, 'model');
    expect(s.usage!.used, 5);
    expect(s.sessionInfo!.updatedAt, 'now');
    expect(s.plans.byId.keys, ['p']);
    expect(s.title, 'Hello', reason: 'the existing title field still works');
  });

  test('a whole-namespace replace mirrors state: a removed key becomes null',
      () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({
        'usage': {'used': 1, 'size': 2}
      }))
      ..apply(_replaceAll({
        'mode': {'currentModeId': 'x'}
      }));
    expect(r.current.sessionState.usage, isNull);
    expect(r.current.sessionState.mode!.currentModeId, 'x');
  });

  test('a wrong-typed state key reads as null and is reported once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(_replaceAll({'usage': 'oops'}));
    expect(r.current.sessionState.usage, isNull);
    final d = r.current.diagnostics
        .where((d) => d.kind == DiagnosticKind.malformedPayload)
        .toList();
    expect(d, hasLength(1));
    expect(d.single.name, '$_ns/usage');
    expect(d.single.payload, 'oops');
  });

  test('a key that is fixed and then breaks again is reported again', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(_replaceAll({
        'usage': {'used': 1}
      }))
      ..apply(_replaceAll({'usage': 'oops'}));
    expect(
      r.current.diagnostics
          .where((d) => d.kind == DiagnosticKind.malformedPayload),
      hasLength(2),
    );
  });

  test('diagnostic indexes keep increasing across a replay reset', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'usage': 'oops'}))
      ..apply(const CustomEvent(name: '$_ns:sync', value: {'mode': 'replace'}))
      ..apply(_snap({'currentModeId': 'x'}));
    final idx = r.current.diagnostics.map((d) => d.index).toList();
    expect(idx, [...idx]..sort());
    expect(idx.toSet(), hasLength(idx.length));
  });

  test('an unknown top-level state key is reported once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({'currentModeId': 'code'}))
      ..apply(_replaceAll({'currentModeId': 'code'}));
    final d = r.current.diagnostics
        .where((d) => d.kind == DiagnosticKind.unknownStateKey)
        .toList();
    expect(d, hasLength(1));
    expect(d.single.name, '$_ns/currentModeId');
  });

  test('a fine-grained patch refreshes typed state', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_snap({}))
      ..apply(StateDeltaEvent(delta: [
        {
          'op': 'add',
          'path': '/$_ns/usage',
          'value': {'used': 3, 'size': 9}
        },
      ]));
    expect(r.current.sessionState.usage!.used, 3);
  });

  test('the legacy single-slot shape (episutra) is unaffected', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(StateSnapshotEvent(snapshot: {
        'episutra': {
          'session_info': {'title': 'PC'},
          'modes': {'x': 1}
        },
      }));
    expect(r.current.sessionState.title, 'PC');
    expect(r.current.sessionState.modes, {'x': 1});
    expect(r.current.diagnostics, isEmpty);
  });
}
