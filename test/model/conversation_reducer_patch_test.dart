import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

const _ns = 'episutra';

StateDeltaEvent _op(Map<String, dynamic> op) => StateDeltaEvent(delta: [op]);

Map<String, dynamic> _permission(String id) =>
    {'requestId': 'r-$id', 'toolCallId': id, 'options': <dynamic>[]};

List<PermissionRequestTimelineItem> _cards(ConversationReducer r) =>
    r.current.timeline.whereType<PermissionRequestTimelineItem>().toList();

void main() {
  test('a deep add lands at any depth (permissions/by-id/<id>)', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {
        _ns: {'permissions': {'by-id': {}}},
      }))
      ..apply(_op({
        'op': 'add',
        'path': '/$_ns/permissions/by-id/tc9',
        'value': _permission('tc9'),
      }));
    expect(_cards(r).single.requestId, 'r-tc9');
  });

  test('a deep remove removes the entry', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(StateSnapshotEvent(snapshot: {
        _ns: {'permissions': {'by-id': {'tc9': _permission('tc9')}}},
      }))
      ..apply(_op({'op': 'remove', 'path': '/$_ns/permissions/by-id/tc9'}));
    expect(_cards(r), isEmpty);
  });

  test('escaped pointer segments are unescaped', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {_ns: {}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/a~1b', 'value': 1}));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.unknownStateKey);
    expect(d.name, '$_ns/a/b');
  });

  test('a patch outside the namespace is recorded, not applied', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_op({'op': 'add', 'path': '/other/x', 'value': 1}));
    final d = r.current.diagnostics.single;
    expect(d.kind, DiagnosticKind.unknownStateKey);
    expect(d.name, '/other/x');
  });

  test('an unsupported op is recorded', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(_op({'op': 'move', 'path': '/$_ns/x', 'from': '/$_ns/y'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('an op without a path is recorded', () {
    final r = ConversationReducer(namespace: _ns)..apply(_op({'op': 'add'}));
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('a snapshot key outside the namespace is recorded once', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {'other': {'a': 1}, _ns: {}}))
      ..apply(const StateSnapshotEvent(snapshot: {'other': {'a': 1}, _ns: {}}));
    final d = r.current.diagnostics.where((d) => d.name == 'snapshot/other');
    expect(d, hasLength(1));
  });

  test('a patch that descends into a list is recorded and changes nothing', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {
        _ns: {
          'mode': {
            'currentModeId': 'a',
            'availableModes': [
              {'id': 'a'},
            ],
          },
        },
      }))
      ..apply(_op({
        'op': 'replace',
        'path': '/$_ns/mode/availableModes/0',
        'value': {'id': 'b'},
      }));
    expect(r.current.sessionState.mode!.availableModes.single.id, 'a');
    expect(r.current.diagnostics.single.kind, DiagnosticKind.malformedPayload);
  });

  test('2- and 3-segment patches keep working (existing behavior)', () {
    final r = ConversationReducer(namespace: _ns)
      ..apply(const StateSnapshotEvent(snapshot: {_ns: {}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/usage', 'value': {'used': 1}}))
      ..apply(_op({'op': 'add', 'path': '/$_ns/mode/currentModeId', 'value': 'x'}));
    expect(r.current.sessionState.usage!.used, 1);
    expect(r.current.sessionState.mode!.currentModeId, 'x');
  });
}
