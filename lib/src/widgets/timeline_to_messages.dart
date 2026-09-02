// lib/src/widgets/timeline_to_messages.dart
// Pure adapter: TimelineItem (domain) -> flutter_chat_core.Message
// (rendering). No state of its own — a projection of an already-reduced
// Conversation.timeline, recomputed by the caller on every rebuild.
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart';
import '../model/conversation.dart';

const kUserAuthorId = 'user';
const kAgentAuthorId = 'assistant';

List<chat_core.Message> timelineToMessages(List<TimelineItem> timeline) {
  final requestedToolCallIds = {
    for (final item in timeline)
      if (item case ToolRequestTimelineItem(requestId: final id)) id,
    // A PermissionRequestTimelineItem's own requestId doubles as its
    // correlated tool call's id for the direct acp.permission_request path
    // (see conversation_reducer.dart's case for that event — the ACP
    // protocol sets callId = the tool call's own id), so it must be
    // collected unconditionally, not only via the separate toolCallId field
    // below (which only Adapter A/pocketcoder's state-sync path sets). Both
    // items now legitimately coexist in ConversationReducer's timeline
    // (they no longer overwrite each other — see that reducer case's doc
    // comment), so without this, converting both to Messages would produce
    // two entries sharing one Message.id, which InMemoryChatController
    // rejects as a duplicate id.
    for (final item in timeline)
      if (item case PermissionRequestTimelineItem(:final requestId)) requestId,
    for (final item in timeline)
      if (item case PermissionRequestTimelineItem(toolCallId: final id?)) id,
    for (final item in timeline)
      if (item case ElicitationRequestTimelineItem(toolCallId: final id?)) id,
  };
  return timeline
      .where((item) => switch (item) {
            ToolCallTimelineItem(:final id) => !requestedToolCallIds.contains(id),
            _ => true,
          })
      .map(_toMessage)
      .toList(growable: false);
}

chat_core.Message _toMessage(TimelineItem item) {
  return switch (item) {
    TextTimelineItem(:final id, :final kind, :final role, :final text) => chat_core.Message.text(
        id: id,
        authorId: role == 'user' ? kUserAuthorId : kAgentAuthorId,
        text: text,
        metadata: {
          'kind': kind == ChatMessageKind.reasoning ? 'reasoning' : 'text',
          'role': role,
        },
      ),
    TextStreamTimelineItem(:final id, :final kind, :final role) => chat_core.Message.textStream(
        id: id,
        authorId: role == 'user' ? kUserAuthorId : kAgentAuthorId,
        streamId: id,
        metadata: {
          'kind': kind == ChatMessageKind.reasoning ? 'reasoning' : 'text',
          'role': role,
        },
      ),
    ToolCallTimelineItem(
      :final id,
      :final name,
      :final args,
      :final result,
      :final diffs,
      :final toolKind,
    ) =>
      chat_core.Message.custom(
        id: id,
        authorId: kAgentAuthorId,
        metadata: {
          'kind': 'toolCall',
          'name': name,
          'args': args,
          'result': result,
          'diffs': diffs
              .map((d) => {'path': d.path, 'oldText': d.oldText, 'newText': d.newText})
              .toList(),
          'toolKind': toolKind,
        },
      ),
    PermissionRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'permissionRequest'},
      ),
    ElicitationRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'elicitationRequest'},
      ),
    ToolRequestTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'toolRequest'},
      ),
  };
}

/// Projects every currently-open streaming text item into the `StreamState`
/// map `FlyerChatTextStreamMessage` needs.
Map<String, StreamState> streamStatesFromTimeline(List<TimelineItem> timeline) {
  final out = <String, StreamState>{};
  for (final item in timeline) {
    if (item is TextStreamTimelineItem) {
      out[item.id] = StreamStateStreaming(item.text);
    }
  }
  return out;
}
