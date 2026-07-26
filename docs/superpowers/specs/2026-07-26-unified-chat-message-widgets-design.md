# Unified Chat Message Widgets — Design

## Problem

Episutra has two chat surfaces and they render messages in two unrelated, hand-rolled ways:

- **Global chat** (`chat_transcript_pane.dart`) already sits on `AgUiChat`/`Conversation`/`TimelineItem`, but overrides only `textMessageBuilder` (a bespoke `_EpisutraChatBubble`: `EpisutraPalette` colors, asymmetric "tail" corners, bot icon prefix) and `permissionBuilder` (a bespoke `_EpisutraPermissionCard` that inconsistently uses raw `Theme.of(context)` instead of the palette). Everything else falls back to `ag_ui_widgets_flutter`'s plain `Theme.of(context)`-only defaults.
- **Doc-scoped chat** (`document_chat_section.dart`) is fully bespoke and doesn't touch `AgUiChat` at all today — `_DocMessageBubble`/`_DocStreamingBubble`/`_DocA2uiBubble` read directly from `NoteChatCubit`'s legacy state shape (`state.messages`, `state.streamingText`, `state.activeToolName`, `state.pendingA2uiSurface`). A separate, already-in-flight plan (`docs/superpowers/plans/2026-07-25-note-chat-agui-migration-plan.md`, in episutra) migrates `NoteChatCubit` onto `IAgUiTransport`/`ConversationReducer`, which is what makes doc chat eligible to adopt `AgUiChat` at all. **This spec assumes that migration has landed** — it designs the shared rendering layer both surfaces will consume, not the doc-chat migration itself.

Neither surface renders markdown today — both are plain `Text`. `flutter_markdown_plus`/`markdown` are already app-level pubspec deps but are wired only into an unrelated attachment-rendering feature; `packages/episutra_markdown` is a parser-only (AST) package built for the track-changes editor, not chat.

## Scope

