// lib/src/model/conversation_reducer.dart
// Stateful reducer: BaseEvent in, Conversation out via [current]. NOT a
// pure function — see design spec "The reducer is the fully-shared piece —
// as a stateful object, not a pure fold" for why a pure
// (Conversation, BaseEvent) -> Conversation signature can't work here (the
// accumulator carries bookkeeping — open-message buffers, id->index maps —
// that isn't representable in Conversation's public shape, and rebuilding
// it from Conversation on every call would be O(n) per event).
import 'dart:convert';

import 'package:ag_ui/ag_ui.dart' as ag_ui;
import 'conversation.dart';
import 'wire_parse.dart';

/// True for the cold-replay reset marker backends emit to signal "the client
/// should discard history and rebuild from here": a `<namespace>:sync`
/// CustomEvent whose value has `mode: replace`. [namespace] is required; pass
/// the same value the reducer was constructed with.
bool isReplaceMarker(ag_ui.BaseEvent event, {required String namespace}) =>
    event is ag_ui.CustomEvent &&
    event.name == '$namespace:sync' &&
    (event.value is Map && (event.value as Map)['mode'] == 'replace');

class _OpenMessage {
  _OpenMessage(this.role);
  final String role;
  final StringBuffer text = StringBuffer();
}

/// Incrementally folds a stream of AG-UI [ag_ui.BaseEvent]s into a
/// [Conversation]. One instance per chat session — construct fresh per
/// session, call [apply] once per event, read [current] after each call (or
/// once per batch, callers' choice).
///
/// Storage is a keyed map (`_items`), not a positional list: every item has
/// a stable identity (its reducer-internal storage key, distinct from
/// [TimelineItem.itemId]/[TimelineItem.storageKey] — see the per-key
/// comments below) and an [OrderKey] assigned the first time that key is
/// seen. The displayed timeline is derived by sorting `_items.values` on
/// [OrderKey] at read time, so "is this the same entity" is always an exact
/// key lookup, never positional inference — a repeated start event, a
/// result arriving for an already-tracked tool call, or a re-synced
/// permission all update the existing entry in place instead of risking a
/// second, shadowing one.
class ConversationReducer {
  final Map<String, TimelineItem> _items = {};
  int _seq = 0;
  List<TimelineItem>? _sortedCache;

  final Map<String, _OpenMessage> _openText = {};
  final Map<String, _OpenMessage> _openReasoning = {};
  final Map<String, dynamic> _state = {};

  /// Ids of permission/elicitation cards currently shown *because* the
  /// state-sync path (`_syncPermission`/`_syncElicitation`)
  /// put them there — as opposed to a direct `acp.permission_request`/
  /// `acp.elicitation_request` CustomEvent, which is a different source
  /// entirely. `_syncPermission`/`_syncElicitation` only ever remove/replace
  /// entries whose id is in this set, so a re-sync never touches a card
  /// that came from the direct-CustomEvent path.
  final Set<String> _adapterAIds = {};
  final Set<String> _resolvedIds = {};
  bool _isRunning = false;
  bool _isStarting = false;
  String? _runError;
  RunOutcome? _runOutcome;

  static const int _maxDiagnostics = 200;
  static const int _maxSourceRecords = 200;
  final List<Diagnostic> _diagnostics = [];
  final List<Map<String, dynamic>> _sourceRecords = [];
  int _diagnosticCount = 0; // never reset: Diagnostic.index stays monotonic

  // What is currently reported. A whole-namespace replace arrives on every
  // state change, so a re-sync must not re-report the same problem; an entry
  // leaves its set when the problem goes away, so it is reported again if it
  // comes back.
  final Set<String> _reportedMalformed = {};
  final Set<String> _reportedUnknown = {};
  final Set<String> _reportedContent = {};
  final Set<String> _reportedSnapshotKeys = {};
  final Set<String> _reportedOnce = {};

  String? _threadId;
  String? _runId;
  String? _stopReason;
  String? _runErrorCode;

  AgentState? _agent;
  ModeState? _mode;
  CommandsState? _commands;
  ConfigState? _configState;
  UsageState? _usage;
  SessionInfo? _sessionInfo;
  PlansState _plans = const PlansState();

  int _mediaCount = 0;
  Map<String, dynamic> _responseMeta = const {};

  /// Called with a tool's name for every incoming `acp.client_execute_request`; return
  /// `true` to skip creating a [ToolRequestTimelineItem] for it entirely.
  ///
  /// Some tools resolve themselves near-instantly with no user decision
  /// involved (a local write, no permission dialog) — for those, a pending
  /// card would be inserted and removed again within one event-loop tick,
  /// which is pure churn: no UI ever needs to show it, and the insert+remove
  /// pair was previously left to callers to suppress by calling
  /// [resolveRequest] synchronously right after dispatch. That worked, but
  /// pushed a decision that belongs to protocol semantics ("does this tool
  /// need a human in the loop?") into every caller of [apply]. Leaving this
  /// null preserves the old always-insert behavior.
  final bool Function(String toolName)? autoResolveToolRequest;

