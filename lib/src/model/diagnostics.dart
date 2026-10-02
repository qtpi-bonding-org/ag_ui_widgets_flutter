// lib/src/model/diagnostics.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnostics.freezed.dart';

/// Why the reducer recorded an item instead of folding it into the
/// conversation.
enum DiagnosticKind {
  /// A CUSTOM event whose name the reducer does not know.
  unknownCustom,

  /// A standard AG-UI event type the reducer does not fold (e.g. a step or
  /// activity event).
  unhandledEvent,

  /// A RAW event (the adapter uses these for content it could not type).
  raw,

  /// A recognised event, state key or patch whose payload was the wrong type
  /// or shape.
  malformedPayload,

  /// A top-level state key under `/<namespace>` the reducer does not read, or
  /// a patch aimed outside the namespace.
  unknownStateKey,
}

/// Something the reducer saw but did not fold into the timeline or session
/// state. Kept (bounded) so nothing is silently lost.
@freezed
abstract class Diagnostic with _$Diagnostic {
  const factory Diagnostic({
    required DiagnosticKind kind,
    required String name,
    Object? payload,

    /// Monotonic over the reducer's whole life — a replay reset does not
    /// restart it — so diagnostics stay ordered.
    required int index,
  }) = _Diagnostic;
}
