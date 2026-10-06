import 'package:farmfriend/features/notifications/data/notification_repository.dart';
import 'package:farmfriend/features/notifications/data/read_notifications_store.dart';
import 'package:farmfriend/features/notifications/domain/app_notification.dart';

class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository([List<AppNotification> initial = const []]) : items = List.of(initial);

  List<AppNotification> items;
  Object? fetchError;
  int fetches = 0;
  List<AppNotification>? cached;

  @override
  Future<List<AppNotification>> fetchLatest(String uid) async {
    fetches++;
    if (fetchError != null) throw fetchError!;
    return List.of(items);
  }

  @override
  Future<void> saveToCache(String uid, List<AppNotification> list) async => cached = List.of(list);
}

class MemoryReadNotificationsStore implements ReadNotificationsStore {
  final read = <String, Set<String>>{};
  Object? loadError;

  @override
  Future<Set<String>> load(String uid) async {
    if (loadError != null) throw loadError!;
    return {...?read[uid]};
  }

  @override
  Future<void> addAll(String uid, Iterable<String> ids) async =>
      read.putIfAbsent(uid, () => {}).addAll(ids);
}
