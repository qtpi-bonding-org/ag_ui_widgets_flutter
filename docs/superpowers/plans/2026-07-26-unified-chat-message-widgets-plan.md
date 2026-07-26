# Unified Chat Message Widgets Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add two new widget-builder families to `ag_ui_widgets_flutter` — `StackedChatBuilders`
(full-width, vertically-alternating) and `BubbleChatBuilders` (aligned, max-width bubbles) — each
covering all five `AgUiChat` builder slots with markdown rendering, so any consuming app can get a
fully themed, consistent chat surface from one style object instead of hand-rolling bubbles.

**Architecture:** A shared `chatMarkdownBody` helper (via `flutter_markdown_plus`) renders message
text; two independent Freezed style configs (`StackedChatStyle`, `BubbleChatStyle`, raw Flutter
types only) plus one shared `ChatActionCallbacks` bundle parameterize two builder classes. Card
*content* for permission/elicitation/toolRequest is factored into shared internal helper functions
so the two builder classes only differ in layout/decoration, never in card logic.

**Tech Stack:** Dart (Freezed for style configs), Flutter widgets, `flutter_markdown_plus` +
`package:markdown` (new deps), `flutter_test` widget tests.

## Global Constraints

- Spec: `/Users/aicoder/Documents/ag_ui_widgets_flutter/docs/superpowers/specs/2026-07-26-unified-chat-message-widgets-design.md`
  — read it in full before starting; every task below implements a specific numbered section of it.
