// lib/src/widgets/composer_placement.dart

/// Where [AgUiTranscript] puts its composer relative to the transcript.
enum ComposerPlacement {
  /// The composer is the last item *inside* the scroll content. A short
  /// conversation sits at the top of the viewport and grows downward, so the
  /// prompt migrates down as output accumulates — terminal behavior.
  ///
  /// Consequence: the composer is only on screen when scrolled to the end.
  inline,

  /// The composer is fixed below the scroll viewport and always visible.
  /// Correct for a small, always-open chat panel.
  pinned,
}
