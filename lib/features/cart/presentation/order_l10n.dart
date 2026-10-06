import '../../../core/utils/app_status.dart';
import '../../../l10n/app_localizations.dart';

extension OrderL10n on AppLocalizations {
  /// One sentence explaining an order status to the farmer (spec §11.17) —
  /// the detail sheet's status panel and the body of status notifications.
  String orderStatusMessage(AppStatus status) => switch (status) {
    AppStatus.pending => orderWaitingReview,
    AppStatus.approved || AppStatus.confirmed => orderStatusApprovedMessage,
    AppStatus.shipped => orderStatusShippedMessage,
    AppStatus.delivered => orderStatusDeliveredMessage,
    AppStatus.cancelled => orderStatusCancelledMessage,
    AppStatus.rejected => orderStatusRejectedMessage,
    _ => orderStatusOtherMessage,
  };
}