- **Single repo, single package:** all work happens in `/Users/aicoder/Documents/ag_ui_widgets_flutter`.
  No episutra-side changes are part of this plan (doc chat's actual migration to `AgUiChat` and both
  apps' adoption of these new builders are separate, out-of-scope follow-ups per the spec).
- **No app-specific types in `lib/src/`.** Every new public type uses only Flutter SDK types
  (`Color`, `TextStyle`, `BorderRadius`, `EdgeInsets`, `Widget`) or this package's own existing
  types (`TimelineItem` and its subtypes, `PermissionOption`). Never import anything from an app
  (no `EpisutraPalette`, no `qtpi_ui`, etc.).
- **`chat_action_cards.dart`'s three helper functions are NOT exported** from
  `lib/ag_ui_widgets_flutter.dart` — they're internal, consumed only by the two builder classes
  within this package.
- **No CriticMarkup.** Markdown rendering uses plain GFM via `flutter_markdown_plus`/`markdown` —
  do not reach for `packages/episutra_markdown` (a different repo's editor-specific parser) for
  anything in this plan.
- **Version bump to `0.3.0`** happens in the last task, once every new file exists to export.
- **Follow this repo's existing Freezed pattern** — `@freezed abstract class X with _$X { const
  factory X({...}) = _X; }` plus a `part 'x.freezed.dart';` directive, exactly as
  `lib/src/model/conversation.dart` already does. Run `dart run build_runner build
  --delete-conflicting-outputs` after adding/changing any `@freezed` class.
- **Follow this repo's existing widget-test pattern** — see `test/widgets/ag_ui_chat_test.dart`:
  wrap the widget under test in `MaterialApp(home: Scaffold(body: ...))`, construct
  `Conversation`/`TimelineItem` fixtures directly (no mocking framework), use
  `tester.pumpWidget(...)` + `await tester.pumpAndSettle()`, assert via `find.text(...)` /
  `find.byType(...)` / captured-variable closures (as the existing permission/elicitation tests do).

---

### Task 1: Shared markdown rendering helper

**Files:**
- Create: `lib/src/widgets/markdown_body.dart`
- Modify: `pubspec.yaml` (add dependencies)
- Test: `test/widgets/markdown_body_test.dart`

**Interfaces:**
- Consumes: nothing new (only `flutter_markdown_plus`, `package:markdown` — new deps added in this task).
- Produces: `Widget chatMarkdownBody(BuildContext context, String text, {MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder})` — used by both builder classes in Task 4.

- [ ] **Step 1: Add the new dependencies**

Edit `pubspec.yaml`, adding to the `dependencies:` block (alphabetical order to match the existing list):

```yaml
  flutter_markdown_plus: ^1.0.3
  markdown: ^7.3.1
```

Run `flutter pub get` from the repo root to confirm resolution.

- [ ] **Step 2: Write the failing test**

Create `test/widgets/markdown_body_test.dart`:

```dart
// test/widgets/markdown_body_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/markdown_body.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders bold text without literal asterisks', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, 'hello **world**'),
    )));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('renders a fenced code block', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, '```\nconst x = 1;\n```'),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('const x = 1;'), findsWidgets);
  });

  testWidgets('falls back to MarkdownStyleSheet.fromTheme when no styleSheetBuilder is given', (tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => chatMarkdownBody(context, 'plain text'),
    )));
    await tester.pumpAndSettle();
    final markdownBody = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdownBody.styleSheet, isNotNull);
  });

  testWidgets('uses a custom styleSheetBuilder when supplied', (tester) async {
    late MarkdownStyleSheet expectedSheet;
    await tester.pumpWidget(host(Builder(
      builder: (context) {
        expectedSheet = MarkdownStyleSheet(p: const TextStyle(fontSize: 42));
        return chatMarkdownBody(context, 'plain text', styleSheetBuilder: (_) => expectedSheet);
      },
    )));
    await tester.pumpAndSettle();
    final markdownBody = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdownBody.styleSheet!.p!.fontSize, 42);
  });
}
```

- [ ] **Step 2b: Run test to verify it fails**

Run: `flutter test test/widgets/markdown_body_test.dart`
Expected: FAIL — `markdown_body.dart` doesn't exist yet (import error).

- [ ] **Step 3: Write the implementation**

Create `lib/src/widgets/markdown_body.dart`:

```dart
// lib/src/widgets/markdown_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// Renders [text] as GFM markdown, shared by every builder family's
/// text-message rendering. `selectable: false` matches plain-`Text`
/// behavior (chat bubbles aren't currently selectable anywhere this
/// package is consumed) — revisit only if a future spec asks for
/// text selection.
Widget chatMarkdownBody(
  BuildContext context,
  String text, {
  MarkdownStyleSheet Function(BuildContext)? styleSheetBuilder,
}) {
  return MarkdownBody(
    data: text,
    selectable: false,
    styleSheet: styleSheetBuilder?.call(context) ?? MarkdownStyleSheet.fromTheme(Theme.of(context)),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/widgets/markdown_body_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/src/widgets/markdown_body.dart test/widgets/markdown_body_test.dart
git commit -m "feat: add chatMarkdownBody shared markdown rendering helper"
```

---

### Task 2: StackedChatStyle and BubbleChatStyle

**Files:**
- Create: `lib/src/style/stacked_chat_style.dart`
- Create: `lib/src/style/bubble_chat_style.dart`
- Test: `test/style/stacked_chat_style_test.dart`
- Test: `test/style/bubble_chat_style_test.dart`

**Interfaces:**
- Consumes: nothing new.
- Produces:
  - `StackedChatStyle({required Color sentBackground, required Color receivedBackground, required TextStyle textStyle, Widget Function(BuildContext)? aiLeadingIconBuilder, EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12), Color? cardBorderColor, BorderRadius cardRadius = const BorderRadius.all(Radius.circular(8)), MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder})`
  - `BubbleChatStyle({required Color sentBackground, required Color receivedBackground, Color? sentBorder, Color? receivedBorder, required TextStyle textStyle, required double maxWidth, BorderRadius sentRadius = const BorderRadius.all(Radius.circular(12)), BorderRadius receivedRadius = const BorderRadius.all(Radius.circular(12)), EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12), MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder})`
  - Both used by Task 5's builder classes.

- [ ] **Step 1: Write the failing tests**

Create `test/style/stacked_chat_style_test.dart`:

```dart
// test/style/stacked_chat_style_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/style/stacked_chat_style.dart';

void main() {
  test('applies defaults for optional fields', () {
    const style = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
    );
    expect(style.padding, const EdgeInsets.symmetric(vertical: 8, horizontal: 12));
    expect(style.cardRadius, const BorderRadius.all(Radius.circular(8)));
    expect(style.cardBorderColor, isNull);
    expect(style.aiLeadingIconBuilder, isNull);
    expect(style.markdownStyleSheetBuilder, isNull);
  });

  test('required fields round-trip', () {
    const style = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(fontSize: 14),
    );
    expect(style.sentBackground, Colors.blue);
    expect(style.receivedBackground, Colors.grey);
    expect(style.textStyle.fontSize, 14);
  });
}
```

Create `test/style/bubble_chat_style_test.dart`:

```dart
// test/style/bubble_chat_style_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/style/bubble_chat_style.dart';

void main() {
  test('applies defaults for optional fields', () {
    const style = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 260,
    );
    expect(style.sentRadius, const BorderRadius.all(Radius.circular(12)));
    expect(style.receivedRadius, const BorderRadius.all(Radius.circular(12)));
    expect(style.padding, const EdgeInsets.symmetric(vertical: 8, horizontal: 12));
    expect(style.sentBorder, isNull);
    expect(style.receivedBorder, isNull);
  });

  test('required fields round-trip', () {
    const style = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 300,
    );
    expect(style.maxWidth, 300);
  });
}
```

- [ ] **Step 1b: Run tests to verify they fail**

Run: `flutter test test/style/stacked_chat_style_test.dart test/style/bubble_chat_style_test.dart`
Expected: FAIL — files under `lib/src/style/` don't exist yet.

- [ ] **Step 2: Write the implementation**

Create `lib/src/style/stacked_chat_style.dart`:

```dart
// lib/src/style/stacked_chat_style.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stacked_chat_style.freezed.dart';