**In scope:**
- Two new widget-builder families in `ag_ui_widgets_flutter`: a full-width "stacked" layout and an aligned "bubble" layout, each covering all five `AgUiChat` builder slots (`textMessageBuilder`, `toolCallBuilder`, `permissionBuilder`, `elicitationBuilder`, `toolRequestBuilder`).
- Markdown rendering for message text, via `flutter_markdown_plus` + `package:markdown` (plain GFM, no CriticMarkup) added as new dependencies of `ag_ui_widgets_flutter`.
- Style configuration objects (raw Flutter types only — no app-specific types leak into the package).
- An extension point (`toolRequestOverrides`) so an app can render specific client-tool requests (e.g. doc chat's `render_surface` → `A2uiSurface`) distinctly from the generic fallback.

**Out of scope (follow-up work, not designed here):**
- Doc chat's actual switch from its bespoke bubbles to `AgUiChat` — that's wiring work in episutra, sequenced after this package change ships and after the note-chat migration plan completes.
- Global chat's/doc chat's actual adoption of these new builders (a small follow-up change in episutra once this package version is published).
- `composerBuilder` — untouched, apps keep supplying their own or use `AgUiChat`'s default.
- CriticMarkup rendering — explicitly rejected per user direction ("just the normal markdown lib, no fancy").

## Design

### 1. Two widget families, not one with a mode switch

A single "style object + layout-mode enum" was considered and rejected: the two layouts' style knobs barely overlap (alignment/max-width/per-side radii only matter for bubbles; background-tint-only differentiation only matters for the stacked layout), so a shared config would carry many always-ignored fields depending on mode. Instead:

- **`StackedChatBuilders`** — full-width, vertically-alternating messages (terminal/log style): each message spans the row width, sender is differentiated by background tint and an optional leading icon, no left/right alignment.
- **`BubbleChatBuilders`** — aligned, max-width-constrained bubbles: sent messages align right, received align left, each with independent background/border/corner-radius.

Both are built on shared internal helpers (markdown rendering, permission/elicitation/toolRequest card content) so there's no duplicated logic between them — only the message-shell/layout code differs. §3b shows the exact shared-helper signatures that make this concrete rather than asserted.

### 2. Style configuration (new files: `lib/src/style/stacked_chat_style.dart`, `lib/src/style/bubble_chat_style.dart`)

```dart
@freezed
abstract class StackedChatStyle with _$StackedChatStyle {
  const factory StackedChatStyle({
    required Color sentBackground,
    required Color receivedBackground,
    required TextStyle textStyle,
    Widget Function(BuildContext)? aiLeadingIconBuilder,
    @Default(EdgeInsets.symmetric(vertical: 8, horizontal: 12)) EdgeInsets padding,
    Color? cardBorderColor,
    @Default(BorderRadius.all(Radius.circular(8))) BorderRadius cardRadius,
    MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
  }) = _StackedChatStyle;
}

@freezed
abstract class BubbleChatStyle with _$BubbleChatStyle {
  const factory BubbleChatStyle({
    required Color sentBackground,
    required Color receivedBackground,
    Color? sentBorder,
    Color? receivedBorder,
    required TextStyle textStyle,
    required double maxWidth,
    @Default(BorderRadius.all(Radius.circular(12))) BorderRadius sentRadius,
    @Default(BorderRadius.all(Radius.circular(12))) BorderRadius receivedRadius,
    @Default(EdgeInsets.symmetric(vertical: 8, horizontal: 12)) EdgeInsets padding,
    MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
  }) = _BubbleChatStyle;
}
```

`Widget`/`Color`/`TextStyle`/`BorderRadius`/`EdgeInsets` are Flutter SDK types, not app types — this preserves the package's existing app-agnostic constraint (matching how `default_builders.dart` today touches only `Theme.of(context)`).

Neither config carries a `layoutMode` field — the choice of layout is which class you instantiate, not a field you set.

### 3. Shared action callbacks (new file: `lib/src/style/chat_action_callbacks.dart`)

Rendering an actionable permission/elicitation/toolRequest card requires calling back into whichever cubit/transport is driving that specific chat — the package can't know which, so the caller supplies:

```dart
class ChatActionCallbacks {
  const ChatActionCallbacks({
    required this.onPermissionOptionSelected,
    required this.onElicitationRespond,
    this.toolRequestOverrides = const {},
  });

  /// Signature-compatible with IAgUiTransport.respondPermission(callId,
  /// {optionId, cancelled}) — same parameter shapes/order (return type
  /// differs, Future<void> vs void, which is fine: a plain tear-off of an
  /// async method satisfies a void-returning function-typed field per
  /// Dart's void-return covariance, same pattern as VoidCallback). Renamed
  /// callId -> requestId deliberately: requestId is
  /// PermissionRequestTimelineItem.requestId (== ACP callId).
  final void Function(String requestId, {String? optionId, bool cancelled}) onPermissionOptionSelected;

  /// Signature-compatible with IAgUiTransport.respondElicitation
  /// (elicitationId, response) — identical parameter shapes, same
  /// tear-off-compatibility note as above.
  final void Function(String requestId, Map<String, dynamic> response) onElicitationRespond;

  /// Keyed by ToolRequestTimelineItem.toolName. A registered entry fully
  /// replaces the generic toolRequest card for that tool name (e.g. doc
  /// chat registers 'render_surface' -> its own A2uiSurface-hosting
  /// widget). Unregistered tool names get the generic fallback card.
  final Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> toolRequestOverrides;
}
```

Both `onPermissionOptionSelected` and `onElicitationRespond` are deliberately signature-compatible with `IAgUiTransport`'s existing methods (see doc comments above for the one intentional divergence — the return type) — callers wire them with a plain tear-off (`callbacks: ChatActionCallbacks(onPermissionOptionSelected: transport.respondPermission, onElicitationRespond: transport.respondElicitation, ...)`) or a one-line lambda if the cubit needs to also call `resolveRequest` first (as global chat's `ChatCubit.submitPermission` and the migrated `NoteChatCubit` both do).

The generic fallback toolRequest card (used for any `toolName` not in `toolRequestOverrides`) renders the tool's `toolTitle ?? toolName` and a "waiting for client" indicator — there is no generic action for it since the package doesn't know what a given client tool means; it's observational only, matching how `toolCallBuilder`'s default is already observe-only for built-in ACP tools.

