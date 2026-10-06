import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/product_filter_provider.dart';

/// Horizontal filter chips: "All" followed by the categories found in the
/// data (spec §11.13).
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  /// Database values of `products.category`.
  final List<String> categories;

  /// The active category, or null for "All".
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    // A category from a link that the data does not (yet) list still gets a
    // chip, so the user can see and clear it.
    final all = [
      ...categories,
      if (selected != null && !categories.contains(selected)) selected!,
    ];

    Widget chip(String label, String? value) {
      final active = value == selected;
      return Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          showCheckmark: false,
          labelStyle: text.labelMedium?.copyWith(
            color: active ? AppColors.white : AppColors.forest900,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          onSelected: (_) => onSelected(value),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          chip(l10n.marketCategoryAll, null),
          for (final category in all) chip(productCategoryLabel(l10n, category), category),
        ],
      ),
    );
  }
}
