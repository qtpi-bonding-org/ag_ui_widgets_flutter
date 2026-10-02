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

  test('a tool call forwards locations, terminals, patches, media, results and meta',
      () {
    final item = TimelineItem.toolCall(
      id: 't',
      name: 'edit',
      order: const OrderKey(1),
      locations: const [ToolLocation(path: 'a.dart', line: 3)],
      terminals: const [ToolTerminal(terminalId: 'x')],
      patches: const [ToolPatch(format: 'unified', patch: 'p')],
      media: const [MediaDescriptor(kind: 'image', mimeType: 'image/png')],
      resultParts: const [ToolResultPart(messageId: 'r1', content: 'A')],
      meta: const {'k': 1},
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect(m.metadata!['locations'], [
      {'path': 'a.dart', 'line': 3},
    ]);
    expect((m.metadata!['terminals'] as List).single['terminalId'], 'x');
    expect((m.metadata!['patches'] as List).single['patch'], 'p');
    expect((m.metadata!['media'] as List).single['mimeType'], 'image/png');
    expect((m.metadata!['resultParts'] as List).single['content'], 'A');
    expect(m.metadata!['meta'], {'k': 1});
  });

  test('tool call extras in locations, terminals, patches and diffs are preserved',
      () {
    final item = TimelineItem.toolCall(
      id: 't',
      name: 'edit',
      order: const OrderKey(1),
      locations: const [
        ToolLocation(path: 'a.dart', line: 3, extras: {'xLoc': 'val1'})
      ],
      terminals: const [
        ToolTerminal(terminalId: 'x', extras: {'xTerm': 'val2'})
      ],
      patches: const [
        ToolPatch(format: 'unified', patch: 'p', extras: {'xPatch': 'val3'})
      ],
      diffs: const [ToolDiff(path: 'b.dart', newText: 'n', extras: {'xDiff': 'val4'})],
    );
    final m = timelineToMessages([item]).single as chat_core.CustomMessage;
    expect((m.metadata!['locations'] as List).single['xLoc'], 'val1');
    expect((m.metadata!['terminals'] as List).single['xTerm'], 'val2');
    expect((m.metadata!['patches'] as List).single['xPatch'], 'val3');
    expect((m.metadata!['diffs'] as List).single['xDiff'], 'val4');
  });
}
