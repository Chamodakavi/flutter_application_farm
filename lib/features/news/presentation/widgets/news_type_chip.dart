import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/widgets.dart';

/// Localized label for a `news.n_type` value. Types added later by an admin
/// are shown as stored (spec §6.2).
String newsTypeLabel(AppLocalizations l10n, String? type) {
  final raw = type?.trim() ?? '';
  return switch (raw.toLowerCase()) {
    '' || 'general' => l10n.newsTypeGeneral,
    'technology' => l10n.newsTypeTechnology,
    'alert' => l10n.newsTypeAlert,
    'disease' => l10n.newsTypeDisease,
    'market' => l10n.newsTypeMarket,
    _ => raw,
  };
}

/// Black pill with the news type.
class NewsTypeChip extends StatelessWidget {
  const NewsTypeChip(this.type, {super.key});

  /// Raw database value.
  final String? type;

  @override
  Widget build(BuildContext context) => TypeBadge(newsTypeLabel(context.l10n, type), dark: true);
}
