import 'package:ag_ui/ag_ui.dart';

/// Decodes one AG-UI event as `acp-agui-adapter` emits it.
///
/// `ag_ui` 0.3.0 reads `TOOL_CALL_RESULT.content` as a `String`, while AG-UI 1.0
/// (and the adapter) send a list of content parts. A list is decoded as the
/// text of its text parts, joined by newlines, and the whole list rides on the
/// event's `rawEvent` under `parts` so nothing is lost.
BaseEvent decodeAgUiWire(Map<String, dynamic> json) {
  final content = json['content'];
  if (json['type'] == 'TOOL_CALL_RESULT' && content is List) {
    final text = [
      for (final part in content)
        if (part is Map && part['type'] == 'text' && part['text'] is String)
          part['text'] as String,
    ].join('\n');
    return BaseEvent.fromJson({
      ...json,
      'content': text,
      'rawEvent': {'parts': content},
    });
  }
  return BaseEvent.fromJson(json);
}
