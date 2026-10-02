import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  test('a message-level media item becomes a custom media message', () {
    final item = TimelineItem.media(
      id: 'media:0',
      messageId: 'm1',
      media: const MediaDescriptor(kind: 'audio', mimeType: 'audio/wav'),
      order: const OrderKey(2),
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect(m.id, 'media:0');
    expect(m.metadata!['kind'], 'media');
    expect(m.metadata!['messageId'], 'm1');
    expect((m.metadata!['media'] as Map)['kind'], 'audio');
  });
}