### 3b. Shared card-content helpers (new file: `lib/src/widgets/chat_action_cards.dart`)

To make the "no duplicated logic between the two families" claim in §1 concrete rather than asserted, both builder families delegate permission/elicitation/toolRequest *content* rendering to shared functions that take a pre-resolved decoration/style — each family resolves its own `BoxDecoration` (single-value for `StackedChatStyle`, alignment-dependent for `BubbleChatStyle`) before calling in, so the shared helpers never need to know which family invoked them:

```dart
Widget buildPermissionCardContent(
  BuildContext context,
  PermissionRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required void Function(String requestId, {String? optionId, bool cancelled}) onSelect,
}) {
  // Card with decoration, item.toolTitle/description, one button per
  // item.options calling onSelect(item.requestId, optionId: option.optionId).
}

Widget buildElicitationCardContent(
  BuildContext context,
  ElicitationRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required void Function(String requestId, Map<String, dynamic> response) onRespond,
}) {
  // Card with decoration, item.message, mode-appropriate input
  // ('form' -> fields from item.schema, 'url' -> a link/button), calls
  // onRespond(item.requestId, ...) on submit.
}

Widget buildToolRequestCardContent(
  BuildContext context,
  ToolRequestTimelineItem item, {
  required BoxDecoration decoration,
  required TextStyle textStyle,
  required Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> overrides,
}) {
  final override = overrides[item.toolName];
  if (override != null) return override(context, item);
  // Generic fallback: card with decoration, (item.toolTitle ?? item.toolName),
  // a "waiting for client" indicator — observational only, no action.
}
```

Each builder family's `permissionBuilder`/`elicitationBuilder`/`toolRequestBuilder` getter (§4) is then just: downcast the `TimelineItem`, build its own `BoxDecoration`/`TextStyle` from its own style object, and call the matching shared function. Only `textMessageBuilder`/`toolCallBuilder`'s outer shell (alignment, width constraint, background) and the three cards' decoration-construction are family-specific; all card *content* logic lives in one place.

### 4. Builder classes (new files: `lib/src/widgets/stacked_chat_builders.dart`, `lib/src/widgets/bubble_chat_builders.dart`)

```dart
class StackedChatBuilders {
  StackedChatBuilders(this.style, this.callbacks);
  final StackedChatStyle style;
  final ChatActionCallbacks callbacks;

  chat_core.TextMessageBuilder get textMessageBuilder => (context, message, index, {required isSentByMe, groupStatus}) {
    // full-width Container tinted by style.sentBackground/receivedBackground,
    // body rendered via chatMarkdownBody(context, message.text,
    // styleSheetBuilder: style.markdownStyleSheetBuilder) (see §5),
    // optional style.aiLeadingIconBuilder prefixed for !isSentByMe.
    // message.metadata?['kind'] == 'reasoning' is not distinguished — out
    // of scope for this spec's 5-slot coverage; both kinds render identically.
  };

  CustomCardBuilder get toolCallBuilder => ...; // same shell, message.metadata name/result/diffs
  Widget Function(BuildContext, TimelineItem) get permissionBuilder => ...; // downcasts to PermissionRequestTimelineItem, builds a BoxDecoration from style.cardRadius/cardBorderColor, delegates to buildPermissionCardContent (§3b)
  Widget Function(BuildContext, TimelineItem) get elicitationBuilder => ...; // downcasts to ElicitationRequestTimelineItem, same decoration, delegates to buildElicitationCardContent (§3b)
  Widget Function(BuildContext, TimelineItem) get toolRequestBuilder => ...; // downcasts to ToolRequestTimelineItem, same decoration, delegates to buildToolRequestCardContent (§3b) with callbacks.toolRequestOverrides
}

class BubbleChatBuilders {
  BubbleChatBuilders(this.style, this.callbacks);
  final BubbleChatStyle style;
  final ChatActionCallbacks callbacks;
  // same five getters, using Align(alignment: isSentByMe ? right : left) + maxWidth constraint + per-side radius/color
}
```

