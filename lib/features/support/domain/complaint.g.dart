// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Complaint _$ComplaintFromJson(Map<String, dynamic> json) => _Complaint(
  id: (json['id'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  subject: json['subject'] as String? ?? '',
  body: json['body'] as String? ?? '',
  userId: json['user_id'] as String?,
  userName: json['user_name'] as String?,
  userEmail: json['user_email'] as String?,
  status: json['status'] as String?,
  adminReply: json['admin_reply'] as String?,
  repliedAt: json['replied_at'] == null
      ? null
      : DateTime.parse(json['replied_at'] as String),
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
);

Map<String, dynamic> _$ComplaintToJson(_Complaint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'subject': instance.subject,
      'body': instance.body,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'status': instance.status,
      'admin_reply': instance.adminReply,
      'replied_at': instance.repliedAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
    };
