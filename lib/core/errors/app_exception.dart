import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// Typed failures thrown by repositories (spec §18). The UI maps them to
/// localized text with `context.errorMessage(e)`.
@freezed
sealed class AppException with _$AppException implements Exception {
  const factory AppException.network([String? detail]) = NetworkException;
  const factory AppException.auth(String code) = AuthFailure;
  const factory AppException.permission() = PermissionFailure; // RLS 42501
  const factory AppException.notFound() = NotFoundFailure;
  const factory AppException.conflict(String code) = ConflictFailure; // 23505 duplicates
  const factory AppException.validation(String field) = ValidationFailure;
  const factory AppException.unknown([Object? cause]) = UnknownFailure;
}
