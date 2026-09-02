## 0.7.0

- New: `ToolCallTimelineItem` gains `toolKind` (`String?`) — ACP's `ToolCallUpdate.Kind`
  (`execute`/`edit`/`read`/etc.), carried by the previously-unhandled `pocketcoder:tool` CUSTOM
  event and forwarded into `Message.metadata['toolKind']`. Lets a consumer distinguish a shell/
  "execute" tool call from any other kind for display purposes without guessing from `name`/`args`
  alone.

## 0.6.0

- New: `StackedChatStyle`/`BubbleChatStyle` gain `markdownWhileStreaming`
  (`bool`, default `false` — no behavior change unless set) and
  `streamingLoadingBuilder`. When `true`, both builder families' generated
  `textStreamMessageBuilder` renders the in-progress message via
  `chatMarkdownBody` (the exact same `flutter_markdown_plus` call the
  completed-message view uses) instead of
  `FlyerChatTextStreamMessage`/`gpt_markdown`, so a message's formatting no
  longer visibly changes renderer the instant it finishes streaming.
  `streamingLoadingBuilder` lets a caller supply their own "no content yet"
  placeholder (falls back to a plain low-opacity `'...'` otherwise) —
  written to fix this exact inconsistency for one consumer (episutra), now
  available to any consumer without writing a full custom builder from
  scratch. New shared `buildStreamingMarkdownContent` (in
  `streaming_markdown_content.dart`) does the actual `StreamState`
  dispatch, used by both builder families rather than duplicated in each.

## 0.5.2

- Fix: tool-call cards showed the raw MCP wire format for a tool's result —
  `[{"type":"text","text":"..."}]` — instead of the actual text. New
  `prettifyToolResult` extracts and joins text blocks from that
  content-array shape (the common case for any MCP server, not
  backend-specific); anything that doesn't match falls back to the raw
  string unchanged, so no content is ever silently hidden behind a parse
  failure.

## 0.5.1

- Fix: `AgUiChat` re-diffed and replaced its entire message list
  (`ChatController.setMessages`) on every single conversation update,
  including every streaming text delta and tool-call args/result update.
  `flutter_chat_ui` translates any same-id content change into a
  remove-then-insert of that id; Flutter's `SliverAnimatedList` performs the
  insert immediately but defers the remove for its fade animation, so two
  widgets briefly shared the identical key — corrupting
  `RenderSliverMultiBoxAdaptor`'s child-index bookkeeping and crashing with
  `'child == null || indexOf(child) > index'` / `'indexOf(child) ==
  index'`. `AgUiChat` now computes a minimal diff
  (`message_list_sync.dart`'s `computeMessageListSyncActions`) and routes
  same-id content changes through `ChatController.updateMessage` instead,
  which never touches the animated list at all.
- Fix: `ConversationReducer`'s `acp.permission_request` case stored a
  permission card at the bare `callId` key — the same key its correlated
  `ToolCallTimelineItem` already occupied (an ACP permission request's
  `callId` IS the tool call's own id by protocol design), so the permission
  card silently overwrote the tool call's data. Resolving the permission
  then destroyed that (already-overwritten) entry entirely, so a later
  `TOOL_CALL_RESULT` had nothing to update and synthesized a new, nameless,
  detached-at-the-end-of-timeline entry instead. Permission requests now
  store at a namespaced `'perm:$callId'` key (matching the existing
  `'req:$callId'` pattern for `ToolRequestTimelineItem`), so they coexist
  with rather than overwrite the tool call.
- `timelineToMessages` updated to match: a tool call's raw bubble is now
  also suppressed while its permission card is live (previously only done
  for tool-request cards), since the two can now legitimately coexist in
  the timeline and would otherwise produce two `Message`s sharing one id.

## 0.4.0

- New: `AgUiChat.textStreamMessageBuilder` — streaming (in-progress) messages are now
  caller-overridable like every other message kind (previously hardcoded internally).
- New: `StackedChatStyle`/`BubbleChatStyle` gain `diffAddedColor`/`diffRemovedColor`,
  `reasoningTextStyle`, and `roleHeaderBuilder({role, isSentByMe, isReasoning})`.
- New: `ChatActionCallbacks` gains `toolCallOverrides` (mirrors `toolRequestOverrides`),
  `permissionCardBuilder`, `elicitationCardBuilder` (full-override escape hatches, `null` falls
  back to generic shared content).
- New: both builder families now render tool-call diffs (`diffs` metadata) via a new shared
  `DiffLinesView` widget, and render JSON-Schema-typed elicitation form fields (checkbox for
  `boolean`, numeric keyboard for `integer`/`number`, dropdown for `enum`) instead of a plain
  `TextField` per top-level schema key.
- Fix: elicitation `mode == 'form'` cards previously read `schema.keys` directly instead of
  `schema['properties']` — every form rendered zero usable fields for any real ACP-shaped schema.

## 0.3.0

- **Breaking:** `IAgUiTransport.sendMessage` gains a `context` parameter
  (`List<AgUiContextItem>`, defaults to `const []`) — every implementer's
  override must add it, even if unused.
- New: `AgUiContextItem` freezed type (`uri`, `text`) for passing message
  context (e.g. the current note's body) in a backend-agnostic shape.

## 0.2.0

- **Breaking:** `TimelineItem.permission`/`.elicitation` replaced by payload-carrying
  `.permissionRequest`/`.elicitationRequest`; new `.toolRequest` variant.
- **Breaking:** `ToolRequestTimelineItem` now requires a `toolName` field (the machine
  dispatch key for client-executed tools, e.g. `"propose_edit"`); the ACP-native
  `toolTitle`/`toolKind` remain nullable.
- **Breaking:** `AgUiChat.permissionBuilder`/`.elicitationBuilder` now receive the full
  `TimelineItem`, not a bare `requestId`. New `toolRequestBuilder` slot (default: renders nothing).
- **Breaking:** `IAgUiTransport` gains `submitToolResult(callId, resultJson)`.
- New: `ConversationReducer.resolveRequest(requestId)` for explicit resolution, safe against
  backend state that's never cleared server-side.
- New: canonical `acp.permission_request`/`acp.elicitation_request`/`acp.tool_request`
  `CustomEvent` recognition, alongside pocketcoder's existing `/pocketcoder/<ns>` StateDelta
  convention — both feed the same canonical model.

## 0.0.1

* TODO: Describe initial release.
