// lib/src/widgets/chat_action_cards.dart
import 'package:flutter/material.dart';
import '../model/conversation.dart';

/// Card content for a pending permission request, shared by every
/// builder family. Callers resolve their own [decoration]/[textStyle]
/// from their own style object before calling in — this function never
/// needs to know which family invoked it.
Widget buildPermissionCardContent(
  BuildContext context,
  PermissionRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required void Function(String requestId, {String? optionId, bool cancelled}) onSelect,
}) {
  return Container(
    decoration: decoration,
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.toolTitle ?? item.description ?? 'Permission requested', style: textStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final option in item.options)
              ElevatedButton(
                onPressed: () => onSelect(item.requestId, optionId: option.optionId),
                child: Text(option.label),
              ),
          ],
        ),
      ],
    ),
  );
}

/// Card content for a pending elicitation request, shared by every
/// builder family. Renders mode-appropriate input: a text field per
/// [item.schema] property for `mode == 'form'`, a link button to
/// [item.url] for `mode == 'url'`, otherwise a plain acknowledgement
/// button.
Widget buildElicitationCardContent(
  BuildContext context,
  ElicitationRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required void Function(String requestId, Map<String, dynamic> response) onRespond,
}) {
  Widget action;
  switch (item.mode) {
    case 'form':
      final controllers = <String, TextEditingController>{
        for (final key in (item.schema?.keys ?? const <String>[])) key: TextEditingController(),
      };
      action = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in controllers.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(controller: entry.value, decoration: InputDecoration(labelText: entry.key)),
            ),
          ElevatedButton(
            onPressed: () => onRespond(item.requestId, {
              for (final entry in controllers.entries) entry.key: entry.value.text,
            }),
            child: const Text('Submit'),
          ),
        ],
      );
    case 'url':
      action = ElevatedButton(
        onPressed: () => onRespond(item.requestId, {'url': item.url}),
        child: const Text('Open link'),
      );
    default:
      action = ElevatedButton(
        onPressed: () => onRespond(item.requestId, {'acknowledged': true}),
        child: const Text('Continue'),
      );
  }
  return Container(
    decoration: decoration,
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.message, style: textStyle),
        const SizedBox(height: 8),
        action,
      ],
    ),
  );
}

/// Card content for a client-executed tool request. A registered
/// [overrides] entry fully replaces this generic card for that
/// [ToolRequestTimelineItem.toolName]; unregistered names get an
/// observational fallback — the package can't know what a given
/// client tool means, matching how the built-in toolCallBuilder
/// default is already observe-only.
Widget buildToolRequestCardContent(
  BuildContext context,
  ToolRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> overrides,
}) {
  final override = overrides[item.toolName];
  if (override != null) return override(context, item);
  return Container(
    decoration: decoration,
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.toolTitle ?? item.toolName, style: textStyle),
        const SizedBox(height: 4),
        Text('Waiting for client…', style: textStyle.copyWith(fontStyle: FontStyle.italic)),
      ],
    ),
  );
}
