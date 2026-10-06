// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String?,
  content: json['content'] as String? ?? '',
  image: json['image'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  authorName: json['author_name'] as String?,
  authorAvatar: json['author_avatar'] as String?,
  likeCount: json['like_count'] == null ? 0 : asInt(json['like_count']),
  commentCount: json['comment_count'] == null
      ? 0
      : asInt(json['comment_count']),
  likedByMe: json['liked_by_me'] == null ? false : asBool(json['liked_by_me']),
  savedByMe: json['saved_by_me'] == null ? false : asBool(json['saved_by_me']),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'content': instance.content,
  'image': instance.image,
  'created_at': instance.createdAt?.toIso8601String(),
  'author_name': instance.authorName,
  'author_avatar': instance.authorAvatar,
  'like_count': instance.likeCount,
  'comment_count': instance.commentCount,
  'liked_by_me': instance.likedByMe,
  'saved_by_me': instance.savedByMe,
};
