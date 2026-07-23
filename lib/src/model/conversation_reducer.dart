// lib/src/model/conversation_reducer.dart
// Stateful reducer: BaseEvent in, Conversation out via [current]. NOT a
// pure function — see design spec "The reducer is the fully-shared piece —
// as a stateful object, not a pure fold" for why a pure
// (Conversation, BaseEvent) -> Conversation signature can't work here (the
// accumulator carries bookkeeping — open-message buffers, id->index maps —
// that isn't representable in Conversation's public shape, and rebuilding
// it from Conversation on every call would be O(n) per event).
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
class ConversationReducer {
  final List<TimelineItem> _timeline = [];
  final Map<String, _OpenMessage> _openText = {};
  final Map<String, int> _openTextIndex = {};
  final Map<String, _OpenMessage> _openReasoning = {};
  final Map<String, int> _toolTimelineIndex = {};
  final Map<String, dynamic> _pocketcoder = {};
  bool _isRunning = false;
  String? _runError;

  Conversation get current => Conversation(
        timeline: List.unmodifiable(_timeline),
        sessionState: _sessionState(),
      );

  void apply(ag_ui.BaseEvent event) {
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
        _insertTimelineItem(_timeline.length,
            TimelineItem.textStream(id: event.messageId, role: open.role, text: ''));
        _openTextIndex[event.messageId] = _timeline.length - 1;
      case ag_ui.TextMessageContentEvent():
        var open = _openText[event.messageId];
        if (open == null) {
          open = _OpenMessage('assistant');
          _openText[event.messageId] = open;
          _insertTimelineItem(_timeline.length,
              TimelineItem.textStream(id: event.messageId, role: open.role, text: ''));
          _openTextIndex[event.messageId] = _timeline.length - 1;
        }
        open.text.write(event.delta);
        final idx = _openTextIndex[event.messageId];
        if (idx != null) {
          _timeline[idx] = TimelineItem.textStream(
              id: event.messageId, role: open.role, text: open.text.toString());
        }
      case ag_ui.TextMessageEndEvent():
        final open = _openText.remove(event.messageId);
        final idx = _openTextIndex.remove(event.messageId);
        if (open != null && idx != null) {
          _timeline[idx] = TimelineItem.text(
            id: event.messageId,
            kind: ChatMessageKind.text,
            role: open.role,
            text: open.text.toString(),
          );
        }

      case ag_ui.ReasoningMessageStartEvent():
        _openReasoning[event.messageId] = _OpenMessage(event.role.value);
      case ag_ui.ReasoningMessageContentEvent():
        _openReasoning
            .putIfAbsent(event.messageId, () => _OpenMessage('assistant'))
            .text
            .write(event.delta);
      case ag_ui.ReasoningMessageEndEvent():
        final open = _openReasoning.remove(event.messageId);
        if (open != null) {
          _insertTimelineItem(
            _timeline.length,
            TimelineItem.text(
              id: event.messageId,
              kind: ChatMessageKind.reasoning,
              role: open.role,
              text: open.text.toString(),
            ),
          );
        }

      case ag_ui.ToolCallStartEvent():
        _insertTimelineItem(_timeline.length,
            TimelineItem.toolCall(id: event.toolCallId, name: event.toolCallName));
        _toolTimelineIndex[event.toolCallId] = _timeline.length - 1;
      case ag_ui.ToolCallArgsEvent():
        _updateTool(event.toolCallId, (t) => t.copyWith(args: t.args + event.delta));
      case ag_ui.ToolCallResultEvent():
        _updateTool(event.toolCallId, (t) => t.copyWith(result: event.content));
      case ag_ui.ToolCallEndEvent():
        break; // terminal state is "has a result"; nothing to flip here.

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
    _timeline.clear();
    _openText.clear();
    _openTextIndex.clear();
    _openReasoning.clear();
    _toolTimelineIndex.clear();
    _pocketcoder.clear();
    _isRunning = false;
    _runError = null;
  }

  void _updateTool(String id, ToolCallTimelineItem Function(ToolCallTimelineItem) update) {
    var idx = _toolTimelineIndex[id];
    if (idx == null) {
      _insertTimelineItem(_timeline.length, TimelineItem.toolCall(id: id, name: ''));
      idx = _timeline.length - 1;
      _toolTimelineIndex[id] = idx;
    }
    final current = _timeline[idx];
    if (current is ToolCallTimelineItem) {
      _timeline[idx] = update(current);
    }
  }

  void _insertTimelineItem(int index, TimelineItem item) {
    _timeline.insert(index, item);
    _toolTimelineIndex.updateAll((_, i) => i >= index ? i + 1 : i);
    _openTextIndex.updateAll((_, i) => i >= index ? i + 1 : i);
  }

  void _removeTimelineItemsWhere(bool Function(TimelineItem) test) {
    for (var i = _timeline.length - 1; i >= 0; i--) {
      if (test(_timeline[i])) {
        _timeline.removeAt(i);
        _toolTimelineIndex.updateAll((_, v) => v > i ? v - 1 : v);
        _openTextIndex.updateAll((_, v) => v > i ? v - 1 : v);
      }
    }
  }

  void _syncPermission() {
    _removeTimelineItemsWhere((item) => item is PermissionTimelineItem);
    final permission = _pocketcoder['permission'];
    if (permission is! Map) return;
    final requestId = permission['requestId'];
    if (requestId is! String) return;
    final toolCallId = permission['toolCallId'];
    final toolIdx = toolCallId is String ? _toolTimelineIndex[toolCallId] : null;
    _insertTimelineItem(
      toolIdx != null ? toolIdx + 1 : _timeline.length,
      TimelineItem.permission(requestId: requestId),
    );
  }

  void _syncElicitation() {
    _removeTimelineItemsWhere((item) => item is ElicitationTimelineItem);
    final elicitation = _pocketcoder['elicitation'];
    if (elicitation is! Map) return;
    final requestId = elicitation['elicitationId'];
    if (requestId is! String) return;
    _insertTimelineItem(_timeline.length, TimelineItem.elicitation(requestId: requestId));
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
