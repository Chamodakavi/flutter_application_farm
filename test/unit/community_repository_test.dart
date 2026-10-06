import 'dart:convert';
import 'dart:io';

import 'package:farmfriend/core/cache/cache_policy.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/community/data/community_repository.dart';
import 'package:farmfriend/features/community/domain/feed_kind.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// One request as PostgREST would see it.
class _Call {
  _Call(this.method, this.table, this.query, this.body);

  final String method;
  final String table;
  final Map<String, String> query;
  final Object? body;

  @override
  String toString() => '$method $table $query';
}

typedef _Reply = ({int status, Object? body});

/// A loopback stand-in for PostgREST, so the repository is exercised with the
/// real Supabase client (query strings, error codes) and no mocks.
class _FakePostgrest {
  late final HttpServer _server;
  late final SupabaseClient client;
  final calls = <_Call>[];
  _Reply Function(_Call call) reply = (_) => (status: 200, body: const <Object?>[]);

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((request) async {
      final text = await utf8.decoder.bind(request).join();
      final call = _Call(
        request.method,
        request.uri.pathSegments.last,
        request.uri.queryParameters,
        text.isEmpty ? null : jsonDecode(text),
      );
      calls.add(call);
      final answer = reply(call);
      request.response
        ..statusCode = answer.status
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(answer.body));
      await request.response.close();
    });
    client = SupabaseClient(
      'http://${_server.address.address}:${_server.port}',
      'test-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
  }

  /// Signs in locally with a session that is valid for an hour.
  Future<void> signIn(String uid) async {
    final expiresAt = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
    String part(Map<String, Object?> json) =>
        base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
    final token =
        '${part({'alg': 'HS256', 'typ': 'JWT'})}.${part({'sub': uid, 'exp': expiresAt})}.sig';
    await client.auth.recoverSession(
      jsonEncode({
        'access_token': token,
        'token_type': 'bearer',
        'expires_in': 3600,
        'expires_at': expiresAt,
        'refresh_token': 'refresh',
        'user': {
          'id': uid,
          'aud': 'authenticated',
          'app_metadata': <String, Object?>{},
          'user_metadata': <String, Object?>{},
          'created_at': '2026-01-01T00:00:00Z',
        },
      }),
    );
  }

  Future<void> stop() async {
    await client.dispose();
    await _server.close(force: true);
  }
}

const _relationshipError = (
  status: 400,
  body: {
    'code': 'PGRST200',
    'message': "Could not find a relationship between 'comments' and 'users' in the schema cache",
    'details': null,
    'hint': null,
  },
);

Map<String, Object?> _postRow(int id) => {
  'id': id,
  'user_id': 'someone',
  'content': 'Post $id',
  'image': null,
  'created_at': '2026-10-0${id}T08:00:00+00:00',
  'author_name': 'Nimal',
  'author_avatar': null,
  'like_count': 2,
  'comment_count': '1',
  'liked_by_me': false,
  'saved_by_me': true,
};

