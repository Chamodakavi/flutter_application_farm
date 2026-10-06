import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/hive_boxes.dart';

/// Which broadcasts this user has opened on this device. `notifications` has
/// no per-user state, so "read" lives locally (spec §11.24, §17.3). Behind an
/// interface so tests can use an in-memory fake — Hive is not initialised
/// there.
abstract class ReadNotificationsStore {
  Future<Set<String>> load(String uid);

  Future<void> addAll(String uid, Iterable<String> ids);
}

/// The ids are the keys of the per-user `read_notifications_{uid}` box.
class HiveReadNotificationsStore implements ReadNotificationsStore {
  const HiveReadNotificationsStore();

  @override
  Future<Set<String>> load(String uid) async {
    final box = await HiveBoxes.open(HiveBoxes.readNotifications(uid));
    return {for (final key in box.keys) key.toString()};
  }

  @override
  Future<void> addAll(String uid, Iterable<String> ids) async {
    final box = await HiveBoxes.open(HiveBoxes.readNotifications(uid));
    await box.putAll({for (final id in ids) id: true});
  }
}

final readNotificationsStoreProvider = Provider<ReadNotificationsStore>(
  (ref) => const HiveReadNotificationsStore(),
);
