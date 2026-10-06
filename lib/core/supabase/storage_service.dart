import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/constants.dart';
import '../errors/app_exception.dart';
import '../errors/error_mapper.dart';
import 'supabase_providers.dart';

/// Image uploads to Supabase Storage (spec §7.5, §13.9).
class StorageService {
  StorageService(this._db);

  final SupabaseClient _db;
  static const _uuid = Uuid();
  static const _jpeg = FileOptions(contentType: 'image/jpeg', upsert: true);

  String get _uid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw const AppException.auth('session_expired');
    return id;
  }

  /// Uploads `{uid}/{uuid}.jpg` (max 1600 px, JPEG 80) and a 400 px
  /// `{uid}/{uuid}_thumb.jpg`; returns the public URL of the full image.
  Future<String> uploadPostImage(String filePath) => guard(() async {
    final id = _uuid.v4();
    final full = await _compress(filePath, 1600, 80);
    final thumb = await _compress(filePath, 400, 70);
    final bucket = _db.storage.from(Buckets.postImages);
    final path = '$_uid/$id.jpg';
    await bucket.uploadBinary(path, full, fileOptions: _jpeg);
    await bucket.uploadBinary('$_uid/${id}_thumb.jpg', thumb, fileOptions: _jpeg);
    return bucket.getPublicUrl(path);
  });

  /// Uploads `{uid}/avatar.jpg`; the returned URL is cache-busted so the new
  /// picture shows immediately.
  Future<String> uploadAvatar(String filePath) => guard(() async {
    final bytes = await _compress(filePath, 512, 80);
    final bucket = _db.storage.from(Buckets.avatars);
    final path = '$_uid/avatar.jpg';
    await bucket.uploadBinary(path, bytes, fileOptions: _jpeg);
    return '${bucket.getPublicUrl(path)}?v=${DateTime.now().millisecondsSinceEpoch}';
  });

  Future<Uint8List> _compress(String path, int maxSide, int quality) async {
    final out = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: maxSide,
      minHeight: maxSide,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    if (out == null) throw const AppException.validation('image');
    return out;
  }

  /// `…/abc.jpg` → `…/abc_thumb.jpg` for images uploaded by this app.
  static String thumbUrl(String url) {
    final q = url.indexOf('?');
    final base = q == -1 ? url : url.substring(0, q);
    if (!base.contains('/${Buckets.postImages}/') || !base.endsWith('.jpg')) return url;
    return '${base.substring(0, base.length - 4)}_thumb.jpg';
  }
}

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(ref.watch(supabaseClientProvider)),
);