  /// The backend's wire namespace. Backends that project state and tool
  /// metadata namespace their CustomEvents as `<namespace>:tool`,
  /// `<namespace>:diff` and `<namespace>:sync`, and root their state tree
  /// (STATE_SNAPSHOT key, STATE_DELTA path prefix) at `/<namespace>`. Required,
  /// with no default: each backend passes its own (e.g. episutra's
  /// `acp-agui-adapter` is constructed with a namespace of its own). Fixed protocol-level events
  /// (`acp.*`) are not namespaced and do not depend on this.
  final String namespace;

  ConversationReducer({
    required this.namespace,
    this.autoResolveToolRequest,
  });

  Conversation get current => Conversation(
        timeline: List.unmodifiable(_sortedTimeline),
        sessionState: _sessionState(),
        diagnostics: List.unmodifiable(_diagnostics),
        sourceRecords: List.unmodifiable(_sourceRecords),
      );

  /// Inserts a message directly into the timeline, bypassing the AG-UI
  /// event stream entirely — for a caller that needs to reflect something
  /// it already knows locally before (or independent of) a backend echo,
  /// e.g. optimistic display of a just-sent user prompt. Goes through the
  /// same [_upsert] identity/ordering machinery as every event-sourced
  /// entry, so a later real event sharing [id] updates this entry in place
  /// instead of producing a duplicate.
  void addLocalMessage({
    required String id,
    required String role,
    required String text,
  }) {
    _upsert(
      id,
      (order) => TimelineItem.text(
        id: id,
        kind: ChatMessageKind.text,
        role: role,
        text: text,
        order: order,
      ),
    );
  }

  /// Insert-or-replace by stable key. The FIRST time [key] is seen, [build]
  /// receives a fresh [OrderKey] anchored at the current event's sequence
  /// number; every later call for the same [key] reuses that same order, so
  /// updates (streaming deltas, tool result arriving) never move an item.
  void _upsert(String key, TimelineItem Function(OrderKey order) build) {
    final existingOrder = _items[key]?.order;
    _items[key] = build(existingOrder ?? OrderKey(_seq));
    _sortedCache = null;
  }

  void _removeKey(String key) {
    if (_items.remove(key) != null) _sortedCache = null;
  }

  /// Removes every entry matching [test] whose identifying id is in
  /// [_adapterAIds] — the keyed equivalent of the old positional
  /// `_removeAdapterAItemsWhere`.
  void _removeAdapterItemsWhere(bool Function(TimelineItem) test) {
    final before = _items.length;
    _items.removeWhere((_, item) {
      final id = switch (item) {
        PermissionRequestTimelineItem(:final requestId) => requestId,
        ElicitationRequestTimelineItem(:final requestId) => requestId,
        _ => null,
      };
      return test(item) && id != null && _adapterAIds.contains(id);
    });
    if (_items.length != before) _sortedCache = null;
  }

  List<TimelineItem> get _sortedTimeline => _sortedCache ??=
      (_items.values.toList()..sort((a, b) => a.order.compareTo(b.order)));

