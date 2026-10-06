import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_exception.dart';

/// Converts anything thrown by Supabase, dio or the platform into an
/// [AppException]. Repositories wrap their calls with [guard].
AppException mapError(Object error) {
  if (error is AppException) return error;
  // A provider that awaits another provider gets the failure wrapped.
  if (error is ProviderException) return mapError(error.exception);
  if (error is PostgrestException) return mapPostgrest(error);
  if (error is AuthException) return mapAuth(error);
  if (error is StorageException) {
    return error.statusCode == '403' || error.statusCode == '401'
        ? const AppException.permission()
        : AppException.unknown(error.message);
  }
  if (error is FunctionException) {
    if (error.status == 401) return const AppException.auth('session_expired');
    if (error.status == 429) return const AppException.conflict('rate_limited');
    return AppException.network('function_${error.status}');
  }
  if (error is DioException) {
    return AppException.network(error.type.name);
  }
  if (error is SocketException ||
      error is TimeoutException ||
      error is HttpException ||
      error is HandshakeException) {
    return AppException.network(error.runtimeType.toString());
  }
  // package:http ClientException and realtime socket errors surface by name.
  final name = error.runtimeType.toString();
  if (name.contains('ClientException') || name.contains('SocketException')) {
    return AppException.network(name);
  }
  return AppException.unknown(error);
}

AppException mapPostgrest(PostgrestException e) {
  switch (e.code) {
    case '42501':
      return const AppException.permission();
    case '23505':
      return AppException.conflict(e.details?.toString() ?? 'duplicate');
    case 'PGRST116':
      return const AppException.notFound();
    case 'PGRST301':
    case '401':
      return const AppException.auth('session_expired');
  }
  final message = e.message.toLowerCase();
  if (message.contains('failed host lookup') || message.contains('socketexception')) {
    return AppException.network(e.message);
  }
  return AppException.unknown(e.message);
}

AppException mapAuth(AuthException e) {
  final code = e.code ?? '';
  final message = e.message.toLowerCase();

  if (e is AuthRetryableFetchException || message.contains('failed host lookup')) {
    return AppException.network(e.message);
  }
  if (code.isNotEmpty) return AppException.auth(code);

  // Older GoTrue responses carry no machine code — infer from the message.
  if (message.contains('invalid login credentials')) {
    return const AppException.auth('invalid_credentials');
  }
  if (message.contains('email not confirmed')) {
    return const AppException.auth('email_not_confirmed');
  }
  if (message.contains('already registered') || message.contains('already exists')) {
    return const AppException.auth('user_already_exists');
  }
  if (message.contains('expired')) return const AppException.auth('otp_expired');
  if (message.contains('rate limit')) {
    return const AppException.auth('over_request_rate_limit');
  }
  if (message.contains('password')) return const AppException.auth('weak_password');
  return AppException.auth(e.message);
}

/// Runs [body] and rethrows any failure as an [AppException].
Future<T> guard<T>(Future<T> Function() body) async {
  try {
    return await body();
  } catch (e) {
    throw mapError(e);
  }
}
