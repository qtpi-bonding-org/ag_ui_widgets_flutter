import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/conversation.dart';
import 'ag_ui_chat.dart' show CustomCardBuilder, TextStreamCardBuilder;
import 'composer_placement.dart';
import 'default_builders.dart';
import 'timeline_request_index.dart';
import 'timeline_to_messages.dart';
import 'transcript_scroll_controller.dart';

class AgUiTranscript extends StatefulWidget {
  const AgUiTranscript({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.composerBuilder,
    this.placement = ComposerPlacement.pinned,
    this.textMessageBuilder,
    this.textStreamMessageBuilder,
    this.toolCallBuilder,
    this.permissionBuilder,
    this.elicitationBuilder,
    this.toolRequestBuilder,
    this.onTapEmptySpace,
    this.theme,
  });

  final Conversation conversation;
  final String currentUserId;
  final WidgetBuilder composerBuilder;
  final ComposerPlacement placement;
  final chat_core.TextMessageBuilder? textMessageBuilder;
  final TextStreamCardBuilder? textStreamMessageBuilder;
  final CustomCardBuilder? toolCallBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? permissionBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? elicitationBuilder;
  final Widget Function(BuildContext context, TimelineItem item)? toolRequestBuilder;
  final VoidCallback? onTapEmptySpace;
  final chat_core.ChatTheme? theme;

  @override
  State<AgUiTranscript> createState() => AgUiTranscriptState();
}

class AgUiTranscriptState extends State<AgUiTranscript> {
  final _scroll = TranscriptScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void rearmFollow() => _scroll.rearm();

  Widget _buildMessage(
    BuildContext context,
    chat_core.Message message,
    int index,
    Map<String, chat_stream.StreamState> streamStates,
    Map<String, TimelineItem> requests,
  ) {
    final isSentByMe = message.authorId == kUserAuthorId;
    switch (message) {
      case chat_core.TextMessage():
        return (widget.textMessageBuilder ?? defaultTextMessageBuilder)(
          context, message, index, isSentByMe: isSentByMe, groupStatus: null);
      case chat_core.TextStreamMessage():
        return (widget.textStreamMessageBuilder ?? defaultTextStreamMessageBuilder)(
          context, message, index,
          isSentByMe: isSentByMe,
          groupStatus: null,
          streamState: streamStates[message.id] ?? const chat_stream.StreamStateLoading());
      case chat_core.CustomMessage():
        switch (message.metadata?['kind']) {
          case 'toolCall':
            return (widget.toolCallBuilder ?? defaultToolCallBuilder)(
              context, message, index, isSentByMe: isSentByMe, groupStatus: null);
          case 'permissionRequest':
            final item = requests[message.id];
            return item == null ? const SizedBox.shrink() :
                widget.permissionBuilder?.call(context, item) ?? const SizedBox.shrink();
          case 'elicitationRequest':
            final item = requests[message.id];
            return item == null ? const SizedBox.shrink() :
                widget.elicitationBuilder?.call(context, item) ?? const SizedBox.shrink();
          case 'toolRequest':
            final item = requests[message.id];
            return item == null ? const SizedBox.shrink() :
                widget.toolRequestBuilder?.call(context, item) ?? const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeline = widget.conversation.timeline;
    final messages = timelineToMessages(timeline);
    final streamStates = streamStatesFromTimeline(timeline);
    final requests = timelineRequestIndex(timeline);
    _scroll.scheduleStick();

    // Read purely to register a dependency: a keyboard inset shrinks the
    // viewport through a CONSTRAINT change, which re-layouts without
    // rebuilding. Reading it here turns an inset change into a rebuild, which
    // then flows through the same post-frame re-stick as everything else.
    MediaQuery.viewInsetsOf(context);

    final list = SliverList.builder(
      itemCount: messages.length,
      findChildIndexCallback: (key) {
        if (key is! ValueKey<String>) return null;
        final index = messages.indexWhere((m) => m.id == key.value);
        return index == -1 ? null : index;
      },
      itemBuilder: (context, index) {
        final message = messages[index];
        return KeyedSubtree(
          key: ValueKey<String>(message.id),
          child: RepaintBoundary(child: _buildMessage(
            context, message, index, streamStates, requests)),
        );
      },
    );

    Widget wrapped(Widget scrollView) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _scroll.handleNotification(notification);
            return false; // never consume — let it keep bubbling.
          },
          child: scrollView,
        );

    final Widget child;
    switch (widget.placement) {
      case ComposerPlacement.pinned:
        child = Column(
          children: [
            Expanded(
              child: wrapped(CustomScrollView(
                controller: _scroll.controller,
                slivers: [list],
              )),
            ),
            widget.composerBuilder(context),
          ],
        );
      case ComposerPlacement.inline:
        child = wrapped(CustomScrollView(
          controller: _scroll.controller,
          slivers: [
            list,
            SliverToBoxAdapter(child: widget.composerBuilder(context)),
            SliverFillRemaining(
              hasScrollBody: false,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTapEmptySpace,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ));
    }

    // AgUiChat gets these for free from flutter_chat_ui's Chat widget, which
    // wraps its whole subtree in Provider<ChatTheme>, Provider<UserID>, and
    // Provider<DateFormat>. AgUiTranscript bypasses Chat entirely, so
    // builders that construct flutter_chat_ui-family widgets directly (e.g.
    // FlyerChatTextStreamMessage, which reads all three via
    // context.select/context.read) need the same providers here. AgUiChat
    // itself has no timeFormat override parameter, so this mirrors that by
    // hardcoding Chat's own default rather than adding new surface area.
    return MultiProvider(
      providers: [
        Provider<chat_core.ChatTheme>.value(
          value: widget.theme ?? chat_core.ChatTheme.light(),
        ),
        Provider<chat_core.UserID>.value(value: widget.currentUserId),
        Provider<DateFormat>.value(value: DateFormat('HH:mm')),
      ],
      child: child,
    );
  }
}
