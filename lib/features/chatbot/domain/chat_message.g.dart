// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  role: $enumDecode(_$ChatRoleEnumMap, json['role']),
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  status:
      $enumDecodeNullable(_$ChatStatusEnumMap, json['status']) ??
      ChatStatus.sent,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$ChatRoleEnumMap[instance.role]!,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ChatStatusEnumMap[instance.status]!,
    };

const _$ChatRoleEnumMap = {ChatRole.user: 'user', ChatRole.bot: 'bot'};

const _$ChatStatusEnumMap = {
  ChatStatus.sending: 'sending',
  ChatStatus.sent: 'sent',
  ChatStatus.failed: 'failed',
};
