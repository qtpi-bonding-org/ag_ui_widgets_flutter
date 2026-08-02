// lib/src/model/conversation.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';

enum ChatMessageKind { text, reasoning }

/// One diff hunk from a tool call's result — the full before/after text for
/// one file. [oldText] is empty for new-file diffs (the backend's ACP-facing
/// `ToolDiff.OldText` uses `omitempty`, so a new-file event never carries an
/// `oldText` key at all).
@freezed
abstract class ToolDiff with _$ToolDiff {
  const factory ToolDiff({
    required String path,
    @Default('') String oldText,
    required String newText,
  }) = _ToolDiff;
}

/// One option in a pending permission request. ACP's `PermissionOption`
/// (`option_id`/`name`/`kind` — always present on the wire in both SDKs) maps
/// 1:1 to this shape; both real backends already forward all three fields.
@freezed
abstract class PermissionOption with _$PermissionOption {
  const factory PermissionOption({
    required String optionId,
    required String label,
    required String kind,
  }) = _PermissionOption;
}

/// Total order over timeline items. `seq` is the reducer's monotonic
/// event-arrival counter, bumped once per `apply()` call. `sub` orders
/// items correlated to the same anchor (e.g. a permission card pinned
/// just after its tool call) without needing a fractional key.
class OrderKey implements Comparable<OrderKey> {
  const OrderKey(this.seq, [this.sub = 0]);
  final int seq;
  final int sub;

  @override
  int compareTo(OrderKey other) =>
      seq != other.seq ? seq.compareTo(other.seq) : sub.compareTo(other.sub);

  @override
  bool operator ==(Object other) =>
      other is OrderKey && other.seq == seq && other.sub == sub;

  @override
  int get hashCode => Object.hash(seq, sub);
}

/// One item in the ordered conversation timeline: text/reasoning prose, an
/// in-progress streaming reply, a tool invocation, or an inline
/// permission/elicitation/tool-request. Built by [ConversationReducer]
/// in true chronological order.
@freezed
sealed class TimelineItem with _$TimelineItem {
  const TimelineItem._();

  /// A completed message: concatenation of every `*_CONTENT` delta between
  /// a message's `*_START` and `*_END`.
  const factory TimelineItem.text({
    required String id,
    required ChatMessageKind kind,
    required String role,
    required String text,
    required OrderKey order,
  }) = TextTimelineItem;

  /// A still-open text message: `text` is the partial content accumulated
  /// so far. Replaced in place by a `TimelineItem.text` (same `id`) once the
  /// message's `*_END` event arrives. `kind` mirrors `TimelineItem.text`'s
  /// so a still-streaming reasoning block can be told apart from a
  /// still-streaming response while it's in progress, not just once done.
  const factory TimelineItem.textStream({
    required String id,
    @Default(ChatMessageKind.text) ChatMessageKind kind,
    required String role,
    required String text,
    required OrderKey order,
  }) = TextStreamTimelineItem;

  /// One tool invocation. Enters the timeline on `TOOL_CALL_START`.
  /// `args`/`result` fill in as `TOOL_CALL_ARGS`/`_RESULT` arrive; an empty
  /// `args`/`null` result means "still running".
  const factory TimelineItem.toolCall({
    required String id,
    required String name,
    required OrderKey order,
    @Default('') String args,
    String? result,
    @Default(<ToolDiff>[]) List<ToolDiff> diffs,
  }) = ToolCallTimelineItem;

  /// A pending permission request — full payload, not a marker. `toolTitle`/
  /// `toolKind` are ACP's `ToolCallUpdate.Title`/`Kind`, both optional on the
  /// wire; `description` is never protocol-native (only a bridge may
  /// synthesize one). `options` is the per-request `PermissionOption` list.
  const factory TimelineItem.permissionRequest({
    required String requestId,
    String? toolTitle,
    String? toolCallId,
    String? toolKind,
    String? description,
    required List<PermissionOption> options,
    required OrderKey order,
  }) = PermissionRequestTimelineItem;

  /// A pending elicitation request — full payload. `message` and `mode` are
  /// always present on the wire; `schema` is set for `mode == "form"`, `url`
  /// for `mode == "url"`.
  const factory TimelineItem.elicitationRequest({
    required String requestId,
    String? toolCallId,
    required String message,
    required String mode,
    required OrderKey order,
    Map<String, dynamic>? schema,
    String? url,
  }) = ElicitationRequestTimelineItem;

  /// A client-executed tool request — full payload. `toolTitle`/`toolKind`
  /// are nullable for the same reason as on [permissionRequest].
  const factory TimelineItem.toolRequest({
    required String requestId,
    required String toolName,
    required OrderKey order,
    String? toolTitle,
    String? toolKind,
    required String argsJson,
  }) = ToolRequestTimelineItem;

  /// Display/correlation identity. A ToolCallTimelineItem and its correlated
  /// ToolRequestTimelineItem share the same itemId ON PURPOSE (same subject).
  String get itemId => switch (this) {
        TextTimelineItem(:final id) => id,
        TextStreamTimelineItem(:final id) => id,
        ToolCallTimelineItem(:final id) => id,
        PermissionRequestTimelineItem(:final requestId) => requestId,
        ElicitationRequestTimelineItem(:final requestId) => requestId,
        ToolRequestTimelineItem(:final requestId) => requestId,
      };

  /// Storage/merge identity — unique per distinct entity. Namespaces
  /// ToolRequestTimelineItem away from its correlated ToolCallTimelineItem
  /// (same itemId, NOT the same entity).
  String get storageKey => switch (this) {
        ToolRequestTimelineItem(:final requestId) => 'req:$requestId',
        _ => itemId,
      };
}

/// Ambient session-wide state, sourced from `StateSnapshotEvent`/
/// `StateDeltaEvent` plus run-lifecycle events. `modes`/`config`/`plan` are
/// intentionally untyped maps — their shape is backend-specific and not
/// this package's concern (see design spec's transport-boundary section).
@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState({
    Map<String, dynamic>? permission,
    Map<String, dynamic>? elicitation,
    Map<String, dynamic>? modes,
    Map<String, dynamic>? config,
    Map<String, dynamic>? plan,
    String? title,
    @Default(false) bool isRunning,
    /// Set while the agent process is spawning/handshaking (see
    /// `acp.session_phase` CustomEvent), before it has produced any real
    /// output. Independent of isRunning — never derived from it and never
    /// re-derives it. False for backends that never emit `acp.session_phase`
    /// (e.g. a local, already-warm model).
    @Default(false) bool isStarting,
    String? runError,
  }) = _SessionState;

  const SessionState._();

  static const empty = SessionState();
}

/// The full reduced view of a chat's AG-UI event stream: the ordered
/// timeline plus ambient session state. [ConversationReducer] is the only
/// producer.
@freezed
sealed class Conversation with _$Conversation {
  const factory Conversation({
    @Default(<TimelineItem>[]) List<TimelineItem> timeline,
    @Default(SessionState.empty) SessionState sessionState,
  }) = _Conversation;

  const Conversation._();

  static const empty = Conversation();
}
