// Exports are added as each piece lands (Tasks 2-5).
export 'package:flutter_chat_core/flutter_chat_core.dart'
    show ChatTheme, ChatColors, ChatTypography;
export 'src/model/conversation.dart';
export 'src/model/conversation_reducer.dart';
export 'src/transport/ag_ui_transport.dart';
export 'src/widgets/ag_ui_chat.dart';
export 'src/widgets/composer_placement.dart';
export 'src/widgets/timeline_to_messages.dart' show timelineToMessages, streamStatesFromTimeline;
export 'src/style/stacked_chat_style.dart';
export 'src/style/bubble_chat_style.dart';
export 'src/style/chat_action_callbacks.dart';
export 'src/widgets/stacked_chat_builders.dart';
export 'src/widgets/bubble_chat_builders.dart';
export 'src/widgets/markdown_body.dart' show chatMarkdownBody;
