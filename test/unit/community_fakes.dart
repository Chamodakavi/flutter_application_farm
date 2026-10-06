import 'dart:async';

import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:farmfriend/features/community/data/community_repository.dart';
import 'package:farmfriend/features/community/domain/comment.dart';
import 'package:farmfriend/features/community/domain/feed_kind.dart';
import 'package:farmfriend/features/community/domain/post.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Id of the signed-in user in community tests.
const testUserId = 'me';

Post testPost(
  int id, {
  String? userId = 'someone-else',
  String content = 'Hello farmers',
  String? authorName = 'Nimal Perera',
  int likeCount = 0,
  int commentCount = 0,
  bool likedByMe = false,
  bool savedByMe = false,
}) => Post(
  id: id,
  userId: userId,
  content: content,
  authorName: authorName,
  createdAt: DateTime.now().subtract(Duration(minutes: 5 + id)),
  likeCount: likeCount,
  commentCount: commentCount,
  likedByMe: likedByMe,
  savedByMe: savedByMe,
);

/// In-memory stand-in for the Supabase-backed repository.
class FakeCommunityRepository implements CommunityRepository {
  FakeCommunityRepository({List<Post> posts = const [], List<Comment> comments = const []})
    : posts = [...posts],
      comments = [...comments];

  /// Newest first, like `feed_posts`.
  final List<Post> posts;
  final List<Comment> comments;

  /// When set, every write throws it.
  AppException? writeError;

  /// When set, writes wait for it — to observe the optimistic state.
  Completer<void>? writeGate;

  final likeCalls = <(int, bool)>[];
  final saveCalls = <(int, bool)>[];
  final realtime = StreamController<Comment>.broadcast();
  int realtimeListeners = 0;
  int _nextCommentId = 1000;

  Future<void> _write() async {
    await writeGate?.future;
    final error = writeError;
    if (error != null) throw error;
  }

  void _replace(int id, Post Function(Post) change) {
    final index = posts.indexWhere((p) => p.id == id);
    if (index != -1) posts[index] = change(posts[index]);
  }

  @override
  Future<PostPage> fetchPosts(FeedKind kind, {int page = 0}) async {
    final matching = switch (kind) {
      FeedKind.all => posts,
      FeedKind.mine => posts.where((p) => p.userId == testUserId).toList(),
      FeedKind.saved => posts.where((p) => p.savedByMe).toList(),
    };
    final rows = matching.skip(page * AppConst.pageSize).take(AppConst.pageSize).toList();
    return PostPage(rows, hasMore: rows.length >= AppConst.pageSize);
  }

  @override
  Future<Post> fetchPost(int id) async =>
      posts.firstWhere((p) => p.id == id, orElse: () => throw const AppException.notFound());

  @override
  Future<int> countMyPosts() async => posts.where((p) => p.userId == testUserId).length;

  @override
  Future<int> countSavedPosts() async => posts.where((p) => p.savedByMe).length;

  @override
  Future<void> setLiked(int postId, bool liked) async {
    await _write();
    likeCalls.add((postId, liked));
    _replace(postId, (p) => p.likedByMe == liked ? p : p.toggledLike());
  }

  @override
  Future<void> setSaved(int postId, bool saved) async {
    await _write();
    saveCalls.add((postId, saved));
    _replace(postId, (p) => p.copyWith(savedByMe: saved));
  }

  @override
  Future<void> createPost({required String content, String? imageUrl}) async {
    await _write();
    final id = posts.fold(0, (max, p) => p.id > max ? p.id : max) + 1;
    posts.insert(0, testPost(id, userId: testUserId, content: content));
  }

  @override
  Future<void> updatePost(int id, String content) async {
    await _write();
    _replace(id, (p) => p.copyWith(content: content));
  }

  @override
  Future<void> deletePost(int id) async {
    await _write();
    posts.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Comment>> fetchComments(int postId, {int offset = 0}) async =>
      comments.where((c) => c.postId == postId).skip(offset).take(AppConst.pageSize).toList();

  @override
  Future<Comment> addComment(int postId, String content) async {
    await _write();
    final comment = Comment(
      id: _nextCommentId++,
      userId: testUserId,
      postId: postId,
      content: content,
      createdAt: DateTime.now(),
    );
    comments.add(comment);
    return comment;
  }

  @override
  Future<void> deleteComment(int id) async {
    await _write();
    comments.removeWhere((c) => c.id == id);
  }

  @override
  Stream<Comment> commentInserts(int postId) {
    late final StreamController<Comment> out;
    StreamSubscription<Comment>? source;
    out = StreamController<Comment>(
      onListen: () {
        realtimeListeners++;
        source = realtime.stream.where((c) => c.postId == postId).listen(out.add);
      },
      onCancel: () async {
        realtimeListeners--;
        await source?.cancel();
      },
    );
    return out.stream;
  }
}

class FakeProfileController extends ProfileController {
  @override
  Future<AppUser?> build() async =>
      const AppUser(id: testUserId, name: 'Kamal', surname: 'Silva', phone: '+94771234567');
}

/// Everything a community screen reaches outside its own repository.
List<Override> communityOverrides(FakeCommunityRepository repository) => [
  communityRepositoryProvider.overrideWithValue(repository),
  currentUserIdProvider.overrideWithValue(testUserId),
  profileProvider.overrideWith(FakeProfileController.new),
  cartCountProvider.overrideWithValue(0),
  unreadNotificationCountProvider.overrideWithValue(0),
];
