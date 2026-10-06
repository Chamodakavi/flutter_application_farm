import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/product_repository.dart';

/// What the product grid is showing: a category chip and the search text.
/// It is the argument of the products provider family, so each combination
/// keeps its own pages.
@immutable
class ProductFilter {
  const ProductFilter({this.category, this.query = ''});

  /// Database value of `products.category`; null means "All".
  final String? category;

  /// Search text, matched against the product name.
  final String query;

  ProductFilter withCategory(String? value) => ProductFilter(category: value, query: query);

  ProductFilter withQuery(String value) => ProductFilter(category: category, query: value.trim());

  @override
  bool operator ==(Object other) =>
      other is ProductFilter && other.category == category && other.query == query;

  @override
  int get hashCode => Object.hash(category, query);
}

/// Category chips, derived from the data (spec §11.13).
final productCategoriesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(productRepositoryProvider).categories(),
);

/// Localized name for the categories the app knows; categories added later
/// by an admin are shown as stored.
String productCategoryLabel(AppLocalizations l10n, String category) =>
    switch (category.trim().toLowerCase()) {
      'seeds' => l10n.marketCategorySeeds,
      'tools' => l10n.marketCategoryTools,
      _ => category,
    };
