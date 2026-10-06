import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Order / crop-registration / complaint status strings as stored in the
/// database (spec §6.2). Parsing is tolerant so a new admin value never
/// crashes the app.
enum AppStatus {
  pending,
  approved,
  confirmed,
  shipped,
  delivered,
  cancelled,
  rejected,
  open,
  replied,
  closed,
  unknown;

  static AppStatus fromDb(String? value) {
    final v = value?.trim().toLowerCase() ?? '';
    return switch (v) {
      'pending' => pending,
      'approved' => approved,
      'confirmed' => confirmed,
      'shipped' => shipped,
      'delivered' => delivered,
      'cancelled' || 'canceled' => cancelled,
      'rejected' => rejected,
      'open' => open,
      'replied' => replied,
      'closed' || 'resolved' => closed,
      _ => unknown,
    };
  }

  Color get color => switch (this) {
    pending || open => AppColors.orange500,
    approved || confirmed || delivered || replied => AppColors.green600,
    shipped => AppColors.blue600,
    cancelled || rejected => AppColors.red600,
    closed || unknown => AppColors.ink500,
  };

  IconData get icon => switch (this) {
    pending || open => Icons.schedule_rounded,
    approved || confirmed => Icons.check_circle_outline_rounded,
    shipped => Icons.local_shipping_outlined,
    delivered => Icons.inventory_2_outlined,
    cancelled || rejected => Icons.cancel_outlined,
    replied => Icons.mark_chat_read_outlined,
    closed => Icons.lock_outline_rounded,
    unknown => Icons.help_outline_rounded,
  };

  /// Localized label; [raw] is shown as-is for values the app doesn't know.
  String label(AppLocalizations l10n, [String? raw]) => switch (this) {
    pending => l10n.statusPending,
    approved => l10n.statusApproved,
    confirmed => l10n.statusConfirmed,
    shipped => l10n.statusShipped,
    delivered => l10n.statusDelivered,
    cancelled => l10n.statusCancelled,
    rejected => l10n.statusRejected,
    open => l10n.statusOpen,
    replied => l10n.statusReplied,
    closed => l10n.statusClosed,
    unknown => (raw == null || raw.trim().isEmpty) ? l10n.statusUnknown : raw,
  };
}

/// How full a crop's national quota is (spec §13.2).
enum SurplusLevel {
  low,
  medium,
  high,
  full;

  /// `< 60%` low, `60–85%` medium, `85–100%` high, `≥ 100%` full. The two
  /// thresholds can be overridden from `app_config`.
  static SurplusLevel fromRatio(double ratio, {double medium = 0.6, double high = 0.85}) {
    if (ratio >= 1) return full;
    if (ratio >= high) return SurplusLevel.high;
    if (ratio >= medium) return SurplusLevel.medium;
    return low;
  }

  Color get color => switch (this) {
    low => AppColors.surplusLow,
    medium => AppColors.surplusMedium,
    high => AppColors.surplusHigh,
    full => AppColors.surplusFull,
  };

  String label(AppLocalizations l10n) => switch (this) {
    low => l10n.surplusLow,
    medium => l10n.surplusMedium,
    high => l10n.surplusHigh,
    full => l10n.surplusFull,
  };
}
