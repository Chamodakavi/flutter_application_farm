// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get authWelcomeBack => 'FarmFriend වෙත නැවත සාදරයෙන් පිළිගනිමු';

  @override
  String get authSignIn => 'පිවිසෙන්න';

  @override
  String get authSignOut => 'ඉවත් වන්න';

  @override
  String get authEmail => 'ඊමේල්';

  @override
  String get authPassword => 'මුරපදය';

  @override
  String get authForgot => 'මුරපදය අමතකද?';

  @override
  String get authGoogle => 'Google සමඟ ඉදිරියට';

  @override
  String get authPhone => 'දුරකථන අංකයෙන් ඉදිරියට';

  @override
  String get authNewHere => 'අලුත්ද?';

  @override
  String get authCreateAccount => 'ගිණුමක් සාදන්න';

  @override
  String get authCreateTitle => 'ඔබේ ගිණුම සාදන්න';

  @override
  String get authFullName => 'සම්පූර්ණ නම';

  @override
  String get authConfirmPassword => 'මුරපදය තහවුරු කරන්න';

  @override
  String get authAgreeTerms => 'මම නියම සහ රහස්‍යතා ප්‍රතිපත්තියට එකඟ වෙමි';

  @override
  String get authAgreeRequired => 'ඉදිරියට යාමට නියමවලට එකඟ වන්න.';

  @override
  String get authHaveAccount => 'දැනටමත් ගිණුමක් තිබේද?';

  @override
  String get authSignInInstead => 'ඒ වෙනුවට පිවිසෙන්න';

  @override
  String get authCheckEmailTitle => 'ඔබේ ඊමේල් බලන්න';

  @override
  String authCheckEmailBody(String email) {
    return 'අපි $email වෙත තහවුරු කිරීමේ සබැඳියක් යැව්වා. ගිණුම සක්‍රිය කිරීමට එය විවෘත කර, පසුව පිවිසෙන්න.';
  }

  @override
  String get authOpenEmailApp => 'ඊමේල් යෙදුම විවෘත කරන්න';

  @override
  String get authBackToLogin => 'පිවිසුමට ආපසු';

  @override
  String get authForgotTitle => 'මුරපදය යළි සකසන්න';

  @override
  String get authForgotBody => 'ඔබේ ඊමේල් ඇතුළත් කරන්න. නව මුරපදයක් තේරීමට සබැඳියක් අපි එවන්නෙමු.';

  @override
  String get authSendResetLink => 'යළි සැකසීමේ සබැඳිය යවන්න';

  @override
  String authResetSent(String email) {
    return '$email සඳහා ගිණුමක් තිබේ නම්, යළි සැකසීමේ සබැඳියක් එවනු ලැබේ. එය මෙම දුරකථනයෙන් විවෘත කරන්න.';
  }

  @override
  String get authResetTitle => 'නව මුරපදයක් තෝරන්න';

  @override
  String get authResetNeedsLink =>
      'නව මුරපදයක් තේරීමට, ඔබේ ඊමේල් එකේ ඇති සබැඳිය මෙම දුරකථනයෙන් විවෘත කරන්න.';

  @override
  String get authNewPassword => 'නව මුරපදය';

  @override
  String get authSavePassword => 'මුරපදය සුරකින්න';

  @override
  String get authPasswordUpdated => 'මුරපදය යාවත්කාලීන විය. නව මුරපදයෙන් පිවිසෙන්න.';

  @override
  String get authPhoneTitle => 'ඔබේ දුරකථනයෙන් පිවිසෙන්න';

  @override
  String get authPhoneBody => 'අපි මෙම අංකයට SMS මගින් ඉලක්කම් 6ක කේතයක් එවන්නෙමු.';

  @override
  String get authPhoneNumber => 'ජංගම දුරකථන අංකය';

  @override
  String get authSendCode => 'කේතය යවන්න';

  @override
  String get authOtpTitle => 'කේතය ඇතුළත් කරන්න';

  @override
  String authOtpBody(String phone) {
    return 'අපි $phone වෙත ඉලක්කම් 6ක කේතයක් යැව්වා.';
  }

  @override
  String get authVerify => 'තහවුරු කරන්න';

  @override
  String authResendIn(int seconds) {
    return 'තත්පර $secondsකින් කේතය නැවත යවන්න';
  }

  @override
  String get authResend => 'කේතය නැවත යවන්න';

  @override
  String get authCodeSent => 'නව කේතයක් යවන ලදී.';

  @override
  String get authChangeNumber => 'අංකය වෙනස් කරන්න';

  @override
  String get authResendLimit => 'කේත ඉල්ලීම් වැඩියි. මිනිත්තු කිහිපයකින් නැවත උත්සාහ කරන්න.';

  @override
  String get splashGettingReady => 'සූදානම් කරමින්…';

  @override
  String get splashProfileError => 'ඔබේ පැතිකඩ පූරණය කළ නොහැකි විය.';

  @override
  String get onboarding1Title => 'වගා කිරීමට පෙර සැලසුම් කරන්න';

  @override
  String get onboarding1Body =>
      'කුමක් වගා කළ යුතුදැයි තීරණය කිරීමට පෙර, රටට එක් එක් බෝගයෙන් කොපමණ අවශ්‍යද සහ දැනටමත් කොපමණ ලියාපදිංචි වී ඇත්දැයි බලන්න.';

  @override
  String get onboarding2Title => 'සාධාරණ මිල, අඩු අපතේ යාම';

  @override
  String get onboarding2Body =>
      'ඔබේ අස්වැන්න සාධාරණ මිලකට විකිණීමට, පුරෝකථන මිල සහ අස්වනු නෙළීමට හොඳම මාසය බලන්න.';

  @override
  String get onboarding3Title => 'වෙළඳපොළ, ප්‍රජාව සහ AgriBot';

  @override
  String get onboarding3Body =>
      'බීජ සහ උපකරණ මිලදී ගන්න, අනෙක් ගොවීන් සමඟ බෙදාගන්න, ඔබේම භාෂාවෙන් AgriBot ගෙන් ඕනෑම දෙයක් අසන්න.';

  @override
  String get onboardingGetStarted => 'ආරම්භ කරන්න';

  @override
  String get profileCompleteTitle => 'ඔබේ පැතිකඩ සම්පූර්ණ කරන්න';

  @override
  String get profileCompleteSubtitle => 'ආරම්භ කිරීමට පෙර අපට තොරතුරු කිහිපයක් අවශ්‍යයි.';

  @override
  String get profileName => 'නම';

  @override
  String get profileSurname => 'වාසගම';

  @override
  String get profileEmail => 'ඊමේල්';

  @override
  String get profileEmailReadOnly => 'ඊමේල් මෙහිදී වෙනස් කළ නොහැක.';

  @override
  String get profileTelephone => 'දුරකථන අංකය';

  @override
  String get profileType => 'වර්ගය';

  @override
  String get profileSelectType => 'වර්ගය තෝරන්න';

  @override
  String get profileDistrict => 'දිස්ත්‍රික්කය';

  @override
  String get profileSelectDistrict => 'දිස්ත්‍රික්කය තෝරන්න';

  @override
  String get profileSaveContinue => 'සුරකින්න සහ ඉදිරියට';

  @override
  String get profileTypeFarmer => 'ගොවියා';

  @override
  String get profileTypeBuyer => 'ගැනුම්කරු';

  @override
  String get profileTypeOfficer => 'කෘෂිකර්ම නිලධාරී';

  @override
  String get profileAddPhoto => 'ඡායාරූපයක් එක් කරන්න';

  @override
  String get profileChangePhoto => 'ඡායාරූපය වෙනස් කරන්න';

  @override
  String get profilePhotoGallery => 'ගැලරියෙන් තෝරන්න';

  @override
  String get profilePhotoCamera => 'ඡායාරූපයක් ගන්න';

  @override
  String get maintenanceBody =>
      'FarmFriend යාවත්කාලීන වෙමින් පවතී. ටික වේලාවකින් නැවත උත්සාහ කරන්න.';

  @override
  String get cartTitle => 'සාප්පු කරත්තය';

  @override
  String get cartSubtitle => 'ඔබේ කරත්තය පරීක්ෂා කර, යොමු කළ ඇණවුම් ගැන දැනගන්න.';

  @override
  String get cartCashOnDelivery => 'භාරදීමේදී මුදල් ගෙවීම';

  @override
  String get cartAdded => 'කරත්තයට එක් කළා';

  @override
  String get cartViewCart => 'කරත්තය බලන්න';

  @override
  String get cartEmptyTitle => 'ඔබේ කරත්තය හිස්ය';

  @override
  String get cartEmptyMessage =>
      'ඔබේ කරත්තයේ කිසිවක් නැත. භාණ්ඩ බලන්න, නැතහොත් පහතින් ඔබේ ඇණවුම් ඉතිහාසය බලන්න.';

  @override
  String get cartStartShopping => 'මිලදී ගැනීම අරඹන්න';

  @override
  String cartUnitPrice(String price) {
    return 'එකක් $price';
  }

  @override
  String get cartRemove => 'කරත්තයෙන් ඉවත් කරන්න';

  @override
  String cartRemoved(String name) {
    return '$name කරත්තයෙන් ඉවත් කළා';
  }

  @override
  String cartOnlyLeft(String count) {
    return 'තොගයේ ඇත්තේ $countක් පමණි. ප්‍රමාණය අඩු කරන්න.';
  }

  @override
  String get cartLineOutOfStock => 'මෙම භාණ්ඩය තොගයේ නැත. ඉදිරියට යාමට එය ඉවත් කරන්න.';

  @override
  String get cartSummaryTitle => 'ඇණවුම් සාරාංශය';

  @override
  String get cartSubtotal => 'උප එකතුව';

  @override
  String get cartShipping => 'ප්‍රවාහන ගාස්තුව';

  @override
  String get cartTotal => 'මුළු එකතුව';

  @override
  String get cartPayment => 'ගෙවීම';

  @override
  String get cartEstimateNote => 'මේවා ඇස්තමේන්තු මුදල්ය. ඇණවුම යොමු කරන විට අවසාන මුදල තහවුරු වේ.';

  @override
  String get cartFixStock =>
      'සමහර භාණ්ඩවල ප්‍රමාණය තොගයට වඩා වැඩිය. ඉදිරියට යාමට ඒවා නිවැරදි කරන්න.';

  @override
  String get cartCheckout => 'ඇණවුම් කිරීමට ඉදිරියට යන්න';

  @override
  String get checkoutTitle => 'ඇණවුම තහවුරු කිරීම';

  @override
  String get checkoutContactTitle => 'භාරදීමේ සම්බන්ධතා තොරතුරු';

  @override
  String get checkoutName => 'නම';

  @override
  String get checkoutPhone => 'දුරකථන අංකය';

  @override
  String get checkoutPhoneHelper => 'භාරදීම ගැන අපි මෙම අංකයට අමතන්නෙමු.';

  @override
  String get checkoutDistrict => 'දිස්ත්‍රික්කය';

  @override
  String get checkoutPaymentTitle => 'ගෙවීම් ක්‍රමය';

  @override
  String get checkoutCodHint => 'ඇණවුම ලැබුණු විට මුදලින් ගෙවන්න.';

  @override
  String get checkoutSummaryTitle => 'ඇණවුම් සාරාංශය';

  @override
  String checkoutLine(String name, String qty) {
    return '$name × $qty';
  }

  @override
  String get checkoutReviewNote =>
      'ඔබ ඇණවුම යොමු කළ පසු පරිපාලකයෙක් එය පරීක්ෂා කරයි. එය අපේක්ෂිත තත්ත්වයේ ඇති තෙක් ඔබට අවලංගු කළ හැක.';

  @override
  String get checkoutPlaceOrder => 'ඇණවුම යොමු කරන්න';

  @override
  String get checkoutEmptyCart => 'ඔබේ කරත්තය හිස්ය. ඇණවුම් කිරීමට පෙර භාණ්ඩ එක් කරන්න.';

  @override
  String get checkoutFailed => 'ඔබේ ඇණවුම යොමු කළ නොහැකි විය. නැවත උත්සාහ කරන්න.';

  @override
  String get checkoutStockTitle => 'තොගය ප්‍රමාණවත් නැත';

  @override
  String checkoutStockMessage(String name, String available) {
    return '\"$name\" තොගයේ ඇත්තේ $availableක් පමණි. කරත්තයේ ප්‍රමාණය අඩු කර නැවත උත්සාහ කරන්න.';
  }

  @override
  String checkoutStockNone(String name) {
    return '\"$name\" තොගයේ නැත. එය කරත්තයෙන් ඉවත් කර නැවත උත්සාහ කරන්න.';
  }

  @override
  String get checkoutStockGeneric =>
      'ඔබේ කරත්තයේ ඇති භාණ්ඩයක තොගය ප්‍රමාණවත් නැත. කරත්තය යාවත්කාලීන කර නැවත උත්සාහ කරන්න.';

  @override
  String get checkoutUpdateCart => 'කරත්තය යාවත්කාලීන කරන්න';

  @override
  String get orderMyOrders => 'මගේ ඇණවුම්';

  @override
  String orderNumber(String id) {
    return 'ඇණවුම #$id';
  }

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'භාණ්ඩ $count',
      one: 'භාණ්ඩ 1',
      zero: 'භාණ්ඩ නැත',
    );
    return '$_temp0';
  }

  @override
  String orderPlacedOn(String date) {
    return 'ඇණවුම් කළේ $date';
  }

  @override
  String orderTotalLine(String total) {
    return 'මුළු එකතුව: $total';
  }

  @override
  String get orderItemsTitle => 'භාණ්ඩ';

  @override
  String get orderItemsUnavailable => 'භාණ්ඩ විස්තර ලබාගත නොහැක.';

  @override
  String orderItemQty(String qty, String price) {
    return 'ප්‍රමාණය: $qty × $price';
  }

  @override
  String get orderAdminNote => 'පරිපාලකගේ සටහන';

  @override
  String get orderCancel => 'ඇණවුම අවලංගු කරන්න';

  @override
  String get orderCancelConfirmTitle => 'මෙම ඇණවුම අවලංගු කරන්නද?';

  @override
  String orderCancelConfirmMessage(String id) {
    return 'ඇණවුම #$id අවලංගු වේ. මෙය ආපසු හැරවිය නොහැක.';
  }

  @override
  String get orderCancelConfirmYes => 'ඔව්, අවලංගු කරන්න';

  @override
  String get orderCancelConfirmNo => 'ඇණවුම තබාගන්න';

  @override
  String get orderCancelled => 'ඔබේ ඇණවුම අවලංගු කළා.';

  @override
  String get orderCancelNotCancellable =>
      'මෙම ඇණවුම දැනටමත් සකසා ඇති නිසා තවදුරටත් අවලංගු කළ නොහැක.';

  @override
  String get orderWaitingReview => 'ඔබේ ඇණවුම පරිපාලක සමාලෝචනය සඳහා රැඳී ඇත.';

  @override
  String get orderStatusApprovedMessage => 'ඔබේ ඇණවුම අනුමත කර ඇත. එය සූදානම් කරමින් පවතී.';

  @override
  String get orderStatusShippedMessage => 'ඔබේ ඇණවුම ඔබ වෙත එමින් පවතී.';

  @override
  String get orderStatusDeliveredMessage => 'ඔබේ ඇණවුම භාර දී ඇත. ස්තූතියි!';

  @override
  String get orderStatusCancelledMessage => 'මෙම ඇණවුම අවලංගු කර ඇත.';

  @override
  String get orderStatusRejectedMessage =>
      'මෙම ඇණවුම පිළිගෙන නැත. පරිපාලකගේ සටහන බලන්න, නැතහොත් සහාය අමතන්න.';

  @override
  String get orderStatusOtherMessage => 'මෙම ඇණවුමේ තත්ත්වය යාවත්කාලීන විය.';

  @override
  String orderNotifyTitle(String id, String status) {
    return 'ඇණවුම #$id: $status';
  }

  @override
  String get orderEmptyTitle => 'තවම ඇණවුම් නැත';

  @override
  String get orderEmptyMessage => 'ඔබ යොමු කරන ඇණවුම් මෙහි දිස්වේ.';

  @override
  String get orderNotFound => 'එම ඇණවුම සොයාගත නොහැකි විය.';

  @override
  String get orderSuccessTitle => 'ඇණවුම යොමු කළා';

  @override
  String get orderSuccessHeading => 'ස්තූතියි! ඔබේ ඇණවුම ලැබුණා.';

  @override
  String get orderSuccessMessage => 'ඔබේ ඇණවුම අපට ලැබී ඇත. භාණ්ඩ ලැබුණු විට මුදලින් ගෙවන්න.';

  @override
  String get orderSuccessNumber => 'ඇණවුම් අංකය';

  @override
  String get orderViewMyOrders => 'මගේ ඇණවුම් බලන්න';

  @override
  String get orderContinueShopping => 'තවත් මිලදී ගන්න';

  @override
  String get chatTitle => 'AgriBot';

  @override
  String get chatSubtitle => 'FarmFriend සහායක';

  @override
  String get chatOnline => 'සබැඳි';

  @override
  String get chatOffline => 'නොබැඳි';

  @override
  String chatLanguageTooltip(String language) {
    return 'AgriBot $language භාෂාවෙන් පිළිතුරු දෙයි. වෙනස් කිරීමට තට්ටු කරන්න.';
  }

  @override
  String get chatDisclaimer =>
      'AgriBot ට වැරදි සිදුවිය හැක. වැදගත් තීරණ ඔබගේ කෘෂි නිලධාරියා සමඟ තහවුරු කරගන්න.';

  @override
  String get chatEmptyTitle => 'අද මම ඔබට කෙසේ උදව් කරන්නද?';

  @override
  String get chatEmptyMessage => 'බෝග, මිල ගණන්, බීජ හෝ ශාක රෝග ගැන අසන්න.';

  @override
  String get chatSuggestionCrop => 'ලබන මාසයේ මා වගා කළ යුත්තේ කුමන බෝගයද?';

  @override
  String get chatSuggestionPrice => 'මේ මාසයේ කැරට් මිල කීයද?';

  @override
  String get chatSuggestionSeeds => 'වෙළඳපොළේ ඇති බීජ මොනවාද?';

  @override
  String get chatSuggestionDisease => 'මිරිස් කොළ කොඩවීම පාලනය කරන්නේ කෙසේද?';

  @override
  String get chatInputHint => 'ඔබේ ප්‍රශ්නය ටයිප් කරන්න…';

  @override
  String get chatSend => 'යවන්න';

  @override
  String get chatSending => 'යවමින්…';

  @override
  String get chatFailedRetry => 'යැවුණේ නැත. නැවත යැවීමට තට්ටු කරන්න';

  @override
  String get chatRateLimited => 'ප්‍රශ්න වැඩියි — කරුණාකර විනාඩියක් රැඳී සිටින්න.';

  @override
  String get chatTyping => 'AgriBot ලියමින් සිටී…';

  @override
  String get chatClear => 'කතාබහ මකන්න';

  @override
  String get chatClearTitle => 'මෙම කතාබහ මකන්නද?';

  @override
  String get chatClearMessage => 'මෙම දුරකථනයේ සුරකින ලද පණිවිඩ ඉවත් කෙරේ.';

  @override
  String get chatClearConfirm => 'මකන්න';

  @override
  String get chatLoadEarlier => 'පැරණි පණිවිඩ පෙන්වන්න';

  @override
  String get chatMicHold => 'කතා කිරීමට ඔබාගෙන සිටින්න';

  @override
  String get chatMicListening => 'අසමින් සිටී… අවසන් වූ පසු අතහරින්න';

  @override
  String get chatMicUnavailable => 'මෙම දුරකථනයේ මෙම භාෂාවෙන් හඬ ආදානය ලබාගත නොහැක.';

  @override
  String get chatMicFailed =>
      'මයික්‍රෆෝනය ආරම්භ කළ නොහැකි විය. මයික්‍රෆෝන අවසරය දී නැවත උත්සාහ කරන්න.';

  @override
  String get chatSpeak => 'ශබ්ද නඟා කියවන්න';

  @override
  String get chatStopSpeaking => 'කියවීම නවත්වන්න';

  @override
  String get appName => 'FarmFriend';

  @override
  String get navHome => 'මුල් පිටුව';

  @override
  String get navMarket => 'වෙළඳපොළ';

  @override
  String get navRegister => 'ලියාපදිංචිය';

  @override
  String get navCommunity => 'ප්‍රජාව';

  @override
  String get navMore => 'තවත්';

  @override
  String get commonRetry => 'නැවත උත්සාහ කරන්න';

  @override
  String get commonOffline => 'ඔබ නොබැඳි තත්ත්වයේ සිටී. සුරකින ලද දත්ත පෙන්වයි.';

  @override
  String get commonRequiresInternet => 'මෙය කිරීමට අන්තර්ජාලයට සම්බන්ධ වන්න.';

  @override
  String get commonCancel => 'අවලංගු කරන්න';

  @override
  String get commonConfirm => 'තහවුරු කරන්න';

  @override
  String get commonSave => 'සුරකින්න';

  @override
  String get commonDelete => 'මකන්න';

  @override
  String get commonEdit => 'සංස්කරණය';

  @override
  String get commonClose => 'වසන්න';

  @override
  String get commonDone => 'හරි';

  @override
  String get commonContinue => 'ඉදිරියට';

  @override
  String get commonBack => 'ආපසු';

  @override
  String get commonNext => 'ඊළඟ';

  @override
  String get commonSkip => 'මඟ හරින්න';

  @override
  String get commonSearch => 'සොයන්න';

  @override
  String get commonSeeAll => 'සියල්ල බලන්න';

  @override
  String get commonViewAll => 'සියල්ල බලන්න';

  @override
  String get commonLoading => 'පූරණය වෙමින්…';

  @override
  String get commonYes => 'ඔව්';

  @override
  String get commonNo => 'නැහැ';

  @override
  String get commonOk => 'හරි';

  @override
  String get commonOr => 'හෝ';

  @override
  String get commonOptional => 'අත්‍යවශ්‍ය නොවේ';

  @override
  String get commonSelect => 'තෝරන්න';

  @override
  String get commonUndo => 'පෙර තත්ත්වයට';

  @override
  String get commonNoResults => 'ප්‍රතිඵල හමු නොවීය';

  @override
  String get commonNothingHere => 'තවම මෙහි කිසිවක් නැත';

  @override
  String get commonJustNow => 'මේ දැන්';

  @override
  String commonMinutesAgo(int count) {
    return 'මිනිත්තු $countකට පෙර';
  }

  @override
  String commonHoursAgo(int count) {
    return 'පැය $countකට පෙර';
  }

  @override
  String commonDaysAgo(int count) {
    return 'දින $countකට පෙර';
  }

  @override
  String commonUpdatedAgo(String time) {
    return 'යාවත්කාලීන කළේ $time';
  }

  @override
  String get commonMt => 'මෙ.ටො.';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'වාර්තා $count',
      zero: 'වාර්තා නැත',
    );
    return '$_temp0';
  }

  @override
  String get appBarCart => 'කරත්තය';

  @override
  String get appBarNotifications => 'දැනුම්දීම්';

  @override
  String get appBarProfile => 'පැතිකඩ සහ සැකසුම්';

  @override
  String get chatFabTooltip => 'AgriBot ගෙන් අසන්න';

  @override
  String get languageSwitch => 'භාෂාව වෙනස් කරන්න';

  @override
  String get errorTitle => 'යම් දෝෂයක් ඇති විය';

  @override
  String get errorNetwork => 'අන්තර්ජාල සම්බන්ධතාවක් නැත. ජාලය පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get errorPermission => 'මෙය කිරීමට ඔබට අවසර නැත.';

  @override
  String get errorNotFound => 'ඔබ සොයන දෙය හමු නොවීය.';

  @override
  String get errorConflict => 'මෙය දැනටමත් සිදු කර ඇත හෝ වෙනස් වී ඇත. නැවුම් කර නැවත උත්සාහ කරන්න.';

  @override
  String get errorRateLimited => 'ඉල්ලීම් වැඩියි. මිනිත්තුවක් රැඳී නැවත උත්සාහ කරන්න.';

  @override
  String get errorValidation => 'ඔබ ඇතුළත් කළ තොරතුරු පරීක්ෂා කරන්න.';

  @override
  String get errorSessionExpired => 'ඔබේ සැසිය කල් ඉකුත් වී ඇත. නැවත පිවිසෙන්න.';

  @override
  String get errorUnknown => 'යම් දෝෂයක් ඇති විය. නැවත උත්සාහ කරන්න.';

  @override
  String get errorPageNotFound => 'මෙම පිටුව නොපවතී.';

  @override
  String get errorGoHome => 'මුල් පිටුවට යන්න';

  @override
  String get authInvalidCredentials => 'පිවිසුම් තොරතුරු වැරදියි';

  @override
  String get authEmailNotConfirmed =>
      'කරුණාකර පළමුව ඔබේ ඊමේල් තහවුරු කරන්න. සබැඳිය සඳහා ඔබේ එන ලිපි බලන්න.';

  @override
  String get authUserExists => 'මෙම ඊමේල් දැනටමත් ලියාපදිංචි කර ඇත. ඒ වෙනුවට පිවිසෙන්න.';

  @override
  String get authWeakPassword =>
      'මුරපදය දුර්වලයි. අකුරක් සහ අංකයක් සහිත අක්ෂර 8ක් වත් භාවිත කරන්න.';

  @override
  String get authSamePassword => 'නව මුරපදය පැරණි එකට වඩා වෙනස් විය යුතුය.';

  @override
  String get authWrongPassword => 'ඔබේ වත්මන් මුරපදය වැරදියි.';

  @override
  String get authOtpExpired => 'කේතය කල් ඉකුත් වී ඇත, නව එකක් යවන්න.';

  @override
  String get authOtpInvalid => 'එම කේතය නිවැරදි නැත. නැවත උත්සාහ කරන්න.';

  @override
  String get authRateLimited => 'උත්සාහයන් වැඩියි, පසුව නැවත උත්සාහ කරන්න.';

  @override
  String get authGoogleFailed => 'Google පිවිසුම අසාර්ථක විය. නැවත උත්සාහ කරන්න.';

  @override
  String get validationRequired => 'මෙම ක්ෂේත්‍රය අවශ්‍යයි';

  @override
  String get validationEmail => 'වලංගු ඊමේල් ලිපිනයක් ඇතුළත් කරන්න';

  @override
  String get validationPassword => 'අකුරක් සහ අංකයක් සහිත අක්ෂර 8ක් වත් භාවිත කරන්න';

  @override
  String get validationPasswordMismatch => 'මුරපද නොගැළපේ';

  @override
  String get validationPhone => 'වලංගු ජංගම දුරකථන අංකයක් ඇතුළත් කරන්න (7XXXXXXXX)';

  @override
  String get validationAmount => 'දශම ස්ථාන 2ක් දක්වා, 0ට වැඩි ප්‍රමාණයක් ඇතුළත් කරන්න';

  @override
  String validationTooLong(int max) {
    return 'උපරිම අක්ෂර $maxක් භාවිත කරන්න';
  }

  @override
  String get statusPending => 'අපේක්ෂිත';

  @override
  String get statusApproved => 'අනුමතයි';

  @override
  String get statusConfirmed => 'තහවුරුයි';

  @override
  String get statusShipped => 'යවා ඇත';

  @override
  String get statusDelivered => 'භාර දී ඇත';

  @override
  String get statusCancelled => 'අවලංගුයි';

  @override
  String get statusRejected => 'ප්‍රතික්ෂේපිතයි';

  @override
  String get statusOpen => 'විවෘතයි';

  @override
  String get statusReplied => 'පිළිතුරු දී ඇත';

  @override
  String get statusClosed => 'වසා ඇත';

  @override
  String get statusUnknown => 'නොදනී';

  @override
  String get surplusLow => 'ඉඩ ඇත';

  @override
  String get surplusMedium => 'පිරෙමින් පවතී';

  @override
  String get surplusHigh => 'පිරීමට ආසන්නයි';

  @override
  String get surplusFull => 'පිරී ඇත';

  @override
  String quotaFilledOfLimit(String filled, String limit) {
    return 'මෙ.ටො. $limitන් $filledක් ලියාපදිංචියි';
  }

  @override
  String quotaRemaining(String remaining) {
    return 'මෙ.ටො. $remainingක් ඉතිරියි';
  }

  @override
  String get feedbackTitle => 'අපගේ සේවාව කෙසේද?';

  @override
  String get feedbackSubtitle =>
      'ඔබේ පිළිතුරු FarmFriend වැඩිදියුණු කිරීමට පර්යේෂණ කණ්ඩායමට උපකාරී වේ.';

  @override
  String get feedbackOverall => 'සමස්තයක් ලෙස';

  @override
  String get feedbackEase => 'භාවිතයට පහසුයි';

  @override
  String get feedbackUsefulness => 'මගේ ගොවිතැනට ප්‍රයෝජනවත්';

  @override
  String get feedbackComment => 'වෙනත් යමක් තිබේද? (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get feedbackSubmit => 'ප්‍රතිචාරය යවන්න';

  @override
  String get feedbackThanks => 'ඔබේ ප්‍රතිචාරයට ස්තුතියි!';

  @override
  String get updateRequiredTitle => 'යාවත්කාලීන කිරීම අවශ්‍යයි';

  @override
  String get updateRequiredBody => 'ඉදිරියට යාමට නව අනුවාදයක් අවශ්‍යයි.';

  @override
  String get updateButton => 'යාවත්කාලීන කරන්න';

  @override
  String get updateAvailable => 'යාවත්කාලීනයක් ඇත';

  @override
  String get maintenanceTitle => 'අපි ඉක්මනින් නැවත එන්නෙමු';

  @override
  String get adminBanner =>
      'ඔබ පරිපාලකයෙකි. ඉලක්ක, නිෂ්පාදන සහ පුවත් වෙබ් පරිපාලක පුවරුවෙන් කළමනාකරණය කරන්න.';

  @override
  String get adminBannerOpen => 'වෙබ් පුවරුව විවෘත කරන්න';

  @override
  String get communityWhatsOnMind => 'ඔබේ සිතේ ඇත්තේ කුමක්ද?';

  @override
  String get communityPhoto => 'ඡායාරූපය';

  @override
  String get communityActivity => 'ක්‍රියාකාරකම';

  @override
  String get communityPost => 'පළ කරන්න';

  @override
  String get communityLike => 'කැමතියි';

  @override
  String get communityComment => 'අදහස්';

  @override
  String get communityShare => 'බෙදාගන්න';

  @override
  String get communityMyPosts => 'මගේ පළකිරීම්';

  @override
  String get communitySavedPosts => 'සුරැකි පළකිරීම්';

  @override
  String communityMyPostsCount(String count) {
    return 'මගේ පළකිරීම් ($count)';
  }

  @override
  String communitySavedPostsCount(String count) {
    return 'සුරැකි පළකිරීම් ($count)';
  }

  @override
  String get communityEmptyTitle => 'තවම පළකිරීම් නැත';

  @override
  String get communityEmptyMessage => 'අනෙක් ගොවීන් සමඟ යමක් බෙදාගන්නා පළමු කෙනා වන්න.';

  @override
  String get communityEmptyAction => 'පළකිරීමක් සාදන්න';

  @override
  String get communityMyPostsEmptyTitle => 'ඔබ තවම කිසිවක් පළ කර නැත';

  @override
  String get communityMyPostsEmptyMessage => 'ඔබේ පළකිරීම් මෙහි පෙන්වනු ඇත.';

  @override
  String get communitySavedEmptyTitle => 'සුරැකි පළකිරීම් නැත';

  @override
  String get communitySavedEmptyMessage => 'පළකිරීමක් මෙහි තබා ගැනීමට එහි පොත් සලකුණ තට්ටු කරන්න.';

  @override
  String get communityLoadMore => 'තවත් පෙන්වන්න';

  @override
  String get communityLoadMoreFailed => 'තවත් පළකිරීම් ලබා ගත නොහැකි විය.';

  @override
  String get communityFarmer => 'ගොවියා';

  @override
  String get communitySave => 'පළකිරීම සුරකින්න';

  @override
  String get communityUnsave => 'සුරැකි ලැයිස්තුවෙන් ඉවත් කරන්න';

  @override
  String communityCommentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'අදහස් $count',
      one: 'අදහස් 1',
      zero: 'අදහස් නැත',
    );
    return '$_temp0';
  }

  @override
  String communityLikesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'කැමැත්ත $count',
      one: 'කැමැත්ත 1',
      zero: 'කැමැත්ත නැත',
    );
    return '$_temp0';
  }

  @override
  String get communitySeeMore => 'තව පෙන්වන්න';

  @override
  String get communitySeeLess => 'අඩුවෙන් පෙන්වන්න';

  @override
  String get communityMoreOptions => 'තවත් විකල්ප';

  @override
  String get communityReport => 'වාර්තා කරන්න';

  @override
  String communityReportSubject(String id) {
    return 'පළකිරීම #$id වාර්තා කිරීම';
  }

  @override
  String get communityDeleteTitle => 'මෙම පළකිරීම මකන්නද?';

  @override
  String get communityDeleteMessage => 'මෙය ආපසු හැරවිය නොහැක.';

  @override
  String get communityPostDeleted => 'පළකිරීම මකා දමන ලදී';

  @override
  String get communityViewPhoto => 'ඡායාරූපය බලන්න';

  @override
  String get communityActivityChoose => 'ඔබ කරන්නේ කුමක්ද?';

  @override
  String get communityActivityNone => 'ක්‍රියාකාරකමක් නැත';

  @override
  String get communityActivityPlanting => 'වගා කිරීම';

  @override
  String get communityActivityHarvesting => 'අස්වනු නෙළීම';

  @override
  String get communityActivitySelling => 'විකිණීම';

  @override
  String get communityActivityQuestion => 'ප්‍රශ්නය';

  @override
  String get postCreateTitle => 'පළකිරීමක් සාදන්න';

  @override
  String get postEditTitle => 'පළකිරීම සංස්කරණය';

  @override
  String get postDetailTitle => 'පළකිරීම';

  @override
  String get postGallery => 'ගැලරිය';

  @override
  String get postCamera => 'කැමරාව';

  @override
  String get postRemovePhoto => 'ඡායාරූපය ඉවත් කරන්න';

  @override
  String get postPhotoFailed =>
      'ඡායාරූපය විවෘත කළ නොහැකි විය. යෙදුමේ අවසර පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get postPublished => 'ඔබේ පළකිරීම පළ විය';

  @override
  String get postUpdated => 'පළකිරීම යාවත්කාලීන විය';

  @override
  String get postEditPhotoNote => 'වෙනස් කළ හැක්කේ පෙළ පමණි. ඡායාරූපය එලෙසම පවතී.';

  @override
  String get postNotYours => 'ඔබට සංස්කරණය කළ හැක්කේ ඔබේම පළකිරීම් පමණි.';

  @override
  String get postComments => 'අදහස්';

  @override
  String get postNoComments => 'තවම අදහස් නැත';

  @override
  String get postNoCommentsMessage => 'පළමු අදහස ඔබ දක්වන්න.';

  @override
  String get postCommentHint => 'අදහසක් ලියන්න…';

  @override
  String get postCommentSend => 'අදහස යවන්න';

  @override
  String get postCommentSending => 'යවමින්…';

  @override
  String get postCommentDeleteTitle => 'මෙම අදහස මකන්නද?';

  @override
  String get postCommentDeleted => 'අදහස මකා දමන ලදී';

  @override
  String get postCommentsLoadMore => 'තවත් අදහස් පෙන්වන්න';

  @override
  String get postCommentHoldToDelete => 'මැකීමට තද කර අල්ලාගෙන සිටින්න';

  @override
  String get homePill => 'ස්මාර්ට් ගොවිතැන් පුවරුව';

  @override
  String homeWelcome(String name) {
    return 'නැවත සාදරයෙන් පිළිගනිමු, $name';
  }

  @override
  String get homeFarmerFallback => 'ගොවි මහතා';

  @override
  String get homeHeroText =>
      'ඔබගේ බෝග ලියාපදිංචි කිරීම් බලන්න, වෙළඳපොළ නිෂ්පාදන සොයන්න, ගොවි පුවත් කියවන්න සහ AI සහායකයාගෙන් උදව් ලබාගන්න.';

  @override
  String get homeRegisterCrop => 'බෝගය ලියාපදිංචි කරන්න';

  @override
  String get homeMarketplace => 'වෙළඳපොළ';

  @override
  String get homeMyCrops => 'මගේ ලියාපදිංචි බෝග';

  @override
  String homeTotalMt(String amount) {
    return 'මුළු: මෙ.ටො. $amount';
  }

  @override
  String get homeMarketItems => 'වෙළඳපොළ භාණ්ඩ';

  @override
  String get homeProductsAvailable => 'දැන් ලබාගත හැකි නිෂ්පාදන';

  @override
  String get homeFarmingNews => 'ගොවි පුවත්';

  @override
  String get homeLatestUpdates => 'නවතම යාවත්කාලීන සහ අනතුරු ඇඟවීම්';

  @override
  String get homeCropOutlook => 'බෝග තත්ත්වය';

  @override
  String get homeCropOutlookSubtitle => 'එක් එක් බෝගයේ ජාතික කෝටාව පිරී ඇති ප්‍රමාණය';

  @override
  String homePercentFull(int percent) {
    return '$percent%ක් පිරී ඇත';
  }

  @override
  String get homeOutlookEmpty => 'දැනට සක්‍රිය බෝග ඉලක්ක නැත.';

  @override
  String get homePriceOutlook => 'මිල තත්ත්වය';

  @override
  String get homePriceOutlookSubtitle => 'මෙම මාසයේ තොග මිලෙහි විශාලතම වෙනස්වීම්';

  @override
  String get homePricesEmpty => 'මිල පුරෝකථන තවම ලබාගත නොහැක.';

  @override
  String get homeQuickActions => 'ඉක්මන් ක්‍රියා';

  @override
  String get homeActionRegister => 'අස්වැන්න ලියාපදිංචිය';

  @override
  String get homeActionRegisterSub => 'අපේක්ෂිත බෝග ප්‍රමාණය එක් කරන්න';

  @override
  String get homeActionPlan => 'ලාභය සැලසුම් කරන්න';

  @override
  String get homeActionPlanSub => 'වගා කිරීමට පෙර ආදායම බලන්න';

  @override
  String get homeActionBrowse => 'නිෂ්පාදන බලන්න';

  @override
  String get homeActionBrowseSub => 'බීජ සහ ගොවි උපකරණ මිලදී ගන්න';

  @override
  String get homeActionAsk => 'සහායකයාගෙන් අසන්න';

  @override
  String get homeActionAskSub => 'AgriBot ගෙන් උදව් ලබාගන්න';

  @override
  String get homeMyRegistrations => 'මගේ බෝග ලියාපදිංචි කිරීම්';

  @override
  String homeMtRegistered(String amount) {
    return 'මෙ.ටො. $amountක් ලියාපදිංචියි';
  }

  @override
  String get homeRegisterLink => 'ලියාපදිංචි වන්න';

  @override
  String get homeNoRegistrations => 'තවම බෝග ලියාපදිංචි කර නැත';

  @override
  String get homeNoRegistrationsBody =>
      'ඔබේ කෝටාව තහවුරු කර ගැනීමට අපේක්ෂිත අස්වැන්න ලියාපදිංචි කරන්න.';

  @override
  String get homeLatestNews => 'නවතම ගොවි පුවත්';

  @override
  String get homeNoNews => 'තවම පුවත් නැත.';

  @override
  String get homeUpdateBody => 'FarmFriend හි නව අනුවාදයක් ඇත.';

  @override
  String get marketTitle => 'වෙළඳපොළ';

  @override
  String get marketSubtitle => 'ඔබේ ගොවිපළට අවශ්‍ය කෘෂි උපකරණ, බීජ සහ මෙවලම් බලන්න.';

  @override
  String get marketSearchHint => 'භාණ්ඩ සොයන්න';

  @override
  String get marketSearchClear => 'සෙවුම මකන්න';

  @override
  String get marketCategoryAll => 'සියල්ල';

  @override
  String get marketCategorySeeds => 'බීජ';

  @override
  String get marketCategoryTools => 'මෙවලම්';

  @override
  String get marketEmptyTitle => 'තවම භාණ්ඩ නැත';

  @override
  String get marketEmptyMessage => 'දැනට මෙහි පෙන්වීමට කිසිවක් නැත. නැවුම් කිරීමට පහළට අදින්න.';

  @override
  String marketEmptySearch(String query) {
    return '\"$query\" සඳහා ගැළපෙන කිසිවක් නැත. වෙනත් වචනයක් උත්සාහ කරන්න.';
  }

  @override
  String get marketShowAll => 'සියලු භාණ්ඩ පෙන්වන්න';

  @override
  String productInStock(String count) {
    return 'තොගයේ: $count';
  }

  @override
  String get productOutOfStock => 'තොග අවසන්';

  @override
  String get productAdd => 'එක් කරන්න';

  @override
  String get productDetailTitle => 'භාණ්ඩ විස්තර';

  @override
  String productWeight(String weight) {
    return 'බර: $weight';
  }

  @override
  String get productDescription => 'විස්තරය';

  @override
  String get productReadMore => 'තව කියවන්න';

  @override
  String get productShowLess => 'අඩුවෙන් පෙන්වන්න';

  @override
  String get productQuantity => 'ප්‍රමාණය';

  @override
  String get productOutOfStockNote => 'මෙම භාණ්ඩය දැනට තොගයේ නැත. පසුව නැවත බලන්න.';

  @override
  String get productAddToCart => 'කරත්තයට එක් කරන්න';

  @override
  String get productBuyNow => 'දැන් මිලදී ගන්න';

  @override
  String get moreProfileHint => 'ඔබේ පැතිකඩ බලන්න සහ වෙනස් කරන්න';

  @override
  String get moreProfileNoName => 'ඔබේ පැතිකඩ';

  @override
  String get moreGroupFarming => 'ගොවිතැන් මෙවලම්';

  @override
  String get moreGroupActivity => 'මගේ කටයුතු';

  @override
  String get moreGroupApp => 'යෙදුම';

  @override
  String get moreNews => 'පුවත්';

  @override
  String get morePrices => 'බෝග මිල';

  @override
  String get morePlanner => 'ලාභ සැලසුම';

  @override
  String get moreOutlook => 'බෝග තත්ත්වය';

  @override
  String get moreOrders => 'මගේ ඇණවුම්';

  @override
  String get moreQuotas => 'මගේ කෝටා';

  @override
  String get moreSupport => 'සහාය අමතන්න';

  @override
  String get moreNotifications => 'දැනුම්දීම්';

  @override
  String get newsTitle => 'නවතම පුවත්';

  @override
  String get newsSubtitle => 'ගොවිතැන් පුවත් සහ අනතුරු ඇඟවීම්';

  @override
  String get newsDetailTitle => 'පුවත්';

  @override
  String get newsReadMore => 'තව කියවන්න';

  @override
  String get newsFilterAll => 'සියල්ල';

  @override
  String get newsTypeTechnology => 'තාක්ෂණය';

  @override
  String get newsTypeAlert => 'අනතුරු ඇඟවීම';

  @override
  String get newsTypeGeneral => 'සාමාන්‍ය';

  @override
  String get newsTypeDisease => 'රෝග';

  @override
  String get newsTypeMarket => 'වෙළඳපොළ';

  @override
  String get newsEmptyTitle => 'තවම පුවත් නැත';

  @override
  String get newsEmptyMessage => 'නව ලිපි සහ අනතුරු ඇඟවීම් මෙහි පෙන්වනු ඇත.';

  @override
  String get newsLoadMore => 'තවත් පෙන්වන්න';

  @override
  String get newsLoadMoreFailed => 'තවත් පුවත් ලබා ගත නොහැකි විය.';

  @override
  String newsByAuthor(String author) {
    return '$author විසින්';
  }

  @override
  String get newsShare => 'බෙදාගන්න';

  @override
  String get notifEmptyTitle => 'තවම දැනුම්දීම් නැත';

  @override
  String get notifEmptyMessage => 'අනතුරු ඇඟවීම් සහ නිවේදන මෙහි දිස්වේ.';

  @override
  String get notifMarkAllRead => 'සියල්ල කියවූ ලෙස සලකුණු කරන්න';

  @override
  String notifUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'නොකියවූ දැනුම්දීම් $count',
    );
    return '$_temp0';
  }

  @override
  String get notifNewTitle => 'නව දැනුම්දීමක්';

  @override
  String get notifUnread => 'නොකියවූ';

  @override
  String get pricesTitle => 'බෝග මිල';

  @override
  String pricesSubtitle(String date) {
    return 'තොග මිල පුරෝකථනය · යාවත්කාලීන කළේ $date';
  }

  @override
  String get pricesSubtitleNoDate => 'තොග මිල පුරෝකථනය';

  @override
  String get pricesSearchHint => 'බෝග සොයන්න';

  @override
  String get pricesSortAz => 'අකාරාදී';

  @override
  String get pricesSortRise => 'වැඩිම ඉහළ යාම';

  @override
  String get pricesSortFall => 'වැඩිම පහළ යාම';

  @override
  String get pricesSortMargin => 'හොඳම ලාභය';

  @override
  String get pricesAboveFair => 'සාධාරණ මිලට ඉහළින්';

  @override
  String get pricesBelowFair => 'සාධාරණ මිලට පහළින්';

  @override
  String get pricesForecastPending => 'පුරෝකථනය තවම නැත';

  @override
  String get pricesStale => 'පුරෝකථනය පැරණි විය හැක';

  @override
  String get pricesFooterNote =>
      'පුරෝකථන යනු පසුගිය මිල ගණන්, කාලගුණය සහ ඉන්ධන වියදම් මත පදනම් වූ ඇස්තමේන්තු වේ. සැබෑ වෙළඳපොළ මිල වෙනස් විය හැක.';

  @override
  String get pricesEmptyTitle => 'තවම මිල ගණන් නැත';

  @override
  String get pricesEmptyBody => 'මාසික පුරෝකථනය ක්‍රියාත්මක වූ පසු මිල පුරෝකථන මෙහි දිස් වේ.';

  @override
  String pricesChangeUp(String percent) {
    return 'පසුගිය මාසයට වඩා $percentක් ඉහළයි';
  }

  @override
  String pricesChangeDown(String percent) {
    return 'පසුගිය මාසයට වඩා $percentක් පහළයි';
  }

  @override
  String get pricesChangeFlat => 'පසුගිය මාසයට සාපේක්ෂව වෙනසක් නැත';

  @override
  String get pricesThisMonth => 'මෙම මාසයේ තොග මිල';

  @override
  String pricesLatestActual(String month) {
    return 'නවතම වෙළඳපොළ මිල ($month)';
  }

  @override
  String get pricesVsLastMonth => 'පසුගිය මාසයට සාපේක්ෂව';

  @override
  String pricesRetail(String price) {
    return 'ඇස්තමේන්තුගත සිල්ලර මිල $price';
  }

  @override
  String get pricesTrendTitle => 'මිල ප්‍රවණතාව';

  @override
  String get pricesTrendSubtitle => 'පසුගිය මාස 24 සහ ඉදිරි මාස 12';

  @override
  String get pricesLegendActual => 'සැබෑ මිල';

  @override
  String get pricesLegendForecast => 'පුරෝකථනය';

  @override
  String get pricesLegendBand => 'අවම මිල සිට සාධාරණ මිල දක්වා';

  @override
  String get pricesToday => 'අද';

  @override
  String get pricesChartEmpty => 'ප්‍රස්තාරයක් ඇඳීමට තවම ප්‍රමාණවත් මිල දත්ත නැත.';

  @override
  String get pricesBestMonthTitle => 'අස්වනු නෙළීමට හොඳම මාසය';

  @override
  String pricesBestMonthProfit(String profit) {
    return 'ලාභය $profit';
  }

  @override
  String pricesPlantToHarvest(String plant, String harvest) {
    return '$harvest අස්වනු නෙළීමට $plant වගා කරන්න';
  }

  @override
  String get pricesRegisterCrop => 'මෙම බෝගය ලියාපදිංචි කරන්න';

  @override
  String get pricesPlanProfit => 'මගේ ලාභය සැලසුම් කරන්න';

  @override
  String get pricesCostTitle => 'වියදම සහ සාධාරණ මිල';

  @override
  String get pricesCostPerKg => 'වගා වියදම';

  @override
  String get pricesFairPrice => 'සාධාරණ මිල (වියදම + 40%)';

  @override
  String get pricesProfitPerKg => 'කිලෝවකට ලාභය';

  @override
  String get pricesFloorPrice => 'අවම සහතික මිල';

  @override
  String get pricesQuotaTitle => 'ජාතික කෝටාව';

  @override
  String get pricesQuotaOpen => 'බෝග දැක්ම බලන්න';

  @override
  String get pricesWhyTitle => 'මෙම මිල ඇයි?';

  @override
  String get pricesWhyIntro => 'මෙම මාසය සඳහා පුරෝකථන ආකෘතිය භාවිත කළ දත්ත:';

  @override
  String get pricesWhyRainfall => 'භාවිත කළ වර්ෂාපතනය';

  @override
  String pricesWhyRainfallValue(String mm) {
    return 'මි.මී. $mm';
  }

  @override
  String get pricesWhyWeather => 'කාලගුණ බලපෑම';

  @override
  String get pricesWhyWeatherApplied => 'යොදා ඇත';

  @override
  String get pricesWhyWeatherNone => 'යොදා නැත';

  @override
  String get pricesWhyDiesel => 'ඩීසල් මිල (ලීටරයකට)';

  @override
  String get pricesWhyTransport => 'ප්‍රවාහන දර්ශකය';

  @override
  String get pricesWhyCycle => 'වර්ධන කාලය';

  @override
  String pricesWhyCycleValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'මාස $count',
      one: 'මාස 1',
    );
    return '$_temp0';
  }

  @override
  String get pricesWhyModel => 'ආකෘති අනුවාදය';

  @override
  String get pricesWhyGenerated => 'පුරෝකථනය සකස් කළ දිනය';

  @override
  String get pricesAskBot => 'AgriBot ගෙන් අසන්න';

  @override
  String pricesAskPrompt(String crop, String month) {
    return '$month වන විට $crop විකිණෙන්නේ කීයටද?';
  }

  @override
  String get pricesNotFoundTitle => 'මෙම බෝගයට මිල ගණන් නැත';

  @override
  String pricesNotFoundBody(String crop) {
    return '$crop සඳහා තවම මිල ඉතිහාසයක් හෝ පුරෝකථනයක් නැත.';
  }

  @override
  String get plannerTitle => 'ලාභ සැලසුම්කරු';

  @override
  String get plannerSubtitle => 'මෙපමණ වගා කළොත් මට ලැබෙන්නේ කීයද?';

  @override
  String get plannerCrop => 'බෝගය';

  @override
  String get plannerCropHint => 'බෝගයක් තෝරන්න';

  @override
  String get plannerMonth => 'අස්වනු මාසය';

  @override
  String get plannerBestMonthHint => '⭐ අස්වනු නෙළීමට හොඳම මාසය';

  @override
  String get plannerLand => 'ඉඩම් ප්‍රමාණය';

  @override
  String get plannerLandHint => 'උදා: 1';

  @override
  String get plannerAcres => 'අක්කර';

  @override
  String get plannerHectares => 'හෙක්ටයාර';

  @override
  String plannerLandInHa(String ha) {
    return '= හෙක්ටයාර $ha';
  }

  @override
  String get plannerPickCrop => 'සැලසුම ආරම්භ කිරීමට බෝගයක් තෝරන්න.';

  @override
  String get plannerEnterLand => 'සැලසුම බැලීමට ඔබේ ඉඩම් ප්‍රමාණය ඇතුළත් කරන්න.';

  @override
  String get plannerResultTitle => 'ඔබේ සැලසුම';

  @override
  String get plannerNoYield =>
      'මෙම බෝගය සහ මාසය සඳහා ආකෘතියේ අස්වනු අගයක් නැති බැවින් අස්වැන්න ඇස්තමේන්තු කළ නොහැක.';

  @override
  String get plannerPlantIn => 'වගා කළ යුතු මාසය';

  @override
  String get plannerExpectedHarvest => 'අපේක්ෂිත අස්වැන්න';

  @override
  String get plannerCost => 'නිෂ්පාදන වියදම';

  @override
  String get plannerIncome => 'පුරෝකථිත තොග මිල අනුව අපේක්ෂිත ආදායම';

  @override
  String get plannerProfit => 'අපේක්ෂිත ලාභය';

  @override
  String get plannerLoss => 'අපේක්ෂිත පාඩුව';

  @override
  String get plannerBreakEven => 'පාඩු නොවන මිල';

  @override
  String plannerQuotaFits(String remaining, String amount) {
    return 'මෙ.ටො. $remainingක් ඉතිරියි — ඔබේ මෙ.ටො. $amount ගැළපේ ✅';
  }

  @override
  String plannerQuotaExceeds(String remaining, String amount) {
    return 'මෙ.ටො. $remainingක් ඉතිරියි — ඔබේ මෙ.ටො. $amount ඉතිරි කෝටාව ඉක්මවයි ⚠️';
  }

  @override
  String get plannerSeeAlternatives => 'ඉඩ ඇති බෝග බලන්න';

  @override
  String get plannerCompareTitle => 'බෝග සසඳන්න';

  @override
  String get plannerCompareSubtitle => 'එකම ඉඩම සහ අස්වනු මාසය, තවත් බෝග 3ක් දක්වා';

  @override
  String get plannerCompareAdd => 'සැසඳීමට බෝගයක් එක් කරන්න';

  @override
  String plannerCompareRemove(String crop) {
    return '$crop ඉවත් කරන්න';
  }

  @override
  String get plannerCompareBest => 'ඉහළම ලාභය';

  @override
  String get plannerCompareNoData => '— යනු එම බෝගයට මෙම මාසයේ පුරෝකථනයක් නැති බවයි.';

  @override
  String get plannerShortHarvest => 'අස්වැන්න';

  @override
  String get plannerShortCost => 'වියදම';

  @override
  String get plannerShortIncome => 'ආදායම';

  @override
  String get plannerShortProfit => 'ලාභය';

  @override
  String plannerRegisterCta(String amount, String crop) {
    return '$crop මෙ.ටො. $amount ලියාපදිංචි කරන්න';
  }

  @override
  String get plannerDisclaimer =>
      'මේවා පුරෝකථන ආකෘතියෙන් ලැබෙන ඇස්තමේන්තු පමණි. සැබෑ අස්වැන්න, වියදම් සහ වෙළඳපොළ මිල වෙනස් විය හැක.';

  @override
  String get plannerNoForecastTitle => 'තවම පුරෝකථන නැත';

  @override
  String get plannerNoForecastBody =>
      'සැලසුම්කරුට මිල පුරෝකථන අවශ්‍යයි. අන්තර්ජාලයට සම්බන්ධ වී නැවුම් කිරීමට පහළට අදින්න.';

  @override
  String get registerTitle => 'අස්වනු කෝටාව ලියාපදිංචි කරන්න';

  @override
  String get registerAuthBadge => 'තහවුරු කළ ගොවියෙකි';

  @override
  String get registerInfo => 'මිල සුරක්ෂිත කර ගැනීමට ඔබේ බෝග ලියාපදිංචි කරන්න.';

  @override
  String get registerSelectCrop => 'බෝගය තෝරන්න';

  @override
  String get registerSelectCropHint => 'බෝගයක් තේරීමට තට්ටු කරන්න';

  @override
  String get registerCropRequired => 'කරුණාකර බෝගයක් තෝරන්න';

  @override
  String get registerSearchCrop => 'බෝග සොයන්න';

  @override
  String get registerNoTargets => 'දැනට සක්‍රිය බෝග ඉලක්ක නැත. කරුණාකර පසුව නැවත බලන්න.';

  @override
  String registerNoActiveTarget(String crop) {
    return '$crop සඳහා දැනට සක්‍රිය ජාතික ඉලක්කයක් නැත.';
  }

  @override
  String get registerLimit => 'ජාතික සීමාව';

  @override
  String get registerFilled => 'මේ වන විට ලියාපදිංචි';

  @override
  String get registerRemaining => 'ඉතිරිය';

  @override
  String get registerFairPrice => 'සාධාරණ මිල';

  @override
  String get registerWholesale => 'ඇස්තමේන්තුගත තොග මිල';

  @override
  String get registerPlantingDate => 'වගා කරන දිනය';

  @override
  String get registerHarvestDate => 'ඉලක්කගත අස්වනු දිනය';

  @override
  String registerFarmerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ගොවීන් $countක් ලියාපදිංචි වී ඇත',
      one: 'ගොවියෙක් ලියාපදිංචි වී ඇත',
      zero: 'තවම ගොවීන් ලියාපදිංචි වී නැත',
    );
    return '$_temp0';
  }

  @override
  String registerForecastTitle(String month) {
    return '$month සඳහා ආකෘති පුරෝකථනය';
  }

  @override
  String get registerForecastWholesale => 'තොග මිල';

  @override
  String get registerForecastProfit => 'කිලෝවකට ලාභය';

  @override
  String get registerSeeTrend => 'මිල ප්‍රවණතාව බලන්න';

  @override
  String get registerAmountLabel => 'අපේක්ෂිත අස්වනු ප්‍රමාණය (මෙ.ටො.)';

  @override
  String get registerAmountHint => 'උදා: 100';

  @override
  String registerAmountHelper(String remaining) {
    return 'ඉතිරි ධාරිතාව: මෙ.ටො. $remaining';
  }

  @override
  String registerAmountMax(String max) {
    return 'ප්‍රමාණය මෙ.ටො. $maxට වඩා වැඩි විය නොහැක';
  }

  @override
  String get registerInvalidAmount =>
      'මෙම ප්‍රමාණය පිළිගත්තේ නැත. එය පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get registerDontKnow => 'ටොන් ගණන දන්නේ නැද්ද?';

  @override
  String get registerCheckAndRegister => 'පරීක්ෂා කර ලියාපදිංචි කරන්න';

  @override
  String get registerSuccessTitle => 'කෝටාව ලියාපදිංචි විය';

  @override
  String registerSuccessBody(String amount, String crop) {
    return '$crop මෙ.ටො. $amountක් ලියාපදිංචි විය. ඔබේ කෝටාව තහවුරුයි.';
  }

  @override
  String get registerViewQuotas => 'මගේ කෝටා බලන්න';

  @override
  String get registerNoTarget => 'මෙම බෝගය සඳහා සක්‍රිය ජාතික ඉලක්කයක් නැත. පරිපාලක අමතන්න.';

  @override
  String get registerContactSupport => 'සහාය අමතන්න';

  @override
  String get registerUnknownResult =>
      'මෙම ලියාපදිංචිය තහවුරු කර ගත නොහැකි විය. පහත ‘මගේ ලියාපදිංචි කෝටා’ බලන්න, නැතහොත් යෙදුම යාවත්කාලීන කර නැවත උත්සාහ කරන්න.';

  @override
  String registerCropChanged(String crop) {
    return 'බෝගය $crop ලෙස වෙනස් විය. ඉදිරියට යාමට ‘පරීක්ෂා කර ලියාපදිංචි කරන්න’ තට්ටු කරන්න.';
  }

  @override
  String registerSurplusTitle(String crop) {
    return '$crop කෝටාව ඉක්මවා ඇත';
  }

  @override
  String registerSurplusBody(String remaining) {
    return 'ඉතිරිව ඇත්තේ මෙ.ටො. $remainingක් පමණි. ඊට වඩා ලියාපදිංචි කළහොත් අතිරික්තයක් ඇති වී මිල පහළ යයි.';
  }

  @override
  String get registerSurplusBodyFull =>
      'මෙම කෝටාව පිරී ඇත. තවත් ලියාපදිංචි කළහොත් අතිරික්තයක් ඇති වී මිල පහළ යයි.';

  @override
  String registerSurplusRequested(String amount) {
    return 'ඔබ ඉල්ලුවේ මෙ.ටො. $amountක් ලියාපදිංචි කිරීමටයි.';
  }

  @override
  String get registerSurplusConfirming => 'සේවාදායකය සමඟ තහවුරු කරමින්…';

  @override
  String get registerSurplusAlternatives => 'විකල්ප බෝග';

  @override
  String get registerSurplusNoAlternatives => 'දැනට වෙනත් කිසිදු බෝගයකට ඉඩ නැත.';

  @override
  String registerAltWhy(String remaining, String price) {
    return 'මෙ.ටො. $remainingක ඉඩ · සාධාරණ මිල $price';
  }

  @override
  String registerAltWhyNoPrice(String remaining) {
    return 'මෙ.ටො. $remainingක ඉඩ';
  }

  @override
  String get registerAltChoose => 'තෝරන්න';

  @override
  String registerRemainingCta(String remaining) {
    return 'ඉතිරි මෙ.ටො. $remaining ලියාපදිංචි කරන්න';
  }

  @override
  String get registerLandTitle => 'ඉඩම් ප්‍රමාණයෙන් ඇස්තමේන්තු කරන්න';

  @override
  String registerLandBody(String crop, String month) {
    return '$month අස්වනු නෙළන $crop සඳහා ආකෘතියේ අස්වනු අනුපාතය භාවිත කරයි.';
  }

  @override
  String get registerLandSize => 'ඉඩම් ප්‍රමාණය';

  @override
  String get registerLandEstimate => 'ඇස්තමේන්තුගත අස්වැන්න';

  @override
  String registerLandYield(String tonnes) {
    return 'ආකෘතියේ අස්වැන්න: හෙක්ටයාරයකට මෙ.ටො. $tonnes';
  }

  @override
  String registerLandUse(String amount) {
    return 'මෙ.ටො. $amount යොදන්න';
  }

  @override
  String get registerLandUseDisabled => 'ඔබේ ඉඩම් ප්‍රමාණය ඇතුළත් කරන්න';

  @override
  String get quotasTitle => 'මගේ ලියාපදිංචි කෝටා';

  @override
  String get quotasSubtitle => 'ඔබ තහවුරු කරගත් අස්වනු කෝටා';

  @override
  String get quotasColCrop => 'බෝගය';

  @override
  String get quotasColAmount => 'ප්‍රමාණය (මෙ.ටො.)';

  @override
  String get quotasColDate => 'දිනය';

  @override
  String get quotasLockedNote => 'මෙම කෝටා තහවුරු කර ඇත. වාර්තා වෙනස් කිරීමට පරිපාලක අමතන්න.';

  @override
  String get quotasRequestChange => 'වෙනසක් ඉල්ලන්න';

  @override
  String get quotasChangeSubject => 'කෝටා වෙනස් කිරීමේ ඉල්ලීම';

  @override
  String get quotasEmptyTitle => 'තවම කෝටා ලියාපදිංචි කර නැත';

  @override
  String get quotasEmptyBody =>
      'කෝටාවක් සහ සාධාරණ මිලක් තහවුරු කර ගැනීමට ඔබේ අපේක්ෂිත අස්වැන්න ලියාපදිංචි කරන්න.';

  @override
  String get quotasEmptyAction => 'බෝගයක් ලියාපදිංචි කරන්න';

  @override
  String get quotasTotal => 'මුළු ලියාපදිංචිය';

  @override
  String quotasCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'බෝග $countක්',
      one: 'බෝග 1ක්',
    );
    return '$_temp0';
  }

  @override
  String get outlookTitle => 'බෝග දැක්ම';

  @override
  String get outlookSubtitle => 'ජාතික ඉල්ලුම සහ ලියාපදිංචි සැපයුම';

  @override
  String get outlookSearchHint => 'බෝග සොයන්න';

  @override
  String get outlookFilterAll => 'සියල්ල';

  @override
  String get outlookFilterAvailable => 'ඉඩ ඇත';

  @override
  String get outlookFilterAlmostFull => 'පිරීමට ආසන්නයි';

  @override
  String get outlookFilterFull => 'පිරී ඇත';

  @override
  String get outlookSortLabel => 'පෙළගස්වන්න';

  @override
  String get outlookSortMostRoom => 'වැඩිම ඉඩ';

  @override
  String get outlookSortHighestPrice => 'ඉහළම මිල';

  @override
  String get outlookSortAz => 'අකාරාදී';

  @override
  String outlookCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'බෝග $countක්',
      one: 'බෝග 1ක්',
      zero: 'බෝග නැත',
    );
    return '$_temp0';
  }

  @override
  String outlookFairPriceLine(String price) {
    return 'සාධාරණ මිල: $price';
  }

  @override
  String outlookHarvestWindow(String date) {
    return 'අස්වනු: $date';
  }

  @override
  String get outlookEmptyTitle => 'සක්‍රිය බෝග ඉලක්ක නැත';

  @override
  String get outlookEmptyBody => 'ජාතික ඉලක්ක අනුමත වූ පසු මෙහි දිස් වේ.';

  @override
  String get outlookNoMatch => 'මෙම සෙවුමට හෝ පෙරහනට ගැළපෙන බෝග නැත';

  @override
  String get outlookNotFoundTitle => 'සක්‍රිය ඉලක්කයක් නැත';

  @override
  String outlookNotFoundBody(String crop) {
    return '$crop සඳහා දැනට සක්‍රිය ජාතික ඉලක්කයක් නැත.';
  }

  @override
  String get outlookSeeAll => 'සියලු බෝග බලන්න';

  @override
  String get outlookNumbers => 'කෝටා විස්තර';

  @override
  String get outlookAllowedExtent => 'අවසර ලත් වගා බිම් ප්‍රමාණය';

  @override
  String outlookHectares(String amount) {
    return 'හෙක්ටයාර $amount';
  }

  @override
  String get outlookPriceCompare => 'සාධාරණ මිල සහ තොග මිල';

  @override
  String get outlookFullNote => 'මෙම කෝටාව පිරී ඇත. අතිරික්තයක් වළක්වා ගැනීමට වෙනත් බෝගයක් තෝරන්න.';

  @override
  String get outlookRegisterCta => 'මෙම බෝගය ලියාපදිංචි කරන්න';

  @override
  String outlookAskBot(String crop) {
    return '$crop ගැන AgriBot ගෙන් අසන්න';
  }

  @override
  String outlookAskPrompt(String crop) {
    return '$crop වගාව ගැන කියන්න: ඉල්ලුම, අපේක්ෂිත මිල සහ වගා කළ යුතු කාලය.';
  }

  @override
  String get settingsTitle => 'සැකසුම්';

  @override
  String get settingsTabAccount => 'ගිණුම';

  @override
  String get settingsTabNotifications => 'දැනුම්දීම්';

  @override
  String get settingsTabCredentials => 'මුරපදය';

  @override
  String get settingsGeneral => 'පොදු';

  @override
  String get settingsLanguage => 'භාෂාව';

  @override
  String get settingsLanguageHint => 'යෙදුමේ භාෂාව තෝරන්න. එය වහාම වෙනස් වේ.';

  @override
  String get settingsAbout => 'යෙදුම ගැන';

  @override
  String get settingsFeedback => 'අදහස් දෙන්න';

  @override
  String get settingsSignOut => 'ඉවත් වන්න';

  @override
  String get settingsSignOutConfirmTitle => 'ඉවත් වෙනවාද?';

  @override
  String get settingsSignOutConfirmMessage => 'FarmFriend භාවිත කිරීමට ඔබ නැවත පිවිසිය යුතුයි.';

  @override
  String get settingsName => 'නම';

  @override
  String get settingsSurname => 'වාසගම';

  @override
  String get settingsEmail => 'ඊමේල්';

  @override
  String get settingsEmailLocked => 'ඊමේල් ලිපිනය මෙතැනින් වෙනස් කළ නොහැක.';

  @override
  String get settingsPhone => 'දුරකථන අංකය';

  @override
  String get settingsType => 'වර්ගය';

  @override
  String get settingsTypeHint => 'වර්ගය තෝරන්න';

  @override
  String get settingsTypeFarmer => 'ගොවියා';

  @override
  String get settingsTypeBuyer => 'ගැනුම්කරු';

  @override
  String get settingsTypeOfficer => 'කෘෂිකර්ම නිලධාරී';

  @override
  String get settingsDistrict => 'දිස්ත්‍රික්කය';

  @override
  String get settingsDistrictHint => 'දිස්ත්‍රික්කය තෝරන්න';

  @override
  String get settingsChangePhoto => 'ඡායාරූපය වෙනස් කරන්න';

  @override
  String get settingsPhotoUpdated => 'පැතිකඩ ඡායාරූපය යාවත්කාලීන විය.';

  @override
  String get settingsUpdateProfile => 'පැතිකඩ යාවත්කාලීන කරන්න';

  @override
  String get settingsProfileUpdated => 'පැතිකඩ යාවත්කාලීන විය.';

  @override
  String get settingsDangerZone => 'අවදානම් කලාපය';

  @override
  String get settingsDeleteAccount => 'ගිණුම මකන්න';

  @override
  String get settingsDeleteAccountInfo =>
      'මෙයින් ඔබේ ගිණුම සමඟ ලියාපදිංචි කිරීම්, ඇණවුම් සහ පළ කිරීම් සදහටම මැකේ. එය ආපසු හැරවිය නොහැක.';

  @override
  String get settingsDeleteConfirmTitle => 'ඔබේ ගිණුම මකනවාද?';

  @override
  String settingsDeleteConfirmMessage(String word) {
    return 'මෙය ආපසු හැරවිය නොහැක. තහවුරු කිරීමට $word ලෙස ටයිප් කරන්න.';
  }

  @override
  String get settingsNotifyMaster => 'දැනුම්දීම්වලට ඉඩ දෙන්න';

  @override
  String get settingsNotifyMasterHint =>
      'අතිරික්ත අනතුරු ඇඟවීම්, ඇණවුම් යාවත්කාලීන සහ FarmFriend පිළිතුරු.';

  @override
  String get settingsNotifyDeviceTitle => 'මෙම දුරකථනයේ';

  @override
  String get settingsNotifyOrders => 'ඇණවුම් යාවත්කාලීන';

  @override
  String get settingsNotifyOrdersHint => 'ඔබේ ඇණවුම තහවුරු කළ, යැවූ හෝ ලැබුණු විට.';

  @override
  String get settingsNotifyCommunity => 'ප්‍රජා පිළිතුරු';

  @override
  String get settingsNotifyCommunityHint => 'කවුරුන් හෝ ඔබේ පළ කිරීමට අදහසක් දැක්වූ විට.';

  @override
  String get settingsNotifyNews => 'පුවත් දැනුම්දීම්';

  @override
  String get settingsNotifyNewsHint => 'ගොවිතැන් පුවත්, අනතුරු ඇඟවීම් සහ නිවේදන.';

  @override
  String get settingsPushTitle => 'තල්ලු දැනුම්දීම්';

  @override
  String get settingsPushHint => 'යෙදුම වසා ඇති විටත් FarmFriend ඔබට දැනුම් දීමට ඉඩ දෙන්න.';

  @override
  String get settingsEnablePush => 'තල්ලු දැනුම්දීම් සක්‍රීය කරන්න';

  @override
  String get settingsPushEnabled => 'තල්ලු දැනුම්දීම් සක්‍රීයයි.';

  @override
  String get settingsPushDenied => 'දැනුම්දීම් අවහිර කර ඇත. ඔබේ දුරකථන සැකසුම්වලින් ඉඩ දෙන්න.';

  @override
  String get settingsChangePassword => 'මුරපදය වෙනස් කරන්න';

  @override
  String get settingsCurrentPassword => 'වත්මන් මුරපදය';

  @override
  String get settingsNewPassword => 'නව මුරපදය';

  @override
  String get settingsConfirmPassword => 'නව මුරපදය තහවුරු කරන්න';

  @override
  String get settingsUpdatePassword => 'මුරපදය යාවත්කාලීන කරන්න';

  @override
  String get settingsPasswordUpdated => 'මුරපදය යාවත්කාලීන විය.';

  @override
  String get settingsGoogleAccount => 'ඔබ පිවිසුණේ Google මගිනි';

  @override
  String get settingsGoogleAccountHint => 'ඊමේල් ලිපිනයෙන්ද පිවිසීමට අවශ්‍ය නම් මුරපදයක් සකසන්න.';

  @override
  String get settingsSetPassword => 'මුරපදයක් සකසන්න';

  @override
  String get settingsPasswordSet => 'මුරපදය සුරැකිණි. දැන් ඔබට ඊමේල් සහ මුරපදයෙන් පිවිසිය හැක.';

  @override
  String settingsPhoneAccount(String phone) {
    return '$phone දුරකථන අංකයෙන් පිවිස ඇත';
  }

  @override
  String get settingsAddEmailPassword => 'ඊමේල් සහ මුරපදය එක් කරන්න';

  @override
  String get settingsAddEmailHint => 'අත්‍යවශ්‍ය නොවේ. ඊමේල් ලිපිනයකින්ද පිවිසීමට ඉඩ සලසයි.';

  @override
  String get settingsEmailPasswordAdded => 'සුරැකිණි. ලිපිනය තහවුරු කිරීමට ඔබේ ඊමේල් බලන්න.';

  @override
  String get aboutTagline => 'වගා කිරීමට පෙර සැලසුම් කරන්න.';

  @override
  String aboutVersion(String version) {
    return 'සංස්කරණය $version';
  }

  @override
  String get aboutWebPortal => 'වෙබ් ද්වාරය විවෘත කරන්න';

  @override
  String get aboutPrivacy => 'පෞද්ගලිකත්ව ප්‍රතිපත්තිය';

  @override
  String get aboutTerms => 'භාවිත කොන්දේසි';

  @override
  String get aboutLicences => 'විවෘත මූලාශ්‍ර බලපත්‍ර';

  @override
  String get aboutCreditsTitle => 'ස්තුතිය';

  @override
  String get aboutCredits =>
      'ශ්‍රී ලංකාවේ ගොවීන් වෙනුවෙන් Horizon Campus පර්යේෂණ කණ්ඩායම විසින් නිර්මාණය කරන ලදී.';

  @override
  String get aboutLinkFailed => 'සබැඳිය විවෘත කළ නොහැකි විය.';

  @override
  String get supportTitle => 'සහාය අමතන්න';

  @override
  String get supportNewTitle => 'නව පණිවිඩයක් යවන්න';

  @override
  String get supportNewSubtitle => 'පරිපාලක ඔබේ පණිවිඩය පරීක්ෂා කර අවශ්‍ය නම් පිළිතුරු දෙනු ඇත.';

  @override
  String get supportSubject => 'මාතෘකාව';

  @override
  String get supportSubjectHint => 'මෙය කුමක් ගැනද?';

  @override
  String get supportDescription => 'විස්තරය';

  @override
  String get supportDescriptionHint => 'ඔබේ ගැටලුව හෝ ප්‍රශ්නය විස්තර කරන්න';

  @override
  String get supportSend => 'පණිවිඩය යවන්න';

  @override
  String get supportSent => 'පණිවිඩය යවන ලදී. අවශ්‍ය නම් පරිපාලක පිළිතුරු දෙනු ඇත.';

  @override
  String get supportMineTitle => 'මා යැවූ පණිවිඩ';

  @override
  String get supportEmpty => 'තවම පණිවිඩ යවා නැත.';

  @override
  String get supportAdminReplied => 'පරිපාලක පිළිතුරු දී ඇත';

  @override
  String get supportNewReply => 'නව පිළිතුරක්';

  @override
  String get supportDetailTitle => 'පණිවිඩ විස්තර';

  @override
  String get supportYourMessage => 'ඔබේ පණිවිඩය';

  @override
  String get supportAdminReply => 'පරිපාලක පිළිතුර';

  @override
  String supportSentOn(String date) {
    return 'යැවූ දිනය: $date';
  }

  @override
  String supportRepliedOn(String date) {
    return 'පිළිතුරු දුන් දිනය: $date';
  }

  @override
  String get supportNoReplyYet =>
      'තවම පිළිතුරක් නැත. පරිපාලක ඔබේ පණිවිඩය පරීක්ෂා කර අවශ්‍ය නම් පිළිතුරු දෙනු ඇත.';

  @override
  String get supportReplyNotifTitle => 'පරිපාලක ඔබේ පණිවිඩයට පිළිතුරු දී ඇත';

  @override
  String get weatherTitle => 'කාලගුණය';

  @override
  String weatherTemp(String value) {
    return '$value°C';
  }

  @override
  String get weatherCardUnavailable => 'කාලගුණ තොරතුරු නැත';

  @override
  String get weatherHumidity => 'ආර්ද්‍රතාව';

  @override
  String get weatherWind => 'සුළඟ';

  @override
  String weatherWindValue(String value) {
    return 'පැයට කි.මී. $value';
  }

  @override
  String get weatherRainChance => 'වැසි අවස්ථාව';

  @override
  String get weatherAdviceTitle => 'කෙත් වැඩ සඳහා උපදෙස්';

  @override
  String get weatherAdviceAvoidSpraying => 'අද ඉසීමෙන් වළකින්න';

  @override
  String get weatherAdviceAvoidSprayingDetail =>
      'අද වැසි ඇති විය හැක. පළිබෝධනාශක සහ පොහොර ක්‍රියා කිරීමට පෙර සේදී යා හැක.';

  @override
  String get weatherAdviceIrrigate => 'උදේ පාන්දර හෝ සවස ජලය සපයන්න';

  @override
  String get weatherAdviceIrrigateDetail =>
      'අද දැඩි උණුසුමක් පවතී. ජලය අපතේ නොයන ලෙස සිසිල් වේලාවක වගාවට ජලය දෙන්න.';

  @override
  String get weatherAdviceGood => 'කෙත් වැඩට හොඳ දවසක්';

  @override
  String get weatherAdviceGoodDetail => 'අද තද වැසි හෝ අධික උණුසුමක් බලාපොරොත්තු නොවේ.';

  @override
  String get weatherHourlyTitle => 'වැසි අවස්ථාව — ඉදිරි පැය 24';

  @override
  String get weatherHourlyEmpty => 'පැයෙන් පැය වැසි තොරතුරු දැනට නොමැත.';

  @override
  String weatherHourlyTooltip(String time, String percent) {
    return '$time · $percent';
  }

  @override
  String get weatherDailyTitle => 'දින 7ක අනාවැකිය';

  @override
  String get weatherDailyEmpty => 'දින 7ක අනාවැකිය දැනට නොමැත.';

  @override
  String get weatherToday => 'අද';

  @override
  String weatherHighLow(String high, String low) {
    return '$high° / $low°';
  }

  @override
  String get weatherLocationHint => 'ඔබේ පැතිකඩේ ඇති දිස්ත්‍රික්කයට අදාළ කාලගුණය පෙන්වයි.';

  @override
  String get weatherChangeDistrict => 'දිස්ත්‍රික්කය වෙනස් කරන්න';

  @override
  String get weatherSource => 'කාලගුණ දත්ත: Open-Meteo.com';

  @override
  String get weatherCondClear => 'පැහැදිලි අහස';

  @override
  String get weatherCondPartlyCloudy => 'අර්ධ වශයෙන් වලාකුළු සහිතයි';

  @override
  String get weatherCondCloudy => 'වලාකුළු සහිතයි';

  @override
  String get weatherCondFog => 'මීදුම';

  @override
  String get weatherCondDrizzle => 'සුළු වැසි';

  @override
  String get weatherCondRain => 'වැසි';

  @override
  String get weatherCondShowers => 'වැසි වැටීම්';

  @override
  String get weatherCondSnow => 'හිම';

  @override
  String get weatherCondThunderstorm => 'ගිගුරුම් සහිත වැසි';

  @override
  String get weatherCondUnknown => 'කාලගුණය';
}
