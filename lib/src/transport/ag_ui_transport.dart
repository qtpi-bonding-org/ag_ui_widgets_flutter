import "package:ag_ui/ag_ui.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "ag_ui_transport.freezed.dart";

/// One piece of context to send alongside a user message — e.g. the current
/// note's body, or a semantic-neighbor snippet. Deliberately backend-agnostic
/// (not ACP's `AcpContextItem`, not any single app's domain type) — each
/// `IAgUiTransport` implementation maps this to its own richer type at the
/// boundary, same pattern as every other parameter on this interface.
@freezed
abstract class AgUiContextItem with _$AgUiContextItem {
  const factory AgUiContextItem({required String uri, required String text}) = _AgUiContextItem;
}

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

  Future<void> sendMessage(String text, {List<AgUiContextItem> context = const []});

  Future<void> cancel();

  Future<void> respondPermission(String callId, {String? optionId, bool cancelled = false});

  Future<void> respondElicitation(String elicitationId, Map<String, dynamic> response);

  Future<void> submitToolResult(String callId, String resultJson);

  Future<void> setMode(String modeId);

  Future<void> setConfigOption(String optionId, String value);

  Future<void> dispose();
}
