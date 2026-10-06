import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/constants.dart';
import '../../data/news_repository.dart';
import '../../domain/news.dart';

/// Latest 3 news items (Home).
final latestNewsProvider = FutureProvider<List<News>>((ref) async {
  final news = await ref.watch(newsRepositoryProvider).fetchLatest();
  return news.take(3).toList();
});

/// News published in the last 30 days (Home stat card).
final recentNewsCountProvider = FutureProvider<int>((ref) {
  final since = DateTime.now().subtract(const Duration(days: 30));
  return ref.watch(newsRepositoryProvider).countSince(since);
});

/// The loaded part of the news list.
class NewsListState {
  const NewsListState({
    this.items = const [],
    this.hasMore = false,
    this.loadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<News> items;
  final bool hasMore;
  final bool loadingMore;

  /// The last "load more" failed; scrolling stops retrying until the user
  /// taps Retry.
  final bool loadMoreFailed;

  NewsListState copyWith({
    List<News>? items,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreFailed,
  }) => NewsListState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
  );
}

/// Paginated news list, newest first (spec §11.18).
///
/// The repository hands over the newest [NewsRepository.cacheLimit] articles
/// at once (they are what is saved for offline reading); the list still grows
/// by [AppConst.pageSize], first from that batch and then from the network.
class NewsListController extends AsyncNotifier<NewsListState> {
  /// The batch from the repository; `state.items` is a prefix of it until
  /// the list grows past its end.
  List<News> _latest = const [];

  /// Bumped by every first-page load, so a "load more" that was in flight
  /// during a refresh is dropped instead of appended to the new list.
  int _generation = 0;

  @override
  Future<NewsListState> build() async =>
      _firstPage(await ref.watch(newsRepositoryProvider).fetchLatest());

  NewsListState _firstPage(List<News> latest) {
    _generation++;
    _latest = latest;
    return _reveal(AppConst.pageSize);
  }

  /// The first [count] articles of the batch. A full batch means the server
  /// may have more.
  NewsListState _reveal(int count) {
    final shown = _latest.take(count).toList();
    return NewsListState(
      items: shown,
      hasMore: shown.length < _latest.length || _latest.length >= NewsRepository.cacheLimit,
    );
  }

  /// Pull-to-refresh: skips the cache. Throws when the reload fails; the
  /// list already on screen is kept.
  Future<void> refresh() async {
    final latest = await ref.read(newsRepositoryProvider).fetchLatest(forceRefresh: true);
    if (!ref.mounted) return;
    state = AsyncData(_firstPage(latest));
    ref
      ..invalidate(latestNewsProvider)
      ..invalidate(recentNewsCountProvider);
  }

  /// Appends the next page. [retry] is the footer button after a failure.
  Future<void> loadMore({bool retry = false}) async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;
    if (current.items.length < _latest.length) {
      state = AsyncData(_reveal(current.items.length + AppConst.pageSize));
      return;
    }
    if (current.loadMoreFailed && !retry) return;
    state = AsyncData(current.copyWith(loadingMore: true, loadMoreFailed: false));
    final generation = _generation;
    final List<News> page;
    try {
      page = await ref.read(newsRepositoryProvider).fetchMore(current.items.length);
    } catch (_) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(current.copyWith(loadingMore: false, loadMoreFailed: true));
      return;
    }
    if (!ref.mounted || generation != _generation) return;
    // Articles published meanwhile push rows down a page: skip repeats.
    final known = current.items.map((n) => n.id).toSet();
    state = AsyncData(
      NewsListState(
        items: [...current.items, ...page.where((n) => known.add(n.id))],
        hasMore: page.length >= AppConst.pageSize,
      ),
    );
  }
}

final newsListProvider = AsyncNotifierProvider.autoDispose<NewsListController, NewsListState>(
  NewsListController.new,
);

/// One article by id — works for deep links, not only from the list.
final newsByIdProvider = FutureProvider.autoDispose.family<News, int>(
  (ref, id) => ref.watch(newsRepositoryProvider).fetchById(id),
);
