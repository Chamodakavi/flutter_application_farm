import 'package:freezed_annotation/freezed_annotation.dart';

part 'news.freezed.dart';
part 'news.g.dart';

/// A row of `news`.
@freezed
abstract class News with _$News {
  const News._();

  const factory News({
    @JsonKey(name: 'n_id') required int id,
    @JsonKey(name: 'n_img') String? image,
    @JsonKey(name: 'n_title') @Default('') String title,
    @JsonKey(name: 'n_description') @Default('') String description,
    @JsonKey(name: 'n_type') String? type,
    @JsonKey(name: 'n_author') String? author,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  /// Alerts get an amber accent in lists (spec §11.18).
  bool get isAlert => type?.trim().toLowerCase() == 'alert';

  bool get hasImage => image != null && image!.trim().isNotEmpty;
}
