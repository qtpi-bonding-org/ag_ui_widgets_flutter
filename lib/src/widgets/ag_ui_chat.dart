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
    this.composerBuilder,
  });

  final Conversation conversation;
  final String currentUserId;
  final void Function(String text) onSendMessage;
  final chat_core.TextMessageBuilder? textMessageBuilder;
  final CustomCardBuilder? toolCallBuilder;

  /// Receives only the permission `requestId` — no payload. See
  /// TimelineItem.permission's doc comment.
  final Widget Function(BuildContext context, String requestId)? permissionBuilder;

  /// Receives only the elicitation `elicitationId` — no payload.
  final Widget Function(BuildContext context, String elicitationId)? elicitationBuilder;
  final WidgetBuilder? composerBuilder;

  @override
  State<AgUiChat> createState() => _AgUiChatState();
}

class _AgUiChatState extends State<AgUiChat> {
  final _controller = chat_core.InMemoryChatController();

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
      builders: chat_core.Builders(
        textMessageBuilder: widget.textMessageBuilder ?? defaultTextMessageBuilder,
        textStreamMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) =>
            chat_stream.FlyerChatTextStreamMessage(
          message: message,
          index: index,
          streamState: streamStates[message.id] ?? const chat_stream.StreamStateLoading(),
        ),
        customMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) {
          switch (message.metadata?['kind']) {
            case 'toolCall':
              return (widget.toolCallBuilder ?? defaultToolCallBuilder)(
                  context, message, index, isSentByMe: isSentByMe, groupStatus: groupStatus);
            case 'permission':
              return widget.permissionBuilder?.call(context, message.id) ??
                  const SizedBox.shrink();
            case 'elicitation':
              return widget.elicitationBuilder?.call(context, message.id) ??
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
