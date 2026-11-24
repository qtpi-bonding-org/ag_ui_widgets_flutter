// lib/src/widgets/transcript_selection.dart
//
// Text selection for a transcript. Flutter joins selected pieces with nothing
// between them, so paragraphs, list items and messages would copy as one run
// of text; these containers put the line breaks back.
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps the whole transcript (outside its scroll view).
class TranscriptSelection extends StatefulWidget {
  const TranscriptSelection({super.key, required this.onActiveChanged, required this.child});

  /// Whether any text is selected.
  final ValueChanged<bool> onActiveChanged;
  final Widget child;

  @override
  State<TranscriptSelection> createState() => _TranscriptSelectionState();
}

class _TranscriptSelectionState extends State<TranscriptSelection> {
  // Ours, so TranscriptControl can tell when the region took focus.
  final _focus = FocusNode(debugLabel: 'transcript selection');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SelectionArea(
        focusNode: _focus,
        onSelectionChanged: (content) =>
            widget.onActiveChanged(content != null && content.plainText.isNotEmpty),
        child: _Container(create: _TranscriptDelegate.new, child: widget.child),
      );
}

/// Wraps one message.
class MessageSelection extends StatelessWidget {
  const MessageSelection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _Container(create: _MessageDelegate.new, child: child);
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

class _Container extends StatefulWidget {
  const _Container({required this.create, required this.child});

  final StaticSelectionContainerDelegate Function() create;
  final Widget child;

  @override
  State<_Container> createState() => _ContainerState();
}

class _ContainerState extends State<_Container> {
  late final _delegate = widget.create();

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
  static final _marker = RegExp(r'^(•|\d+\.)$');

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
        final sameRow = rect.top < before.center.dy && rect.bottom > before.center.dy;
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
    return MatrixUtils.transformRect(selectable.getTransformTo(null), local);
  }
}
