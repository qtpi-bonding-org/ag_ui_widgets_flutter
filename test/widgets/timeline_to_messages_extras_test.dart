import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  test('extras named like a known key never overwrite the real value', () {
    final item = TimelineItem.toolCall(
      id: 't',
      name: 'edit',
      order: const OrderKey(1),
      diffs: const [
        ToolDiff(path: 'real', newText: 'n', extras: {'path': 'evil', 'newText': 'evil'})
      ],
      locations: const [
        ToolLocation(path: 'real', line: 1, extras: {'path': 'evil', 'line': 99})
      ],
      terminals: const [
        ToolTerminal(terminalId: 'real', extras: {'terminalId': 'evil'})
      ],
      patches: const [
        ToolPatch(format: 'real', patch: 'p', extras: {'format': 'evil', 'patch': 'evil'})
      ],
      media: const [
        MediaDescriptor(
            kind: 'image',
            uri: 'real',
            extras: {'kind': 'evil', 'uri': 'evil', 'mimeType': 'evil'})
      ],
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    final md = m.metadata!;
    expect((md['diffs'] as List).single['path'], 'real');
    expect((md['diffs'] as List).single['newText'], 'n');
    expect((md['locations'] as List).single['path'], 'real');
    expect((md['locations'] as List).single['line'], 1);
    expect((md['terminals'] as List).single['terminalId'], 'real');
    expect((md['patches'] as List).single['format'], 'real');
    expect((md['patches'] as List).single['patch'], 'p');
    final media = (md['media'] as List).single as Map;
    expect(media['kind'], 'image');
    expect(media['uri'], 'real');
    expect(media['mimeType'], isNull);
  });

  test('a standalone media message keeps real values over extras', () {
    final item = TimelineItem.media(
      id: 'media:0',
      messageId: 'm',
      media: const MediaDescriptor(kind: 'audio', extras: {'kind': 'evil'}),
      order: const OrderKey(1),
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect((m.metadata!['media'] as Map)['kind'], 'audio');
  });
}
