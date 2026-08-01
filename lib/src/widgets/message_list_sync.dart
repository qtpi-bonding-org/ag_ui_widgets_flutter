// lib/src/widgets/message_list_sync.dart
// Pure diff: old message list -> new message list, expressed as a minimal
// set of ChatController-shaped actions. Extracted from AgUiChat._syncMessages
// so the diffing logic itself (order-preservation check, insert/remove/
// update classification) is directly unit-testable without pumping a widget
// tree.
//
// Why not just call ChatController.setMessages on every update (the
// previous, simpler implementation): flutter_chat_ui's ChatAnimatedList
// translates a diffutil "changed" entry (same id, different content) into a
// remove-then-insert of that SAME id. Flutter's SliverAnimatedList performs
// the insert immediately but defers the remove for a ~250ms fade animation
// (see animated_scroll_view.dart's insertItem vs removeItem), so for that
// whole window two widgets share the identical ValueKey inside one
// SliverAnimatedList — which corrupts its child-index bookkeeping and
// crashes with 'indexOf(child) > index'/'indexOf(child) == index'
// assertions in RenderSliverMultiBoxAdaptor. This happens on ANY same-id
// content change — every streaming text delta, every tool-call args/result
// update — not just permission-request churn (confirmed via a real crash
// log, 2026-08-01).
//
// The fix: route same-id content changes through ChatController.updateMessage
// instead, which never touches SliverAnimatedList at all (verified against
// flutter_chat_ui's own source: ChatOperationType.update is handled with a
// bare `_oldList[op.index!] = op.message!`, no sliver interaction — each row
// widget, ChatMessageInternal, subscribes to the operations stream itself
// and rebuilds only its own row). insertMessage/removeMessage are each
// independently safe too (SliverAnimatedList only breaks on a same-KEY
// remove+insert pair in one diff batch, not on distinct-id inserts/removes
// happening together) — only same-id CHANGES needed rerouting.
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;

sealed class SyncAction {
  const SyncAction();
}

/// A message present in the old list but not the new one.
class RemoveAction extends SyncAction {
  const RemoveAction(this.message);
  final chat_core.Message message;
}

/// A message present in both lists at the same id, with different content —
/// applied via `ChatController.updateMessage`, the crash-safe path.
class UpdateAction extends SyncAction {
  const UpdateAction(this.oldMessage, this.newMessage);
  final chat_core.Message oldMessage;
  final chat_core.Message newMessage;
}

/// A message present in the new list but not the old one, at its final
/// target [index] in the new list.
class InsertAction extends SyncAction {
  const InsertAction(this.message, this.index);
  final chat_core.Message message;
  final int index;
}

/// A full-list reset — the safe fallback for a shape this incremental diff
/// doesn't handle: a genuine reorder among ids present in both lists.
/// `ConversationReducer`'s design should never actually produce that (each
/// item's `OrderKey` is assigned once and reused — see its own doc
/// comments), so this should never fire in practice; the check exists as
/// defensive input validation for a SHARED package with more than one
/// producer, not an assumption baked in silently. Also covers a full
/// session reset (every id changes at once).
class ResetAction extends SyncAction {
  const ResetAction(this.messages);
  final List<chat_core.Message> messages;
}

/// Computes the minimal ordered set of [SyncAction]s to turn [oldMessages]
/// into [newMessages]. Pure — no side effects, directly unit-testable
/// without a `ChatController` or a widget tree. Applying every action (in
/// the order returned) to a `ChatController` starting at [oldMessages]
/// leaves it holding exactly [newMessages].
List<SyncAction> computeMessageListSyncActions(
  List<chat_core.Message> oldMessages,
  List<chat_core.Message> newMessages,
) {
  final oldIds = oldMessages.map((m) => m.id).toSet();
  final newIds = newMessages.map((m) => m.id).toSet();

  final oldSurvivingIds =
      oldMessages.map((m) => m.id).where(newIds.contains).toList();
  final newSurvivingIds =
      newMessages.map((m) => m.id).where(oldIds.contains).toList();
  if (!_idOrderEquals(oldSurvivingIds, newSurvivingIds)) {
    return [ResetAction(newMessages)];
  }

  final oldById = {for (final m in oldMessages) m.id: m};
  final newById = {for (final m in newMessages) m.id: m};
  final actions = <SyncAction>[];

  // Removals first — so the insertions below, which are computed against
  // NEW-list target indices, land correctly once removed ids are gone.
  for (final old in oldMessages) {
    if (!newIds.contains(old.id)) actions.add(RemoveAction(old));
  }

  // Updates — order doesn't matter; these never change list length/position.
  for (final old in oldMessages) {
    final updated = newById[old.id];
    if (updated != null && updated != old) {
      actions.add(UpdateAction(old, updated));
    }
  }

  // Insertions, in ascending target-index order — required for correctness:
  // applying them left-to-right against the new list's own indices means
  // each insert's target index is still valid when it's actually applied
  // (everything before it is already in its final place; the standard
  // ascending-index-order insert algorithm).
  for (var i = 0; i < newMessages.length; i++) {
    final msg = newMessages[i];
    if (!oldById.containsKey(msg.id)) actions.add(InsertAction(msg, i));
  }

  return actions;
}

bool _idOrderEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
