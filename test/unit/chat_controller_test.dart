import 'dart:async';

import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/chatbot/data/chat_repository.dart';
import 'package:farmfriend/features/chatbot/domain/chat_message.dart';
import 'package:farmfriend/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'chat_fakes.dart';

const _uid = 'user-1';

ChatMessage _saved(int i, {ChatRole role = ChatRole.user, ChatStatus status = ChatStatus.sent}) =>
    ChatMessage(
      id: 'm$i',
      role: role,
      text: 'message $i',
      createdAt: DateTime(2026, 1, 1, 8).add(Duration(minutes: i)),
      status: status,
    );

void main() {
  late FakeChatRepository repository;
  late MemoryChatStore store;
  late List<TrackedEvent> events;

  ProviderContainer container({String? uid = _uid}) => ProviderContainer.test(
    overrides: chatOverrides(repository: repository, store: store, events: events, uid: uid),
  );

  setUp(() {
    repository = FakeChatRepository();
    store = MemoryChatStore();
    events = [];
  });

  group('send', () {
    test('marks the question sent, appends the reply and persists both', () async {
      final c = container();
      await c.read(chatControllerProvider.notifier).send('  Price of carrot?  ');

      final state = c.read(chatControllerProvider);
      expect(repository.sent, ['Price of carrot?']);
      expect(state.waiting, isFalse);
      expect(state.messages, hasLength(2));
      expect(state.messages[0].role, ChatRole.user);
      expect(state.messages[0].text, 'Price of carrot?');
      expect(state.messages[0].status, ChatStatus.sent);
      expect(state.messages[1].role, ChatRole.bot);
      expect(state.messages[1].text, 'Reply to: Price of carrot?');
      expect(state.sentCount, 1);

      expect(store.messages[_uid], state.messages);
      expect(store.counts[_uid], 1);
    });

    test('shows the question as sending while the reply is on its way', () async {
      final reply = Completer<String>();
      repository.script.add(reply);
      final c = container();
      final sending = c.read(chatControllerProvider.notifier).send('Hello');
      await pumpEventQueue();

      var state = c.read(chatControllerProvider);
      expect(state.waiting, isTrue);
      expect(state.messages.single.status, ChatStatus.sending);
      // Saved straight away, so a question survives the app being closed.
      expect(store.messages[_uid]?.single.status, ChatStatus.sending);

      // A second question has to wait for the first reply.
      await c.read(chatControllerProvider.notifier).send('Second');
      expect(repository.sent, ['Hello']);

      reply.complete('Hi!');
      await sending;
      state = c.read(chatControllerProvider);
      expect(state.waiting, isFalse);
      expect(state.messages.map((m) => m.text), ['Hello', 'Hi!']);
    });

    test('tracks chat_sent with the language only — never the text', () async {
      final c = container();
      await c.read(chatControllerProvider.notifier).send('My secret question');

      expect(events, hasLength(1));
      expect(events.single.event, AnalyticsEvents.chatSent);
      expect(events.single.props, {'language': 'en'});
    });

    test('ignores blank input and does nothing when signed out', () async {
      final c = container();
      await c.read(chatControllerProvider.notifier).send('   ');
      expect(c.read(chatControllerProvider).messages, isEmpty);

      final signedOut = container(uid: null);
      await signedOut.read(chatControllerProvider.notifier).send('Hello');
      expect(signedOut.read(chatControllerProvider).messages, isEmpty);
      expect(repository.sent, isEmpty);
    });
  });

  group('failure and retry', () {
    test('a failed send marks the message failed and keeps it', () async {
      repository.script.add(const AppException.network('chat_502'));
      final c = container();
      await c.read(chatControllerProvider.notifier).send('Hello');

      final state = c.read(chatControllerProvider);
      expect(state.waiting, isFalse);
      expect(state.rateLimited, isFalse);
      expect(state.messages.single.status, ChatStatus.failed);
      expect(state.sentCount, 0);
      expect(store.messages[_uid]?.single.status, ChatStatus.failed);
      expect(events, isEmpty);
    });

    test('429 raises the rate-limit notice until the next attempt', () async {
      repository.script.add(const AppException.conflict('chat_rate_limited'));
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.send('Hello');
      expect(c.read(chatControllerProvider).rateLimited, isTrue);

      await controller.retry(c.read(chatControllerProvider).messages.single.id);
      expect(c.read(chatControllerProvider).rateLimited, isFalse);
    });

    test('retry re-sends the failed message and appends the reply', () async {
      repository.script.addAll([const AppException.network(), 'Plant beans.']);
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.send('What should I plant?');
      final failed = c.read(chatControllerProvider).messages.single;
      expect(failed.isFailed, isTrue);

      await controller.retry(failed.id);

      final state = c.read(chatControllerProvider);
      expect(repository.sent, ['What should I plant?', 'What should I plant?']);
      expect(state.messages, hasLength(2));
      expect(state.messages[0].id, failed.id);
      expect(state.messages[0].status, ChatStatus.sent);
      expect(state.messages[1].text, 'Plant beans.');
      expect(store.messages[_uid], state.messages);
    });

    test('retry moves an older failed message under the newest ones', () async {
      repository.script.addAll([const AppException.network(), 'First answer', 'Second answer']);
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.send('Failed question');
      await controller.send('Good question');
      final failedId = c.read(chatControllerProvider).messages.first.id;

      await controller.retry(failedId);

      expect(c.read(chatControllerProvider).messages.map((m) => m.text), [
        'Good question',
        'First answer',
        'Failed question',
        'Second answer',
      ]);
    });

    test('retry ignores messages that did not fail', () async {
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.send('Hello');
      await controller.retry(c.read(chatControllerProvider).messages.first.id);
      expect(repository.sent, ['Hello']);
    });
  });

  group('persistence', () {
    test('restores the saved conversation and the answered count', () async {
      store.messages[_uid] = [_saved(1), _saved(2, role: ChatRole.bot)];
      store.counts[_uid] = 4;
      final c = container();
      expect(c.read(chatControllerProvider).restoring, isTrue);
      await pumpEventQueue();

      final state = c.read(chatControllerProvider);
      expect(state.restoring, isFalse);
      expect(state.messages.map((m) => m.id), ['m1', 'm2']);
      expect(state.sentCount, 4);
    });

    test('the answered count carries on from earlier sessions (feedback after the 5th)', () async {
      store.counts[_uid] = 4;
      store.messages[_uid] = [_saved(1)];
      repository.script.add(const AppException.network());
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);

      await controller.send('Not answered');
      expect(c.read(chatControllerProvider).sentCount, 4);

      await controller.send('Answered');
      expect(c.read(chatControllerProvider).sentCount, 5);
      expect(store.counts[_uid], 5);
    });

    test('a question interrupted by closing the app comes back as failed', () async {
      store.messages[_uid] = [_saved(1, status: ChatStatus.sending)];
      final c = container();
      c.read(chatControllerProvider);
      await pumpEventQueue();
      expect(c.read(chatControllerProvider).messages.single.status, ChatStatus.failed);
    });

    test('keeps only the last 100 messages', () async {
      store.messages[_uid] = [for (var i = 0; i < ChatController.maxMessages; i++) _saved(i)];
      final c = container();
      await c.read(chatControllerProvider.notifier).send('One more');

      final state = c.read(chatControllerProvider);
      expect(state.messages, hasLength(ChatController.maxMessages));
      expect(state.messages.first.id, 'm2');
      expect(state.messages[98].text, 'One more');
      expect(state.messages.last.role, ChatRole.bot);
      expect(store.messages[_uid], hasLength(ChatController.maxMessages));
    });

    test('conversations are kept per user', () async {
      store.messages['someone-else'] = [_saved(1)];
      final c = container();
      c.read(chatControllerProvider);
      await pumpEventQueue();
      expect(c.read(chatControllerProvider).messages, isEmpty);
    });

    test('clear empties the conversation and the store', () async {
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.send('Hello');
      await controller.clear();

      expect(c.read(chatControllerProvider).isEmpty, isTrue);
      expect(store.messages[_uid], isEmpty);
    });

    test('a cleared chat stays cleared: the server history is not brought back', () async {
      store.messages[_uid] = [];
      repository.historyPages.add(
        const ChatHistoryPage(
          entries: [ChatHistoryEntry(id: 1, role: ChatRole.user, text: 'old question')],
          oldestId: 1,
        ),
      );
      final c = container();
      c.read(chatControllerProvider);
      await pumpEventQueue();

      final state = c.read(chatControllerProvider);
      expect(state.isEmpty, isTrue);
      expect(state.canLoadEarlier, isFalse);
      expect(repository.historyRequests, isEmpty);
    });

    test('a reply that arrives after clear is dropped', () async {
      final reply = Completer<String>();
      repository.script.add(reply);
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      final sending = controller.send('Hello');
      await pumpEventQueue();
      await controller.clear();
      reply.complete('Late answer');
      await sending;

      final state = c.read(chatControllerProvider);
      expect(state.isEmpty, isTrue);
      expect(state.waiting, isFalse);
    });
  });

  group('load earlier', () {
    const page = ChatHistoryPage(
      entries: [
        ChatHistoryEntry(id: 12, role: ChatRole.bot, text: 'About Rs. 240/kg.'),
        ChatHistoryEntry(id: 11, role: ChatRole.user, text: 'Carrot price?'),
      ],
      oldestId: 11,
    );

    test('an empty chat brings back the server history by itself', () async {
      repository.historyPages.add(page);
      final c = container();
      c.read(chatControllerProvider);
      await pumpEventQueue();

      final state = c.read(chatControllerProvider);
      expect(state.earlier.map((m) => m.text), ['Carrot price?', 'About Rs. 240/kg.']);
      expect(state.messages, isEmpty);
      expect(state.all, hasLength(2));
      expect(state.canLoadEarlier, isFalse);
      // History is shown but not copied into the device store.
      expect(store.messages[_uid], isNull);
    });

    test('rows already on screen are not loaded twice', () async {
      store.messages[_uid] = [
        ChatMessage(id: 'a', role: ChatRole.user, text: 'Carrot price?', createdAt: DateTime(2026)),
        ChatMessage(
          id: 'b',
          role: ChatRole.bot,
          text: 'About Rs. 240/kg.',
          createdAt: DateTime(2026),
        ),
      ];
      repository.historyPages.add(
        ChatHistoryPage(
          entries: [
            ...page.entries,
            const ChatHistoryEntry(id: 10, role: ChatRole.bot, text: 'Hello farmer!'),
            const ChatHistoryEntry(id: 9, role: ChatRole.user, text: 'Hi'),
          ],
          oldestId: 9,
        ),
      );
      final c = container();
      await c.read(chatControllerProvider.notifier).loadEarlier();

      final state = c.read(chatControllerProvider);
      expect(state.earlier.map((m) => m.text), ['Hi', 'Hello farmer!']);
      expect(state.all.map((m) => m.text), [
        'Hi',
        'Hello farmer!',
        'Carrot price?',
        'About Rs. 240/kg.',
      ]);
    });

    test('pages further back with the oldest id as cursor', () async {
      store.messages[_uid] = [_saved(1)];
      repository.historyPages.addAll([
        const ChatHistoryPage(
          entries: [
            ChatHistoryEntry(id: 9, role: ChatRole.user, text: 'message 1'),
            ChatHistoryEntry(id: 8, role: ChatRole.bot, text: 'older'),
          ],
          oldestId: 8,
          hasMore: true,
        ),
        const ChatHistoryPage(
          entries: [ChatHistoryEntry(id: 3, role: ChatRole.user, text: 'oldest')],
          oldestId: 3,
        ),
      ]);
      final c = container();
      final controller = c.read(chatControllerProvider.notifier);
      await controller.loadEarlier();
      expect(c.read(chatControllerProvider).canLoadEarlier, isTrue);
      await controller.loadEarlier();

      expect(repository.historyRequests, [null, 8]);
      final state = c.read(chatControllerProvider);
      expect(state.earlier.map((m) => m.text), ['oldest', 'older']);
      expect(state.canLoadEarlier, isFalse);
    });

    test('any error just hides the option', () async {
      store.messages[_uid] = [_saved(1)];
      repository.historyPages.add(const AppException.permission());
      final c = container();
      await c.read(chatControllerProvider.notifier).loadEarlier();

      final state = c.read(chatControllerProvider);
      expect(state.canLoadEarlier, isFalse);
      expect(state.loadingEarlier, isFalse);
      expect(state.messages, hasLength(1));
    });
  });

  group('HistoryAligner', () {
    ChatMessage local(String text, ChatRole role) =>
        ChatMessage(id: text, role: role, text: text, createdAt: DateTime(2026));
    ChatHistoryEntry row(int id, String text, ChatRole role) =>
        ChatHistoryEntry(id: id, role: role, text: text);

    test('with nothing on screen every row is older', () {
      final rows = [row(2, 'a', ChatRole.bot), row(1, 'q', ChatRole.user)];
      expect(HistoryAligner(const []).older(rows), rows);
    });

    test('skips rows from another device and continues across pages', () {
      final aligner = HistoryAligner([
        local('q1', ChatRole.user),
        local('a1', ChatRole.bot),
        local('q2', ChatRole.user),
        local('a2', ChatRole.bot),
      ]);
      final first = aligner.older([
        row(9, 'a2', ChatRole.bot),
        row(8, 'q2', ChatRole.user),
        row(7, 'asked on the web', ChatRole.user),
      ]);
      expect(first, isEmpty);
      final second = aligner.older([
        row(6, 'a1', ChatRole.bot),
        row(5, 'q1', ChatRole.user),
        row(4, 'before', ChatRole.bot),
      ]);
      expect(second.map((e) => e.text), ['before']);
    });

    test('gives up matching when the server stores different text', () {
      final aligner = HistoryAligner([local('typed question', ChatRole.user)]);
      final rows = [for (var id = 30; id > 0; id--) row(id, 'stored $id', ChatRole.bot)];
      final older = aligner.older(rows);
      expect(older.first.id, 10);
      expect(older, hasLength(10));
    });

    test('failed local messages are not expected on the server', () {
      final aligner = HistoryAligner([
        local('q1', ChatRole.user),
        local('never sent', ChatRole.user).copyWith(status: ChatStatus.failed),
      ]);
      final older = aligner.older([row(2, 'q1', ChatRole.user), row(1, 'q0', ChatRole.user)]);
      expect(older.map((e) => e.text), ['q0']);
    });
  });
}
