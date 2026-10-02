import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/tool_models.dart';

void main() {
  group('ToolLocation.parse', () {
    test('reads path and line, keeps unknown keys', () {
      final l = ToolLocation.parse({'path': 'a.dart', 'line': 7, 'x': 1})!;
      expect(l.path, 'a.dart');
      expect(l.line, 7);
      expect(l.extras, {'x': 1});
    });
    test('line is optional; non-map is null', () {
      expect(ToolLocation.parse({'path': 'a'})!.line, isNull);
      expect(ToolLocation.parse('nope'), isNull);
    });
    test('a missing path becomes empty, not a dropped entry', () {
      expect(ToolLocation.parse({'line': 3})!.path, '');
    });
  });

  test('ToolTerminal.parse keeps meta', () {
    final t = ToolTerminal.parse({
      'toolCallId': 'tc',
      'terminalId': 't1',
      'meta': {'k': 1}
    })!;
    expect(t.terminalId, 't1');
    expect(t.meta, {'k': 1});
    expect(t.extras, isEmpty, reason: 'toolCallId is routing, not data');
  });

  test('ToolPatch.parse reads format and patch', () {
    final p = ToolPatch.parse(
        {'toolCallId': 'tc', 'format': 'unified', 'patch': '@@ -1 +1 @@'})!;
    expect(p.format, 'unified');
    expect(p.patch, '@@ -1 +1 @@');
  });

  test('MediaDescriptor.parse reads every adapter field', () {
    final m = MediaDescriptor.parse({
      'kind': 'image',
      'mimeType': 'image/png',
      'uri': 'file:///a.png',
      'name': 'a.png',
      'size': 12,
      'data': 'AAAA',
      'title': 'T',
      'description': 'D',
      'messageId': 'm1',
      'other': true,
    })!;
    expect(m.kind, 'image');
    expect(m.mimeType, 'image/png');
    expect(m.size, 12);
    expect(m.messageId, 'm1');
    expect(m.extras, {'other': true});
  });

  group('ToolContent.parse', () {
    test('diff', () {
      final c = ToolContent.parse(
          {'toolCallId': 't', 'path': 'a', 'oldText': null, 'newText': 'b'});
      expect(c, isA<ToolContentDiff>());
      expect((c as ToolContentDiff).diff.oldText, '');
      expect(c.diff.extras, isEmpty);
    });
    test('patch (DiffV2: no path, no newText)', () {
      expect(ToolContent.parse({'toolCallId': 't', 'patch': 'p'}),
          isA<ToolContentPatch>());
    });
    test('terminal', () {
      expect(ToolContent.parse({'toolCallId': 't', 'terminalId': 'x'}),
          isA<ToolContentTerminal>());
    });
    test('media', () {
      expect(ToolContent.parse({'toolCallId': 't', 'kind': 'image'}),
          isA<ToolContentMedia>());
    });
    test('anything else is kept as unknown, never dropped', () {
      final c = ToolContent.parse({'weird': 1});
      expect(c, isA<ToolContentUnknown>());
      expect((c as ToolContentUnknown).raw, {'weird': 1});
    });
    test('non-map is null', () => expect(ToolContent.parse(3), isNull));
  });
}