/// Visual configuration for [StackedChatBuilders] (full-width,
/// vertically-alternating message layout). Raw Flutter types only — no
/// app-specific theming types, so this package stays app-agnostic.
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
```

Create `lib/src/style/bubble_chat_style.dart`:

```dart
// lib/src/style/bubble_chat_style.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bubble_chat_style.freezed.dart';

/// Visual configuration for [BubbleChatBuilders] (aligned,
/// max-width-constrained bubbles). Raw Flutter types only.
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

- [ ] **Step 3: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `lib/src/style/stacked_chat_style.freezed.dart` and `lib/src/style/bubble_chat_style.freezed.dart` with no errors.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/style/stacked_chat_style_test.dart test/style/bubble_chat_style_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/src/style/stacked_chat_style.dart lib/src/style/stacked_chat_style.freezed.dart \
        lib/src/style/bubble_chat_style.dart lib/src/style/bubble_chat_style.freezed.dart \
        test/style/stacked_chat_style_test.dart test/style/bubble_chat_style_test.dart
git commit -m "feat: add StackedChatStyle and BubbleChatStyle config classes"
```

---

### Task 3: ChatActionCallbacks

**Files:**
- Create: `lib/src/style/chat_action_callbacks.dart`
- Test: `test/style/chat_action_callbacks_test.dart`

**Interfaces:**
- Consumes: `ToolRequestTimelineItem` (already defined in `lib/src/model/conversation.dart`).
- Produces: `ChatActionCallbacks({required void Function(String requestId, {String? optionId, bool cancelled}) onPermissionOptionSelected, required void Function(String requestId, Map<String, dynamic> response) onElicitationRespond, Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> toolRequestOverrides = const {}})` — used by Task 4's shared helpers and Task 5's builder classes.

- [ ] **Step 1: Write the failing test**

Create `test/style/chat_action_callbacks_test.dart`:

```dart
// test/style/chat_action_callbacks_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';

void main() {
  test('defaults toolRequestOverrides to an empty map', () {
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
    );
    expect(callbacks.toolRequestOverrides, isEmpty);
  });

  test('onPermissionOptionSelected is invoked with the given args', () {
    String? gotRequestId;
    String? gotOptionId;
    bool? gotCancelled;
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (requestId, {optionId, cancelled = false}) {
        gotRequestId = requestId;
        gotOptionId = optionId;
        gotCancelled = cancelled;
      },
      onElicitationRespond: (_, __) {},
    );
    callbacks.onPermissionOptionSelected('p1', optionId: 'allow');
    expect(gotRequestId, 'p1');
    expect(gotOptionId, 'allow');
    expect(gotCancelled, false);
  });

  test('toolRequestOverrides dispatches by toolName', () {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'render_surface', argsJson: '{}');
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
      toolRequestOverrides: {
        'render_surface': (context, item) => const Text('SURFACE'),
      },
    );
    expect(callbacks.toolRequestOverrides['render_surface'], isNotNull);
    expect(callbacks.toolRequestOverrides[item.toolName], isNotNull);
    expect(callbacks.toolRequestOverrides['other_tool'], isNull);
  });
}
```

- [ ] **Step 1b: Run test to verify it fails**

Run: `flutter test test/style/chat_action_callbacks_test.dart`
Expected: FAIL — `chat_action_callbacks.dart` doesn't exist yet.

- [ ] **Step 2: Write the implementation**

Create `lib/src/style/chat_action_callbacks.dart`:

```dart
// lib/src/style/chat_action_callbacks.dart
import 'package:flutter/material.dart';
import '../model/conversation.dart';

/// Action hooks a builder-family caller supplies so shared card content
/// (permission/elicitation/toolRequest) can call back into whichever
/// cubit/transport is driving that specific chat — the package can't
/// know which.
class ChatActionCallbacks {
  const ChatActionCallbacks({
    required this.onPermissionOptionSelected,
    required this.onElicitationRespond,
    this.toolRequestOverrides = const {},
  });

  /// Signature-compatible with IAgUiTransport.respondPermission(callId,
  /// {optionId, cancelled}) — same parameter shapes/order (return type
  /// differs, Future<void> vs void: a plain tear-off of an async method
  /// satisfies a void-returning function-typed field per Dart's
  /// void-return covariance, same pattern as VoidCallback). Renamed
  /// callId -> requestId deliberately: requestId is
  /// PermissionRequestTimelineItem.requestId (== ACP callId).
  final void Function(String requestId, {String? optionId, bool cancelled}) onPermissionOptionSelected;

