// lib/src/widgets/ag_ui_chat.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;
import '../model/conversation.dart';
import 'timeline_to_messages.dart';
import 'default_builders.dart';

typedef CustomCardBuilder = Widget Function(
  BuildContext context,
  chat_core.CustomMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
});

/// Local typedef for `AgUiChat.textStreamMessageBuilder` — mirrors
/// `CustomCardBuilder`'s pattern. `chat_core.TextStreamMessageBuilder` is
/// typed against `chat_core.TextStreamMessage`, which carries no text
/// content (only `id`/`authorId`/`streamId`); the partial text exists only
/// in this package's private `streamStates` map, so we expose `streamState`
/// as an explicit param that `AgUiChat` itself supplies at the call site.
typedef TextStreamCardBuilder = Widget Function(
  BuildContext context,
  chat_core.TextStreamMessage message,
  int index, {
  required bool isSentByMe,
  chat_core.MessageGroupStatus? groupStatus,
  required chat_stream.StreamState streamState,
});

/// Renders a [Conversation]'s timeline as a chat, wrapping `flutter_chat_ui`.
/// Every message kind is rendered by a caller-suppliable builder; unset
/// builders fall back to plain Theme.of(context)-only defaults.
class AgUiChat extends StatefulWidget {
  const AgUiChat({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onSendMessage,
    this.textMessageBuilder,
    this.toolCallBuilder,
    this.permissionBuilder,
    this.elicitationBuilder,
    this.toolRequestBuilder,
    this.composerBuilder,
    this.textStreamMessageBuilder,
    this.theme,
  });

  final Conversation conversation;
  final String currentUserId;
  final void Function(String text) onSendMessage;
  final chat_core.TextMessageBuilder? textMessageBuilder;
  final CustomCardBuilder? toolCallBuilder;

  /// Receives the full `PermissionRequestTimelineItem` — callers downcast to
  /// access the payload (options, toolTitle, etc.). Lookup is by
  /// `requestId` via the widget's internal `_itemsById` map.
  final Widget Function(BuildContext context, TimelineItem item)? permissionBuilder;

  /// Receives the full `ElicitationRequestTimelineItem` — callers downcast
  /// to access the payload (message, mode, schema, url).
  final Widget Function(BuildContext context, TimelineItem item)? elicitationBuilder;

  /// Receives the full `ToolRequestTimelineItem` — callers downcast to
  /// access the payload (toolName, argsJson, toolTitle, toolKind). Default
  /// renders an empty `SizedBox.shrink()`.
  final Widget Function(BuildContext context, TimelineItem item)? toolRequestBuilder;

  final WidgetBuilder? composerBuilder;

  /// Caller-supplied override for the in-progress streaming message
  /// builder. Unset falls back to `defaultTextStreamMessageBuilder`. See
  /// `TextStreamCardBuilder` for why this slot can't reuse
  /// `chat_core.TextStreamMessageBuilder`'s shape.
  final TextStreamCardBuilder? textStreamMessageBuilder;

  /// Caller-supplied theme for the underlying `flutter_chat_ui` `Chat`
  /// widget. Left unset, `Chat` silently falls back to `ChatTheme.light()`
  /// regardless of the app's ambient `Theme.of(context)` brightness — so a
  /// dark-themed host app must pass one explicitly or the message list
  /// renders on a white background.
  final chat_core.ChatTheme? theme;

  @override
  State<AgUiChat> createState() => _AgUiChatState();
}

class _AgUiChatState extends State<AgUiChat> {
  final _controller = chat_core.InMemoryChatController();

  /// requestId → full TimelineItem for the three payload-carrying variants.
  /// Rebuilt every time `_syncMessages` runs (i.e. on every conversation
  /// change), then looked up by the `customMessageBuilder` dispatch switch
  /// when a custom message of kind `permissionRequest`/`elicitationRequest`/
  /// `toolRequest` is rendered — chosen over embedding the full item in
  /// `flutter_chat_core`'s untyped `Message.custom` metadata.
  Map<String, TimelineItem> _itemsById = const {};

  @override
  void didUpdateWidget(covariant AgUiChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMessages();
  }

  @override
  void initState() {
    super.initState();
    _syncMessages();
  }

  void _syncMessages() {
    _controller.setMessages(timelineToMessages(widget.conversation.timeline));
    _itemsById = {
      for (final item in widget.conversation.timeline)
        if (item is PermissionRequestTimelineItem) item.requestId: item,
      for (final item in widget.conversation.timeline)
        if (item is ElicitationRequestTimelineItem) item.requestId: item,
      for (final item in widget.conversation.timeline)
        if (item is ToolRequestTimelineItem) item.requestId: item,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamStates = streamStatesFromTimeline(widget.conversation.timeline);
    return chat_ui.Chat(
      currentUserId: widget.currentUserId,
      resolveUser: (id) async => chat_core.User(id: id),
      chatController: _controller,
      theme: widget.theme,
      builders: chat_core.Builders(
        textMessageBuilder: widget.textMessageBuilder ?? defaultTextMessageBuilder,
        textStreamMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) =>
            (widget.textStreamMessageBuilder ?? defaultTextStreamMessageBuilder)(
              context, message, index,
              isSentByMe: isSentByMe,
              groupStatus: groupStatus,
              streamState: streamStates[message.id] ?? const chat_stream.StreamStateLoading(),
            ),
        customMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) {
          switch (message.metadata?['kind']) {
            case 'toolCall':
              return (widget.toolCallBuilder ?? defaultToolCallBuilder)(
                  context, message, index, isSentByMe: isSentByMe, groupStatus: groupStatus);
            case 'permissionRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.permissionBuilder?.call(context, item) ??
                  const SizedBox.shrink();
            case 'elicitationRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.elicitationBuilder?.call(context, item) ??
                  const SizedBox.shrink();
            case 'toolRequest':
              final item = _itemsById[message.id];
              if (item == null) return const SizedBox.shrink();
              return widget.toolRequestBuilder?.call(context, item) ??
                  const SizedBox.shrink();
            default:
              return const SizedBox.shrink();
          }
        },
        composerBuilder: widget.composerBuilder,
      ),
    );
  }
}
