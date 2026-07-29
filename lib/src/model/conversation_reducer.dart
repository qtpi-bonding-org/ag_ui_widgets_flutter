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

/// True for the cold-replay reset marker c1/goose-style backends emit to
/// signal "the client should discard history and rebuild from here" —
/// pocketcoder's specific wire vocabulary, harmless to recognize
/// universally since no other backend emits a CustomEvent with this name.
bool isReplaceMarker(ag_ui.BaseEvent event) =>
    event is ag_ui.CustomEvent &&
    event.name == 'pocketcoder:sync' &&
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
  final Map<String, dynamic> _pocketcoder = {};

  /// Ids of permission/elicitation cards currently shown *because* the
  /// pocketcoder state-sync path (`_syncPermission`/`_syncElicitation`)
  /// put them there — as opposed to a direct `acp.permission_request`/
  /// `acp.elicitation_request` CustomEvent, which is a different source
  /// entirely. `_syncPermission`/`_syncElicitation` only ever remove/replace
  /// entries whose id is in this set, so a re-sync never touches a card
  /// that came from the direct-CustomEvent path.
  final Set<String> _adapterAIds = {};
  final Set<String> _resolvedIds = {};
  bool _isRunning = false;
  String? _runError;

  /// Called with a tool's name for every incoming `acp.tool_request`; return
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

  ConversationReducer({this.autoResolveToolRequest});

  Conversation get current => Conversation(
        timeline: List.unmodifiable(_sortedTimeline),
        sessionState: _sessionState(),
      );

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
    if (isReplaceMarker(event)) {
      _reset();
      return;
    }
    switch (event) {
      case ag_ui.RunStartedEvent():
        _isRunning = true;
        _runError = null;
      case ag_ui.RunFinishedEvent():
        _isRunning = false;
      case ag_ui.RunErrorEvent(:final message):
        _isRunning = false;
        _runError = message;

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
        _upsert(
          event.toolCallId,
          (order) => TimelineItem.toolCall(
            id: event.toolCallId,
            name: event.toolCallName,
            order: order,
          ),
        );
      case ag_ui.ToolCallArgsEvent():
        _updateTool(event.toolCallId, (t) => t.copyWith(args: t.args + event.delta));
      case ag_ui.ToolCallResultEvent():
        _updateTool(event.toolCallId, (t) => t.copyWith(result: event.content));
      case ag_ui.ToolCallEndEvent():
        break; // terminal state is "has a result"; nothing to flip here.

      case ag_ui.CustomEvent(name: 'acp.permission_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            final optionsJson = value['optionsJson'] as String? ?? '[]';
            final rawOptions = jsonDecode(optionsJson);
            final options = (rawOptions is List ? rawOptions : const [])
                .whereType<Map>()
                .map((o) => PermissionOption(
                      optionId: (o['id'] as String?) ?? '',
                      label: (o['label'] as String?) ?? '',
                      kind: (o['kind'] as String?) ?? '',
                    ))
                .toList();
            _upsert(
              callId,
              (order) => TimelineItem.permissionRequest(
                requestId: callId,
                toolTitle: value['toolName'] as String?,
                description: value['description'] as String?,
                options: options,
                order: order,
              ),
            );
          }
        }
      case ag_ui.CustomEvent(name: 'acp.elicitation_request', :final value):
        if (value is Map) {
          final requestId = value['requestId'];
          if (requestId is String) {
            _upsert(
              requestId,
              (order) => TimelineItem.elicitationRequest(
                requestId: requestId,
                message: (value['message'] as String?) ?? '',
                mode: (value['mode'] as String?) ?? 'form',
                schema: value['schema'] is Map
                    ? Map<String, dynamic>.from(value['schema'] as Map)
                    : null,
                url: value['url'] as String?,
                order: order,
              ),
            );
          }
        }
      case ag_ui.CustomEvent(name: 'acp.tool_request', :final value):
        if (value is Map) {
          final callId = value['callId'];
          if (callId is String) {
            final toolName = (value['toolName'] as String?) ?? '';
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
                  argsJson: (value['args'] as String?) ?? '{}',
                  order: anchor != null ? OrderKey(anchor.seq, 1) : order,
                ),
              );
            }
          }
        }
      case ag_ui.CustomEvent(name: 'pocketcoder:diff'):
        final value = event.value;
        if (value is Map) {
          final toolCallId = value['toolCallId'];
          final path = value['path'];
          final newText = value['newText'];
          if (toolCallId is String && path is String && newText is String) {
            final diff = ToolDiff(
              path: path,
              oldText: (value['oldText'] as String?) ?? '',
              newText: newText,
            );
            _updateTool(toolCallId, (t) => t.copyWith(diffs: [...t.diffs, diff]));
          }
        }

      case ag_ui.StateSnapshotEvent():
        final snapshot = event.snapshot;
        _pocketcoder.clear();
        if (snapshot is Map) {
          final pocketcoder = snapshot['pocketcoder'];
          _pocketcoder.addAll(
              pocketcoder is Map ? Map<String, dynamic>.from(pocketcoder) : {});
        }
        _syncPermission();
        _syncElicitation();
      case ag_ui.StateDeltaEvent():
        for (final op in event.delta) {
          _applyPatch(op);
        }

      default:
        break; // event kinds this reducer doesn't surface.
    }
  }

  void _reset() {
    // _resolvedIds is deliberately NOT cleared here — see resolveRequest's
    // doc comment. Clearing it would resurrect already-resolved
    // permission/elicitation/tool-request cards on every pocketcoder
    // reconnect replay, since the backend never clears its own state.
    // _adapterAIds is likewise left untouched, matching the pre-rewrite
    // reducer's _reset (it never cleared _adapterAIds either).
    _items.clear();
    _seq = 0;
    _sortedCache = null;
    _openText.clear();
    _openReasoning.clear();
    _pocketcoder.clear();
    _isRunning = false;
    _runError = null;
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

  void _syncPermission() {
    _removeAdapterItemsWhere((item) => item is PermissionRequestTimelineItem);
    final permission = _pocketcoder['permission'];
    if (permission is! Map) return;
    final requestId = permission['requestId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    final options = (permission['options'] as List? ?? const [])
        .whereType<Map>()
        .map((o) => PermissionOption(
              optionId: (o['optionId'] as String?) ?? '',
              label: (o['name'] as String?) ?? '',
              kind: (o['kind'] as String?) ?? '',
            ))
        .toList();
    final toolCallId = permission['toolCallId'];
    final anchor = toolCallId is String ? _items[toolCallId]?.order : null;
    _adapterAIds.add(requestId);
    _upsert(
      requestId,
      (order) => TimelineItem.permissionRequest(
        requestId: requestId,
        toolTitle: permission['title'] as String?,
        toolKind: permission['kind'] as String?,
        toolCallId: toolCallId is String ? toolCallId : null,
        options: options,
        order: anchor != null ? OrderKey(anchor.seq, 1) : order,
      ),
    );
  }

  void _syncElicitation() {
    _removeAdapterItemsWhere((item) => item is ElicitationRequestTimelineItem);
    final elicitation = _pocketcoder['elicitation'];
    if (elicitation is! Map) return;
    final requestId = elicitation['elicitationId'];
    if (requestId is! String) return;
    if (_resolvedIds.contains(requestId)) return;
    final message = elicitation['message'] as String? ?? '';
    final mode = elicitation['mode'] as String? ?? 'form';
    final schema = elicitation['requestedSchema'];
    final url = elicitation['url'] as String?;
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
      ),
    );
  }

  /// Resolves a pending permission/elicitation/tool-request: removes it from
  /// the timeline immediately, and remembers it as resolved so a later
  /// replay of the same backend state (pocketcoder's backend never clears
  /// its own /pocketcoder/<ns> namespace server-side — see the design spec's
  /// "Resolution" section) does not resurrect it. Survives `_reset()`
  /// deliberately — see that method.
  void resolveRequest(String requestId) {
    _resolvedIds.add(requestId);
    // The bare `requestId` key may belong to a permission/elicitation card
    // (which use bare keys) — but for a resolved tool-request, `requestId`
    // is the same value as its tool call's own key (`callId`), and that
    // ToolCallTimelineItem must NOT be removed. Only remove the bare key
    // when it actually holds a request-type item.
    final atBareKey = _items[requestId];
    if (atBareKey is PermissionRequestTimelineItem ||
        atBareKey is ElicitationRequestTimelineItem) {
      _removeKey(requestId);
    }
    _removeKey('req:$requestId');
    _adapterAIds.remove(requestId);
  }

  void _applyPatch(Map<String, dynamic> op) {
    final path = op['path'] as String?;
    if (path == null) return;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList(growable: false);
    if (segments.isEmpty || segments.first != 'pocketcoder') return;
    if (segments.length == 2) {
      final ns = segments[1];
      switch (op['op']) {
        case 'remove':
          _pocketcoder.remove(ns);
        default:
          _pocketcoder[ns] = op['value'];
      }
      if (ns == 'permission') _syncPermission();
      if (ns == 'elicitation') _syncElicitation();
    } else if (segments.length >= 3) {
      final ns = segments[1];
      final key = segments[2];
      final existing = _pocketcoder[ns];
      final sub = existing is Map ? Map<String, dynamic>.from(existing) : <String, dynamic>{};
      switch (op['op']) {
        case 'remove':
          sub.remove(key);
        default:
          sub[key] = op['value'];
      }
      _pocketcoder[ns] = sub;
    }
  }

  SessionState _sessionState() {
    Map<String, dynamic>? asMap(dynamic v) => v is Map ? Map<String, dynamic>.from(v) : null;
    final sessionInfo = asMap(_pocketcoder['session_info']);
    return SessionState(
      permission: asMap(_pocketcoder['permission']),
      elicitation: asMap(_pocketcoder['elicitation']),
      modes: asMap(_pocketcoder['modes']),
      config: asMap(_pocketcoder['config']),
      plan: asMap(_pocketcoder['plan']),
      title: sessionInfo?['title'] as String?,
      isRunning: _isRunning,
      runError: _runError,
    );
  }
}

/// Convenience wrapper for callers holding a full event list (e.g.
/// pocketcoder's cache-replay `AgentChatRepository.watch()` — see Task 8).
/// Equivalent to constructing a fresh [ConversationReducer] and applying
/// every event in order.
Conversation reduce(List<ag_ui.BaseEvent> events) {
  final r = ConversationReducer();
  for (final event in events) {
    r.apply(event);
  }
  return r.current;
}