  /// Signature-compatible with IAgUiTransport.respondElicitation
  /// (elicitationId, response).
  final void Function(String requestId, Map<String, dynamic> response) onElicitationRespond;

  /// Keyed by ToolRequestTimelineItem.toolName. A registered entry fully
  /// replaces the generic toolRequest card for that tool name (e.g. an
  /// app registers 'render_surface' -> its own surface-hosting widget).
  /// Unregistered tool names get the generic fallback card.
  final Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> toolRequestOverrides;
}
```

- [ ] **Step 3: Run test to verify it passes**

Run: `flutter test test/style/chat_action_callbacks_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 4: Commit**

```bash
git add lib/src/style/chat_action_callbacks.dart test/style/chat_action_callbacks_test.dart
git commit -m "feat: add ChatActionCallbacks"
```

---

### Task 4: Shared card-content helpers

**Files:**
- Create: `lib/src/widgets/chat_action_cards.dart`
- Test: `test/widgets/chat_action_cards_test.dart`

**Interfaces:**
- Consumes: `PermissionRequestTimelineItem`, `ElicitationRequestTimelineItem`, `ToolRequestTimelineItem`, `PermissionOption` (from `lib/src/model/conversation.dart`); the callback function types defined in Task 3's `ChatActionCallbacks` (passed individually as parameters here, not the class itself — these helpers don't depend on `ChatActionCallbacks` directly).
- Produces:
  - `Widget buildPermissionCardContent(BuildContext context, PermissionRequestTimelineItem item, {required BoxDecoration decoration, required TextStyle textStyle, required void Function(String requestId, {String? optionId, bool cancelled}) onSelect})`
  - `Widget buildElicitationCardContent(BuildContext context, ElicitationRequestTimelineItem item, {required BoxDecoration decoration, required TextStyle textStyle, required void Function(String requestId, Map<String, dynamic> response) onRespond})`
  - `Widget buildToolRequestCardContent(BuildContext context, ToolRequestTimelineItem item, {required BoxDecoration decoration, required TextStyle textStyle, required Map<String, Widget Function(BuildContext, ToolRequestTimelineItem)> overrides})`
  - All three used by Task 5's `StackedChatBuilders`/`BubbleChatBuilders`. **Not exported from the barrel** (Task 6 must not add an export line for this file).

- [ ] **Step 1: Write the failing tests**

Create `test/widgets/chat_action_cards_test.dart`:

```dart
// test/widgets/chat_action_cards_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/chat_action_cards.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
  const decoration = BoxDecoration(color: Colors.white);
  const textStyle = TextStyle();

  testWidgets('permission card renders one button per option and calls onSelect with its optionId', (tester) async {
    String? gotRequestId;
    String? gotOptionId;
    const item = PermissionRequestTimelineItem(
      requestId: 'p1',
      toolTitle: 'bash',
      options: [
        PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once'),
        PermissionOption(optionId: 'deny', label: 'Deny', kind: 'reject_once'),
      ],
    );
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildPermissionCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        onSelect: (requestId, {optionId, cancelled = false}) {
          gotRequestId = requestId;
          gotOptionId = optionId;
        },
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Allow'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
    await tester.tap(find.text('Allow'));
    expect(gotRequestId, 'p1');
    expect(gotOptionId, 'allow');
  });

  testWidgets('elicitation card renders the message and calls onRespond on submit', (tester) async {
    String? gotRequestId;
    Map<String, dynamic>? gotResponse;
    const item = ElicitationRequestTimelineItem(requestId: 'e1', message: 'Pick a color', mode: 'url', url: 'https://example.com');
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildElicitationCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        onRespond: (requestId, response) {
          gotRequestId = requestId;
          gotResponse = response;
        },
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Pick a color'), findsOneWidget);
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    expect(gotRequestId, 'e1');
    expect(gotResponse, isNotNull);
  });

  testWidgets('toolRequest card dispatches to a registered override', (tester) async {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'render_surface', argsJson: '{}');
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildToolRequestCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        overrides: {'render_surface': (context, item) => const Text('SURFACE')},
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.text('SURFACE'), findsOneWidget);
  });

  testWidgets('toolRequest card falls back to a generic card for an unregistered tool name', (tester) async {
    const item = ToolRequestTimelineItem(requestId: 'r1', toolName: 'unknown_tool', toolTitle: 'Unknown Tool', argsJson: '{}');
    await tester.pumpWidget(host(Builder(
      builder: (context) => buildToolRequestCardContent(
        context, item,
        decoration: decoration, textStyle: textStyle,
        overrides: const {},
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unknown Tool'), findsOneWidget);
  });
}
```

