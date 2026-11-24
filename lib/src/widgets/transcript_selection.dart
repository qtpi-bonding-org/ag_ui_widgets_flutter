// lib/src/widgets/transcript_selection.dart
//
// Text selection for a transcript. Flutter joins selected pieces with nothing
// between them, so paragraphs, list items and messages would copy as one run
// of text; these containers put the line breaks back.
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps the whole transcript (outside its scroll view).
class TranscriptSelection extends StatefulWidget {
  const TranscriptSelection({super.key, required this.child});

  final Widget child;

  @override
  State<TranscriptSelection> createState() => TranscriptSelectionState();
}

class TranscriptSelectionState extends State<TranscriptSelection> {
  // Ours, so TranscriptControl can tell when the region took focus.
  final _focus = FocusNode(debugLabel: 'transcript selection');

  late final _delegate = _TranscriptDelegate();

  /// Whether any text is selected right now. Asked, not stored: when the
  /// selected row is replaced the selection ends without a notification.
  bool get hasSelection => _delegate.getSelectedContent()?.plainText.isNotEmpty ?? false;

  @override
  void dispose() {
    _focus.dispose();
    _delegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SelectionArea(
        focusNode: _focus,
        child: SelectionContainer(delegate: _delegate, child: widget.child),
      );
}

/// Wraps one message.
class MessageSelection extends StatelessWidget {
  const MessageSelection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _MessageContainer(child: child);
}

/// A control inside the transcript: not part of the selection, and pressing it
/// does not move keyboard focus to the transcript.
class TranscriptControl extends StatefulWidget {
  const TranscriptControl({super.key, required this.child});

  final Widget child;

  @override
  State<TranscriptControl> createState() => _TranscriptControlState();
}

class _TranscriptControlState extends State<TranscriptControl> {
  FocusNode? _before;

  /// The selection region takes focus when a press is held. Give it back,
  /// unless something else (a text field in a card) took it.
  void _restore() {
    final before = _before;
    _before = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || before == null || before.context == null) return;
      final region = context.findAncestorWidgetOfExactType<SelectableRegion>();
      if (region?.focusNode?.hasPrimaryFocus ?? false) before.requestFocus();
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (_) => _before = FocusManager.instance.primaryFocus,
        onPointerUp: (_) => _restore(),
        onPointerCancel: (_) => _restore(),
        child: SelectionContainer.disabled(child: widget.child),
      );
}

class _MessageContainer extends StatefulWidget {
  const _MessageContainer({required this.child});

  final Widget child;

  @override
  State<_MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<_MessageContainer> {
  final _delegate = _MessageDelegate();

  @override
  void dispose() {
    _delegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SelectionContainer(delegate: _delegate, child: widget.child);
}

/// Drops the separator the last message added.
class _TranscriptDelegate extends StaticSelectionContainerDelegate {
  @override
  SelectedContent? getSelectedContent() {
    final content = super.getSelectedContent();
    return content == null ? null : SelectedContent(plainText: content.plainText.trimRight());
  }
}

/// Pieces on different rows are joined with a line break, pieces on one row
/// with a tab when there is a gap (table cells), a space after a list marker,
/// and nothing otherwise. Ends with a blank line, because the scroll view
/// between this and [_TranscriptDelegate] joins messages with nothing.
class _MessageDelegate extends StaticSelectionContainerDelegate {
  static final _marker = RegExp(r'^(•|\d+[.)])$');

  @override
  SelectedContent? getSelectedContent() {
    final out = StringBuffer();
    Rect? previousRect;
    var previousText = '';
    for (final selectable in selectables) {
      final text = selectable.getSelectedContent()?.plainText;
      if (text == null || text.isEmpty) continue;
      final rect = _rectOf(selectable);
      final before = previousRect;
      if (before != null) {
        final overlap = min(rect.bottom, before.bottom) - max(rect.top, before.top);
        final sameRow = overlap > min(rect.height, before.height) / 2;
        if (!sameRow) {
          out.write('\n');
        } else if (_marker.hasMatch(previousText.trim())) {
          out.write(' ');
        } else if (rect.left - before.right > 1) {
          out.write('\t');
        }
      }
      out.write(text);
      previousRect = rect;
      previousText = text;
    }
    return out.isEmpty ? null : SelectedContent(plainText: '$out\n\n');
  }

  Rect _rectOf(Selectable selectable) {
    final boxes = selectable.boundingBoxes;
    final local = boxes.isEmpty ? Offset.zero & selectable.size : boxes.first;
    // Relative to the message: a row kept alive off screen has no usable
    // position in the window.
    return MatrixUtils.transformRect(getTransformFrom(selectable), local);
  }
}
