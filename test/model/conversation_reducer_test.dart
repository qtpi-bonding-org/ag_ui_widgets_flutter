import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

BaseEvent _sync() =>
    const CustomEvent(name: 'pocketcoder:sync', value: {'mode': 'replace'});

StateDeltaEvent _delta(String path, {String op = 'add', dynamic value}) {
  return StateDeltaEvent(delta: [
    {'op': op, 'path': path, if (value != null) 'value': value},
  ]);
}

void main() {
  group('text messages', () {
    test('START -> textStream item; CONTENT x2 -> grows in place; END -> replaced by text item', () {
      final r = ConversationReducer();
      r.apply(const TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant));
      expect(r.current.timeline, hasLength(1));
      expect(r.current.timeline.single, isA<TextStreamTimelineItem>());

      r.apply(const TextMessageContentEvent(messageId: 'm1', delta: 'Hello, '));
      expect((r.current.timeline.single as TextStreamTimelineItem).text, 'Hello, ');

      r.apply(const TextMessageContentEvent(messageId: 'm1', delta: 'world!'));
      r.apply(const TextMessageEndEvent(messageId: 'm1'));
      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as TextTimelineItem;
      expect(item.kind, ChatMessageKind.text);
      expect(item.role, 'assistant');
      expect(item.text, 'Hello, world!');
    });
  });

  group('reasoning messages', () {
    test('START -> reasoning textStream item; CONTENT grows in place; END -> replaced by reasoning text item', () {
      final r = ConversationReducer();
      r.apply(const ReasoningMessageStartEvent(messageId: 'r1'));
      expect(r.current.timeline, hasLength(1));
      final streaming = r.current.timeline.single as TextStreamTimelineItem;
      expect(streaming.kind, ChatMessageKind.reasoning);
      expect(streaming.text, '');

      r.apply(const ReasoningMessageContentEvent(messageId: 'r1', delta: 'thinking...'));
      expect(r.current.timeline, hasLength(1));
      expect((r.current.timeline.single as TextStreamTimelineItem).text, 'thinking...');

      r.apply(const ReasoningMessageEndEvent(messageId: 'r1'));
      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as TextTimelineItem;
      expect(item.kind, ChatMessageKind.reasoning);
      expect(item.text, 'thinking...');
    });

    test('reasoning streams in place even when a tool call starts afterward', () {
      final r = ConversationReducer()
        ..apply(const ReasoningMessageStartEvent(messageId: 'r1'))
        ..apply(const ReasoningMessageContentEvent(messageId: 'r1', delta: 'first '))
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'search'))
        ..apply(const ReasoningMessageContentEvent(messageId: 'r1', delta: 'second'));

      expect(r.current.timeline, hasLength(2));
      final reasoning = r.current.timeline[0] as TextStreamTimelineItem;
      expect(reasoning.kind, ChatMessageKind.reasoning);
      expect(reasoning.text, 'first second');
      expect(r.current.timeline[1], isA<ToolCallTimelineItem>());
    });
  });

  group('tool calls', () {
    test('START/ARGS/RESULT builds one toolCall item in place', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'search'))
        ..apply(const ToolCallArgsEvent(toolCallId: 't1', delta: '{"q":'))
        ..apply(const ToolCallArgsEvent(toolCallId: 't1', delta: '"x"}'))
        ..apply(const ToolCallResultEvent(messageId: 'm1', toolCallId: 't1', content: 'ok'));

      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.name, 'search');
      expect(item.args, '{"q":"x"}');
      expect(item.result, 'ok');
    });
  });

  group('tool call diffs', () {
    BaseEvent diffEvent(String toolCallId, String path,
            {String? oldText, required String newText}) =>
        CustomEvent(name: 'pocketcoder:diff', value: {
          'toolCallId': toolCallId,
          'path': path,
          if (oldText != null) 'oldText': oldText,
          'newText': newText,
        });

    test('pocketcoder:diff event appends a ToolDiff to the matching tool call', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'edit_file'))
        ..apply(diffEvent('t1', 'lib/foo.dart', oldText: 'a', newText: 'b'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, hasLength(1));
      expect(item.diffs.single.path, 'lib/foo.dart');
      expect(item.diffs.single.oldText, 'a');
      expect(item.diffs.single.newText, 'b');
    });

    test('a second diff event for the same tool call appends rather than replaces', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'multi_edit'))
        ..apply(diffEvent('t1', 'lib/a.dart', newText: 'a2'))
        ..apply(diffEvent('t1', 'lib/b.dart', newText: 'b2'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, hasLength(2));
      expect(item.diffs[0].path, 'lib/a.dart');
      expect(item.diffs[1].path, 'lib/b.dart');
    });

    test('diff event for an unknown toolCallId creates an orphan entry, same as args/result would', () {
      final r = ConversationReducer()..apply(diffEvent('unknown', 'lib/c.dart', newText: 'c'));

      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.id, 'unknown');
      expect(item.name, '');
      expect(item.diffs.single.path, 'lib/c.dart');
    });

    test('new-file diff (no oldText in the event) defaults oldText to empty string', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'write_file'))
        ..apply(diffEvent('t1', 'lib/new.dart', newText: 'content'));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs.single.oldText, '');
    });

    test('a malformed diff event (missing newText) is ignored, not crashed on', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'edit_file'))
        ..apply(const CustomEvent(
            name: 'pocketcoder:diff', value: {'toolCallId': 't1', 'path': 'lib/x.dart'}));

      final item = r.current.timeline.single as ToolCallTimelineItem;
      expect(item.diffs, isEmpty);
    });
  });

  group('permission/elicitation via state delta', () {
    group('elicitation (Adapter A: pocketcoder StateDelta)', () {
      test('StateSnapshot with /pocketcoder/elicitation produces a full-payload item', () {
        final r = ConversationReducer();
        r.apply(const StateSnapshotEvent(snapshot: {
          'pocketcoder': {
            'elicitation': {
              'elicitationId': 'e1',
              'message': 'Pick a color',
              'mode': 'form',
              'requestedSchema': {'type': 'object', 'properties': {'color': {'type': 'string'}}},
            }
          }
        }));
        expect(r.current.timeline, hasLength(1));
        final item = r.current.timeline.single as ElicitationRequestTimelineItem;
        expect(item.requestId, 'e1');
        expect(item.message, 'Pick a color');
        expect(item.mode, 'form');
        expect(item.schema, {'type': 'object', 'properties': {'color': {'type': 'string'}}});
        expect(item.url, isNull);
      });

      test('url-mode elicitation carries url, no schema', () {
        final r = ConversationReducer();
        r.apply(const StateSnapshotEvent(snapshot: {
          'pocketcoder': {
            'elicitation': {
              'elicitationId': 'e2',
              'message': 'Open this link',
              'mode': 'url',
              'url': 'https://example.com/auth',
            }
          }
        }));
        final item = r.current.timeline.single as ElicitationRequestTimelineItem;
        expect(item.mode, 'url');
        expect(item.url, 'https://example.com/auth');
        expect(item.schema, isNull);
      });
    });

    group('permission (Adapter A: pocketcoder StateDelta)', () {
      test('StateSnapshot with /pocketcoder/permission produces a full-payload item (toolTitle null today)', () {
        final r = ConversationReducer();
        r.apply(const StateSnapshotEvent(snapshot: {
          'pocketcoder': {
            'permission': {
              'requestId': 'p1',
              'status': 'pending',
              'options': [
                {'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'},
                {'optionId': 'deny', 'name': 'Deny', 'kind': 'reject_once'},
              ],
            }
          }
        }));
        expect(r.current.timeline, hasLength(1));
        final item = r.current.timeline.single as PermissionRequestTimelineItem;
        expect(item.requestId, 'p1');
        expect(item.toolTitle, isNull); // pocketcoder doesn't send this yet (Phase 2, Task 9)
        expect(item.description, isNull); // never an ACP wire field
        expect(item.options, hasLength(2));
        expect(item.options[0].optionId, 'allow');
        expect(item.options[0].label, 'Allow');
        expect(item.options[0].kind, 'allow_once');
      });

      test('once pocketcoder forwards title/kind (Phase 2), the adapter reads them', () {
        final r = ConversationReducer();
        r.apply(const StateSnapshotEvent(snapshot: {
          'pocketcoder': {
            'permission': {
              'requestId': 'p2',
              'status': 'pending',
              'title': 'Run shell command',
              'kind': 'execute',
              'options': [
                {'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'},
              ],
            }
          }
        }));
        final item = r.current.timeline.single as PermissionRequestTimelineItem;
        expect(item.toolTitle, 'Run shell command');
        expect(item.toolKind, 'execute');
      });
    });

    test('permission sub-path add inserts a full-payload item after its correlated tool call', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 't1', toolCallName: 'write_file'))
        ..apply(_delta('/pocketcoder/permission',
            value: {'requestId': 'p1', 'toolCallId': 't1'}));

      expect(r.current.timeline, hasLength(2));
      expect(r.current.timeline[0], isA<ToolCallTimelineItem>());
      final marker = r.current.timeline[1] as PermissionRequestTimelineItem;
      expect(marker.requestId, 'p1');
    });

    test('elicitation sub-path add appends a marker at the end', () {
      final r = ConversationReducer()
        ..apply(_delta('/pocketcoder/elicitation', value: {'elicitationId': 'e1'}));

      expect(r.current.timeline, hasLength(1));
      expect((r.current.timeline.single as ElicitationRequestTimelineItem).requestId, 'e1');
    });
  });

  group('resolveRequest', () {
    test('resolving a permission removes it and a later replay of the same state does not resurrect it', () {
      final r = ConversationReducer();
      final snapshot = const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'permission': {
            'requestId': 'p1',
            'status': 'pending',
            'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
          }
        }
      });
      r.apply(snapshot);
      expect(r.current.timeline, hasLength(1));

      r.resolveRequest('p1');
      expect(r.current.timeline, isEmpty);

      // Simulate pocketcoder replaying the exact same StateSnapshot (backend
      // never clears its own namespace) — the resolved item must not come back.
      r.apply(snapshot);
      expect(r.current.timeline, isEmpty);
    });

    test('resolved-id set survives the cold-replay reset marker', () {
      final r = ConversationReducer();
      final snapshot = const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'elicitation': {'elicitationId': 'e1', 'message': 'm', 'mode': 'form'}
        }
      });
      r.apply(snapshot);
      r.resolveRequest('e1');
      expect(r.current.timeline, isEmpty);

      // Reconnect replay: cold-replay marker, then the same snapshot again.
      r.apply(const CustomEvent(name: 'pocketcoder:sync', value: {'mode': 'replace'}));
      r.apply(snapshot);
      expect(r.current.timeline, isEmpty,
          reason: 'resolved-id set must survive _reset(), or reconnect resurrects resolved items');
    });
  });

  group('permission/elicitation/tool-request (Adapter B: canonical CustomEvent)', () {
    test('acp.permission_request decodes optionsJson and remaps id->optionId', () {
      final r = ConversationReducer();
      r.apply(const CustomEvent(name: 'acp.permission_request', value: {
        'callId': 'p1',
        'toolName': 'bash',
        'description': 'bash: run ls',
        'optionsJson': '[{"id":"allow","label":"Allow","kind":"allow_once"}]',
      }));
      expect(r.current.timeline, hasLength(1));
      final item = r.current.timeline.single as PermissionRequestTimelineItem;
      expect(item.requestId, 'p1');
      expect(item.toolTitle, 'bash');
      expect(item.description, 'bash: run ls');
      expect(item.options.single.optionId, 'allow');
      expect(item.options.single.label, 'Allow');
    });

    test('acp.tool_request produces a ToolRequestTimelineItem', () {
      final r = ConversationReducer();
      r.apply(const CustomEvent(name: 'acp.tool_request', value: {
        'callId': 't1',
        'toolName': 'propose_edit',
        'args': '{"changeId":"c1"}',
      }));
      final item = r.current.timeline.single as ToolRequestTimelineItem;
      expect(item.requestId, 't1');
      expect(item.toolName, 'propose_edit');
      expect(item.argsJson, '{"changeId":"c1"}');
    });

    test(
      'autoResolveToolRequest suppresses the ToolRequestTimelineItem entirely '
      'for tools it returns true for — no insert-then-remove churn',
      () {
        final r = ConversationReducer(
          autoResolveToolRequest: (toolName) => toolName != 'render_surface',
        );
        r.apply(const CustomEvent(name: 'acp.tool_request', value: {
          'callId': 't1',
          'toolName': 'add_comment',
          'args': '{}',
        }));
        expect(r.current.timeline, isEmpty);

        r.apply(const CustomEvent(name: 'acp.tool_request', value: {
          'callId': 't2',
          'toolName': 'render_surface',
          'args': '{}',
        }));
        expect(r.current.timeline, hasLength(1));
        expect(
          (r.current.timeline.single as ToolRequestTimelineItem).requestId,
          't2',
        );
      },
    );

    test(
      'a call_id suppressed by autoResolveToolRequest counts as resolved — '
      'a later resolveRequest for it is a harmless no-op',
      () {
        final r = ConversationReducer(
          autoResolveToolRequest: (toolName) => true,
        );
        r.apply(const CustomEvent(name: 'acp.tool_request', value: {
          'callId': 't1',
          'toolName': 'add_comment',
          'args': '{}',
        }));
        expect(r.current.timeline, isEmpty);
        r.resolveRequest('t1');
        expect(r.current.timeline, isEmpty);
      },
    );

    test('Adapter B items are independent of Adapter A — resolving one A item does not touch a B item', () {
      final r = ConversationReducer();
      r.apply(const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'permission': {
            'requestId': 'a1', 'status': 'pending',
            'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
          }
        }
      }));
      r.apply(const CustomEvent(name: 'acp.permission_request', value: {
        'callId': 'b1', 'toolName': 'x', 'description': 'x', 'optionsJson': '[]',
      }));
      expect(r.current.timeline, hasLength(2));

      // A fresh StateSnapshot rebuild (Adapter A's normal behavior) must not
      // wipe Adapter B's b1 item.
      r.apply(const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'permission': {
            'requestId': 'a1', 'status': 'pending',
            'options': [{'optionId': 'allow', 'name': 'Allow', 'kind': 'allow_once'}],
          }
        }
      }));
      expect(r.current.timeline, hasLength(2));
      expect(r.current.timeline.any((i) => i is PermissionRequestTimelineItem && i.requestId == 'b1'),
          isTrue);
    });
  });

  group('cold replay', () {
    test('sync replace marker resets the accumulator; only post-marker events survive', () {
      final r = ConversationReducer()
        ..apply(const TextMessageStartEvent(messageId: 'stale', role: TextMessageRole.assistant))
        ..apply(const TextMessageEndEvent(messageId: 'stale'))
        ..apply(_sync())
        ..apply(const TextMessageStartEvent(messageId: 'fresh', role: TextMessageRole.assistant))
        ..apply(const TextMessageEndEvent(messageId: 'fresh'));

      expect(r.current.timeline, hasLength(1));
      expect((r.current.timeline.single as TextTimelineItem).id, 'fresh');
    });
  });

  group('run lifecycle (new — pocketcoder had no equivalent before this package)', () {
    // NOTE: RunStartedEvent/RunFinishedEvent require threadId/runId (not
    // const-constructible with zero args) and ToolCallResultEvent requires
    // messageId in ag_ui 0.3.0 — verified against the real package source
    // during plan review. The values below are arbitrary test fixtures,
    // not meaningful IDs.
    test('RUN_STARTED sets isRunning true and clears any prior error', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'));
      expect(r.current.sessionState.isRunning, isTrue);
      expect(r.current.sessionState.runError, isNull);
    });

    test('RUN_FINISHED sets isRunning false', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunFinishedEvent(threadId: 'th1', runId: 'run1'));
      expect(r.current.sessionState.isRunning, isFalse);
    });

    test('RUN_ERROR sets isRunning false and records the error message', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunErrorEvent(message: 'boom'));
      expect(r.current.sessionState.isRunning, isFalse);
      expect(r.current.sessionState.runError, 'boom');
    });

    test('cold replay resets isRunning/runError along with the timeline', () {
      final r = ConversationReducer()
        ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'))
        ..apply(const RunErrorEvent(message: 'boom'))
        ..apply(_sync());
      expect(r.current.sessionState.isRunning, isFalse);
      expect(r.current.sessionState.runError, isNull);
    });
  });

  group('deterministic identity', () {
    test('a repeated ToolCallStartEvent for the same id updates in place, not duplicates', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'search'))
        ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'search'));
      expect(r.current.timeline.whereType<ToolCallTimelineItem>(), hasLength(1));
    });

    test('resolving a tool-request card does not remove its correlated ToolCallTimelineItem', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'add_comment'))
        ..apply(const CustomEvent(
          name: 'acp.tool_request',
          value: {'callId': 'tc1', 'toolName': 'add_comment', 'args': '{}'},
        ));
      r.resolveRequest('tc1');
      expect(r.current.timeline.whereType<ToolCallTimelineItem>(), hasLength(1));
      expect(r.current.timeline.whereType<ToolRequestTimelineItem>(), isEmpty);
    });

    test('a re-synced permission whose requestId changed removes the stale card, not just adds the new one', () {
      final r = ConversationReducer();
      r.apply(const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'permission': {'requestId': 'p1', 'status': 'pending', 'options': []}
        }
      }));
      expect(
        r.current.timeline.whereType<PermissionRequestTimelineItem>().map((i) => i.requestId),
        ['p1'],
      );
      r.apply(const StateSnapshotEvent(snapshot: {
        'pocketcoder': {
          'permission': {'requestId': 'p2', 'status': 'pending', 'options': []}
        }
      }));
      expect(
        r.current.timeline.whereType<PermissionRequestTimelineItem>().map((i) => i.requestId),
        ['p2'],
      );
    });

    test('a reasoning stream and a text stream with the same messageId do not collide', () {
      final r = ConversationReducer()
        ..apply(const ReasoningMessageStartEvent(messageId: 'm1'))
        ..apply(const TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant))
        ..apply(const ReasoningMessageContentEvent(messageId: 'm1', delta: 'thinking...'))
        ..apply(const TextMessageContentEvent(messageId: 'm1', delta: 'hello'));
      expect(r.current.timeline.whereType<TextStreamTimelineItem>(), hasLength(2));
    });

    test(
      'a permission request shares its callId with a tool call (protocol-level, not '
      'a bug — see acp-core stdio.rs) — resolving the permission must not destroy the '
      "correlated ToolCallTimelineItem's data (regression, 2026-08-01)",
      () {
        final r = ConversationReducer()
          ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'add_comment'))
          ..apply(const CustomEvent(
            name: 'acp.permission_request',
            value: {'callId': 'tc1', 'toolName': 'add_comment', 'optionsJson': '[]'},
          ));
        // Both coexist while the permission is pending — the permission card
        // must not overwrite the tool call's own entry.
        expect(r.current.timeline.whereType<ToolCallTimelineItem>(), hasLength(1));
        expect(r.current.timeline.whereType<PermissionRequestTimelineItem>(), hasLength(1));

        r.resolveRequest('tc1');
        expect(r.current.timeline.whereType<PermissionRequestTimelineItem>(), isEmpty);
        expect(
          r.current.timeline.whereType<ToolCallTimelineItem>(),
          hasLength(1),
          reason: 'resolving the permission destroyed the original tool call entry',
        );

        // The tool's real result must land on the ORIGINAL entry — not
        // synthesize a new nameless/detached one at the end of the timeline
        // (the exact symptom this regression covers).
        r.apply(const ToolCallResultEvent(messageId: 'm1', toolCallId: 'tc1', content: 'ok'));
        final toolCalls = r.current.timeline.whereType<ToolCallTimelineItem>().toList();
        expect(toolCalls, hasLength(1));
        expect(toolCalls.single.name, 'add_comment');
        expect(toolCalls.single.result, 'ok');
      },
    );

    test('a tool call and its correlated tool-request survive together in the same timeline', () {
      final r = ConversationReducer()
        ..apply(const ToolCallStartEvent(toolCallId: 'tc1', toolCallName: 'add_comment'))
        ..apply(const CustomEvent(
          name: 'acp.tool_request',
          value: {'callId': 'tc1', 'toolName': 'add_comment', 'args': '{}'},
        ));
      expect(r.current.timeline.whereType<ToolCallTimelineItem>(), hasLength(1));
      expect(r.current.timeline.whereType<ToolRequestTimelineItem>(), hasLength(1));
      // The request anchors right after its tool call, not wherever _seq happens to land.
      expect(r.current.timeline[0], isA<ToolCallTimelineItem>());
      expect(r.current.timeline[1], isA<ToolRequestTimelineItem>());
    });
  });

  group('reduce() convenience wrapper', () {
    test('folds a full event list identically to sequential apply() calls', () {
      final events = [
        const TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant),
        const TextMessageContentEvent(messageId: 'm1', delta: 'hi'),
        const TextMessageEndEvent(messageId: 'm1'),
      ];
      final viaReduce = reduce(events);
      final r = ConversationReducer();
      for (final e in events) {
        r.apply(e);
      }
      expect(viaReduce, r.current);
    });
  });
}
