import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/app_status.dart';

part 'complaint.freezed.dart';
part 'complaint.g.dart';

/// A row of `complaints`: a Contact Support message and the reply from admin.
@freezed
abstract class Complaint with _$Complaint {
  const Complaint._();

  const factory Complaint({
    required int id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default('') String subject,
    @Default('') String body,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_email') String? userEmail,
    String? status,
    @JsonKey(name: 'admin_reply') String? adminReply,
    @JsonKey(name: 'replied_at') DateTime? repliedAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
  }) = _Complaint;

  factory Complaint.fromJson(Map<String, dynamic> json) => _$ComplaintFromJson(json);

  bool get hasReply => adminReply != null && adminReply!.trim().isNotEmpty;

  /// A reply the farmer has not opened yet.
  bool get hasUnreadReply => hasReply && readAt == null;

  AppStatus get statusEnum =>
      hasReply && AppStatus.fromDb(status) == AppStatus.pending
          ? AppStatus.replied
          : AppStatus.fromDb(status);
}