- [ ] **Step 1b: Run tests to verify they fail**

Run: `flutter test test/widgets/chat_action_cards_test.dart`
Expected: FAIL — `chat_action_cards.dart` doesn't exist yet.

- [ ] **Step 2: Write the implementation**

Create `lib/src/widgets/chat_action_cards.dart`:

```dart
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
```

- [ ] **Step 3: Run tests to verify they pass**

Run: `flutter test test/widgets/chat_action_cards_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 4: Commit**

```bash
git add lib/src/widgets/chat_action_cards.dart test/widgets/chat_action_cards_test.dart
git commit -m "feat: add shared permission/elicitation/toolRequest card content helpers"
```

---

### Task 5: StackedChatBuilders and BubbleChatBuilders

**Files:**
- Create: `lib/src/widgets/stacked_chat_builders.dart`
- Create: `lib/src/widgets/bubble_chat_builders.dart`
- Test: `test/widgets/stacked_chat_builders_test.dart`
- Test: `test/widgets/bubble_chat_builders_test.dart`

**Interfaces:**
- Consumes:
  - `StackedChatStyle`, `BubbleChatStyle` (Task 2)
  - `ChatActionCallbacks` (Task 3)
  - `buildPermissionCardContent`, `buildElicitationCardContent`, `buildToolRequestCardContent` (Task 4)
  - `chatMarkdownBody` (Task 1)
  - `CustomCardBuilder` (typedef already defined in `lib/src/widgets/ag_ui_chat.dart`: `Widget Function(BuildContext, chat_core.CustomMessage, int, {required bool isSentByMe, chat_core.MessageGroupStatus? groupStatus})`)
  - `chat_core.TextMessageBuilder` (from `flutter_chat_core`, already used by `default_builders.dart`)
  - `TimelineItem`, `PermissionRequestTimelineItem`, `ElicitationRequestTimelineItem`, `ToolRequestTimelineItem` (`lib/src/model/conversation.dart`)
- Produces:
  - `StackedChatBuilders(StackedChatStyle style, ChatActionCallbacks callbacks)` with getters `textMessageBuilder`, `toolCallBuilder`, `permissionBuilder`, `elicitationBuilder`, `toolRequestBuilder`.
  - `BubbleChatBuilders(BubbleChatStyle style, ChatActionCallbacks callbacks)` with the same five getters.
  - Both used directly by an app's `AgUiChat(...)` construction (out of scope for this plan — see Global Constraints).

- [ ] **Step 1: Write the failing tests**

Create `test/widgets/stacked_chat_builders_test.dart`:

```dart
// test/widgets/stacked_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/style/stacked_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/stacked_chat_builders.dart';

void main() {
  const style = StackedChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
  );

  Widget host(Conversation conversation, StackedChatBuilders builders) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          textMessageBuilder: builders.textMessageBuilder,
          toolCallBuilder: builders.toolCallBuilder,
          permissionBuilder: builders.permissionBuilder,
          elicitationBuilder: builders.elicitationBuilder,
          toolRequestBuilder: builders.toolRequestBuilder,
        ),
      ),
    );
  }

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello **world**'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('permission builder fires onPermissionOptionSelected with the tapped optionId', (tester) async {
    String? gotOptionId;
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (requestId, {optionId, cancelled = false}) => gotOptionId = optionId,
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.permissionRequest(
          requestId: 'p1',
          toolTitle: 'bash',
          options: [PermissionOption(optionId: 'allow', label: 'Allow', kind: 'allow_once')],
        ),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    expect(gotOptionId, 'allow');
  });

  testWidgets('toolRequest builder dispatches to a registered override', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
        toolRequestOverrides: {'render_surface': (context, item) => const Text('SURFACE')},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'render_surface', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('SURFACE'), findsOneWidget);
  });

  testWidgets('unregistered toolRequest falls back to the generic card', (tester) async {
    final builders = StackedChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.toolRequest(requestId: 'r1', toolName: 'other_tool', toolTitle: 'Other Tool', argsJson: '{}'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('Other Tool'), findsOneWidget);
  });
}
```

Create `test/widgets/bubble_chat_builders_test.dart`:

```dart
// test/widgets/bubble_chat_builders_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';
import 'package:ag_ui_widgets_flutter/src/style/bubble_chat_style.dart';
import 'package:ag_ui_widgets_flutter/src/style/chat_action_callbacks.dart';
import 'package:ag_ui_widgets_flutter/src/widgets/bubble_chat_builders.dart';

