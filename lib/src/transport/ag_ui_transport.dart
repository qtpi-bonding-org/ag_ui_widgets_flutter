import 'package:ag_ui/ag_ui.dart';

/// A backend-agnostic source of AG-UI events plus the actions a UI can
/// take. Parameter types here are deliberately primitive
/// (`Map<String, dynamic>`/`String`), not borrowed from any single app's
/// domain types (e.g. NOT `acp_dart`'s `SetSessionConfigOptionRequest`,
/// NOT a pocketcoder-specific `ElicitationResponse` class) — each
/// implementation converts to/from its own richer types at the boundary.
/// See design spec's "The transport interface is shared; transport
/// implementations are not" for why implementations diverge (in-process
/// FRB call vs. resumable SSE + cache) while this contract doesn't.
abstract class IAgUiTransport {
  Stream<BaseEvent> get events;

  Future<void> sendMessage(String text);

  Future<void> cancel();

  Future<void> respondPermission(String callId, {String? optionId, bool cancelled = false});

  Future<void> respondElicitation(String elicitationId, Map<String, dynamic> response);

  Future<void> setMode(String modeId);

  Future<void> setConfigOption(String optionId, String value);

  Future<void> dispose();
}
