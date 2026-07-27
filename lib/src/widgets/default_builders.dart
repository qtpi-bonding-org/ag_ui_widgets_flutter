// lib/src/widgets/default_builders.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;

/// Plain bubble used when the caller doesn't supply a `textMessageBuilder`.
/// Theme.of(context)-only — see design spec's theming section for why the
/// shared package can't reach into either app's design system.
Widget defaultTextMessageBuilder(
  BuildContext context,
  chat_core.TextMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
}) {
  final colors = Theme.of(context).colorScheme;
  return Align(
    alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSentByMe ? colors.primaryContainer : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message.text, style: Theme.of(context).textTheme.bodyMedium),
    ),
  );
}

/// Plain key/value card used when the caller doesn't supply a
/// `toolCallBuilder`.
Widget defaultToolCallBuilder(
  BuildContext context,
  chat_core.CustomMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
}) {
  final colors = Theme.of(context).colorScheme;
  final name = message.metadata?['name'] as String? ?? '';
  final result = message.metadata?['result'] as String?;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: colors.outlineVariant),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.labelLarge),
        if (result != null) Text(result, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

/// Plain streaming-text renderer used when the caller doesn't supply a
/// `textStreamMessageBuilder`. Explicitly passes `sentTextStyle`/
/// `receivedTextStyle` derived from `Theme.of(context)` — left unset,
/// `FlyerChatTextStreamMessage` falls back to `flutter_chat_ui`'s ambient
/// `ChatTheme.light()` default instead, causing a visible color pop when
/// streaming ends and rendering switches to `textMessageBuilder`.
Widget defaultTextStreamMessageBuilder(
  BuildContext context,
  chat_core.TextStreamMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
  required chat_stream.StreamState streamState,
}) {
  final colors = Theme.of(context).colorScheme;
  final bodyStyle = Theme.of(context).textTheme.bodyMedium;
  return chat_stream.FlyerChatTextStreamMessage(
    message: message,
    index: index,
    streamState: streamState,
    sentTextStyle: bodyStyle?.copyWith(color: colors.onPrimaryContainer),
    receivedTextStyle: bodyStyle?.copyWith(color: colors.onSurface),
  );
}
