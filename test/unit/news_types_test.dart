import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/news/data/news_repository.dart';
import 'package:farmfriend/features/news/domain/news.dart';
import 'package:farmfriend/features/news/domain/news_types.dart';
import 'package:farmfriend/features/news/presentation/controllers/news_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

News _news(int id, String? type) => News(
  id: id,
  title: 'Title $id',
  type: type,
  createdAt: DateTime.utc(2026, 10, 5).subtract(Duration(days: id)),
);

/// Newest first, like the `news` table query.
class _FakeNewsRepository implements NewsRepository {
  _FakeNewsRepository(this.all);

  final List<News> all;
  bool failMore = false;
  int forcedRefreshes = 0;
  final moreOffsets = <int>[];

  @override
  Future<List<News>> fetchLatest({bool forceRefresh = false}) async {
    if (forceRefresh) forcedRefreshes++;
    return all.take(NewsRepository.cacheLimit).toList();
  }

  @override
  Future<List<News>> fetchMore(int offset) async {
    moreOffsets.add(offset);
    if (failMore) throw const AppException.network();
    return all.skip(offset).take(AppConst.pageSize).toList();
  }

  @override
  Future<News> fetchById(int id) async =>
      all.firstWhere((n) => n.id == id, orElse: () => throw const AppException.notFound());

  @override
  Future<int> countSince(DateTime since) async =>
      all.where((n) => !n.createdAt!.isBefore(since)).length;
}

ProviderContainer _container(_FakeNewsRepository repository) => ProviderContainer.test(
  retry: (_, _) => null,
  overrides: [newsRepositoryProvider.overrideWithValue(repository)],
);

void main() {
  group('newsTypesOf', () {
    test('lists each type once, in first-seen order', () {
      final items = [
        _news(1, 'Alert'),
        _news(2, 'Technology'),
        _news(3, 'Alert'),
        _news(4, 'General'),
      ];
      expect(newsTypesOf(items), ['Alert', 'Technology', 'General']);
    });

    test('ignores casing, stray spaces and missing types', () {
      final items = [
        _news(1, ' Market '),
        _news(2, 'market'),
        _news(3, null),
        _news(4, '   '),
        _news(5, 'MARKET'),
      ];
      expect(newsTypesOf(items), ['Market']);
    });

    test('is empty when nothing is loaded', () {
      expect(newsTypesOf(const <News>[]), isEmpty);
    });
  });

  group('filterNewsByType', () {
    final items = [_news(1, 'Alert'), _news(2, 'Technology'), _news(3, 'alert '), _news(4, null)];

    test('null or blank means All', () {
      expect(filterNewsByType(items, null), items);
      expect(filterNewsByType(items, '  '), items);
    });

    test('matches the type case-insensitively', () {
      expect(filterNewsByType(items, 'Alert').map((n) => n.id), [1, 3]);
      expect(filterNewsByType(items, 'TECHNOLOGY').map((n) => n.id), [2]);
      expect(filterNewsByType(items, 'Disease'), isEmpty);
    });
  });

  group('news providers', () {
    final all = [for (var id = 1; id <= 45; id++) _news(id, id.isEven ? 'Alert' : 'General')];

    test('latestNewsProvider is the newest three', () async {
      final container = _container(_FakeNewsRepository(all));
      final latest = await container.read(latestNewsProvider.future);
      expect(latest.map((n) => n.id), [1, 2, 3]);
    });

    test('newsByIdProvider loads an article that is not in the list', () async {
      final container = _container(_FakeNewsRepository(all));
      container.listen(newsByIdProvider(44), (_, _) {});
      expect((await container.read(newsByIdProvider(44).future)).title, 'Title 44');
    });

    test('the list grows a page at a time from the saved batch, without the network', () async {
      final repo = _FakeNewsRepository(all);
      final container = _container(repo);
      container.listen(newsListProvider, (_, _) {});
      final first = await container.read(newsListProvider.future);
      expect(first.items.length, AppConst.pageSize);
      expect(first.hasMore, isTrue);

      final list = container.read(newsListProvider.notifier);
      await list.loadMore();
      expect(container.read(newsListProvider).requireValue.items.length, AppConst.pageSize * 2);
      await list.loadMore();
      final state = container.read(newsListProvider).requireValue;
      expect(state.items.map((n) => n.id), [for (var id = 1; id <= 45; id++) id]);
      // Fewer than a full batch: the server has nothing older.
      expect(state.hasMore, isFalse);
      expect(repo.moreOffsets, isEmpty);
    });

    test('past the saved batch, older pages come from the network', () async {
      final many = [for (var id = 1; id <= 75; id++) _news(id, 'General')];
      final repo = _FakeNewsRepository(many);
      final container = _container(repo);
      container.listen(newsListProvider, (_, _) {});
      await container.read(newsListProvider.future);
      final list = container.read(newsListProvider.notifier);

      await list.loadMore();
      await list.loadMore();
      var state = container.read(newsListProvider).requireValue;
      expect(state.items.length, NewsRepository.cacheLimit);
      expect(state.hasMore, isTrue);
      expect(repo.moreOffsets, isEmpty);

      await list.loadMore();
      await list.loadMore();
      state = container.read(newsListProvider).requireValue;
      expect(repo.moreOffsets, [50, 70]);
      expect(state.items.map((n) => n.id), [for (var id = 1; id <= 75; id++) id]);
      expect(state.hasMore, isFalse);
    });

    test('a failed page keeps the list and waits for Retry', () async {
      final many = [for (var id = 1; id <= 75; id++) _news(id, 'General')];
      final repo = _FakeNewsRepository(many)..failMore = true;
      final container = _container(repo);
      container.listen(newsListProvider, (_, _) {});
      await container.read(newsListProvider.future);
      final list = container.read(newsListProvider.notifier);
      await list.loadMore();
      await list.loadMore();

      await list.loadMore();
      var state = container.read(newsListProvider).requireValue;
      expect(state.items.length, NewsRepository.cacheLimit);
      expect(state.loadMoreFailed, isTrue);

      // Scrolling does not hammer the network after a failure…
      repo.failMore = false;
      await list.loadMore();
      expect(repo.moreOffsets, [50]);

      // …the Retry button does.
      await list.loadMore(retry: true);
      state = container.read(newsListProvider).requireValue;
      expect(state.items.length, NewsRepository.cacheLimit + AppConst.pageSize);
      expect(state.loadMoreFailed, isFalse);
    });

    test('refresh skips the cache', () async {
      final repo = _FakeNewsRepository(all);
      final container = _container(repo);
      container.listen(newsListProvider, (_, _) {});
      await container.read(newsListProvider.future);
      await container.read(newsListProvider.notifier).refresh();
      expect(repo.forcedRefreshes, 1);
    });
  });
}
