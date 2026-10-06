import 'dart:async';

import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/chatbot/data/chat_repository.dart';
import 'package:farmfriend/features/chatbot/domain/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabase extends Mock implements SupabaseClient {}

class _MockFunctions extends Mock implements FunctionsClient {}

void main() {
  late _MockSupabase db;
  late _MockFunctions functions;

  setUp(() {
    db = _MockSupabase();
    functions = _MockFunctions();
    when(() => db.functions).thenReturn(functions);
  });

  ChatRepository repository({Duration? timeout}) {
    final container = ProviderContainer.test(
      overrides: [
        supabaseClientProvider.overrideWithValue(db),
        if (timeout != null)
          chatRepositoryProvider.overrideWith((ref) => ChatRepository(db, ref, timeout: timeout)),
      ],
    );
    return container.read(chatRepositoryProvider);
  }

  void answer(Future<FunctionResponse> Function() response) {
    when(() => functions.invoke(any(), body: any(named: 'body'))).thenAnswer((_) => response());
  }

  group('ChatRepository.send', () {
    test('posts the message and app language to agribot-chat and returns the reply', () async {
      answer(() async => const FunctionResponse(status: 200, data: {'reply': ' Plant beans. '}));

      expect(await repository().send('Which crop?'), 'Plant beans.');

      final body =
          verify(() => functions.invoke(EdgeFn.agribotChat, body: captureAny(named: 'body')))
                  .captured
                  .single
              as Map;
      expect(body, {'message': 'Which crop?', 'language': 'en'});
    });

    test('accepts a JSON reply delivered as text', () async {
      answer(() async => const FunctionResponse(status: 200, data: '{"reply":"OK"}'));
      expect(await repository().send('Hi'), 'OK');
    });

    test('429 → conflict(chat_rate_limited)', () async {
      answer(() async => throw const FunctionException(status: 429));
      await expectLater(
        repository().send('Hi'),
        throwsA(const AppException.conflict('chat_rate_limited')),
      );
    });

    test('401 → auth(session_expired)', () async {
      answer(() async => throw const FunctionException(status: 401));
      await expectLater(
        repository().send('Hi'),
        throwsA(const AppException.auth('session_expired')),
      );
    });

    test('other statuses → network', () async {
      answer(() async => throw const FunctionException(status: 502));
      await expectLater(repository().send('Hi'), throwsA(const AppException.network('chat_502')));
    });

    test('no answer within the timeout → network', () async {
      answer(() => Completer<FunctionResponse>().future);
      await expectLater(
        repository(timeout: const Duration(milliseconds: 20)).send('Hi'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('a response without a reply is an error, not an empty bubble', () async {
      answer(() async => const FunctionResponse(status: 200, data: {'reply': '  '}));
      await expectLater(repository().send('Hi'), throwsA(isA<UnknownFailure>()));
    });
  });

  group('ChatHistoryEntry.fromRow', () {
    test('reads human and ai rows', () {
      final human = ChatHistoryEntry.fromRow({
        'id': 7,
        'message': {'type': 'human', 'content': ' Carrot price? ', 'additional_kwargs': {}},
      });
      expect(human?.id, 7);
      expect(human?.role, ChatRole.user);
      expect(human?.text, 'Carrot price?');

      final ai = ChatHistoryEntry.fromRow({
        'id': '8',
        'message': {'type': 'ai', 'content': 'About Rs. 240/kg.'},
      });
      expect(ai?.id, 8);
      expect(ai?.role, ChatRole.bot);
    });

    test('reads the older nested shape and JSON stored as text', () {
      final nested = ChatHistoryEntry.fromRow({
        'id': 1,
        'message': {
          'type': 'ai',
          'data': {'content': 'Hello'},
        },
      });
      expect(nested?.text, 'Hello');

      final text = ChatHistoryEntry.fromRow({
        'id': 2,
        'message': '{"type":"human","content":"Hi"}',
      });
      expect(text?.role, ChatRole.user);
    });

    test('skips tool rows, empty text and garbage', () {
      expect(
        ChatHistoryEntry.fromRow({
          'id': 1,
          'message': {'type': 'tool', 'content': '{}'},
        }),
        isNull,
      );
      expect(
        ChatHistoryEntry.fromRow({
          'id': 2,
          'message': {'type': 'ai', 'content': ''},
        }),
        isNull,
      );
      expect(ChatHistoryEntry.fromRow({'id': 3, 'message': 'not json'}), isNull);
      expect(ChatHistoryEntry.fromRow({'id': 4, 'message': null}), isNull);
    });
  });
}