  void apply(ag_ui.BaseEvent event) {
    _seq++;
    if (isReplaceMarker(event, namespace: namespace)) {
      _reset();
      return;
    }
    switch (event) {
      case ag_ui.RunStartedEvent(:final threadId, :final runId):
        _isRunning = true;
        _runError = null;
        _runOutcome = null;
        _threadId = threadId;
        _runId = runId;
        _stopReason = null;
        _runErrorCode = null;
      case ag_ui.RunFinishedEvent(:final result):
        _isRunning = false;
        _isStarting = false;
        final stopReason =
            result is Map ? asString(result['stopReason']) : null;
        _stopReason = stopReason;
        _runOutcome = switch (stopReason) {
          'cancelled' => RunOutcome.cancelled,
          null => RunOutcome.success,
          _ => RunOutcome.success,
        };
      case ag_ui.RunErrorEvent(:final message, :final code):
        _isRunning = false;
        _isStarting = false;
        _runError = message;
        _runErrorCode = code;
        _runOutcome = code == 'connection_interrupted'
            ? RunOutcome.interrupted
            : RunOutcome.failed;

      case ag_ui.TextMessageStartEvent():
        final open = _OpenMessage(event.role.value);
        _openText[event.messageId] = open;
        _upsert(
          event.messageId,
          (order) => TimelineItem.textStream(
            id: event.messageId,
            role: open.role,
            text: '',
            order: order,
          ),
        );
      case ag_ui.TextMessageContentEvent():
        var open = _openText[event.messageId];
        if (open == null) {
          open = _OpenMessage('assistant');
          _openText[event.messageId] = open;
        }
        open.text.write(event.delta);
        final text = open.text.toString();
        final role = open.role;
        _upsert(
          event.messageId,
          (order) => TimelineItem.textStream(
            id: event.messageId,
            role: role,
            text: text,
            order: order,
          ),
        );
      case ag_ui.TextMessageEndEvent():
        final open = _openText.remove(event.messageId);
        if (open != null) {
          _upsert(
            event.messageId,
            (order) => TimelineItem.text(
              id: event.messageId,
              kind: ChatMessageKind.text,
              role: open.role,
              text: open.text.toString(),
              order: order,
            ),
          );
        }

      case ag_ui.ReasoningMessageStartEvent():
        final open = _OpenMessage(event.role.value);
        _openReasoning[event.messageId] = open;
        _upsert(
          'reasoning:${event.messageId}',
          (order) => TimelineItem.textStream(
            id: event.messageId,
            kind: ChatMessageKind.reasoning,
            role: open.role,
            text: '',
            order: order,
          ),
        );
      case ag_ui.ReasoningMessageContentEvent():
        final open = _openReasoning.putIfAbsent(
            event.messageId, () => _OpenMessage('assistant'));
        open.text.write(event.delta);
        final text = open.text.toString();
        final role = open.role;
        _upsert(
          'reasoning:${event.messageId}',
          (order) => TimelineItem.textStream(
            id: event.messageId,
            kind: ChatMessageKind.reasoning,
            role: role,
            text: text,
            order: order,
          ),
        );
      case ag_ui.ReasoningMessageEndEvent():
        final open = _openReasoning.remove(event.messageId);
        if (open != null) {
          _upsert(
            'reasoning:${event.messageId}',
            (order) => TimelineItem.text(
              id: event.messageId,
              kind: ChatMessageKind.reasoning,
              role: open.role,
              text: open.text.toString(),
              order: order,
            ),
          );
        }

      case ag_ui.ToolCallStartEvent():
        // Merges into any entry already synthesized by an earlier
        // <namespace>:tool/diff/etc. event instead of overwriting it — a
        // fresh construction here would clobber toolKind/diffs/result that
        // arrived before this event (see the reducer test covering that
        // ordering).
        _upsert(event.toolCallId, (order) {
          final existing = _items[event.toolCallId];
          final base = existing is ToolCallTimelineItem
              ? existing
              : TimelineItem.toolCall(
                  id: event.toolCallId,
                  name: event.toolCallName,
                  order: order,
                ) as ToolCallTimelineItem;
          return base.copyWith(
            name:
                event.toolCallName.isNotEmpty ? event.toolCallName : base.name,
          );
        });
      case ag_ui.ToolCallArgsEvent():
        _updateTool(
            event.toolCallId, (t) => t.copyWith(args: t.args + event.delta));
      case ag_ui.ToolCallResultEvent():
        _updateTool(
          event.toolCallId,
          (t) => t.copyWith(
            result: event.content,
            resultParts: [
              ...t.resultParts,
              ToolResultPart(
                  messageId: event.messageId, content: event.content),
            ],
          ),
        );
      case ag_ui.ToolCallEndEvent():
        _updateTool(event.toolCallId, (t) => t.copyWith(hasEnded: true));

      case ag_ui.CustomEvent(name: final name) when name == '$namespace:tool':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        if (value == null || toolCallId == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          final title = value['title'];
          final kind = value['kind'];
          final status = value['status'];
          final rawLocations = value['locations'];
          List<ToolLocation>? locations;
          if (rawLocations is List) {
            locations = [
              for (final l in rawLocations)
                if (ToolLocation.parse(l) case final loc?) loc,
            ];
            if (locations.length != rawLocations.length) {
              _diagnoseOnce(DiagnosticKind.malformedPayload, '$name/locations',
                  rawLocations);
            }
          } else if (value.containsKey('locations')) {
            // Not a list: keep the locations already known rather than
            // clearing them on junk.
            _diagnoseOnce(DiagnosticKind.malformedPayload, '$name/locations',
                rawLocations);
          }
          final meta = asJsonMap(value['meta']);
          _updateTool(
            toolCallId,
            (t) => t.copyWith(
              name: t.name.isEmpty && title is String && title.isNotEmpty
                  ? title
                  : t.name,
              toolKind: kind is String && kind.isNotEmpty ? kind : t.toolKind,
              status: status is String && status.isNotEmpty ? status : t.status,
              locations: locations ?? t.locations,
              meta: meta ?? t.meta,
            ),
          );
        }

      case ag_ui.CustomEvent(name: 'acp.permission_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            final rawOptionsJson = value['optionsJson'];
            Object? rawOptions;
            if (rawOptionsJson == null) {
              rawOptions = const [];
            } else if (rawOptionsJson is String) {
              try {
                rawOptions = jsonDecode(rawOptionsJson);
              } on FormatException {
                _diagnose(DiagnosticKind.malformedPayload,
                    'acp.permission_request/optionsJson', rawOptionsJson);
              }
            } else {
              _diagnose(DiagnosticKind.malformedPayload,
                  'acp.permission_request/optionsJson', rawOptionsJson);
            }
            final options = (rawOptions is List ? rawOptions : const [])
                .whereType<Map>()
                .map((o) => PermissionOption(
                      optionId: asString(o['id']) ?? '',
                      label: asString(o['label']) ?? '',
                      kind: asString(o['kind']) ?? '',
                    ))
                .toList();
            // Namespaced ('perm:$callId', not bare $callId) — an ACP
            // permission request's callId IS the tool call's own id by
            // protocol design (acp-core/src/transport/stdio.rs sets
            // call_id = req.tool_call.tool_call_id), so storing at the
            // bare key overwrote the ToolCallTimelineItem already living
            // there instead of coexisting with it. Once resolveRequest
            // removed that (overwritten) entry, the tool call's real
            // name/args were gone — its later TOOL_CALL_RESULT then had
            // nothing to update and synthesized a new, nameless,
            // detached-at-the-end entry (see the regression test "a
            // permission request shares its callId with a tool call").
            // Same fix shape as `req:$callId` for ToolRequestTimelineItem
            // just above — including anchoring to the tool call's own
            // OrderKey (sub-order 1) so the card still lands right after
            // its call even out of stream-order. Previously this fell out
            // for free (same key = same order, as a side effect of
            // overwriting); now that the key is namespaced, it must be
            // anchored explicitly or the card would land wherever `_seq`
            // happens to be when the permission event itself arrives.
            final correlatedTool = _items[callId];
            final anchor = correlatedTool?.order;
            _upsert(
              'perm:$callId',
              (order) => TimelineItem.permissionRequest(
                requestId: callId,
                toolTitle: asString(value['toolName']),
                description: asString(value['description']),
                toolCallId: callId,
                toolArgs: correlatedTool is ToolCallTimelineItem
                    ? correlatedTool.args
                    : null,
                options: options,
                order: anchor != null ? OrderKey(anchor.seq, 1) : order,
              ),
            );
          } else {
            _diagnoseOnce(DiagnosticKind.malformedPayload,
                'acp.permission_request', value);
          }
        } else {
          _diagnoseOnce(
              DiagnosticKind.malformedPayload, 'acp.permission_request', value);
        }
      case ag_ui.CustomEvent(name: 'acp.elicitation_request', :final value):
        if (value is Map) {
          final requestId = value['requestId'];
          if (requestId is String) {
            _upsert(
              requestId,
              (order) => TimelineItem.elicitationRequest(
                requestId: requestId,
                message: asString(value['message']) ?? '',
                mode: asString(value['mode']) ?? 'form',
                schema: value['schema'] is Map
                    ? Map<String, dynamic>.from(value['schema'] as Map)
                    : null,
                url: asString(value['url']),
                order: order,
              ),
            );
          } else {
            _diagnoseOnce(DiagnosticKind.malformedPayload,
                'acp.elicitation_request', value);
          }
        } else {
          _diagnoseOnce(DiagnosticKind.malformedPayload,
              'acp.elicitation_request', value);
        }
      case ag_ui.CustomEvent(name: 'acp.client_execute_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            final toolName = asString(value['toolName']) ?? '';
            if (autoResolveToolRequest?.call(toolName) ?? false) {
              _resolvedIds.add(callId);
            } else {
              // Namespaced away from the tool-call's own key ('$callId')
              // so the two coexist as distinct entities — see
              // TimelineItem.storageKey's doc comment. Anchored to the
              // tool call's OrderKey (sub-order 1) so it lands right after
              // the call even if this event arrives out of stream-order.
              final anchor = _items[callId]?.order;
              _upsert(
                'req:$callId',
                (order) => TimelineItem.toolRequest(
                  requestId: callId,
                  toolName: toolName,
                  argsJson: _argsToJson(value['args']),
                  order: anchor != null ? OrderKey(anchor.seq, 1) : order,
                ),
              );
            }
          } else {
            _diagnoseOnce(DiagnosticKind.malformedPayload,
                'acp.client_execute_request', value);
          }
        } else {
          _diagnoseOnce(DiagnosticKind.malformedPayload,
              'acp.client_execute_request', value);
        }
      case ag_ui.CustomEvent(name: 'acp.session_phase', :final value):
        if (value is Map) {
          switch (value['phase']) {
            case 'starting':
              _isStarting = true;
            case 'ready':
              _isStarting = false;
            default:
              _diagnoseOnce(
                  DiagnosticKind.unknownCustom, 'acp.session_phase', value);
          }
        } else {
          _diagnoseOnce(
              DiagnosticKind.malformedPayload, 'acp.session_phase', value);
        }
      case ag_ui.CustomEvent(name: final name) when name == '$namespace:diff':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        final content = value == null ? null : ToolContent.parse(value);
        if (toolCallId == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else if (content is ToolContentDiff) {
          _updateTool(
              toolCallId, (t) => t.copyWith(diffs: [...t.diffs, content.diff]));
        } else if (content is ToolContentPatch) {
          _updateTool(toolCallId,
              (t) => t.copyWith(patches: [...t.patches, content.patch]));
        } else {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        }
      case ag_ui.CustomEvent(name: final name)
          when name == '$namespace:terminal':
        final value = asJsonMap(event.value);
        final toolCallId = asString(value?['toolCallId']);
        final terminal = ToolTerminal.parse(value);
        if (toolCallId == null ||
            terminal == null ||
            terminal.terminalId.isEmpty) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          _updateTool(toolCallId,
              (t) => t.copyWith(terminals: [...t.terminals, terminal]));
        }
      case ag_ui.CustomEvent(name: final name)
          when name == '$namespace:content':
        final media = MediaDescriptor.parse(event.value);
        if (media == null || media.kind.isEmpty) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else if (media.toolCallId != null) {
          _updateTool(
              media.toolCallId!, (t) => t.copyWith(media: [...t.media, media]));
        } else {
          final id = 'media:${_mediaCount++}';
          _upsert(
            id,
            (order) => TimelineItem.media(
              id: id,
              messageId: media.messageId,
              media: media,
              order: order,
            ),
          );
        }
      case ag_ui.CustomEvent(name: final name)
          when name == '$namespace:response_meta':
        final value = asJsonMap(event.value);
        final method = asString(value?['method']);
        if (method == null) {
          _diagnose(DiagnosticKind.malformedPayload, name, event.value);
        } else {
          _responseMeta = {..._responseMeta, method: value!['meta']};
        }

