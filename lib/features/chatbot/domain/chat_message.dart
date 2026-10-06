import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum ChatRole { user, bot }

enum ChatStatus { sending, sent, failed }

/// One bubble in the AgriBot conversation; persisted to Hive as JSON.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required String id,
    required ChatRole role,
    required String text,
    required DateTime createdAt,
    @Default(ChatStatus.sent) ChatStatus status,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  bool get isUser => role == ChatRole.user;
  bool get isFailed => status == ChatStatus.failed;
}
