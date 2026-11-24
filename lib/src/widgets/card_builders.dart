// lib/src/widgets/card_builders.dart
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;
import 'package:material_ui/material_ui.dart';

typedef CustomCardBuilder = Widget Function(
  BuildContext context,
  chat_core.CustomMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
});

/// Mirrors `CustomCardBuilder`'s pattern. `chat_core.TextStreamMessageBuilder` is
/// typed against `chat_core.TextStreamMessage`, which carries no text
/// content (only `id`/`authorId`/`streamId`); the partial text exists only
/// in this package's private `streamStates` map, so we expose `streamState`
/// as an explicit param that `AgUiTranscript` supplies at the call site.
typedef TextStreamCardBuilder = Widget Function(
  BuildContext context,
  chat_core.TextStreamMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
  required chat_stream.StreamState streamState,
});

/// Builds the control that copies [text]: a whole message's markdown, or one
/// code block ([isCode]). [id] is the message id, or the message id plus the
/// block's content hash. Never called for blank text or for reasoning. The app
/// supplies it, because the package has no buttons, labels or clipboard of its
/// own.
typedef CopyButtonBuilder = Widget Function(
  BuildContext context,
  String text, {
  required String id,
  required bool isCode,
});
