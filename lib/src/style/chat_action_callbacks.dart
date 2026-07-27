// lib/src/style/chat_action_callbacks.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import '../model/conversation.dart';

/// Action hooks a builder-family caller supplies so shared card content
/// (permission/elicitation/toolRequest) can call back into whichever
/// cubit/transport is driving that specific chat — the package can't
/// know which.
class ChatActionCallbacks {
  const ChatActionCallbacks({
    required this.onPermissionOptionSelected,
    required this.onElicitationRespond,
    this.toolRequestOverrides = const {},
    this.toolCallOverrides = const {},
  });

  /// Signature-compatible with IAgUiTransport.respondPermission(callId,
  /// {optionId, cancelled}) — same parameter shapes/order (return type
  /// differs, Future<void> vs void: a plain tear-off of an async method
  /// satisfies a void-returning function-typed field per Dart's
  /// void-return covariance, same pattern as VoidCallback). Renamed
  /// callId -> requestId deliberately: requestId is
  /// PermissionRequestTimelineItem.requestId (== ACP callId).
  final void Function(String requestId, {String? optionId, bool cancelled}) onPermissionOptionSelected;

  /// Signature-compatible with IAgUiTransport.respondElicitation
  /// (elicitationId, response).
  final void Function(String requestId, Map<String, dynamic> response) onElicitationRespond;

  /// Keyed by ToolRequestTimelineItem.toolName. A registered entry fully
  /// replaces the generic toolRequest card for that tool name (e.g. an
  /// app registers 'render_surface' -> its own surface-hosting widget).
  /// Unregistered tool names get the generic fallback card.
  final Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> toolRequestOverrides;

  /// Keyed by the tool-call's `name` (`ToolCallTimelineItem.name`). A
  /// registered entry fully replaces the generic tool-call card for that
  /// name — mirrors [toolRequestOverrides] exactly.
  final Map<String, Widget Function(BuildContext, chat_core.CustomMessage)> toolCallOverrides;
}