void main() {
  const style = BubbleChatStyle(
    sentBackground: Colors.blue,
    receivedBackground: Colors.grey,
    textStyle: TextStyle(),
    maxWidth: 260,
  );

  Widget host(Conversation conversation, BubbleChatBuilders builders) {
    return MaterialApp(
      home: Scaffold(
        body: AgUiChat(
          conversation: conversation,
          currentUserId: 'user',
          onSendMessage: (_) {},
          textMessageBuilder: builders.textMessageBuilder,
          toolCallBuilder: builders.toolCallBuilder,
          permissionBuilder: builders.permissionBuilder,
          elicitationBuilder: builders.elicitationBuilder,
          toolRequestBuilder: builders.toolRequestBuilder,
        ),
      ),
    );
  }

  testWidgets('sent message aligns to centerRight, received to centerLeft', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'user', text: 'hi'),
        TimelineItem.text(id: 'm2', kind: ChatMessageKind.text, role: 'assistant', text: 'hello'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    final sentAlign = tester.widget<Align>(find.ancestor(of: find.text('hi'), matching: find.byType(Align)).first);
    final receivedAlign = tester.widget<Align>(find.ancestor(of: find.text('hello'), matching: find.byType(Align)).first);
    expect(sentAlign.alignment, Alignment.centerRight);
    expect(receivedAlign.alignment, Alignment.centerLeft);
  });

  testWidgets('renders markdown in a text message', (tester) async {
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (_, __) {},
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.text(id: 'm1', kind: ChatMessageKind.text, role: 'assistant', text: 'hello **world**'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    expect(find.text('**world**'), findsNothing);
    expect(find.textContaining('world'), findsWidgets);
  });

  testWidgets('elicitation builder fires onElicitationRespond', (tester) async {
    String? gotRequestId;
    final builders = BubbleChatBuilders(
      style,
      ChatActionCallbacks(
        onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
        onElicitationRespond: (requestId, response) => gotRequestId = requestId,
      ),
    );
    await tester.pumpWidget(host(
      const Conversation(timeline: [
        TimelineItem.elicitationRequest(requestId: 'e1', message: 'Pick one', mode: 'url', url: 'https://example.com'),
      ]),
      builders,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    expect(gotRequestId, 'e1');
  });
}
```

- [ ] **Step 1b: Run tests to verify they fail**

Run: `flutter test test/widgets/stacked_chat_builders_test.dart test/widgets/bubble_chat_builders_test.dart`
Expected: FAIL — `stacked_chat_builders.dart`/`bubble_chat_builders.dart` don't exist yet.

- [ ] **Step 2: Write the implementation**

Create `lib/src/widgets/stacked_chat_builders.dart`:

```dart
// lib/src/widgets/stacked_chat_builders.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import '../model/conversation.dart';
import '../style/chat_action_callbacks.dart';
import '../style/stacked_chat_style.dart';
import 'ag_ui_chat.dart' show CustomCardBuilder;
import 'chat_action_cards.dart';
import 'markdown_body.dart';

/// Full-width, vertically-alternating builder family for [AgUiChat]'s
/// five builder slots. Sender is differentiated by background tint and
/// an optional leading icon — no left/right alignment.
class StackedChatBuilders {
  StackedChatBuilders(this.style, this.callbacks);

  final StackedChatStyle style;
  final ChatActionCallbacks callbacks;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: style.receivedBackground,
        border: style.cardBorderColor != null ? Border.all(color: style.cardBorderColor!) : null,
        borderRadius: style.cardRadius,
      );

  chat_core.TextMessageBuilder get textMessageBuilder =>
      (context, message, index, {required isSentByMe, groupStatus}) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: style.padding,
          color: isSentByMe ? style.sentBackground : style.receivedBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSentByMe && style.aiLeadingIconBuilder != null) ...[
                style.aiLeadingIconBuilder!(context),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: chatMarkdownBody(context, message.text, styleSheetBuilder: style.markdownStyleSheetBuilder),
              ),
            ],
          ),
        );
      };

  CustomCardBuilder get toolCallBuilder => (context, message, index, {required isSentByMe, groupStatus}) {
        final name = message.metadata?['name'] as String? ?? '';
        final result = message.metadata?['result'] as String?;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: style.padding,
          decoration: _cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: style.textStyle),
              if (result != null) Text(result, style: style.textStyle),
            ],
          ),
        );
      };

  Widget Function(BuildContext, TimelineItem) get permissionBuilder => (context, item) {
        final permission = item as PermissionRequestTimelineItem;
        return buildPermissionCardContent(
          context, permission,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onSelect: callbacks.onPermissionOptionSelected,
        );
      };

  Widget Function(BuildContext, TimelineItem) get elicitationBuilder => (context, item) {
        final elicitation = item as ElicitationRequestTimelineItem;
        return buildElicitationCardContent(
          context, elicitation,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onRespond: callbacks.onElicitationRespond,
        );
      };

  Widget Function(BuildContext, TimelineItem) get toolRequestBuilder => (context, item) {
        final toolRequest = item as ToolRequestTimelineItem;
        return buildToolRequestCardContent(
          context, toolRequest,
          decoration: _cardDecoration, textStyle: style.textStyle,
          overrides: callbacks.toolRequestOverrides,
        );
      };
}
```

Create `lib/src/widgets/bubble_chat_builders.dart`:

```dart
// lib/src/widgets/bubble_chat_builders.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import '../model/conversation.dart';
import '../style/bubble_chat_style.dart';
import '../style/chat_action_callbacks.dart';
import 'ag_ui_chat.dart' show CustomCardBuilder;
import 'chat_action_cards.dart';
import 'markdown_body.dart';

