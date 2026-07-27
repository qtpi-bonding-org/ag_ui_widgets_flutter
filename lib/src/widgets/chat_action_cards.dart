// lib/src/widgets/chat_action_cards.dart
import 'package:flutter/material.dart';
import '../model/conversation.dart';
import 'diff_lines_view.dart';

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
/// builder family. Renders mode-appropriate input: a typed field per
/// JSON-Schema [item.schema] property for `mode == 'form'`, a link button
/// to [item.url] for `mode == 'url'`, otherwise a plain acknowledgement
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
      final properties = (item.schema?['properties'] as Map<String, dynamic>?) ?? const {};
      // The elicitation card is typically embedded in a decorated chat
      // bubble; without an explicit `Material` ancestor, `CheckboxListTile`'s
      // ink splash and `DropdownButtonFormField`'s input border paint onto a
      // backgrounded `DecoratedBox` whose `Container` would otherwise hide
      // them (`flutter` throws `ListTile background color ... may be invisible`
      // here). This `Material` is local — it only wraps the form so it does
      // not paint over the caller's outer card decoration.
      action = Material(
        type: MaterialType.transparency,
        child: _ElicitationForm(
          properties: properties,
          onSubmit: (values) => onRespond(item.requestId, values),
        ),
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


/// Card content for a tool-call message — name, result, and (if present)
/// every diff hunk in `diffs` (shape: `[{'path', 'oldText', 'newText'}, ...]`,
/// the same JSON shape [ToolDiff] serializes to in
/// `timeline_to_messages.dart`). Shared by every builder family.
Widget buildToolCallCardContent(
  BuildContext context, {
  required String name,
  required String? result,
  required List<dynamic> diffs,
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required Color diffAddedColor,
  required Color diffRemovedColor,
}) {
  return Container(
    decoration: decoration,
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: textStyle),
        if (result != null) ...[
          const SizedBox(height: 4),
          Text(result, style: textStyle),
        ],
        if (diffs.isNotEmpty) ...[
          const SizedBox(height: 4),
          for (final d in diffs)
            DiffLinesView(
              path: (d as Map)['path'] as String? ?? '',
              oldText: d['oldText'] as String? ?? '',
              newText: d['newText'] as String? ?? '',
              textStyle: textStyle,
              addedColor: diffAddedColor,
              removedColor: diffRemovedColor,
            ),
        ],
      ],
    ),
  );
}

/// One elicitation form: a typed field per JSON-Schema property (checkbox
/// for `boolean`, numeric keyboard for `integer`/`number`, dropdown for an
/// `enum` list, plain text otherwise), plus a Submit button collecting every
/// field into the `Map<String, dynamic>` [onSubmit] expects.
class _ElicitationForm extends StatefulWidget {
  const _ElicitationForm({required this.properties, required this.onSubmit});

  final Map<String, dynamic> properties;
  final void Function(Map<String, dynamic> values) onSubmit;

  @override
  State<_ElicitationForm> createState() => _ElicitationFormState();
}

class _ElicitationFormState extends State<_ElicitationForm> {
  final _controllers = <String, TextEditingController>{};
  final _boolValues = <String, bool>{};

  @override
  void initState() {
    super.initState();
    for (final entry in widget.properties.entries) {
      final spec = (entry.value as Map<String, dynamic>?) ?? const {};
      if (spec['type'] == 'boolean') {
        _boolValues[entry.key] = (spec['currentValue'] as bool?) ?? false;
      } else {
        _controllers[entry.key] = TextEditingController(text: spec['currentValue']?.toString() ?? '');
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in widget.properties.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _field(entry.key, (entry.value as Map<String, dynamic>?) ?? const {}),
          ),
        ElevatedButton(
          onPressed: () => widget.onSubmit({
            for (final entry in _controllers.entries) entry.key: entry.value.text,
            for (final entry in _boolValues.entries) entry.key: entry.value,
          }),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _field(String key, Map<String, dynamic> spec) {
    final label = spec['title'] as String? ?? key;
    final type = spec['type'] as String?;
    final enumValues = spec['enum'] as List<dynamic>?;

    if (type == 'boolean') {
      return CheckboxListTile(
        title: Text(label),
        value: _boolValues[key] ?? false,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        onChanged: (value) => setState(() => _boolValues[key] = value ?? false),
      );
    }
    if (enumValues != null && enumValues.isNotEmpty) {
      final current = _controllers[key]!.text;
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        initialValue: current.isNotEmpty ? current : null,
        items: [for (final v in enumValues) DropdownMenuItem(value: v.toString(), child: Text(v.toString()))],
        onChanged: (value) => setState(() => _controllers[key]!.text = value ?? ''),
      );
    }
    final isNumeric = type == 'integer' || type == 'number';
    return TextField(
      controller: _controllers[key],
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    );
  }
}
