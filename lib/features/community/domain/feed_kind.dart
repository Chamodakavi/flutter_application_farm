import 'post.dart';

/// Which slice of `feed_posts` a list shows (spec §11.19, §11.22).
enum FeedKind {
  /// Everyone's posts — the Community tab.
  all,

  /// Posts written by the signed-in user.
  mine,

  /// Posts the signed-in user bookmarked.
  saved,
}

/// One page of a feed.
class PostPage {
  const PostPage(this.posts, {required this.hasMore});

  final List<Post> posts;

  /// False once the server returned a short page.
  final bool hasMore;
}
