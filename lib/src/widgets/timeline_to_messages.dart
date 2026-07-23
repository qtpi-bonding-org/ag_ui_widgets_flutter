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
  return timeline.map(_toMessage).toList(growable: false);
}

chat_core.Message _toMessage(TimelineItem item) {
  return switch (item) {
    TextTimelineItem(:final id, :final kind, :final role, :final text) => chat_core.Message.text(
        id: id,
        authorId: role == 'user' ? kUserAuthorId : kAgentAuthorId,
        text: text,
        metadata: {'kind': kind == ChatMessageKind.reasoning ? 'reasoning' : 'text'},
      ),
    TextStreamTimelineItem(:final id, :final role) => chat_core.Message.textStream(
        id: id,
        authorId: role == 'user' ? kUserAuthorId : kAgentAuthorId,
        streamId: id,
      ),
    ToolCallTimelineItem(:final id, :final name, :final args, :final result) =>
      chat_core.Message.custom(
        id: id,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'toolCall', 'name': name, 'args': args, 'result': result},
      ),
    PermissionTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'permission'},
      ),
    ElicitationTimelineItem(:final requestId) => chat_core.Message.custom(
        id: requestId,
        authorId: kAgentAuthorId,
        metadata: {'kind': 'elicitation'},
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
