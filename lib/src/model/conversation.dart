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

/// One item in the ordered conversation timeline: text/reasoning prose, an
/// in-progress streaming reply, a tool invocation, or an inline
/// permission/elicitation position marker. Built by [ConversationReducer]
/// in true chronological order.
@freezed
sealed class TimelineItem with _$TimelineItem {
  /// A completed message: concatenation of every `*_CONTENT` delta between
  /// a message's `*_START` and `*_END`.
  const factory TimelineItem.text({
    required String id,
    required ChatMessageKind kind,
    required String role,
    required String text,
  }) = TextTimelineItem;

  /// A still-open text message: `text` is the partial content accumulated
  /// so far. Replaced in place by a `TimelineItem.text` (same `id`) once the
  /// message's `*_END` event arrives.
  const factory TimelineItem.textStream({
    required String id,
    required String role,
    required String text,
  }) = TextStreamTimelineItem;

  /// One tool invocation. Enters the timeline on `TOOL_CALL_START`.
  /// `args`/`result` fill in as `TOOL_CALL_ARGS`/`_RESULT` arrive; an empty
  /// `args`/`null` result means "still running".
  const factory TimelineItem.toolCall({
    required String id,
    required String name,
    @Default('') String args,
    String? result,
    @Default(<ToolDiff>[]) List<ToolDiff> diffs,
  }) = ToolCallTimelineItem;

  /// A pending permission — position marker only. The actual request
  /// payload (options, description, tool name) is NOT carried here; each
  /// consuming app looks it up by [requestId] from wherever it keeps that
  /// data (own cubit state, a dedicated cubit, etc).
  const factory TimelineItem.permission({
    required String requestId,
  }) = PermissionTimelineItem;

  /// A pending elicitation — same "marker only" contract as [permission].
  const factory TimelineItem.elicitation({
    required String requestId,
  }) = ElicitationTimelineItem;

  /// A pending permission request — full payload, not a marker. `toolTitle`/
  /// `toolKind` are ACP's `ToolCallUpdate.Title`/`Kind`, both optional on the
  /// wire; `description` is never protocol-native (only a bridge may
  /// synthesize one). `options` is the per-request `PermissionOption` list.
  const factory TimelineItem.permissionRequest({
    required String requestId,
    String? toolTitle,
    String? toolKind,
    String? description,
    required List<PermissionOption> options,
  }) = PermissionRequestTimelineItem;

  /// A pending elicitation request — full payload. `message` and `mode` are
  /// always present on the wire; `schema` is set for `mode == "form"`, `url`
  /// for `mode == "url"`.
  const factory TimelineItem.elicitationRequest({
    required String requestId,
    required String message,
    required String mode,
    Map<String, dynamic>? schema,
    String? url,
  }) = ElicitationRequestTimelineItem;

  /// A client-executed tool request — full payload. `toolTitle`/`toolKind`
  /// are nullable for the same reason as on [permissionRequest].
  const factory TimelineItem.toolRequest({
    required String requestId,
    String? toolTitle,
    String? toolKind,
    required String argsJson,
  }) = ToolRequestTimelineItem;
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