void main() {
  late _FakePostgrest server;
  late CommunityRepository repo;

  setUp(() async {
    server = _FakePostgrest();
    await server.start();
    repo = CommunityRepository(server.client, const CacheStore());
  });

  tearDown(() => server.stop());

  group('comments', () {
    test('are read oldest first with the author embedded', () async {
      server.reply = (_) => (
        status: 200,
        body: [
          {
            'id': 1,
            'user_id': 'u1',
            'post_id': 7,
            'content': 'Hello',
            'created_at': '2026-10-01T08:00:00+00:00',
            'users': {'u_name': 'Sunil', 'u_surname': 'Perera', 'u_avatar': 'https://x/a.jpg'},
          },
        ],
      );

      final comments = await repo.fetchComments(7, offset: 20);

      expect(comments.single.authorName, 'Sunil Perera');
      expect(comments.single.authorAvatar, 'https://x/a.jpg');
      final call = server.calls.single;
      expect(call.table, 'comments');
      expect(call.query['select'], contains('users('));
      expect(call.query['post_id'], 'eq.7');
      expect(call.query['order'], 'created_at.asc.nullslast,id.asc.nullslast');
      expect(call.query['offset'], '20');
      expect(call.query['limit'], '20');
    });

    test('fall back to a plain select when the users relationship is missing', () async {
      server.reply = (call) => call.query['select']!.contains('users(')
          ? _relationshipError
          : (
              status: 200,
              body: [
                {'id': 1, 'user_id': 'u1', 'post_id': 7, 'content': 'Hello', 'created_at': null},
              ],
            );

      final first = await repo.fetchComments(7);
      expect(first.single.content, 'Hello');
      expect(first.single.authorName, isNull);
      expect(server.calls.map((c) => c.query['select']), [contains('users('), '*']);

      // The relationship is not tried again for the rest of the session.
      await repo.fetchComments(7);
      expect(server.calls.length, 3);
      expect(server.calls.last.query['select'], '*');
    });

    test('other errors are not mistaken for a missing relationship', () async {
      server.reply = (_) =>
          (status: 403, body: {'code': '42501', 'message': 'permission denied for table comments'});
      await expectLater(repo.fetchComments(7), throwsA(isA<PermissionFailure>()));
      expect(server.calls.length, 1);
    });
  });

  group('feed', () {
    test('reads feed_posts newest first, one page at a time', () async {
      server.reply = (_) => (status: 200, body: [_postRow(2), _postRow(1)]);
      await server.signIn('me');

      final page = await repo.fetchPosts(FeedKind.all, page: 1);

      expect(page.posts.map((p) => p.id), [2, 1]);
      expect(page.posts.first.commentCount, 1);
      expect(page.hasMore, isFalse);
      final call = server.calls.single;
      expect(call.table, 'feed_posts');
      expect(call.query['order'], 'created_at.desc.nullslast');
      expect(call.query['offset'], '20');
      expect(call.query['limit'], '20');
      expect(call.query.containsKey('user_id'), isFalse);
    });

    test('My Posts filters by the signed-in user', () async {
      await server.signIn('me');
      await repo.fetchPosts(FeedKind.mine);
      expect(server.calls.single.query['user_id'], 'eq.me');
    });

    test('Saved Posts reads my saved ids, then those posts, in saved order', () async {
      server.reply = (call) => call.table == 'saved_posts'
          ? (
              status: 200,
              body: [
                {'post_id': 1},
                {'post_id': 2},
              ],
            )
          : (status: 200, body: [_postRow(2), _postRow(1)]);
      await server.signIn('me');

      final page = await repo.fetchPosts(FeedKind.saved);

      expect(page.posts.map((p) => p.id), [1, 2]);
      expect(server.calls.map((c) => c.table), ['saved_posts', 'feed_posts']);
      expect(server.calls.first.query['user_id'], 'eq.me');
      expect(server.calls.first.query['select'], 'post_id');
      expect(server.calls.last.query['id'], 'in.(1,2)');
    });

    test('Saved Posts with nothing saved does not query the feed', () async {
      await server.signIn('me');
      final page = await repo.fetchPosts(FeedKind.saved);
      expect(page.posts, isEmpty);
      expect(page.hasMore, isFalse);
      expect(server.calls.map((c) => c.table), ['saved_posts']);
    });

    test('a post that does not exist is a not-found failure', () async {
      await expectLater(repo.fetchPost(99), throwsA(isA<NotFoundFailure>()));
      expect(server.calls.single.query['id'], 'eq.99');
    });

    test('reads need a signed-in user where the query depends on one', () async {
      await expectLater(repo.fetchPosts(FeedKind.mine), throwsA(isA<AuthFailure>()));
      await expectLater(repo.countSavedPosts(), throwsA(isA<AuthFailure>()));
    });
  });

  group('likes and bookmarks', () {
    test('liking inserts (user_id, post_id); unliking deletes that row', () async {
      await server.signIn('me');

      await repo.setLiked(5, true);
      expect(server.calls.single.method, 'POST');
      expect(server.calls.single.table, 'post_likes');
      expect(server.calls.single.body, {'user_id': 'me', 'post_id': 5});

      await repo.setLiked(5, false);
      expect(server.calls.last.method, 'DELETE');
      expect(server.calls.last.table, 'post_likes');
      expect(server.calls.last.query, {'user_id': 'eq.me', 'post_id': 'eq.5'});
    });

    test('saving writes saved_posts the same way', () async {
      await server.signIn('me');
      await repo.setSaved(5, true);
      await repo.setSaved(5, false);
      expect(server.calls.map((c) => '${c.method} ${c.table}'), [
        'POST saved_posts',
        'DELETE saved_posts',
      ]);
      expect(server.calls.first.body, {'user_id': 'me', 'post_id': 5});
    });

    test('a duplicate like counts as done; other failures are reported', () async {
      await server.signIn('me');
      server.reply = (_) => (
        status: 409,
        body: {'code': '23505', 'message': 'duplicate key value', 'details': 'exists'},
      );
      await repo.setLiked(5, true);

      server.reply = (_) => (
        status: 403,
        body: {'code': '42501', 'message': 'new row violates row-level security policy'},
      );
      await expectLater(repo.setLiked(5, true), throwsA(isA<PermissionFailure>()));
    });
  });

  group('posts', () {
    test('a new post carries user_id, content and the image only when there is one', () async {
      await server.signIn('me');

      await repo.createPost(content: '🌱 #Planting\nBeans', imageUrl: 'https://x/p.jpg');
      expect(server.calls.last.table, 'posts');
      expect(server.calls.last.body, {
        'user_id': 'me',
        'content': '🌱 #Planting\nBeans',
        'image': 'https://x/p.jpg',
      });

      await repo.createPost(content: 'Text only');
      expect(server.calls.last.body, {'user_id': 'me', 'content': 'Text only'});
    });

    test('editing updates the content of my own post only', () async {
      await server.signIn('me');
      server.reply = (_) => (
        status: 200,
        body: [
          {'id': 3},
        ],
      );
      await repo.updatePost(3, 'New text');
      final call = server.calls.single;
      expect(call.method, 'PATCH');
      expect(call.body, {'content': 'New text'});
      expect(call.query['id'], 'eq.3');
      expect(call.query['user_id'], 'eq.me');

      // Row-level security returns no row for someone else's post.
      server.reply = (_) => (status: 200, body: const <Object?>[]);
      await expectLater(repo.updatePost(4, 'Hack'), throwsA(isA<PermissionFailure>()));
      await expectLater(repo.deletePost(4), throwsA(isA<PermissionFailure>()));
    });
  });
}
