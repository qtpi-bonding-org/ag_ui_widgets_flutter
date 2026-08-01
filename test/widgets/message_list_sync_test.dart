// test/widgets/message_list_sync_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'package:ag_ui_widgets_flutter/src/widgets/message_list_sync.dart';

chat_core.Message _text(String id, String text) => chat_core.Message.text(
      id: id,
      authorId: 'assistant',
      text: text,
    );

void main() {
  group('computeMessageListSyncActions', () {
    test('identical lists produce no actions', () {
      final list = [_text('a', 'hi')];
      expect(computeMessageListSyncActions(list, list), isEmpty);
    });

    test(
      'a same-id content change produces exactly one UpdateAction — NEVER a '
      'Remove+Insert pair (this is the whole point: same-key remove+insert '
      'is what crashes flutter_chat_ui\'s SliverAnimatedList)',
      () {
        final oldList = [_text('a', 'partial')];
        final newList = [_text('a', 'partial more')];

        final actions = computeMessageListSyncActions(oldList, newList);

        expect(actions, hasLength(1));
        final action = actions.single as UpdateAction;
        expect(action.oldMessage.id, 'a');
        expect((action.newMessage as chat_core.TextMessage).text, 'partial more');
      },
    );

    test('a genuinely new id at the tail produces an InsertAction at the correct index', () {
      final oldList = [_text('a', 'hi')];
      final newList = [_text('a', 'hi'), _text('b', 'new')];

      final actions = computeMessageListSyncActions(oldList, newList);

      expect(actions, hasLength(1));
      final action = actions.single as InsertAction;
      expect(action.message.id, 'b');
      expect(action.index, 1);
    });

    test('a genuinely new id mid-list produces an InsertAction at its target index', () {
      final oldList = [_text('a', 'hi'), _text('c', 'bye')];
      final newList = [_text('a', 'hi'), _text('b', 'new'), _text('c', 'bye')];

      final actions = computeMessageListSyncActions(oldList, newList);

      expect(actions, hasLength(1));
      final action = actions.single as InsertAction;
      expect(action.message.id, 'b');
      expect(action.index, 1);
    });

    test('an id no longer present produces a RemoveAction', () {
      final oldList = [_text('a', 'hi'), _text('b', 'bye')];
      final newList = [_text('a', 'hi')];

      final actions = computeMessageListSyncActions(oldList, newList);

      expect(actions, hasLength(1));
      expect((actions.single as RemoveAction).message.id, 'b');
    });

    test(
      'a compound change (removal + content change + insertion in one diff, '
      'the exact real-world shape from the crash log) produces one Remove, '
      'one Update, one Insert — never a Remove+Insert pair for the same id',
      () {
        final oldList = [_text('perm', 'pending'), _text('tool', 'running')];
        final newList = [_text('tool', 'done'), _text('newcard', 'here')];

        final actions = computeMessageListSyncActions(oldList, newList);

        expect(actions.whereType<RemoveAction>().map((a) => a.message.id), ['perm']);
        expect(actions.whereType<UpdateAction>().map((a) => a.oldMessage.id), ['tool']);
        expect(actions.whereType<InsertAction>().map((a) => a.message.id), ['newcard']);
        expect(actions, hasLength(3));
      },
    );

    test('applying the computed actions in order reproduces the new list exactly '
        '(via a real InMemoryChatController, not just asserted by hand)', () async {
      final oldList = [_text('perm', 'pending'), _text('tool', 'running')];
      final newList = [_text('tool', 'done'), _text('newcard', 'here')];
      final controller = chat_core.InMemoryChatController(messages: oldList);
      addTearDown(controller.dispose);

      final actions = computeMessageListSyncActions(oldList, newList);
      for (final action in actions) {
        switch (action) {
          case RemoveAction(:final message):
            await controller.removeMessage(message);
          case UpdateAction(:final oldMessage, :final newMessage):
            await controller.updateMessage(oldMessage, newMessage);
          case InsertAction(:final message, :final index):
            await controller.insertMessage(message, index: index);
          case ResetAction(:final messages):
            await controller.setMessages(messages);
        }
      }

      expect(controller.messages.map((m) => m.id), ['tool', 'newcard']);
      expect(
        (controller.messages.first as chat_core.TextMessage).text,
        'done',
      );
    });

    test('a genuine reorder among surviving ids falls back to ResetAction '
        '(defensive — ConversationReducer should never produce this shape)', () {
      final oldList = [_text('a', '1'), _text('b', '2')];
      final newList = [_text('b', '2'), _text('a', '1')]; // swapped

      final actions = computeMessageListSyncActions(oldList, newList);

      expect(actions, hasLength(1));
      expect(actions.single, isA<ResetAction>());
    });

    test(
      'a full swap (every id changes, none survive) needs no ResetAction — '
      'plain remove-all + insert-all is equally safe, since no id is ever in '
      'both the remove and insert sets at once',
      () {
        final oldList = [_text('a', '1')];
        final newList = [_text('b', '2')];

        final actions = computeMessageListSyncActions(oldList, newList);

        expect(actions.whereType<RemoveAction>().map((a) => a.message.id), ['a']);
        expect(actions.whereType<InsertAction>().map((a) => a.message.id), ['b']);
        expect(actions.whereType<UpdateAction>(), isEmpty);
      },
    );
  });
}
