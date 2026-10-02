import 'package:ag_ui/ag_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation_reducer.dart';

void main() {
  test('RUN_STARTED keeps the thread and run ids', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(RunStartedEvent(threadId: 'th1', runId: 'run1'));
    expect(r.current.sessionState.threadId, 'th1');
    expect(r.current.sessionState.runId, 'run1');
  });

  test('RUN_FINISHED keeps any stopReason verbatim', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(RunStartedEvent(threadId: 't', runId: 'r'))
      ..apply(const RunFinishedEvent(
          threadId: 't', runId: 'r', result: {'stopReason': 'max_tokens'}));
    expect(r.current.sessionState.stopReason, 'max_tokens');
    expect(r.current.sessionState.runOutcome, RunOutcome.success,
        reason: 'outcome semantics are unchanged');
  });

  test('RUN_ERROR keeps its code', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const RunErrorEvent(message: 'boom', code: 'rate_limited'));
    expect(r.current.sessionState.runErrorCode, 'rate_limited');
    expect(r.current.sessionState.runError, 'boom');
  });

  test('a new RUN_STARTED clears the previous run result', () {
    final r = ConversationReducer(namespace: 'episutra')
      ..apply(const RunErrorEvent(message: 'boom', code: 'c'))
      ..apply(RunStartedEvent(threadId: 't', runId: 'r2'));
    expect(r.current.sessionState.runErrorCode, isNull);
    expect(r.current.sessionState.stopReason, isNull);
    expect(r.current.sessionState.runId, 'r2');
  });
}
