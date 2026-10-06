import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/comment.dart';
import '../domain/feed_kind.dart';
import '../domain/post.dart';

/// Community data (spec §7.1, §7.3): the feed is read from the `feed_posts`
/// view; posts, likes, bookmarks and comments are written to their tables.
class CommunityRepository {
  CommunityRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  static const _commentWithAuthor = '*, users(u_name, u_surname, u_avatar)';

  /// Turned off for the session once PostgREST reports that `comments` has
  /// no relationship to `users` to embed.
  bool _embedAuthors = true;

  String get _uid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw const AppException.auth('session_expired');
    return id;
  }

  // --- Feed ------------------------------------------------------------------

  /// One page of a feed, newest first. The first page always comes from the
  /// network when there is one; the saved copy is only the offline fallback.
  Future<PostPage> fetchPosts(FeedKind kind, {int page = 0}) async {
    if (page > 0) return guard(() async => _decodePage(await _loadPage(kind, page)));
    final String key;
    try {
      key = 'feed_${kind.name}_$_uid';
    } catch (e) {
      throw mapError(e);
    }
    return _cache.fetch(
      box: HiveBoxes.cacheUser,
      key: key,
      ttl: Duration.zero,
      load: () => _loadPage(kind, 0),
      decode: _decodePage,
    );
  }

  static PostPage _decodePage(Object? json) {
    final map = json is Map ? json : const <String, Object?>{};
    return PostPage(asRows(map['rows']).map(Post.fromJson).toList(), hasMore: asBool(map['more']));
  }

  Future<Map<String, Object?>> _loadPage(FeedKind kind, int page) async {
    final from = page * AppConst.pageSize;
    final to = from + AppConst.pageSize - 1;

    if (kind == FeedKind.saved) {
      final saved = await _db
          .from(Tables.savedPosts)
          .select('post_id')
          .eq('user_id', _uid)
          .order('created_at', ascending: false)
          .range(from, to);
      final ids = [for (final row in saved) asInt(row['post_id'])];
      if (ids.isEmpty) return {'rows': const <Object?>[], 'more': false};
      final rows = await _db.from(Tables.feedPosts).select().inFilter('id', ids);
      // Keep the order in which the posts were saved.
      final position = {for (var i = 0; i < ids.length; i++) ids[i]: i};
      final sorted = [...rows]
        ..sort((a, b) => (position[asInt(a['id'])] ?? 0).compareTo(position[asInt(b['id'])] ?? 0));
      return {'rows': sorted, 'more': ids.length >= AppConst.pageSize};
    }

    var query = _db.from(Tables.feedPosts).select();
    if (kind == FeedKind.mine) query = query.eq('user_id', _uid);
    final rows = await query.order('created_at', ascending: false).range(from, to);
    return {'rows': rows, 'more': rows.length >= AppConst.pageSize};
  }

  /// A single post with its counters (post detail, deep links).
  Future<Post> fetchPost(int id) => guard(() async {
    final row = await _db.from(Tables.feedPosts).select().eq('id', id).maybeSingle();
    if (row == null) throw const AppException.notFound();
    return Post.fromJson(row);
  });

  /// Number of posts written by the signed-in user ("My Posts (n)").
  Future<int> countMyPosts() => _count('my_posts', Tables.posts);

  /// Number of posts the signed-in user bookmarked ("Saved Posts (n)").
  Future<int> countSavedPosts() => _count('saved_posts', Tables.savedPosts);

  Future<int> _count(String name, String table) async {
    final String uid;
    try {
      uid = _uid;
    } catch (e) {
      throw mapError(e);
    }
    return _cache.fetch(
      box: HiveBoxes.cacheUser,
      key: '${name}_count_$uid',
      ttl: Duration.zero,
      load: () async => await _db.from(table).count().eq('user_id', uid),
      decode: asInt,
    );
  }

  // --- Likes and bookmarks (spec §13.4) --------------------------------------

  Future<void> setLiked(int postId, bool liked) => _setMembership(Tables.postLikes, postId, liked);

  Future<void> setSaved(int postId, bool saved) => _setMembership(Tables.savedPosts, postId, saved);

  /// Inserts or deletes the (`user_id`, `post_id`) row. A duplicate insert
  /// means the row is already there, which is the state we wanted.
  Future<void> _setMembership(String table, int postId, bool member) => guard(() async {
    final uid = _uid;
    if (!member) {
      await _db.from(table).delete().eq('user_id', uid).eq('post_id', postId);
      return;
    }
    try {
      await _db.from(table).insert({'user_id': uid, 'post_id': postId});
    } on PostgrestException catch (e) {
      if (e.code != '23505') rethrow;
    }
  });

  // --- Posts -----------------------------------------------------------------

  /// [imageUrl] is the public URL returned by `StorageService.uploadPostImage`.
  Future<void> createPost({required String content, String? imageUrl}) => guard(() async {
    await _db.from(Tables.posts).insert({'user_id': _uid, 'content': content, 'image': ?imageUrl});
  });

  /// Editing changes the text only (spec §11.19).
  Future<void> updatePost(int id, String content) => guard(() async {
    final rows = await _db
        .from(Tables.posts)
        .update({'content': content})
        .eq('id', id)
        .eq('user_id', _uid)
        .select('id');
    // Row-level security hides other people's posts instead of failing.
    if (rows.isEmpty) throw const AppException.permission();
  });

  Future<void> deletePost(int id) => guard(() async {
    final rows = await _db
        .from(Tables.posts)
        .delete()
        .eq('id', id)
        .eq('user_id', _uid)
        .select('id');
    if (rows.isEmpty) throw const AppException.permission();
  });

  // --- Comments --------------------------------------------------------------

  bool _isRelationshipError(PostgrestException e) =>
      e.code == 'PGRST200' ||
      e.code == 'PGRST201' ||
      e.message.toLowerCase().contains('relationship');

  /// Runs [query] with the author embedded; when PostgREST rejects the
  /// relationship, repeats it with plain columns (authors then show as a
  /// generic "Farmer").
  Future<T> _withAuthors<T>(Future<T> Function(String columns) query) async {
    if (_embedAuthors) {
      try {
        return await query(_commentWithAuthor);
      } on PostgrestException catch (e) {
        if (!_isRelationshipError(e)) rethrow;
        _embedAuthors = false;
      }
    }
    return query('*');
  }

  /// Comments of a post, oldest first, [AppConst.pageSize] from [offset].
  Future<List<Comment>> fetchComments(int postId, {int offset = 0}) => guard(() async {
    final rows = await _withAuthors(
      (columns) => _db
          .from(Tables.comments)
          .select(columns)
          .eq('post_id', postId)
          .order('created_at', ascending: true)
          .order('id', ascending: true)
          .range(offset, offset + AppConst.pageSize - 1),
    );
    return rows.map(Comment.fromRow).toList();
  });

  Future<Comment> addComment(int postId, String content) => guard(() async {
    final row = await _db
        .from(Tables.comments)
        .insert({'user_id': _uid, 'post_id': postId, 'content': content})
        .select()
        .single();
    return Comment.fromRow(row);
  });

  Future<void> deleteComment(int id) => guard(() async {
    await _db.from(Tables.comments).delete().eq('id', id).eq('user_id', _uid);
  });

  /// Comments added to [postId] while someone is listening (spec §17.1).
  /// The realtime channel is opened on listen and removed on cancel.
  Stream<Comment> commentInserts(int postId) {
    RealtimeChannel? channel;
    var cancelled = false;
    late final StreamController<Comment> controller;

    Future<void> emit(Map<String, dynamic> record) async {
      final comment = await _resolveInserted(record);
      if (comment != null && !cancelled) controller.add(comment);
    }

    controller = StreamController<Comment>(
      onListen: () {
        channel = _db
            .channel('comments-$postId-${DateTime.now().microsecondsSinceEpoch}')
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: Tables.comments,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'post_id',
                value: postId,
              ),
              callback: (payload) => emit(payload.newRecord),
            )
            .subscribe();
      },
      onCancel: () async {
        cancelled = true;
        final open = channel;
        channel = null;
        if (open == null) return;
        try {
          await _db.removeChannel(open);
        } catch (_) {
          // Socket already closed (offline, signed out): nothing to remove.
        }
      },
    );
    return controller.stream;
  }

  /// The realtime payload has no author; other people's comments are read
  /// back once with the author embedded when that is possible.
  Future<Comment?> _resolveInserted(Map<String, dynamic> record) async {
    final id = asIntOrNull(record['id']);
    if (id == null) return null;
    final mine = record['user_id'] == _db.auth.currentUser?.id;
    if (_embedAuthors && !mine) {
      try {
        final row = await _db
            .from(Tables.comments)
            .select(_commentWithAuthor)
            .eq('id', id)
            .maybeSingle();
        if (row != null) return Comment.fromRow(row);
      } on PostgrestException catch (e) {
        if (_isRelationshipError(e)) _embedAuthors = false;
      } catch (_) {
        // Offline or timed out: the bare row below is enough.
      }
    }
    return Comment.fromRow(record);
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>(
  (ref) => CommunityRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
