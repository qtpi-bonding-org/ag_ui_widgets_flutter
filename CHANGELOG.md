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