/// Aligned, max-width-constrained bubble builder family for [AgUiChat]'s
/// five builder slots. Sent messages align right, received align left.
class BubbleChatBuilders {
  BubbleChatBuilders(this.style, this.callbacks);

  final BubbleChatStyle style;
  final ChatActionCallbacks callbacks;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: style.receivedBackground,
        border: style.receivedBorder != null ? Border.all(color: style.receivedBorder!) : null,
        borderRadius: style.receivedRadius,
      );

  chat_core.TextMessageBuilder get textMessageBuilder =>
      (context, message, index, {required isSentByMe, groupStatus}) {
        return Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: style.maxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: style.padding,
              decoration: BoxDecoration(
                color: isSentByMe ? style.sentBackground : style.receivedBackground,
                border: (isSentByMe ? style.sentBorder : style.receivedBorder) != null
                    ? Border.all(color: (isSentByMe ? style.sentBorder : style.receivedBorder)!)
                    : null,
                borderRadius: isSentByMe ? style.sentRadius : style.receivedRadius,
              ),
              child: chatMarkdownBody(context, message.text, styleSheetBuilder: style.markdownStyleSheetBuilder),
            ),
          ),
        );
      };

  CustomCardBuilder get toolCallBuilder => (context, message, index, {required isSentByMe, groupStatus}) {
        final name = message.metadata?['name'] as String? ?? '';
        final result = message.metadata?['result'] as String?;
        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: style.maxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: style.padding,
              decoration: _cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: style.textStyle),
                  if (result != null) Text(result, style: style.textStyle),
                ],
              ),
            ),
          ),
        );
      };

  /// Wraps card content the same way [toolCallBuilder] wraps its own
  /// output — Align(left) + maxWidth constraint — so permission/
  /// elicitation/toolRequest cards stay visually consistent with the
  /// rest of this bubble-family's width-constrained shells. There's no
  /// `isSentByMe` here (AgUiChat's permission/elicitation/toolRequest
  /// slots don't receive it), so these always align left, matching
  /// toolCallBuilder.
  Widget _leftAlignedBubble(Widget child) => Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: style.maxWidth),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: child),
        ),
      );

  Widget Function(BuildContext, TimelineItem) get permissionBuilder => (context, item) {
        final permission = item as PermissionRequestTimelineItem;
        return _leftAlignedBubble(buildPermissionCardContent(
          context, permission,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onSelect: callbacks.onPermissionOptionSelected,
        ));
      };

  Widget Function(BuildContext, TimelineItem) get elicitationBuilder => (context, item) {
        final elicitation = item as ElicitationRequestTimelineItem;
        return _leftAlignedBubble(buildElicitationCardContent(
          context, elicitation,
          decoration: _cardDecoration, textStyle: style.textStyle,
          onRespond: callbacks.onElicitationRespond,
        ));
      };

  Widget Function(BuildContext, TimelineItem) get toolRequestBuilder => (context, item) {
        final toolRequest = item as ToolRequestTimelineItem;
        return _leftAlignedBubble(buildToolRequestCardContent(
          context, toolRequest,
          decoration: _cardDecoration, textStyle: style.textStyle,
          overrides: callbacks.toolRequestOverrides,
        ));
      };
}
```

- [ ] **Step 3: Run tests to verify they pass**

Run: `flutter test test/widgets/stacked_chat_builders_test.dart test/widgets/bubble_chat_builders_test.dart`
Expected: PASS (4 tests + 3 tests)

- [ ] **Step 4: Commit**

```bash
git add lib/src/widgets/stacked_chat_builders.dart lib/src/widgets/bubble_chat_builders.dart \
        test/widgets/stacked_chat_builders_test.dart test/widgets/bubble_chat_builders_test.dart
