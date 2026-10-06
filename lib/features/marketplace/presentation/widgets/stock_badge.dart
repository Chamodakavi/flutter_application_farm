import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// "In Stock: 12" in grey, or a red "Out of stock" chip (spec §11.13).
class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (stock <= 0) return TagChip(l10n.productOutOfStock, color: AppColors.red600);
    return Text(
      l10n.productInStock('$stock'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
