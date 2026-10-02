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
}