      case ag_ui.CustomEvent(name: 'acp:source', :final value):
        _recordSource(value);
      case ag_ui.RawEvent(:final event):
        _diagnose(DiagnosticKind.raw, 'raw', event);
      case ag_ui.CustomEvent(:final name, :final value):
        _diagnose(DiagnosticKind.unknownCustom, name, value);

      case ag_ui.StateSnapshotEvent():
        final snapshot = event.snapshot;
        _state.clear();
        if (snapshot is Map) {
          final nsState = snapshot[namespace];
          if (nsState is Map) {
            _state.addAll(Map<String, dynamic>.from(nsState));
          } else if (nsState != null) {
            // The snapshot stays authoritative (state is cleared), but a
            // namespace entry that is not a map is a wire problem.
            _diagnose(DiagnosticKind.malformedPayload, 'snapshot/$namespace',
                nsState);
          }
        }
        _syncPermission();
        _syncElicitation();
        _onStateChanged();
        if (snapshot is Map) {
          // Forget keys that are gone, so one that comes back is reported again.
          _reportedSnapshotKeys
              .retainAll({for (final k in snapshot.keys) '$k'});
          for (final key in snapshot.keys) {
            if (key != namespace && _reportedSnapshotKeys.add('$key')) {
              _diagnose(DiagnosticKind.unknownStateKey, 'snapshot/$key',
                  snapshot[key]);
            }
          }
        } else {
          _reportedSnapshotKeys.clear();
          if (snapshot != null) {
            _diagnose(DiagnosticKind.malformedPayload, 'snapshot', snapshot);
          }
        }
      case ag_ui.StateDeltaEvent():
        for (final op in event.delta) {
          _applyPatch(op);
        }

