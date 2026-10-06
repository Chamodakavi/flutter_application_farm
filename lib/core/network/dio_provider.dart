import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';

/// HTTP client for keyless public APIs (Open-Meteo). Supabase traffic goes
/// through the Supabase SDK, never through this client.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: AppConst.networkTimeout,
      receiveTimeout: AppConst.networkTimeout,
      sendTimeout: AppConst.networkTimeout,
      responseType: ResponseType.json,
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
