import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// A row of the `feed_posts` view: a post plus author and per-user counters.
@freezed
abstract class Post with _$Post {
  const Post._();

  const factory Post({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    @Default('') String content,
    String? image,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'author_name') String? authorName,
    @JsonKey(name: 'author_avatar') String? authorAvatar,
    @JsonKey(name: 'like_count', fromJson: asInt) @Default(0) int likeCount,
    @JsonKey(name: 'comment_count', fromJson: asInt) @Default(0) int commentCount,
    @JsonKey(name: 'liked_by_me', fromJson: asBool) @Default(false) bool likedByMe,
    @JsonKey(name: 'saved_by_me', fromJson: asBool) @Default(false) bool savedByMe,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  bool get hasImage => image != null && image!.trim().isNotEmpty;

  /// Optimistic like toggle (spec §13.4).
  Post toggledLike() => copyWith(
    likedByMe: !likedByMe,
    likeCount: likedByMe ? (likeCount > 0 ? likeCount - 1 : 0) : likeCount + 1,
  );

  Post toggledSave() => copyWith(savedByMe: !savedByMe);
}