      default:
        _diagnose(DiagnosticKind.unhandledEvent, event.eventType.value,
            event.toJson());
    }
  }

  void _reset() {
    // _resolvedIds is deliberately NOT cleared here — see resolveRequest's
    // doc comment. Clearing it would resurrect already-resolved
    // permission/elicitation/tool-request cards on every
    // reconnect replay, since the backend never clears its own state.
    // _adapterAIds is likewise left untouched, matching the pre-rewrite
    // reducer's _reset (it never cleared _adapterAIds either).
    _items.clear();
    _seq = 0;
    _sortedCache = null;
    _openText.clear();
    _openReasoning.clear();
    _state.clear();
    _isRunning = false;
    _isStarting = false;
    _runError = null;
    _runOutcome = null;
    _threadId = null;
    _runId = null;
    _stopReason = null;
    _runErrorCode = null;
    _mediaCount = 0;
    _responseMeta = const {};
    // Reset typed state fields only. Do NOT clear _diagnostics,
    // _sourceRecords, _diagnosticCount or the _reported* sets — they
    // describe what the reducer has seen, and a replay re-sends the same state.
    _agent = null;
    _mode = null;
    _commands = null;
    _configState = null;
    _usage = null;
    _sessionInfo = null;
    _plans = const PlansState();
  }

  void _updateTool(
    String id,
    ToolCallTimelineItem Function(ToolCallTimelineItem) update,
  ) {
    _upsert(id, (order) {
      final current = _items[id];
      final base = current is ToolCallTimelineItem
          ? current
          : TimelineItem.toolCall(id: id, name: '', order: order)
              as ToolCallTimelineItem;
      return update(base);
    });
  }

  /// Upper bound on every `_reported*` dedupe set that is keyed by wire
  /// content (not by a state key that is pruned when it goes away).
  static const int _maxReportedKeys = 500;

  /// Adds [key] to [set], first clearing the set if it is at the cap — a
  /// bounded dedupe: worst case a very old problem is reported once more.
  static bool _firstTime(Set<String> set, String key) {
    if (set.length >= _maxReportedKeys) set.clear();
    return set.add(key);
  }

  /// [_diagnose], but only the first time this exact (kind, name, payload)
  /// is seen, so a producer repeating the same bad event cannot flood the
  /// bounded diagnostics list.
  void _diagnoseOnce(DiagnosticKind kind, String name, [Object? payload]) {
    if (_firstTime(_reportedOnce, '${kind.name}|$name|$payload')) {
      _diagnose(kind, name, payload);
    }
  }

  void _diagnose(DiagnosticKind kind, String name, [Object? payload]) {
    _diagnostics.add(Diagnostic(
      kind: kind,
      name: name,
      payload: payload,
      index: _diagnosticCount++,
    ));
    if (_diagnostics.length > _maxDiagnostics) {
      _diagnostics.removeRange(0, _diagnostics.length - _maxDiagnostics);
    }
  }

  /// Keeps an `acp:source` wire record. Kept apart from [_diagnostics]: there
  /// is one per batch, so sharing a bounded list would let routine traffic
  /// evict real diagnostics.
  void _recordSource(Object? value) {
    final record = asJsonMap(value);
    if (record == null) {
      _diagnose(DiagnosticKind.malformedPayload, 'acp:source', value);
      return;
    }
    _sourceRecords.add(record);
    if (_sourceRecords.length > _maxSourceRecords) {
      _sourceRecords.removeRange(0, _sourceRecords.length - _maxSourceRecords);
    }
  }

  /// Re-reads the typed models from the raw `/<namespace>` map. Called after
  /// every state change. State is mirrored: a key that is gone becomes null.
  void _onStateChanged() {
    T? typed<T>(String key, T? Function(Object?) parse) {
      final raw = _state[key];
      if (raw == null) {
        _reportedMalformed.remove(key);
        return null;
      }
      final value = parse(raw);
      if (value == null) {
        if (_reportedMalformed.add(key)) {
          _diagnose(DiagnosticKind.malformedPayload, '$namespace/$key', raw);
        }
      } else {
        _reportedMalformed.remove(key);
      }
      return value;
    }

    _agent = typed('agent', AgentState.parse);
    _mode = typed('mode', ModeState.parse);
    _commands = typed('commands', CommandsState.parse);
    _configState = typed('config', ConfigState.parse);
    _usage = typed('usage', UsageState.parse);
    _sessionInfo = typed('session_info', SessionInfo.parse);
    _plans = typed('plans', PlansState.parse) ?? const PlansState();

    final unknownNow = {
      for (final k in _state.keys)
        if (!_knownStateKeys.contains(k)) k,
    };
    _reportedUnknown.retainAll(unknownNow);
    for (final key in unknownNow) {
      if (_reportedUnknown.add(key)) {
        _diagnose(
            DiagnosticKind.unknownStateKey, '$namespace/$key', _state[key]);
      }
    }
  }

  static const _knownStateKeys = {
    'agent',
    'mode',
    'commands',
    'config',
    'usage',
    'session_info',
    'plans',
    'permissions',
    'elicitations',
  };

  /// Pending state entries of one kind, from the keyed map
  /// (`<byIdKey>.by-id`, any number pending at once — acp-agui-adapter).
  Iterable<Map> _stateEntries(String byIdKey) sync* {
    final keyed = _state[byIdKey];
    final byId = keyed is Map ? keyed['by-id'] : null;
    if (byId is Map) {
      for (final entry in byId.values) {
        if (entry is Map) yield entry;
      }
    }
  }

  // Both syncs drop only the cards that are no longer pending and update the
  // rest in place. A whole-namespace replace arrives on EVERY state change
  // (a usage tick, a mode change), so removing and re-adding every card would
  // hand each a fresh order key and move it to the end of the timeline.
  void _syncPermission() {
    final entries = _stateEntries('permissions').toList();
    final pending = {
      for (final e in entries)
        if (e['requestId'] is String) e['requestId'] as String,
    };
    _removeAdapterItemsWhere((item) =>
        item is PermissionRequestTimelineItem &&
        !pending.contains(item.requestId));
    entries.forEach(_upsertPermission);
  }

  void _upsertPermission(Map permission) {
    final requestId = permission['requestId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    const permissionKnown = {
      'requestId',
      'sessionId',
      'toolCallId',
      'title',
      'kind',
      'options',
      'content',
      'meta',
    };
    final options = [
      for (final o in asJsonMapList(permission['options']))
        PermissionOption(
          optionId: asString(o['optionId']) ?? '',
          label: asString(o['name']) ?? '',
          kind: asString(o['kind']) ?? '',
          extras: extrasOf(o, const {'optionId', 'name', 'kind'}),
        ),
    ];
    final content = <ToolContent>[];
    final rawContent = permission['content'];
    if (rawContent is List) {
      for (final c in rawContent) {
        final parsed = ToolContent.parse(c);
        if (parsed == null) {
          if (_firstTime(_reportedContent, '$requestId|$c')) {
            _diagnose(DiagnosticKind.malformedPayload,
                '$namespace/permissions/content', c);
          }
        } else {
          content.add(parsed);
        }
      }
    }
    final toolCallId = permission['toolCallId'];
    final correlatedTool = toolCallId is String ? _items[toolCallId] : null;
    final anchor = correlatedTool?.order;
    _adapterAIds.add(requestId);
    _upsert(
      requestId,
      (order) => TimelineItem.permissionRequest(
        requestId: requestId,
        toolTitle: asString(permission['title']),
        toolKind: asString(permission['kind']),
        toolCallId: toolCallId is String ? toolCallId : null,
        toolArgs:
            correlatedTool is ToolCallTimelineItem ? correlatedTool.args : null,
        options: options,
        order: anchor != null ? OrderKey(anchor.seq, 1) : order,
        content: content,
        meta: asJsonMap(permission['meta']),
        sessionId: asString(permission['sessionId']),
        extras:
            extrasOf(Map<String, dynamic>.from(permission), permissionKnown),
      ),
    );
  }

  void _syncElicitation() {
    final entries = _stateEntries('elicitations').toList();
    final pending = {
      for (final e in entries)
        if (e['elicitationId'] is String) e['elicitationId'] as String,
    };
    _removeAdapterItemsWhere((item) =>
        item is ElicitationRequestTimelineItem &&
        !pending.contains(item.requestId));
    entries.forEach(_upsertElicitation);
  }

  void _upsertElicitation(Map elicitation) {
    final requestId = elicitation['elicitationId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    final message = asString(elicitation['message']) ?? '';
    // `mode` is a tagged object — `{kind: form, schema}` / `{kind: url, url}`.
    final rawMode = elicitation['mode'];
    final String mode;
    final Object? schema;
    final String? url;
    if (rawMode is Map) {
      mode = asString(rawMode['kind']) ?? 'form';
      schema = rawMode['schema'];
      url = asString(rawMode['url']);
    } else {
      mode = 'form';
      schema = null;
      url = null;
      // A string mode (the old `requestedSchema`/`url`-beside-it shape) is no
      // longer read; say so once. Those sibling keys stay in `extras`.
      if (rawMode != null &&
          _firstTime(_reportedContent, 'mode|$requestId|$rawMode')) {
        _diagnose(DiagnosticKind.malformedPayload,
            '$namespace/elicitations/mode', rawMode);
      }
    }
    _adapterAIds.add(requestId);
    _upsert(
      requestId,
      (order) => TimelineItem.elicitationRequest(
        requestId: requestId,
        message: message,
        mode: mode,
        schema: schema is Map ? Map<String, dynamic>.from(schema) : null,
        url: url,
        order: order,
        scope: ElicitationScope.parse(elicitation['scope']),
        meta: asJsonMap(elicitation['meta']),
        rawMode: rawMode is Map ? Map<String, dynamic>.from(rawMode) : null,
        extras: extrasOf(Map<String, dynamic>.from(elicitation),
            const {'elicitationId', 'message', 'mode', 'scope', 'meta'}),
      ),
    );
  }

  /// Resolves a pending permission/elicitation/tool-request: removes it from
  /// the timeline immediately, and remembers it as resolved so a later
  /// replay of the same backend state (a backend that never clears
  /// its own state namespace server-side — see the design spec's
  /// "Resolution" section) does not resurrect it. Survives `_reset()`
  /// deliberately — see that method.
  void resolveRequest(String requestId) {
    _resolvedIds.add(requestId);
    // The bare `requestId` key may belong to a state-sync
    // permission/elicitation card, which uses bare keys — its `requestId`
    // is a distinct id from its `toolCallId` field, so no collision risk
    // there, unlike the direct-event path below. But for a
    // resolved tool-request, `requestId` is the same value as its tool
    // call's own key (`callId`), and that ToolCallTimelineItem must NOT be
    // removed. Only remove the bare key when it actually holds a
    // request-type item.
    final atBareKey = _items[requestId];
    if (atBareKey is PermissionRequestTimelineItem ||
        atBareKey is ElicitationRequestTimelineItem) {
      _removeKey(requestId);
    }
    _removeKey('req:$requestId');
    // The direct `acp.permission_request` CustomEvent path (unlike the
    // state-sync path above) stores at 'perm:$requestId', not the bare key — see
    // that case in apply()'s doc comment for why. Harmless no-op if this
    // requestId was never a direct-event permission (or already resolved).
    _removeKey('perm:$requestId');
    _adapterAIds.remove(requestId);
  }

  /// `acp.client_execute_request` carries the tool's arguments as a JSON
  /// value (an object for a normal call). A producer that already holds the
  /// encoded text may send a string instead; both land as the JSON text
  /// [TimelineItem.toolRequest] stores. Absent or null means no arguments.
  static String _argsToJson(Object? args) {
    if (args == null) return '{}';
    if (args is String) return args;
    return jsonEncode(args);
  }

  void _applyPatch(Map<String, dynamic> op) {
    final path = op['path'];
    final kind = op['op'];
    if (path is! String ||
        kind is! String ||
        (kind != 'add' && kind != 'replace' && kind != 'remove')) {
      _diagnose(DiagnosticKind.malformedPayload, '$namespace/patch', op);
      return;
    }
    final segments = [
      for (final s in path.split('/'))
        if (s.isNotEmpty) _unescapePointer(s),
    ];
    if (segments.isEmpty || segments.first != namespace) {
      _diagnose(DiagnosticKind.unknownStateKey, path, op);
      return;
    }
    final keys = segments.sublist(1);
    if (keys.isEmpty) {
      // The whole namespace at once — acp-agui-adapter sends every state
      // change as a `replace` of `/<namespace>` carrying the full state.
      final value = op['value'];
      if (kind != 'remove' && value is! Map) {
        // Not a state tree: leave the current state untouched and say so,
        // rather than silently wiping everything.
        _diagnose(DiagnosticKind.malformedPayload, '$namespace/patch', op);
        return;
      }
      _state.clear();
      if (kind != 'remove') {
        _state.addAll(Map<String, dynamic>.from(value as Map));
      }
    } else if (!_setAt(_state, keys, op['value'], remove: kind == 'remove')) {
      // Descends through a value that exists but is not a map (e.g. a list
      // index). Leave the state untouched rather than corrupt it, and say so.
      _diagnose(DiagnosticKind.malformedPayload, '$namespace/patch', op);
      return;
    }
    _syncPermission();
    _syncElicitation();
    _onStateChanged();
  }

  static String _unescapePointer(String s) =>
      s.replaceAll('~1', '/').replaceAll('~0', '~');

  /// Sets or removes [keys] under [root], copying each map on the way so no
  /// map the caller (or a typed model) still holds is mutated. Returns false,
  /// changing nothing, when the path would descend through an existing value
  /// that is not a map (a list, a scalar).
  static bool _setAt(
    Map<String, dynamic> root,
    List<String> keys,
    Object? value, {
    required bool remove,
  }) {
    Object? probe = root;
    for (var i = 0; i < keys.length - 1; i++) {
      probe = (probe as Map)[keys[i]];
      if (probe == null) {
        // Removing through a parent that does not exist: nothing to remove,
        // and the loop below must not create the missing parents.
        if (remove) return true;
        break;
      }
      if (probe is! Map) return false;
    }
    var current = root;
    for (var i = 0; i < keys.length - 1; i++) {
      final next = current[keys[i]];
      final child =
          next is Map ? Map<String, dynamic>.from(next) : <String, dynamic>{};
      current[keys[i]] = child;
      current = child;
    }
    if (remove) {
      current.remove(keys.last);
    } else {
      current[keys.last] = value;
    }
    return true;
  }

  SessionState _sessionState() {
    return SessionState(
      title: _sessionInfo?.title,
      isRunning: _isRunning,
      isStarting: _isStarting,
      runError: _runError,
      runOutcome: _runOutcome,
      threadId: _threadId,
      runId: _runId,
      stopReason: _stopReason,
      runErrorCode: _runErrorCode,
      agent: _agent,
      mode: _mode,
      commands: _commands,
      configState: _configState,
      usage: _usage,
      sessionInfo: _sessionInfo,
      plans: _plans,
      responseMeta: _responseMeta,
    );
  }
}

/// Convenience wrapper for callers holding a full event list (e.g.
/// a cache-replay `AgentChatRepository.watch()` — see Task 8).
/// Equivalent to constructing a fresh [ConversationReducer] and applying
/// every event in order.
Conversation reduce(
  List<ag_ui.BaseEvent> events, {
  required String namespace,
}) {
  final r = ConversationReducer(namespace: namespace);
  for (final event in events) {
    r.apply(event);
  }
  return r.current;
}