git commit -m "feat: add StackedChatBuilders and BubbleChatBuilders"
```

---

### Task 6: Barrel exports and version bump

**Files:**
- Modify: `lib/ag_ui_widgets_flutter.dart`
- Modify: `pubspec.yaml`
- Test: `test/widgets/public_api_test.dart`

**Interfaces:**
- Consumes: every public type from Tasks 1–5 (`chatMarkdownBody`, `StackedChatStyle`, `BubbleChatStyle`, `ChatActionCallbacks`, `StackedChatBuilders`, `BubbleChatBuilders`).
- Produces: nothing new — this is the final wiring task. No later task depends on this one.

- [ ] **Step 1: Write the failing test**

This test asserts the package's public barrel actually exposes everything an app needs, without reaching into `src/` — exactly the gap the spec's review caught.

Create `test/widgets/public_api_test.dart`:

```dart
// test/widgets/public_api_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart';

void main() {
  test('barrel exports the new style configs, callbacks, and builder classes', () {
    const stackedStyle = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
    );
    const bubbleStyle = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 260,
    );
    final callbacks = ChatActionCallbacks(
      onPermissionOptionSelected: (_, {optionId, cancelled = false}) {},
      onElicitationRespond: (_, __) {},
    );
    final stackedBuilders = StackedChatBuilders(stackedStyle, callbacks);
    final bubbleBuilders = BubbleChatBuilders(bubbleStyle, callbacks);

    expect(stackedBuilders.textMessageBuilder, isNotNull);
    expect(bubbleBuilders.textMessageBuilder, isNotNull);
  });

  testWidgets('chatMarkdownBody is reachable from the barrel', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Builder(builder: (context) => chatMarkdownBody(context, 'hi')),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('hi'), findsWidgets);
  });
}
```

- [ ] **Step 1b: Run test to verify it fails**

Run: `flutter test test/widgets/public_api_test.dart`
Expected: FAIL — none of these symbols are exported from `package:ag_ui_widgets_flutter/ag_ui_widgets_flutter.dart` yet (compile error: undefined names).

- [ ] **Step 2: Add the barrel exports**

Edit `lib/ag_ui_widgets_flutter.dart`, adding these lines (keep the existing export lines untouched):

```dart
export 'src/style/stacked_chat_style.dart';
export 'src/style/bubble_chat_style.dart';
export 'src/style/chat_action_callbacks.dart';
export 'src/widgets/stacked_chat_builders.dart';
export 'src/widgets/bubble_chat_builders.dart';
export 'src/widgets/markdown_body.dart' show chatMarkdownBody;
```

Do **not** add an export line for `src/widgets/chat_action_cards.dart` — its three helper functions stay internal (Task 4's Interfaces block, Global Constraints).

- [ ] **Step 3: Bump the package version**

Edit `pubspec.yaml`, change:

```yaml
version: 0.2.0
```

to:

```yaml
version: 0.3.0
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/widgets/public_api_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Run the full test suite**

Run: `flutter test`
Expected: PASS — every test added in Tasks 1–6 plus all pre-existing tests (`conversation_test.dart`, `conversation_reducer_test.dart`, `ag_ui_chat_test.dart`, `timeline_to_messages_test.dart`) green.

- [ ] **Step 6: Commit**

```bash
git add lib/ag_ui_widgets_flutter.dart pubspec.yaml test/widgets/public_api_test.dart
git commit -m "feat: export new chat widget public API, bump to 0.3.0"
```

---

## Self-Review Notes

**Spec coverage:** §1 (rationale, no task) → covered by Task 5's two-class split. §2 → Task 2. §3 → Task 3.
§3b → Task 4. §4 → Task 5. §5 → Task 1. §6 → Task 6 (exports). §7 → Task 6 (version bump). Testing
section's three listed test files → split across Tasks 1, 5, and folded into Task 4/2/3 for the
lower-level units the spec didn't separately enumerate but that need their own coverage before the
builder classes can be tested meaningfully.

**Placeholder scan:** no TBD/TODO/"similar to Task N" — every step has literal, runnable code.

**Type consistency:** `ChatActionCallbacks`'s field types (Task 3) match exactly what Task 4's helper
parameters expect and what Task 5's builder classes pass through (`callbacks.onPermissionOptionSelected`
directly satisfies `buildPermissionCardContent`'s `onSelect` parameter type; same for
`onElicitationRespond`/`onRespond` and `toolRequestOverrides`/`overrides`). `StackedChatStyle`/
`BubbleChatStyle` field names referenced in Task 5 (`style.sentBackground`, `style.cardRadius`,
`style.markdownStyleSheetBuilder`, etc.) match Task 2's definitions exactly. `chatMarkdownBody`'s
signature (Task 1) matches every call site in Task 5.