Usage in an app (illustrative, episutra-side — not part of this package's own tests):

```dart
final builders = BubbleChatBuilders(myEpisutraBubbleStyle, myCallbacks);
AgUiChat(
  conversation: conversation,
  currentUserId: kUserAuthorId,
  onSendMessage: cubit.sendMessage,
  textMessageBuilder: builders.textMessageBuilder,
  toolCallBuilder: builders.toolCallBuilder,
  permissionBuilder: builders.permissionBuilder,
  elicitationBuilder: builders.elicitationBuilder,
  toolRequestBuilder: builders.toolRequestBuilder,
);
```

Each app builds exactly one `StackedChatStyle`/`BubbleChatStyle` + one `ChatActionCallbacks` (not per-message) and constructs one builders instance per chat widget instance.

### 5. Markdown rendering (new file: `lib/src/widgets/markdown_body.dart`)

A single internal helper shared by both builder families:

```dart
Widget chatMarkdownBody(
  BuildContext context,
  String text, {
  MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder,
}) {
  return MarkdownBody(
    data: text,
    selectable: false,
    styleSheet: styleSheetBuilder?.call(context) ??
        MarkdownStyleSheet.fromTheme(Theme.of(context)),
  );
}
```

Uses `flutter_markdown_plus`'s `MarkdownBody` (not the full scrolling `Markdown` widget — messages sit inside `flutter_chat_ui`'s own scroll view) over `package:markdown`'s default GFM-ish parser. No CriticMarkup, no custom AST layer — `episutra_markdown` is untouched and stays scoped to the track-changes editor. `selectable: false` matches today's plain-`Text` behavior (chat bubbles aren't currently selectable); revisit only if a future spec asks for text selection.

New `pubspec.yaml` dependencies:
```yaml
flutter_markdown_plus: ^1.0.3
markdown: ^7.3.1
```
(Same version floors already used at episutra's app level, so no version-mismatch risk when episutra adopts this package version.)

### 6. Barrel exports (modify: `lib/ag_ui_widgets_flutter.dart`)

The package's public surface is a hand-maintained barrel file — none of `default_builders.dart`'s functions are exported today, so nothing here is exported automatically just by living under `lib/src/`. Add explicit export lines for every new public symbol in the same commit that adds the files:

```dart
export 'src/style/stacked_chat_style.dart';
export 'src/style/bubble_chat_style.dart';
export 'src/style/chat_action_callbacks.dart';
export 'src/widgets/stacked_chat_builders.dart';
export 'src/widgets/bubble_chat_builders.dart';
export 'src/widgets/markdown_body.dart' show chatMarkdownBody;
```

`chat_action_cards.dart`'s three `build*CardContent` helpers are internal (consumed only by the two builder classes within this package) and are NOT exported.

### 7. Version bump

`0.2.0` → `0.3.0` (additive: two new builder-class families + two new style configs + one new callbacks class + two new dependencies; no existing public API changes). Bump `pubspec.yaml`'s `version:` field as part of the same commit that adds the new files.

## Testing

- `test/style/stacked_chat_builders_test.dart` / `test/style/bubble_chat_builders_test.dart`: for each of the 5 builder getters — renders with correct background/alignment/radius per `isSentByMe`; markdown text (`**bold**`, a list, a fenced code block, a GFM table) renders as formatted output, not literal syntax characters; permission card renders one tappable option per `PermissionOption` and calls `onPermissionOptionSelected` with the tapped option's `optionId`; elicitation card calls `onElicitationRespond` with a well-formed response map; toolRequest builder dispatches to a registered `toolRequestOverrides` entry when present and falls back to the generic card (asserting on rendered text, e.g. `toolTitle`) when not.
- `test/widgets/markdown_body_test.dart`: the shared helper renders GFM constructs correctly and respects a custom `styleSheetBuilder` when supplied, falling back to `MarkdownStyleSheet.fromTheme` when not.

## Open Questions

None — all prior open questions (scope vs. doc-chat migration, theming approach, builder coverage, markdown library choice, one-widget-with-mode vs. two-widgets) were resolved during design and are reflected above.
