// lib/src/model/tool_models.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'wire_parse.dart';

part 'tool_models.freezed.dart';

/// One part of a tool call's result stream — a single message with its id and
/// content. [ToolCallTimelineItem.resultParts] keeps every part; [result] is
/// the latest content.
@freezed
abstract class ToolResultPart with _$ToolResultPart {
  const factory ToolResultPart({
    required String messageId,
    required String content,
  }) = _ToolResultPart;
}

/// One diff hunk from a tool call's result — the full before/after text for
/// one file. [oldText] is empty for new-file diffs (the wire's `oldText` is
/// absent or null for a new file).
@freezed
abstract class ToolDiff with _$ToolDiff {
  const factory ToolDiff({
    required String path,
    @Default('') String oldText,
    required String newText,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolDiff;
}

/// A file location a tool call touches (`{path, line?}`).
@freezed
abstract class ToolLocation with _$ToolLocation {
  const ToolLocation._();
  const factory ToolLocation({
    required String path,
    int? line,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolLocation;

  static const _known = {'path', 'line'};

  static ToolLocation? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolLocation(
      path: asString(m['path']) ?? '',
      line: asInt(m['line']),
      extras: extrasOf(m, _known),
    );
  }
}

/// A terminal attached to a tool call (`{terminalId, meta?}`).
@freezed
abstract class ToolTerminal with _$ToolTerminal {
  const ToolTerminal._();
  const factory ToolTerminal({
    required String terminalId,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolTerminal;

  // `toolCallId` is the routing key the reducer uses to attach this to a tool
  // item; it is not data of the terminal itself, so it is not an extra.
  static const _known = {'terminalId', 'meta', 'toolCallId'};

  static ToolTerminal? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolTerminal(
      terminalId: asString(m['terminalId']) ?? '',
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

/// A patch-style diff (ACP DiffV2): `{format?, patch}` with no per-file
/// before/after text.
@freezed
abstract class ToolPatch with _$ToolPatch {
  const ToolPatch._();
  const factory ToolPatch({
    String? format,
    required String patch,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ToolPatch;

  static const _known = {'format', 'patch', 'toolCallId'};

  static ToolPatch? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ToolPatch(
      format: asString(m['format']),
      patch: asString(m['patch']) ?? '',
      extras: extrasOf(m, _known),
    );
  }
}

/// A non-text content block (image, audio, resource link, ...) as the
/// adapter summarises it. [messageId] is set when it belongs to a message,
/// [toolCallId] when it belongs to a tool call.
@freezed
abstract class MediaDescriptor with _$MediaDescriptor {
  const MediaDescriptor._();
  const factory MediaDescriptor({
    required String kind,
    String? mimeType,
    String? uri,
    String? name,
    String? title,
    String? description,
    String? data,
    String? blob,
    int? size,
    String? messageId,
    String? toolCallId,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _MediaDescriptor;

  static const _known = {
    'kind',
    'mimeType',
    'uri',
    'name',
    'title',
    'description',
    'data',
    'blob',
    'size',
    'messageId',
    'toolCallId',
  };

  static MediaDescriptor? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return MediaDescriptor(
      kind: asString(m['kind']) ?? '',
      mimeType: asString(m['mimeType']),
      uri: asString(m['uri']),
      name: asString(m['name']),
      title: asString(m['title']),
      description: asString(m['description']),
      data: asString(m['data']),
      blob: asString(m['blob']),
      size: asInt(m['size']),
      messageId: asString(m['messageId']),
      toolCallId: asString(m['toolCallId']),
      extras: extrasOf(m, _known),
    );
  }
}

/// One entry of a tool call's content as it appears on a permission request:
/// the same payload shapes the adapter sends as `<ns>:diff`, `<ns>:terminal`
/// and `<ns>:content`.
@freezed
sealed class ToolContent with _$ToolContent {
  const ToolContent._();
  const factory ToolContent.diff(ToolDiff diff) = ToolContentDiff;
  const factory ToolContent.patch(ToolPatch patch) = ToolContentPatch;
  const factory ToolContent.terminal(ToolTerminal terminal) =
      ToolContentTerminal;
  const factory ToolContent.media(MediaDescriptor media) = ToolContentMedia;
  const factory ToolContent.unknown(Map<String, dynamic> raw) =
      ToolContentUnknown;

  static ToolContent? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    if (m['terminalId'] is String) {
      return ToolContent.terminal(ToolTerminal.parse(m)!);
    }
    if (m['patch'] is String) return ToolContent.patch(ToolPatch.parse(m)!);
    if (m['path'] is String && m['newText'] is String) {
      return ToolContent.diff(ToolDiff(
        path: m['path'] as String,
        oldText: asString(m['oldText']) ?? '',
        newText: m['newText'] as String,
        extras: extrasOf(m, const {'path', 'oldText', 'newText', 'toolCallId'}),
      ));
    }
    if (m['kind'] is String) {
      return ToolContent.media(MediaDescriptor.parse(m)!);
    }
    return ToolContent.unknown(m);
  }
}
