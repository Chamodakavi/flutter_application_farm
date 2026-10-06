import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'comment.freezed.dart';

/// A row of `comments` with the display name of its author when available.
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int id,
    String? userId,
    required int postId,
    @Default('') String content,
    DateTime? createdAt,
    String? authorName,
    String? authorAvatar,
  }) = _Comment;

  /// Accepts a plain `comments` row, a row with `author_name`/`author_avatar`
  /// columns, or one with an embedded `users(u_name, u_surname, u_avatar)`.
  factory Comment.fromRow(Map<String, dynamic> row) {
    final user = row['users'];
    String? name = asStringOrNull(row['author_name']);
    String? avatar = asStringOrNull(row['author_avatar']);
    if (user is Map) {
      name ??= [user['u_name'], user['u_surname']]
          .whereType<String>()
          .where((s) => s.trim().isNotEmpty)
          .join(' ');
      avatar ??= asStringOrNull(user['u_avatar']);
    }
    return Comment(
      id: asInt(row['id']),
      userId: asStringOrNull(row['user_id']),
      postId: asInt(row['post_id']),
      content: asString(row['content']),
      createdAt: asDateOrNull(row['created_at']),
      authorName: (name == null || name.isEmpty) ? null : name,
      authorAvatar: avatar,
    );
  }
}
