// lib/src/widgets/timeline_request_index.dart
// Pure projection: the three payload-carrying TimelineItem variants, keyed by
// requestId. Both AgUiChat and AgUiTranscript dispatch their permission /
// elicitation / toolRequest builders through this, rather than embedding the
// full item in flutter_chat_core's untyped Message.custom metadata.
import '../model/conversation.dart';

Map<String, TimelineItem> timelineRequestIndex(List<TimelineItem> timeline) => {
      for (final item in timeline)
        if (item is PermissionRequestTimelineItem) item.requestId: item,
      for (final item in timeline)
        if (item is ElicitationRequestTimelineItem) item.requestId: item,
      for (final item in timeline)
        if (item is ToolRequestTimelineItem) item.requestId: item,
    };
