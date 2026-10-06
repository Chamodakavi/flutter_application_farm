// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get authWelcomeBack => 'FarmFriend-க்கு மீண்டும் வரவேற்கிறோம்';

  @override
  String get authSignIn => 'உள்நுழைக';

  @override
  String get authSignOut => 'வெளியேறு';

  @override
  String get authEmail => 'மின்னஞ்சல்';

  @override
  String get authPassword => 'கடவுச்சொல்';

  @override
  String get authForgot => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get authGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get authPhone => 'தொலைபேசி எண் மூலம் தொடரவும்';

  @override
  String get authNewHere => 'புதியவரா?';

  @override
  String get authCreateAccount => 'கணக்கை உருவாக்கு';

  @override
  String get authCreateTitle => 'உங்கள் கணக்கை உருவாக்குங்கள்';

  @override
  String get authFullName => 'முழுப் பெயர்';

  @override
  String get authConfirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get authAgreeTerms => 'விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கிறேன்';

  @override
  String get authAgreeRequired => 'தொடர விதிமுறைகளை ஏற்கவும்.';

  @override
  String get authHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get authSignInInstead => 'அதற்குப் பதிலாக உள்நுழைக';

  @override
  String get authCheckEmailTitle => 'உங்கள் மின்னஞ்சலைப் பாருங்கள்';

  @override
  String authCheckEmailBody(String email) {
    return '$email க்கு உறுதிப்படுத்தல் இணைப்பை அனுப்பியுள்ளோம். கணக்கைச் செயல்படுத்த அதைத் திறந்து, பின்னர் உள்நுழையவும்.';
  }

  @override
  String get authOpenEmailApp => 'மின்னஞ்சல் செயலியைத் திற';

  @override
  String get authBackToLogin => 'உள்நுழைவுக்குத் திரும்பு';

  @override
  String get authForgotTitle => 'கடவுச்சொல்லை மீட்டமைக்கவும்';

  @override
  String get authForgotBody =>
      'உங்கள் மின்னஞ்சலை உள்ளிடவும். புதிய கடவுச்சொல்லைத் தேர்வுசெய்ய ஓர் இணைப்பை அனுப்புவோம்.';

  @override
  String get authSendResetLink => 'மீட்டமைப்பு இணைப்பை அனுப்பு';

  @override
  String authResetSent(String email) {
    return '$email க்கு கணக்கு இருந்தால், மீட்டமைப்பு இணைப்பு அனுப்பப்படும். அதை இந்தத் தொலைபேசியில் திறக்கவும்.';
  }

  @override
  String get authResetTitle => 'புதிய கடவுச்சொல்லைத் தேர்வுசெய்க';

  @override
  String get authResetNeedsLink =>
      'புதிய கடவுச்சொல்லைத் தேர்வுசெய்ய, உங்கள் மின்னஞ்சலில் உள்ள இணைப்பை இந்தத் தொலைபேசியில் திறக்கவும்.';

  @override
  String get authNewPassword => 'புதிய கடவுச்சொல்';

  @override
  String get authSavePassword => 'கடவுச்சொல்லைச் சேமி';

  @override
  String get authPasswordUpdated =>
      'கடவுச்சொல் புதுப்பிக்கப்பட்டது. புதிய கடவுச்சொல்லுடன் உள்நுழையவும்.';

  @override
  String get authPhoneTitle => 'உங்கள் தொலைபேசி மூலம் உள்நுழைக';

  @override
  String get authPhoneBody => 'இந்த எண்ணுக்கு SMS மூலம் 6 இலக்கக் குறியீட்டை அனுப்புவோம்.';

  @override
  String get authPhoneNumber => 'கைபேசி எண்';

  @override
  String get authSendCode => 'குறியீட்டை அனுப்பு';

  @override
  String get authOtpTitle => 'குறியீட்டை உள்ளிடவும்';

  @override
  String authOtpBody(String phone) {
    return '$phone க்கு 6 இலக்கக் குறியீட்டை அனுப்பியுள்ளோம்.';
  }

  @override
  String get authVerify => 'சரிபார்';

  @override
  String authResendIn(int seconds) {
    return '$seconds வினாடிகளில் குறியீட்டை மீண்டும் அனுப்பலாம்';
  }

  @override
  String get authResend => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String get authCodeSent => 'புதிய குறியீடு அனுப்பப்பட்டது.';

  @override
  String get authChangeNumber => 'எண்ணை மாற்று';

  @override
  String get authResendLimit =>
      'அதிகமான குறியீடுகள் கோரப்பட்டன. சில நிமிடங்களில் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get splashGettingReady => 'தயாராகிறது…';

  @override
  String get splashProfileError => 'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை.';

  @override
  String get onboarding1Title => 'நடுவதற்கு முன் திட்டமிடுங்கள்';

  @override
  String get onboarding1Body =>
      'எதைப் பயிரிடுவது என்று முடிவுசெய்யும் முன், நாட்டுக்கு ஒவ்வொரு பயிரும் எவ்வளவு தேவை, ஏற்கனவே எவ்வளவு பதிவாகியுள்ளது என்பதைப் பாருங்கள்.';

  @override
  String get onboarding2Title => 'நியாயமான விலை, குறைந்த வீணாக்கம்';

  @override
  String get onboarding2Body =>
      'உங்கள் விளைச்சல் நியாயமான விலைக்கு விற்க, முன்னறிவிப்பு விலைகளையும் அறுவடைக்குச் சிறந்த மாதத்தையும் பாருங்கள்.';

  @override
  String get onboarding3Title => 'சந்தை, சமூகம் மற்றும் AgriBot';

  @override
  String get onboarding3Body =>
      'விதைகளையும் கருவிகளையும் வாங்குங்கள், மற்ற விவசாயிகளுடன் பகிருங்கள், உங்கள் சொந்த மொழியில் AgriBot-இடம் எதையும் கேளுங்கள்.';

  @override
  String get onboardingGetStarted => 'தொடங்குங்கள்';

  @override
  String get profileCompleteTitle => 'உங்கள் சுயவிவரத்தை நிறைவுசெய்யுங்கள்';

  @override
  String get profileCompleteSubtitle => 'தொடங்கும் முன் சில விவரங்கள் தேவை.';

  @override
  String get profileName => 'பெயர்';

  @override
  String get profileSurname => 'குடும்பப் பெயர்';

  @override
  String get profileEmail => 'மின்னஞ்சல்';

  @override
  String get profileEmailReadOnly => 'மின்னஞ்சலை இங்கு மாற்ற முடியாது.';

  @override
  String get profileTelephone => 'தொலைபேசி';

  @override
  String get profileType => 'வகை';

  @override
  String get profileSelectType => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get profileDistrict => 'மாவட்டம்';

  @override
  String get profileSelectDistrict => 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get profileSaveContinue => 'சேமித்துத் தொடரவும்';

  @override
  String get profileTypeFarmer => 'விவசாயி';

  @override
  String get profileTypeBuyer => 'வாங்குபவர்';

  @override
  String get profileTypeOfficer => 'விவசாய அதிகாரி';

  @override
  String get profileAddPhoto => 'புகைப்படம் சேர்';

  @override
  String get profileChangePhoto => 'புகைப்படத்தை மாற்று';

  @override
  String get profilePhotoGallery => 'கேலரியிலிருந்து தேர்வுசெய்';

  @override
  String get profilePhotoCamera => 'புகைப்படம் எடு';

  @override
  String get maintenanceBody =>
      'FarmFriend புதுப்பிக்கப்படுகிறது. சிறிது நேரம் கழித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get cartTitle => 'கூடை';

  @override
  String get cartSubtitle => 'உங்கள் கூடையைச் சரிபார்த்து, அனுப்பிய ஆர்டர்களைக் கண்காணியுங்கள்.';

  @override
  String get cartCashOnDelivery => 'பொருள் கிடைத்ததும் பணம்';

  @override
  String get cartAdded => 'கூடையில் சேர்க்கப்பட்டது';

  @override
  String get cartViewCart => 'கூடையைக் காண்க';

  @override
  String get cartEmptyTitle => 'உங்கள் கூடை காலியாக உள்ளது';

  @override
  String get cartEmptyMessage =>
      'உங்கள் கூடையில் எதுவும் இல்லை. பொருட்களைப் பார்க்கலாம் அல்லது கீழே உங்கள் ஆர்டர் வரலாற்றைப் பார்க்கலாம்.';

  @override
  String get cartStartShopping => 'வாங்கத் தொடங்குங்கள்';

  @override
  String cartUnitPrice(String price) {
    return 'ஒன்று $price';
  }

  @override
  String get cartRemove => 'கூடையிலிருந்து நீக்கு';

  @override
  String cartRemoved(String name) {
    return '$name கூடையிலிருந்து நீக்கப்பட்டது';
  }

  @override
  String cartOnlyLeft(String count) {
    return 'கையிருப்பில் $count மட்டுமே உள்ளது. அளவைக் குறைக்கவும்.';
  }

  @override
  String get cartLineOutOfStock => 'இந்தப் பொருள் கையிருப்பில் இல்லை. தொடர அதை நீக்கவும்.';

  @override
  String get cartSummaryTitle => 'ஆர்டர் சுருக்கம்';

  @override
  String get cartSubtotal => 'கூட்டுத்தொகை';

  @override
  String get cartShipping => 'விநியோகக் கட்டணம்';

  @override
  String get cartTotal => 'மொத்தம்';

  @override
  String get cartPayment => 'பணம் செலுத்துதல்';

  @override
  String get cartEstimateNote =>
      'இவை மதிப்பிடப்பட்ட தொகைகள். ஆர்டரை அனுப்பும்போது இறுதித் தொகை உறுதிசெய்யப்படும்.';

  @override
  String get cartFixStock =>
      'சில பொருட்களின் அளவு கையிருப்பை விட அதிகம். தொடர அவற்றைச் சரிசெய்யவும்.';

  @override
  String get cartCheckout => 'ஆர்டர் செய்யத் தொடரவும்';

  @override
  String get checkoutTitle => 'ஆர்டரை உறுதிசெய்தல்';

  @override
  String get checkoutContactTitle => 'விநியோகத் தொடர்பு விவரங்கள்';

  @override
  String get checkoutName => 'பெயர்';

  @override
  String get checkoutPhone => 'தொலைபேசி எண்';

  @override
  String get checkoutPhoneHelper => 'விநியோகம் பற்றி இந்த எண்ணுக்கு அழைப்போம்.';

  @override
  String get checkoutDistrict => 'மாவட்டம்';

  @override
  String get checkoutPaymentTitle => 'பணம் செலுத்தும் முறை';

  @override
  String get checkoutCodHint => 'ஆர்டர் கிடைத்ததும் பணமாகச் செலுத்துங்கள்.';

  @override
  String get checkoutSummaryTitle => 'ஆர்டர் சுருக்கம்';

  @override
  String checkoutLine(String name, String qty) {
    return '$name × $qty';
  }

  @override
  String get checkoutReviewNote =>
      'நீங்கள் ஆர்டரை அனுப்பிய பிறகு நிர்வாகி அதைச் சரிபார்ப்பார். அது நிலுவையில் இருக்கும் வரை நீங்கள் ரத்துசெய்யலாம்.';

  @override
  String get checkoutPlaceOrder => 'ஆர்டரை அனுப்பு';

  @override
  String get checkoutEmptyCart =>
      'உங்கள் கூடை காலியாக உள்ளது. ஆர்டர் செய்யும் முன் பொருட்களைச் சேர்க்கவும்.';

  @override
  String get checkoutFailed => 'உங்கள் ஆர்டரை அனுப்ப முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get checkoutStockTitle => 'போதுமான கையிருப்பு இல்லை';

  @override
  String checkoutStockMessage(String name, String available) {
    return '\"$name\" கையிருப்பில் $available மட்டுமே உள்ளது. கூடையில் அளவைக் குறைத்து மீண்டும் முயற்சிக்கவும்.';
  }

  @override
  String checkoutStockNone(String name) {
    return '\"$name\" கையிருப்பில் இல்லை. அதைக் கூடையிலிருந்து நீக்கி மீண்டும் முயற்சிக்கவும்.';
  }

  @override
  String get checkoutStockGeneric =>
      'உங்கள் கூடையில் உள்ள ஒரு பொருளுக்குப் போதுமான கையிருப்பு இல்லை. கூடையைப் புதுப்பித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get checkoutUpdateCart => 'கூடையைப் புதுப்பி';

  @override
  String get orderMyOrders => 'எனது ஆர்டர்கள்';

  @override
  String orderNumber(String id) {
    return 'ஆர்டர் #$id';
  }

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள்',
      one: '1 பொருள்',
      zero: 'பொருட்கள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String orderPlacedOn(String date) {
    return 'ஆர்டர் செய்த நாள்: $date';
  }

  @override
  String orderTotalLine(String total) {
    return 'மொத்தம்: $total';
  }

  @override
  String get orderItemsTitle => 'பொருட்கள்';

  @override
  String get orderItemsUnavailable => 'பொருள் விவரங்கள் கிடைக்கவில்லை.';

  @override
  String orderItemQty(String qty, String price) {
    return 'அளவு: $qty × $price';
  }

  @override
  String get orderAdminNote => 'நிர்வாகியின் குறிப்பு';

  @override
  String get orderCancel => 'ஆர்டரை ரத்துசெய்';

  @override
  String get orderCancelConfirmTitle => 'இந்த ஆர்டரை ரத்துசெய்யவா?';

  @override
  String orderCancelConfirmMessage(String id) {
    return 'ஆர்டர் #$id ரத்துசெய்யப்படும். இதை மாற்ற முடியாது.';
  }

  @override
  String get orderCancelConfirmYes => 'ஆம், ரத்துசெய்';

  @override
  String get orderCancelConfirmNo => 'ஆர்டரை வைத்திரு';

  @override
  String get orderCancelled => 'உங்கள் ஆர்டர் ரத்துசெய்யப்பட்டது.';

  @override
  String get orderCancelNotCancellable =>
      'இந்த ஆர்டர் ஏற்கனவே செயலாக்கப்பட்டதால் இனி ரத்துசெய்ய முடியாது.';

  @override
  String get orderWaitingReview => 'உங்கள் ஆர்டர் நிர்வாகியின் மதிப்பாய்வுக்காகக் காத்திருக்கிறது.';

  @override
  String get orderStatusApprovedMessage =>
      'உங்கள் ஆர்டர் அங்கீகரிக்கப்பட்டது. அது தயாராகிக்கொண்டிருக்கிறது.';

  @override
  String get orderStatusShippedMessage => 'உங்கள் ஆர்டர் உங்களை நோக்கி வந்துகொண்டிருக்கிறது.';

  @override
  String get orderStatusDeliveredMessage => 'உங்கள் ஆர்டர் வழங்கப்பட்டது. நன்றி!';

  @override
  String get orderStatusCancelledMessage => 'இந்த ஆர்டர் ரத்துசெய்யப்பட்டது.';

  @override
  String get orderStatusRejectedMessage =>
      'இந்த ஆர்டர் ஏற்கப்படவில்லை. நிர்வாகியின் குறிப்பைப் பாருங்கள் அல்லது உதவியைத் தொடர்புகொள்ளுங்கள்.';

  @override
  String get orderStatusOtherMessage => 'இந்த ஆர்டரின் நிலை புதுப்பிக்கப்பட்டது.';

  @override
  String orderNotifyTitle(String id, String status) {
    return 'ஆர்டர் #$id: $status';
  }

  @override
  String get orderEmptyTitle => 'இன்னும் ஆர்டர்கள் இல்லை';

  @override
  String get orderEmptyMessage => 'நீங்கள் செய்யும் ஆர்டர்கள் இங்கே தோன்றும்.';

  @override
  String get orderNotFound => 'அந்த ஆர்டரைக் கண்டுபிடிக்க முடியவில்லை.';

  @override
  String get orderSuccessTitle => 'ஆர்டர் அனுப்பப்பட்டது';

  @override
  String get orderSuccessHeading => 'நன்றி! உங்கள் ஆர்டர் பெறப்பட்டது.';

  @override
  String get orderSuccessMessage =>
      'உங்கள் ஆர்டர் எங்களுக்குக் கிடைத்தது. பொருள் கிடைத்ததும் பணமாகச் செலுத்துங்கள்.';

  @override
  String get orderSuccessNumber => 'ஆர்டர் எண்';

  @override
  String get orderViewMyOrders => 'எனது ஆர்டர்களைக் காண்க';

  @override
  String get orderContinueShopping => 'தொடர்ந்து வாங்குங்கள்';

  @override
  String get chatTitle => 'AgriBot';

  @override
  String get chatSubtitle => 'FarmFriend உதவியாளர்';

  @override
  String get chatOnline => 'இணைப்பில்';

  @override
  String get chatOffline => 'இணைப்பில்லை';

  @override
  String chatLanguageTooltip(String language) {
    return 'AgriBot $language மொழியில் பதிலளிக்கும். மாற்ற தட்டவும்.';
  }

  @override
  String get chatDisclaimer =>
      'AgriBot தவறு செய்யக்கூடும். முக்கிய முடிவுகளை உங்கள் விவசாய அதிகாரியிடம் உறுதிப்படுத்துங்கள்.';

  @override
  String get chatEmptyTitle => 'இன்று நான் உங்களுக்கு எப்படி உதவலாம்?';

  @override
  String get chatEmptyMessage =>
      'பயிர்கள், விலைகள், விதைகள் அல்லது பயிர் நோய்கள் பற்றிக் கேளுங்கள்.';

  @override
  String get chatSuggestionCrop => 'அடுத்த மாதம் நான் எந்தப் பயிரை நட வேண்டும்?';

  @override
  String get chatSuggestionPrice => 'இந்த மாதம் கேரட் விலை என்ன?';

  @override
  String get chatSuggestionSeeds => 'சந்தையில் என்ன விதைகள் உள்ளன?';

  @override
  String get chatSuggestionDisease => 'மிளகாயில் இலைச் சுருள் நோயை எப்படிக் கட்டுப்படுத்துவது?';

  @override
  String get chatInputHint => 'உங்கள் கேள்வியைத் தட்டச்சு செய்யுங்கள்…';

  @override
  String get chatSend => 'அனுப்பு';

  @override
  String get chatSending => 'அனுப்புகிறது…';

  @override
  String get chatFailedRetry => 'அனுப்பப்படவில்லை. மீண்டும் முயல தட்டவும்';

  @override
  String get chatRateLimited => 'கேள்விகள் அதிகம் — ஒரு நிமிடம் காத்திருக்கவும்.';

  @override
  String get chatTyping => 'AgriBot தட்டச்சு செய்கிறது…';

  @override
  String get chatClear => 'அரட்டையை அழி';

  @override
  String get chatClearTitle => 'இந்த அரட்டையை அழிக்கவா?';

  @override
  String get chatClearMessage => 'இந்தத் தொலைபேசியில் சேமிக்கப்பட்ட செய்திகள் நீக்கப்படும்.';

  @override
  String get chatClearConfirm => 'அழி';

  @override
  String get chatLoadEarlier => 'முந்தைய செய்திகளைக் காட்டு';

  @override
  String get chatMicHold => 'பேச அழுத்திப் பிடிக்கவும்';

  @override
  String get chatMicListening => 'கேட்கிறது… முடிந்ததும் விடுங்கள்';

  @override
  String get chatMicUnavailable => 'இந்தத் தொலைபேசியில் இந்த மொழியில் குரல் உள்ளீடு கிடைக்கவில்லை.';

  @override
  String get chatMicFailed =>
      'மைக்ரோஃபோனைத் தொடங்க முடியவில்லை. மைக்ரோஃபோன் அனுமதியை வழங்கி மீண்டும் முயலவும்.';

  @override
  String get chatSpeak => 'சத்தமாகப் படி';

  @override
  String get chatStopSpeaking => 'படிப்பதை நிறுத்து';

  @override
  String get appName => 'FarmFriend';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navMarket => 'சந்தை';

  @override
  String get navRegister => 'பதிவு';

  @override
  String get navCommunity => 'சமூகம்';

  @override
  String get navMore => 'மேலும்';

  @override
  String get commonRetry => 'மீண்டும் முயற்சி';

  @override
  String get commonOffline => 'நீங்கள் இணைப்பில் இல்லை. சேமித்த தரவு காட்டப்படுகிறது.';

  @override
  String get commonRequiresInternet => 'இதைச் செய்ய இணையத்துடன் இணையுங்கள்.';

  @override
  String get commonCancel => 'ரத்துசெய்';

  @override
  String get commonConfirm => 'உறுதிப்படுத்து';

  @override
  String get commonSave => 'சேமி';

  @override
  String get commonDelete => 'நீக்கு';

  @override
  String get commonEdit => 'திருத்து';

  @override
  String get commonClose => 'மூடு';

  @override
  String get commonDone => 'முடிந்தது';

  @override
  String get commonContinue => 'தொடரவும்';

  @override
  String get commonBack => 'பின்செல்';

  @override
  String get commonNext => 'அடுத்து';

  @override
  String get commonSkip => 'தவிர்';

  @override
  String get commonSearch => 'தேடு';

  @override
  String get commonSeeAll => 'அனைத்தையும் காண்க';

  @override
  String get commonViewAll => 'அனைத்தையும் காண்க';

  @override
  String get commonLoading => 'ஏற்றப்படுகிறது…';

  @override
  String get commonYes => 'ஆம்';

  @override
  String get commonNo => 'இல்லை';

  @override
  String get commonOk => 'சரி';

  @override
  String get commonOr => 'அல்லது';

  @override
  String get commonOptional => 'விருப்பத்திற்குரியது';

  @override
  String get commonSelect => 'தேர்ந்தெடு';

  @override
  String get commonUndo => 'செயல்தவிர்';

  @override
  String get commonNoResults => 'முடிவுகள் எதுவும் இல்லை';

  @override
  String get commonNothingHere => 'இங்கு இன்னும் எதுவும் இல்லை';

  @override
  String get commonJustNow => 'இப்போது';

  @override
  String commonMinutesAgo(int count) {
    return '$count நிமி. முன்';
  }

  @override
  String commonHoursAgo(int count) {
    return '$count மணி முன்';
  }

  @override
  String commonDaysAgo(int count) {
    return '$count நாள் முன்';
  }

  @override
  String commonUpdatedAgo(String time) {
    return 'புதுப்பிக்கப்பட்டது: $time';
  }

  @override
  String get commonMt => 'மெ.தொ.';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பதிவுகள்',
      one: '1 பதிவு',
      zero: 'பதிவுகள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get appBarCart => 'கூடை';

  @override
  String get appBarNotifications => 'அறிவிப்புகள்';

  @override
  String get appBarProfile => 'சுயவிவரம் மற்றும் அமைப்புகள்';

  @override
  String get chatFabTooltip => 'AgriBot-இடம் கேளுங்கள்';

  @override
  String get languageSwitch => 'மொழியை மாற்று';

  @override
  String get errorTitle => 'ஏதோ தவறு ஏற்பட்டது';

  @override
  String get errorNetwork =>
      'இணைய இணைப்பு இல்லை. உங்கள் வலையமைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorPermission => 'இதைச் செய்ய உங்களுக்கு அனுமதி இல்லை.';

  @override
  String get errorNotFound => 'நீங்கள் தேடியதைக் கண்டுபிடிக்க முடியவில்லை.';

  @override
  String get errorConflict =>
      'இது ஏற்கனவே செய்யப்பட்டுள்ளது அல்லது மாறியுள்ளது. புதுப்பித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorRateLimited =>
      'அதிகமான கோரிக்கைகள். ஒரு நிமிடம் காத்திருந்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorValidation => 'நீங்கள் உள்ளிட்ட விவரங்களைச் சரிபார்க்கவும்.';

  @override
  String get errorSessionExpired => 'உங்கள் அமர்வு காலாவதியாகிவிட்டது. மீண்டும் உள்நுழையவும்.';

  @override
  String get errorUnknown => 'ஏதோ தவறு ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorPageNotFound => 'இந்தப் பக்கம் இல்லை.';

  @override
  String get errorGoHome => 'முகப்புக்குச் செல்';

  @override
  String get authInvalidCredentials => 'தவறான உள்நுழைவு விவரங்கள்';

  @override
  String get authEmailNotConfirmed =>
      'முதலில் உங்கள் மின்னஞ்சலை உறுதிப்படுத்தவும். இணைப்புக்கு உங்கள் அஞ்சல்பெட்டியைப் பார்க்கவும்.';

  @override
  String get authUserExists =>
      'இந்த மின்னஞ்சல் ஏற்கனவே பதிவுசெய்யப்பட்டுள்ளது. அதற்குப் பதிலாக உள்நுழையவும்.';

  @override
  String get authWeakPassword =>
      'கடவுச்சொல் பலவீனமானது. ஒரு எழுத்தும் ஒரு எண்ணும் கொண்ட குறைந்தது 8 எழுத்துகளைப் பயன்படுத்தவும்.';

  @override
  String get authSamePassword => 'புதிய கடவுச்சொல் பழையதிலிருந்து வேறுபட்டிருக்க வேண்டும்.';

  @override
  String get authWrongPassword => 'உங்கள் தற்போதைய கடவுச்சொல் தவறானது.';

  @override
  String get authOtpExpired => 'குறியீடு காலாவதியாகிவிட்டது, புதியதை அனுப்பவும்.';

  @override
  String get authOtpInvalid => 'அந்தக் குறியீடு சரியானதல்ல. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authRateLimited => 'அதிகமான முயற்சிகள், பின்னர் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authGoogleFailed => 'Google உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get validationRequired => 'இந்தப் புலம் தேவை';

  @override
  String get validationEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get validationPassword =>
      'ஒரு எழுத்தும் ஒரு எண்ணும் கொண்ட குறைந்தது 8 எழுத்துகளைப் பயன்படுத்தவும்';

  @override
  String get validationPasswordMismatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get validationPhone => 'சரியான கைபேசி எண்ணை உள்ளிடவும் (7XXXXXXXX)';

  @override
  String get validationAmount => '2 தசம இடங்கள் வரை, 0-ஐ விட அதிகமான அளவை உள்ளிடவும்';

  @override
  String validationTooLong(int max) {
    return 'அதிகபட்சம் $max எழுத்துகளைப் பயன்படுத்தவும்';
  }

  @override
  String get statusPending => 'நிலுவையில்';

  @override
  String get statusApproved => 'அங்கீகரிக்கப்பட்டது';

  @override
  String get statusConfirmed => 'உறுதிசெய்யப்பட்டது';

  @override
  String get statusShipped => 'அனுப்பப்பட்டது';

  @override
  String get statusDelivered => 'வழங்கப்பட்டது';

  @override
  String get statusCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get statusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String get statusOpen => 'திறந்துள்ளது';

  @override
  String get statusReplied => 'பதிலளிக்கப்பட்டது';

  @override
  String get statusClosed => 'மூடப்பட்டது';

  @override
  String get statusUnknown => 'தெரியவில்லை';

  @override
  String get surplusLow => 'இடம் உள்ளது';

  @override
  String get surplusMedium => 'நிரம்பி வருகிறது';

  @override
  String get surplusHigh => 'கிட்டத்தட்ட நிரம்பியது';

  @override
  String get surplusFull => 'நிரம்பியது';

  @override
  String quotaFilledOfLimit(String filled, String limit) {
    return '$limit மெ.தொ. இல் $filled பதிவுசெய்யப்பட்டது';
  }

  @override
  String quotaRemaining(String remaining) {
    return '$remaining மெ.தொ. மீதமுள்ளது';
  }

  @override
  String get feedbackTitle => 'எங்கள் சேவை எப்படி உள்ளது?';

  @override
  String get feedbackSubtitle =>
      'உங்கள் பதில்கள் FarmFriend-ஐ மேம்படுத்த ஆராய்ச்சிக் குழுவுக்கு உதவும்.';

  @override
  String get feedbackOverall => 'ஒட்டுமொத்தமாக';

  @override
  String get feedbackEase => 'பயன்படுத்த எளிது';

  @override
  String get feedbackUsefulness => 'எனது விவசாயத்திற்குப் பயனுள்ளது';

  @override
  String get feedbackComment => 'வேறு ஏதேனும்? (விருப்பத்திற்குரியது)';

  @override
  String get feedbackSubmit => 'கருத்தை அனுப்பு';

  @override
  String get feedbackThanks => 'உங்கள் கருத்துக்கு நன்றி!';

  @override
  String get updateRequiredTitle => 'புதுப்பிப்பு தேவை';

  @override
  String get updateRequiredBody => 'தொடர புதிய பதிப்பு தேவை.';

  @override
  String get updateButton => 'புதுப்பி';

  @override
  String get updateAvailable => 'புதுப்பிப்பு உள்ளது';

  @override
  String get maintenanceTitle => 'விரைவில் திரும்புவோம்';

  @override
  String get adminBanner =>
      'நீங்கள் ஒரு நிர்வாகி. இலக்குகள், பொருட்கள் மற்றும் செய்திகளை இணைய நிர்வாகப் பலகத்தில் நிர்வகிக்கவும்.';

  @override
  String get adminBannerOpen => 'இணையப் பலகத்தைத் திற';

  @override
  String get communityWhatsOnMind => 'உங்கள் மனதில் என்ன இருக்கிறது?';

  @override
  String get communityPhoto => 'புகைப்படம்';

  @override
  String get communityActivity => 'செயல்பாடு';

  @override
  String get communityPost => 'பதிவிடு';

  @override
  String get communityLike => 'விருப்பம்';

  @override
  String get communityComment => 'கருத்து';

  @override
  String get communityShare => 'பகிர்';

  @override
  String get communityMyPosts => 'எனது பதிவுகள்';

  @override
  String get communitySavedPosts => 'சேமித்த பதிவுகள்';

  @override
  String communityMyPostsCount(String count) {
    return 'எனது பதிவுகள் ($count)';
  }

  @override
  String communitySavedPostsCount(String count) {
    return 'சேமித்த பதிவுகள் ($count)';
  }

  @override
  String get communityEmptyTitle => 'இன்னும் பதிவுகள் இல்லை';

  @override
  String get communityEmptyMessage => 'மற்ற விவசாயிகளுடன் முதலில் பகிர்பவராக இருங்கள்.';

  @override
  String get communityEmptyAction => 'பதிவை உருவாக்கு';

  @override
  String get communityMyPostsEmptyTitle => 'நீங்கள் இன்னும் பதிவிடவில்லை';

  @override
  String get communityMyPostsEmptyMessage => 'உங்கள் பதிவுகள் இங்கே தோன்றும்.';

  @override
  String get communitySavedEmptyTitle => 'சேமித்த பதிவுகள் இல்லை';

  @override
  String get communitySavedEmptyMessage =>
      'ஒரு பதிவை இங்கே வைத்திருக்க அதன் புக்மார்க்கைத் தட்டவும்.';

  @override
  String get communityLoadMore => 'மேலும் காட்டு';

  @override
  String get communityLoadMoreFailed => 'மேலும் பதிவுகளை ஏற்ற முடியவில்லை.';

  @override
  String get communityFarmer => 'விவசாயி';

  @override
  String get communitySave => 'பதிவைச் சேமி';

  @override
  String get communityUnsave => 'சேமித்தவற்றிலிருந்து நீக்கு';

  @override
  String communityCommentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கருத்துகள்',
      one: '1 கருத்து',
      zero: 'கருத்துகள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String communityLikesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count விருப்பங்கள்',
      one: '1 விருப்பம்',
      zero: 'விருப்பங்கள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get communitySeeMore => 'மேலும் காண்க';

  @override
  String get communitySeeLess => 'குறைவாகக் காண்க';

  @override
  String get communityMoreOptions => 'மேலும் விருப்பங்கள்';

  @override
  String get communityReport => 'புகாரளி';

  @override
  String communityReportSubject(String id) {
    return 'பதிவு #$id பற்றிய புகார்';
  }

  @override
  String get communityDeleteTitle => 'இந்தப் பதிவை நீக்கவா?';

  @override
  String get communityDeleteMessage => 'இதை மீட்டெடுக்க முடியாது.';

  @override
  String get communityPostDeleted => 'பதிவு நீக்கப்பட்டது';

  @override
  String get communityViewPhoto => 'புகைப்படத்தைக் காண்க';

  @override
  String get communityActivityChoose => 'நீங்கள் என்ன செய்கிறீர்கள்?';

  @override
  String get communityActivityNone => 'செயல்பாடு இல்லை';

  @override
  String get communityActivityPlanting => 'நடவு';

  @override
  String get communityActivityHarvesting => 'அறுவடை';

  @override
  String get communityActivitySelling => 'விற்பனை';

  @override
  String get communityActivityQuestion => 'கேள்வி';

  @override
  String get postCreateTitle => 'பதிவை உருவாக்கு';

  @override
  String get postEditTitle => 'பதிவைத் திருத்து';

  @override
  String get postDetailTitle => 'பதிவு';

  @override
  String get postGallery => 'கேலரி';

  @override
  String get postCamera => 'கேமரா';

  @override
  String get postRemovePhoto => 'புகைப்படத்தை நீக்கு';

  @override
  String get postPhotoFailed =>
      'புகைப்படத்தைத் திறக்க முடியவில்லை. செயலியின் அனுமதிகளைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get postPublished => 'உங்கள் பதிவு வெளியிடப்பட்டது';

  @override
  String get postUpdated => 'பதிவு புதுப்பிக்கப்பட்டது';

  @override
  String get postEditPhotoNote => 'உரையை மட்டுமே மாற்ற முடியும். புகைப்படம் அப்படியே இருக்கும்.';

  @override
  String get postNotYours => 'உங்கள் சொந்தப் பதிவுகளை மட்டுமே திருத்த முடியும்.';

  @override
  String get postComments => 'கருத்துகள்';

  @override
  String get postNoComments => 'இன்னும் கருத்துகள் இல்லை';

  @override
  String get postNoCommentsMessage => 'முதல் கருத்தை நீங்கள் பதிவிடுங்கள்.';

  @override
  String get postCommentHint => 'ஒரு கருத்தை எழுதுங்கள்…';

  @override
  String get postCommentSend => 'கருத்தை அனுப்பு';

  @override
  String get postCommentSending => 'அனுப்புகிறது…';

  @override
  String get postCommentDeleteTitle => 'இந்தக் கருத்தை நீக்கவா?';

  @override
  String get postCommentDeleted => 'கருத்து நீக்கப்பட்டது';

  @override
  String get postCommentsLoadMore => 'மேலும் கருத்துகளைக் காட்டு';

  @override
  String get postCommentHoldToDelete => 'நீக்க அழுத்திப் பிடிக்கவும்';

  @override
  String get homePill => 'ஸ்மார்ட் விவசாய முகப்புப் பலகை';

  @override
  String homeWelcome(String name) {
    return 'மீண்டும் வருக, $name';
  }

  @override
  String get homeFarmerFallback => 'விவசாயி';

  @override
  String get homeHeroText =>
      'உங்கள் பயிர் பதிவுகளைக் கண்காணிக்கவும், சந்தைப் பொருட்களைப் பார்க்கவும், விவசாயச் செய்திகளைப் படிக்கவும், AI உதவியாளரிடம் உதவி பெறவும்.';

  @override
  String get homeRegisterCrop => 'பயிரைப் பதிவுசெய்க';

  @override
  String get homeMarketplace => 'சந்தை';

  @override
  String get homeMyCrops => 'எனது பதிவுசெய்த பயிர்கள்';

  @override
  String homeTotalMt(String amount) {
    return 'மொத்தம்: $amount மெ.தொ.';
  }

  @override
  String get homeMarketItems => 'சந்தைப் பொருட்கள்';

  @override
  String get homeProductsAvailable => 'இப்போது கிடைக்கும் பொருட்கள்';

  @override
  String get homeFarmingNews => 'விவசாயச் செய்திகள்';

  @override
  String get homeLatestUpdates => 'சமீபத்திய தகவல்கள் மற்றும் எச்சரிக்கைகள்';

  @override
  String get homeCropOutlook => 'பயிர் நிலவரம்';

  @override
  String get homeCropOutlookSubtitle =>
      'ஒவ்வொரு பயிருக்கும் தேசிய ஒதுக்கீடு எவ்வளவு நிரம்பியுள்ளது';

  @override
  String homePercentFull(int percent) {
    return '$percent% நிரம்பியது';
  }

  @override
  String get homeOutlookEmpty => 'தற்போது செயலில் உள்ள பயிர் இலக்குகள் இல்லை.';

  @override
  String get homePriceOutlook => 'விலை நிலவரம்';

  @override
  String get homePriceOutlookSubtitle => 'இந்த மாத மொத்த விலையில் மிகப்பெரிய மாற்றங்கள்';

  @override
  String get homePricesEmpty => 'விலை முன்னறிவிப்புகள் இன்னும் கிடைக்கவில்லை.';

  @override
  String get homeQuickActions => 'விரைவுச் செயல்கள்';

  @override
  String get homeActionRegister => 'அறுவடையைப் பதிவுசெய்';

  @override
  String get homeActionRegisterSub => 'எதிர்பார்க்கும் பயிர் அளவைச் சேர்க்கவும்';

  @override
  String get homeActionPlan => 'இலாபத்தைத் திட்டமிடு';

  @override
  String get homeActionPlanSub => 'நடுவதற்கு முன் வருமானத்தைப் பாருங்கள்';

  @override
  String get homeActionBrowse => 'பொருட்களைப் பாருங்கள்';

  @override
  String get homeActionBrowseSub => 'விதைகள் மற்றும் விவசாயக் கருவிகளை வாங்குங்கள்';

  @override
  String get homeActionAsk => 'உதவியாளரிடம் கேளுங்கள்';

  @override
  String get homeActionAskSub => 'AgriBot-இடம் உதவி பெறுங்கள்';

  @override
  String get homeMyRegistrations => 'எனது பயிர் பதிவுகள்';

  @override
  String homeMtRegistered(String amount) {
    return '$amount மெ.தொ. பதிவுசெய்யப்பட்டது';
  }

  @override
  String get homeRegisterLink => 'பதிவுசெய்';

  @override
  String get homeNoRegistrations => 'இன்னும் பயிர்கள் பதிவுசெய்யப்படவில்லை';

  @override
  String get homeNoRegistrationsBody =>
      'உங்கள் ஒதுக்கீட்டை உறுதிசெய்ய எதிர்பார்க்கும் அறுவடையைப் பதிவுசெய்யுங்கள்.';

  @override
  String get homeLatestNews => 'சமீபத்திய விவசாயச் செய்திகள்';

  @override
  String get homeNoNews => 'இன்னும் செய்திகள் இல்லை.';

  @override
  String get homeUpdateBody => 'FarmFriend-இன் புதிய பதிப்பு கிடைக்கிறது.';

  @override
  String get marketTitle => 'சந்தை';

  @override
  String get marketSubtitle =>
      'உங்கள் பண்ணைக்குத் தேவையான விவசாயக் கருவிகள், விதைகள் மற்றும் உபகரணங்களைப் பாருங்கள்.';

  @override
  String get marketSearchHint => 'பொருட்களைத் தேடுங்கள்';

  @override
  String get marketSearchClear => 'தேடலை அழி';

  @override
  String get marketCategoryAll => 'அனைத்தும்';

  @override
  String get marketCategorySeeds => 'விதைகள்';

  @override
  String get marketCategoryTools => 'கருவிகள்';

  @override
  String get marketEmptyTitle => 'இன்னும் பொருட்கள் இல்லை';

  @override
  String get marketEmptyMessage =>
      'இப்போது இங்கே காட்ட எதுவும் இல்லை. புதுப்பிக்க கீழே இழுக்கவும்.';

  @override
  String marketEmptySearch(String query) {
    return '\"$query\" உடன் பொருந்தும் எதுவும் இல்லை. வேறு சொல்லை முயற்சிக்கவும்.';
  }

  @override
  String get marketShowAll => 'அனைத்துப் பொருட்களையும் காட்டு';

  @override
  String productInStock(String count) {
    return 'கையிருப்பு: $count';
  }

  @override
  String get productOutOfStock => 'கையிருப்பு இல்லை';

  @override
  String get productAdd => 'சேர்';

  @override
  String get productDetailTitle => 'பொருள் விவரங்கள்';

  @override
  String productWeight(String weight) {
    return 'எடை: $weight';
  }

  @override
  String get productDescription => 'விளக்கம்';

  @override
  String get productReadMore => 'மேலும் படிக்க';

  @override
  String get productShowLess => 'குறைவாகக் காட்டு';

  @override
  String get productQuantity => 'அளவு';

  @override
  String get productOutOfStockNote =>
      'இந்தப் பொருள் இப்போது கையிருப்பில் இல்லை. பின்னர் மீண்டும் பாருங்கள்.';

  @override
  String get productAddToCart => 'கூடையில் சேர்';

  @override
  String get productBuyNow => 'இப்போதே வாங்கு';

  @override
  String get moreProfileHint => 'உங்கள் சுயவிவரத்தைப் பார்த்துத் திருத்துங்கள்';

  @override
  String get moreProfileNoName => 'உங்கள் சுயவிவரம்';

  @override
  String get moreGroupFarming => 'விவசாயக் கருவிகள்';

  @override
  String get moreGroupActivity => 'எனது செயல்பாடுகள்';

  @override
  String get moreGroupApp => 'செயலி';

  @override
  String get moreNews => 'செய்திகள்';

  @override
  String get morePrices => 'பயிர் விலைகள்';

  @override
  String get morePlanner => 'இலாபத் திட்டம்';

  @override
  String get moreOutlook => 'பயிர் நிலவரம்';

  @override
  String get moreOrders => 'எனது ஆர்டர்கள்';

  @override
  String get moreQuotas => 'எனது ஒதுக்கீடுகள்';

  @override
  String get moreSupport => 'உதவியைத் தொடர்புகொள்ள';

  @override
  String get moreNotifications => 'அறிவிப்புகள்';

  @override
  String get newsTitle => 'சமீபத்திய செய்திகள்';

  @override
  String get newsSubtitle => 'விவசாய செய்திகள் மற்றும் எச்சரிக்கைகள்';

  @override
  String get newsDetailTitle => 'செய்தி';

  @override
  String get newsReadMore => 'மேலும் படிக்க';

  @override
  String get newsFilterAll => 'அனைத்தும்';

  @override
  String get newsTypeTechnology => 'தொழில்நுட்பம்';

  @override
  String get newsTypeAlert => 'எச்சரிக்கை';

  @override
  String get newsTypeGeneral => 'பொது';

  @override
  String get newsTypeDisease => 'நோய்';

  @override
  String get newsTypeMarket => 'சந்தை';

  @override
  String get newsEmptyTitle => 'இன்னும் செய்திகள் இல்லை';

  @override
  String get newsEmptyMessage => 'புதிய கட்டுரைகளும் எச்சரிக்கைகளும் இங்கே தோன்றும்.';

  @override
  String get newsLoadMore => 'மேலும் காட்டு';

  @override
  String get newsLoadMoreFailed => 'மேலும் செய்திகளை ஏற்ற முடியவில்லை.';

  @override
  String newsByAuthor(String author) {
    return 'எழுதியவர்: $author';
  }

  @override
  String get newsShare => 'பகிர்';

  @override
  String get notifEmptyTitle => 'இதுவரை அறிவிப்புகள் இல்லை';

  @override
  String get notifEmptyMessage => 'எச்சரிக்கைகளும் அறிவிப்புகளும் இங்கே தோன்றும்.';

  @override
  String get notifMarkAllRead => 'அனைத்தையும் படித்ததாகக் குறி';

  @override
  String notifUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'படிக்காதவை $count',
      one: 'படிக்காதது 1',
    );
    return '$_temp0';
  }

  @override
  String get notifNewTitle => 'புதிய அறிவிப்பு';

  @override
  String get notifUnread => 'படிக்காதது';

  @override
  String get pricesTitle => 'பயிர் விலைகள்';

  @override
  String pricesSubtitle(String date) {
    return 'மொத்த விலை முன்னறிவிப்பு · புதுப்பிக்கப்பட்டது $date';
  }

  @override
  String get pricesSubtitleNoDate => 'மொத்த விலை முன்னறிவிப்பு';

  @override
  String get pricesSearchHint => 'பயிர்களைத் தேடுக';

  @override
  String get pricesSortAz => 'அகர வரிசை';

  @override
  String get pricesSortRise => 'அதிக உயர்வு';

  @override
  String get pricesSortFall => 'அதிக சரிவு';

  @override
  String get pricesSortMargin => 'சிறந்த இலாபம்';

  @override
  String get pricesAboveFair => 'நியாய விலைக்கு மேல்';

  @override
  String get pricesBelowFair => 'நியாய விலைக்குக் கீழ்';

  @override
  String get pricesForecastPending => 'முன்னறிவிப்பு நிலுவையில்';

  @override
  String get pricesStale => 'முன்னறிவிப்பு பழையதாக இருக்கலாம்';

  @override
  String get pricesFooterNote =>
      'முன்னறிவிப்புகள் கடந்த கால விலைகள், வானிலை மற்றும் எரிபொருள் செலவுகளை அடிப்படையாகக் கொண்ட மதிப்பீடுகள். உண்மையான சந்தை விலைகள் மாறுபடலாம்.';

  @override
  String get pricesEmptyTitle => 'இதுவரை விலைகள் இல்லை';

  @override
  String get pricesEmptyBody =>
      'மாதாந்திர முன்னறிவிப்பு இயங்கிய பின் விலை முன்னறிவிப்புகள் இங்கே தோன்றும்.';

  @override
  String pricesChangeUp(String percent) {
    return 'கடந்த மாதத்தை விட $percent உயர்வு';
  }

  @override
  String pricesChangeDown(String percent) {
    return 'கடந்த மாதத்தை விட $percent சரிவு';
  }

  @override
  String get pricesChangeFlat => 'கடந்த மாதத்துடன் ஒப்பிடும்போது மாற்றம் இல்லை';

  @override
  String get pricesThisMonth => 'இந்த மாத மொத்த விலை';

  @override
  String pricesLatestActual(String month) {
    return 'சமீபத்திய சந்தை விலை ($month)';
  }

  @override
  String get pricesVsLastMonth => 'கடந்த மாதத்துடன் ஒப்பிடும்போது';

  @override
  String pricesRetail(String price) {
    return 'மதிப்பிடப்பட்ட சில்லறை விலை $price';
  }

  @override
  String get pricesTrendTitle => 'விலைப் போக்கு';

  @override
  String get pricesTrendSubtitle => 'கடந்த 24 மாதங்கள் மற்றும் அடுத்த 12 மாதங்கள்';

  @override
  String get pricesLegendActual => 'உண்மையான விலை';

  @override
  String get pricesLegendForecast => 'முன்னறிவிப்பு';

  @override
  String get pricesLegendBand => 'குறைந்தபட்ச விலை முதல் நியாய விலை வரை';

  @override
  String get pricesToday => 'இன்று';

  @override
  String get pricesChartEmpty => 'வரைபடம் வரைய இன்னும் போதுமான விலைத் தரவு இல்லை.';

  @override
  String get pricesBestMonthTitle => 'அறுவடைக்குச் சிறந்த மாதம்';

  @override
  String pricesBestMonthProfit(String profit) {
    return 'இலாபம் $profit';
  }

  @override
  String pricesPlantToHarvest(String plant, String harvest) {
    return '$harvest மாதத்தில் அறுவடை செய்ய $plant மாதத்தில் நடவு செய்யுங்கள்';
  }

  @override
  String get pricesRegisterCrop => 'இந்தப் பயிரைப் பதிவு செய்க';

  @override
  String get pricesPlanProfit => 'எனது இலாபத்தைத் திட்டமிடுக';

  @override
  String get pricesCostTitle => 'செலவும் நியாய விலையும்';

  @override
  String get pricesCostPerKg => 'உற்பத்திச் செலவு';

  @override
  String get pricesFairPrice => 'நியாய விலை (செலவு + 40%)';

  @override
  String get pricesProfitPerKg => 'ஒரு கிலோவுக்கு இலாபம்';

  @override
  String get pricesFloorPrice => 'குறைந்தபட்ச உத்தரவாத விலை';

  @override
  String get pricesQuotaTitle => 'தேசிய ஒதுக்கீடு';

  @override
  String get pricesQuotaOpen => 'பயிர் கண்ணோட்டத்தைப் பார்க்க';

  @override
  String get pricesWhyTitle => 'ஏன் இந்த விலை?';

  @override
  String get pricesWhyIntro => 'இந்த மாதத்திற்கு முன்னறிவிப்பு மாதிரி பயன்படுத்திய தரவுகள்:';

  @override
  String get pricesWhyRainfall => 'பயன்படுத்திய மழைவீழ்ச்சி';

  @override
  String pricesWhyRainfallValue(String mm) {
    return '$mm மி.மீ.';
  }

  @override
  String get pricesWhyWeather => 'வானிலைத் தாக்கம்';

  @override
  String get pricesWhyWeatherApplied => 'சேர்க்கப்பட்டது';

  @override
  String get pricesWhyWeatherNone => 'சேர்க்கப்படவில்லை';

  @override
  String get pricesWhyDiesel => 'டீசல் விலை (ஒரு லிட்டருக்கு)';

  @override
  String get pricesWhyTransport => 'போக்குவரத்துக் குறியீடு';

  @override
  String get pricesWhyCycle => 'வளர்ச்சிக் காலம்';

  @override
  String pricesWhyCycleValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மாதங்கள்',
      one: '1 மாதம்',
    );
    return '$_temp0';
  }

  @override
  String get pricesWhyModel => 'மாதிரிப் பதிப்பு';

  @override
  String get pricesWhyGenerated => 'முன்னறிவிப்பு தயாரிக்கப்பட்ட தேதி';

  @override
  String get pricesAskBot => 'AgriBot-இடம் கேளுங்கள்';

  @override
  String pricesAskPrompt(String crop, String month) {
    return '$month மாதத்தில் $crop என்ன விலைக்கு விற்கும்?';
  }

  @override
  String get pricesNotFoundTitle => 'இந்தப் பயிருக்கு விலைகள் இல்லை';

  @override
  String pricesNotFoundBody(String crop) {
    return '$crop பயிருக்கு இன்னும் விலை வரலாறோ முன்னறிவிப்போ இல்லை.';
  }

  @override
  String get plannerTitle => 'இலாபத் திட்டமிடி';

  @override
  String get plannerSubtitle => 'இவ்வளவு பயிரிட்டால் எனக்கு என்ன கிடைக்கும்?';

  @override
  String get plannerCrop => 'பயிர்';

  @override
  String get plannerCropHint => 'ஒரு பயிரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get plannerMonth => 'அறுவடை மாதம்';

  @override
  String get plannerBestMonthHint => '⭐ அறுவடைக்குச் சிறந்த மாதம்';

  @override
  String get plannerLand => 'நில அளவு';

  @override
  String get plannerLandHint => 'எ.கா. 1';

  @override
  String get plannerAcres => 'ஏக்கர்';

  @override
  String get plannerHectares => 'ஹெக்டேர்';

  @override
  String plannerLandInHa(String ha) {
    return '= $ha ஹெக்டேர்';
  }

  @override
  String get plannerPickCrop => 'திட்டத்தைத் தொடங்க ஒரு பயிரைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get plannerEnterLand => 'திட்டத்தைப் பார்க்க உங்கள் நில அளவை உள்ளிடவும்.';

  @override
  String get plannerResultTitle => 'உங்கள் திட்டம்';

  @override
  String get plannerNoYield =>
      'இந்தப் பயிருக்கும் மாதத்திற்கும் மாதிரியில் விளைச்சல் அளவு இல்லாததால் அறுவடையை மதிப்பிட முடியாது.';

  @override
  String get plannerPlantIn => 'நடவு செய்ய வேண்டிய மாதம்';

  @override
  String get plannerExpectedHarvest => 'எதிர்பார்க்கும் அறுவடை';

  @override
  String get plannerCost => 'உற்பத்திச் செலவு';

  @override
  String get plannerIncome => 'முன்னறிவிக்கப்பட்ட மொத்த விலையில் எதிர்பார்க்கும் வருமானம்';

  @override
  String get plannerProfit => 'எதிர்பார்க்கும் இலாபம்';

  @override
  String get plannerLoss => 'எதிர்பார்க்கும் நட்டம்';

  @override
  String get plannerBreakEven => 'இலாப-நட்டமற்ற விலை';

  @override
  String plannerQuotaFits(String remaining, String amount) {
    return '$remaining மெ.தொ. மீதமுள்ளது — உங்கள் $amount மெ.தொ. பொருந்தும் ✅';
  }

  @override
  String plannerQuotaExceeds(String remaining, String amount) {
    return '$remaining மெ.தொ. மீதமுள்ளது — உங்கள் $amount மெ.தொ. மீதமுள்ள ஒதுக்கீட்டை மீறுகிறது ⚠️';
  }

  @override
  String get plannerSeeAlternatives => 'இடம் உள்ள பயிர்களைப் பார்க்க';

  @override
  String get plannerCompareTitle => 'பயிர்களை ஒப்பிடுக';

  @override
  String get plannerCompareSubtitle => 'அதே நிலம் மற்றும் அறுவடை மாதம், மேலும் 3 பயிர்கள் வரை';

  @override
  String get plannerCompareAdd => 'ஒப்பிட ஒரு பயிரைச் சேர்க்க';

  @override
  String plannerCompareRemove(String crop) {
    return '$crop நீக்குக';
  }

  @override
  String get plannerCompareBest => 'அதிக இலாபம்';

  @override
  String get plannerCompareNoData =>
      '— என்பது அந்தப் பயிருக்கு இந்த மாதத்தில் முன்னறிவிப்பு இல்லை என்பதைக் குறிக்கும்.';

  @override
  String get plannerShortHarvest => 'அறுவடை';

  @override
  String get plannerShortCost => 'செலவு';

  @override
  String get plannerShortIncome => 'வருமானம்';

  @override
  String get plannerShortProfit => 'இலாபம்';

  @override
  String plannerRegisterCta(String amount, String crop) {
    return '$crop $amount மெ.தொ. பதிவு செய்க';
  }

  @override
  String get plannerDisclaimer =>
      'இவை முன்னறிவிப்பு மாதிரியின் மதிப்பீடுகள் மட்டுமே. உண்மையான அறுவடை, செலவுகள் மற்றும் சந்தை விலைகள் மாறுபடலாம்.';

  @override
  String get plannerNoForecastTitle => 'இதுவரை முன்னறிவிப்புகள் இல்லை';

  @override
  String get plannerNoForecastBody =>
      'திட்டமிடிக்கு விலை முன்னறிவிப்புகள் தேவை. இணையத்துடன் இணைந்து, புதுப்பிக்கக் கீழே இழுக்கவும்.';

  @override
  String get registerTitle => 'அறுவடை ஒதுக்கீட்டைப் பதிவு செய்க';

  @override
  String get registerAuthBadge => 'உறுதிப்படுத்தப்பட்ட விவசாயி';

  @override
  String get registerInfo => 'விலையைப் பாதுகாக்க உங்கள் பயிர்களைப் பதிவு செய்யுங்கள்.';

  @override
  String get registerSelectCrop => 'பயிரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get registerSelectCropHint => 'பயிரைத் தேர்வுசெய்ய தட்டவும்';

  @override
  String get registerCropRequired => 'தயவுசெய்து ஒரு பயிரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get registerSearchCrop => 'பயிர்களைத் தேடுக';

  @override
  String get registerNoTargets =>
      'தற்போது செயலில் உள்ள பயிர் இலக்குகள் இல்லை. பின்னர் மீண்டும் பார்க்கவும்.';

  @override
  String registerNoActiveTarget(String crop) {
    return '$crop பயிருக்கு தற்போது செயலில் உள்ள தேசிய இலக்கு இல்லை.';
  }

  @override
  String get registerLimit => 'தேசிய வரம்பு';

  @override
  String get registerFilled => 'இதுவரை பதிவானது';

  @override
  String get registerRemaining => 'மீதம்';

  @override
  String get registerFairPrice => 'நியாய விலை';

  @override
  String get registerWholesale => 'மதிப்பிடப்பட்ட மொத்த விலை';

  @override
  String get registerPlantingDate => 'நடவு தேதி';

  @override
  String get registerHarvestDate => 'இலக்கு அறுவடை தேதி';

  @override
  String registerFarmerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count விவசாயிகள் பதிவு செய்துள்ளனர்',
      one: '1 விவசாயி பதிவு செய்துள்ளார்',
      zero: 'இதுவரை விவசாயிகள் பதிவு செய்யவில்லை',
    );
    return '$_temp0';
  }

  @override
  String registerForecastTitle(String month) {
    return '$month மாதத்திற்கான மாதிரி முன்னறிவிப்பு';
  }

  @override
  String get registerForecastWholesale => 'மொத்த விலை';

  @override
  String get registerForecastProfit => 'ஒரு கிலோவுக்கு இலாபம்';

  @override
  String get registerSeeTrend => 'விலைப் போக்கைப் பார்க்க';

  @override
  String get registerAmountLabel => 'எதிர்பார்க்கும் அறுவடை அளவு (மெ.தொ.)';

  @override
  String get registerAmountHint => 'எ.கா. 100';

  @override
  String registerAmountHelper(String remaining) {
    return 'மீதமுள்ள கொள்ளளவு: $remaining மெ.தொ.';
  }

  @override
  String registerAmountMax(String max) {
    return 'அளவு $max மெ.தொ. ஐ விட அதிகமாக இருக்கக்கூடாது';
  }

  @override
  String get registerInvalidAmount =>
      'இந்த அளவு ஏற்கப்படவில்லை. சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get registerDontKnow => 'தொன் அளவு தெரியவில்லையா?';

  @override
  String get registerCheckAndRegister => 'சரிபார்த்துப் பதிவு செய்க';

  @override
  String get registerSuccessTitle => 'ஒதுக்கீடு பதிவு செய்யப்பட்டது';

  @override
  String registerSuccessBody(String amount, String crop) {
    return '$crop $amount மெ.தொ. பதிவு செய்யப்பட்டது. உங்கள் ஒதுக்கீடு உறுதியானது.';
  }

  @override
  String get registerViewQuotas => 'எனது ஒதுக்கீடுகளைப் பார்க்க';

  @override
  String get registerNoTarget =>
      'இந்தப் பயிருக்கு செயலில் உள்ள தேசிய இலக்கு இல்லை. நிர்வாகியைத் தொடர்பு கொள்ளவும்.';

  @override
  String get registerContactSupport => 'உதவியைத் தொடர்பு கொள்க';

  @override
  String get registerUnknownResult =>
      'இந்தப் பதிவை உறுதிப்படுத்த முடியவில்லை. கீழே உள்ள ‘எனது பதிவு செய்யப்பட்ட ஒதுக்கீடுகள்’ பகுதியைப் பார்க்கவும், அல்லது செயலியைப் புதுப்பித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String registerCropChanged(String crop) {
    return 'பயிர் $crop ஆக மாற்றப்பட்டது. தொடர ‘சரிபார்த்துப் பதிவு செய்க’ என்பதைத் தட்டவும்.';
  }

  @override
  String registerSurplusTitle(String crop) {
    return '$crop ஒதுக்கீடு மீறப்பட்டது';
  }

  @override
  String registerSurplusBody(String remaining) {
    return '$remaining மெ.தொ. மட்டுமே மீதமுள்ளது. அதற்கு மேல் பதிவு செய்தால் உபரி ஏற்பட்டு விலை குறையும்.';
  }

  @override
  String get registerSurplusBodyFull =>
      'இந்த ஒதுக்கீடு நிரம்பிவிட்டது. மேலும் பதிவு செய்தால் உபரி ஏற்பட்டு விலை குறையும்.';

  @override
  String registerSurplusRequested(String amount) {
    return 'நீங்கள் $amount மெ.தொ. பதிவு செய்யக் கேட்டீர்கள்.';
  }

  @override
  String get registerSurplusConfirming => 'சேவையகத்துடன் உறுதிப்படுத்துகிறது…';

  @override
  String get registerSurplusAlternatives => 'மாற்றுப் பயிர்கள்';

  @override
  String get registerSurplusNoAlternatives => 'தற்போது வேறு எந்தப் பயிருக்கும் இடம் இல்லை.';

  @override
  String registerAltWhy(String remaining, String price) {
    return '$remaining மெ.தொ. இடம் உள்ளது · நியாய விலை $price';
  }

  @override
  String registerAltWhyNoPrice(String remaining) {
    return '$remaining மெ.தொ. இடம் உள்ளது';
  }

  @override
  String get registerAltChoose => 'தேர்வு செய்க';

  @override
  String registerRemainingCta(String remaining) {
    return 'மீதமுள்ள $remaining மெ.தொ. பதிவு செய்க';
  }

  @override
  String get registerLandTitle => 'நில அளவிலிருந்து மதிப்பிடுக';

  @override
  String registerLandBody(String crop, String month) {
    return '$month மாதத்தில் அறுவடை செய்யப்படும் $crop பயிருக்கான மாதிரியின் விளைச்சலைப் பயன்படுத்துகிறது.';
  }

  @override
  String get registerLandSize => 'நில அளவு';

  @override
  String get registerLandEstimate => 'மதிப்பிடப்பட்ட அறுவடை';

  @override
  String registerLandYield(String tonnes) {
    return 'மாதிரி விளைச்சல்: ஒரு ஹெக்டேருக்கு $tonnes மெ.தொ.';
  }

  @override
  String registerLandUse(String amount) {
    return '$amount மெ.தொ. பயன்படுத்துக';
  }

  @override
  String get registerLandUseDisabled => 'உங்கள் நில அளவை உள்ளிடவும்';

  @override
  String get quotasTitle => 'எனது பதிவு செய்யப்பட்ட ஒதுக்கீடுகள்';

  @override
  String get quotasSubtitle => 'நீங்கள் உறுதிசெய்த அறுவடை ஒதுக்கீடுகள்';

  @override
  String get quotasColCrop => 'பயிர்';

  @override
  String get quotasColAmount => 'அளவு (மெ.தொ.)';

  @override
  String get quotasColDate => 'தேதி';

  @override
  String get quotasLockedNote =>
      'இந்த ஒதுக்கீடுகள் உறுதிசெய்யப்பட்டுள்ளன. பதிவுகளை மாற்ற நிர்வாகியைத் தொடர்பு கொள்ளவும்.';

  @override
  String get quotasRequestChange => 'மாற்றம் கோருக';

  @override
  String get quotasChangeSubject => 'ஒதுக்கீடு மாற்றக் கோரிக்கை';

  @override
  String get quotasEmptyTitle => 'இதுவரை ஒதுக்கீடுகள் பதிவு செய்யப்படவில்லை';

  @override
  String get quotasEmptyBody =>
      'ஒதுக்கீட்டையும் நியாய விலையையும் உறுதிசெய்ய உங்கள் எதிர்பார்க்கும் அறுவடையைப் பதிவு செய்யுங்கள்.';

  @override
  String get quotasEmptyAction => 'ஒரு பயிரைப் பதிவு செய்க';

  @override
  String get quotasTotal => 'மொத்தப் பதிவு';

  @override
  String quotasCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பயிர்கள்',
      one: '1 பயிர்',
    );
    return '$_temp0';
  }

  @override
  String get outlookTitle => 'பயிர் கண்ணோட்டம்';

  @override
  String get outlookSubtitle => 'தேசிய தேவை மற்றும் பதிவான விநியோகம்';

  @override
  String get outlookSearchHint => 'பயிர்களைத் தேடுக';

  @override
  String get outlookFilterAll => 'அனைத்தும்';

  @override
  String get outlookFilterAvailable => 'இடம் உள்ளது';

  @override
  String get outlookFilterAlmostFull => 'கிட்டத்தட்ட நிரம்பியது';

  @override
  String get outlookFilterFull => 'நிரம்பியது';

  @override
  String get outlookSortLabel => 'வரிசைப்படுத்து';

  @override
  String get outlookSortMostRoom => 'அதிக இடம்';

  @override
  String get outlookSortHighestPrice => 'அதிக விலை';

  @override
  String get outlookSortAz => 'அகர வரிசை';

  @override
  String outlookCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பயிர்கள்',
      one: '1 பயிர்',
      zero: 'பயிர்கள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String outlookFairPriceLine(String price) {
    return 'நியாய விலை: $price';
  }

  @override
  String outlookHarvestWindow(String date) {
    return 'அறுவடை: $date';
  }

  @override
  String get outlookEmptyTitle => 'செயலில் உள்ள பயிர் இலக்குகள் இல்லை';

  @override
  String get outlookEmptyBody => 'தேசிய இலக்குகள் அங்கீகரிக்கப்பட்டதும் இங்கே தோன்றும்.';

  @override
  String get outlookNoMatch => 'இந்தத் தேடலுக்கோ வடிகட்டிக்கோ பொருந்தும் பயிர்கள் இல்லை';

  @override
  String get outlookNotFoundTitle => 'செயலில் உள்ள இலக்கு இல்லை';

  @override
  String outlookNotFoundBody(String crop) {
    return '$crop பயிருக்கு தற்போது செயலில் உள்ள தேசிய இலக்கு இல்லை.';
  }

  @override
  String get outlookSeeAll => 'அனைத்துப் பயிர்களையும் பார்க்க';

  @override
  String get outlookNumbers => 'ஒதுக்கீட்டு விவரங்கள்';

  @override
  String get outlookAllowedExtent => 'அனுமதிக்கப்பட்ட பரப்பளவு';

  @override
  String outlookHectares(String amount) {
    return '$amount ஹெக்டேர்';
  }

  @override
  String get outlookPriceCompare => 'நியாய விலை மற்றும் மொத்த விலை';

  @override
  String get outlookFullNote =>
      'இந்த ஒதுக்கீடு நிரம்பிவிட்டது. உபரியைத் தவிர்க்க வேறு பயிரைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get outlookRegisterCta => 'இந்தப் பயிரைப் பதிவு செய்க';

  @override
  String outlookAskBot(String crop) {
    return '$crop பற்றி AgriBot-இடம் கேளுங்கள்';
  }

  @override
  String outlookAskPrompt(String crop) {
    return '$crop பயிரிடுவது பற்றிச் சொல்லுங்கள்: தேவை, எதிர்பார்க்கப்படும் விலை மற்றும் நடவு செய்ய வேண்டிய காலம்.';
  }

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsTabAccount => 'கணக்கு';

  @override
  String get settingsTabNotifications => 'அறிவிப்புகள்';

  @override
  String get settingsTabCredentials => 'கடவுச்சொல்';

  @override
  String get settingsGeneral => 'பொது';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsLanguageHint => 'செயலியின் மொழியைத் தேர்ந்தெடுங்கள். அது உடனே மாறும்.';

  @override
  String get settingsAbout => 'செயலி பற்றி';

  @override
  String get settingsFeedback => 'கருத்து தெரிவிக்கவும்';

  @override
  String get settingsSignOut => 'வெளியேறு';

  @override
  String get settingsSignOutConfirmTitle => 'வெளியேறவா?';

  @override
  String get settingsSignOutConfirmMessage =>
      'FarmFriend-ஐப் பயன்படுத்த நீங்கள் மீண்டும் உள்நுழைய வேண்டும்.';

  @override
  String get settingsName => 'பெயர்';

  @override
  String get settingsSurname => 'குடும்பப் பெயர்';

  @override
  String get settingsEmail => 'மின்னஞ்சல்';

  @override
  String get settingsEmailLocked => 'மின்னஞ்சலை இங்கு மாற்ற முடியாது.';

  @override
  String get settingsPhone => 'தொலைபேசி எண்';

  @override
  String get settingsType => 'வகை';

  @override
  String get settingsTypeHint => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get settingsTypeFarmer => 'விவசாயி';

  @override
  String get settingsTypeBuyer => 'வாங்குபவர்';

  @override
  String get settingsTypeOfficer => 'விவசாய அதிகாரி';

  @override
  String get settingsDistrict => 'மாவட்டம்';

  @override
  String get settingsDistrictHint => 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get settingsChangePhoto => 'படத்தை மாற்று';

  @override
  String get settingsPhotoUpdated => 'சுயவிவரப் படம் புதுப்பிக்கப்பட்டது.';

  @override
  String get settingsUpdateProfile => 'சுயவிவரத்தைப் புதுப்பி';

  @override
  String get settingsProfileUpdated => 'சுயவிவரம் புதுப்பிக்கப்பட்டது.';

  @override
  String get settingsDangerZone => 'ஆபத்துப் பகுதி';

  @override
  String get settingsDeleteAccount => 'கணக்கை நீக்கு';

  @override
  String get settingsDeleteAccountInfo =>
      'இது உங்கள் கணக்கையும் அதன் பதிவுகள், ஆர்டர்கள், இடுகைகளையும் நிரந்தரமாக நீக்கும். இதை மீட்க முடியாது.';

  @override
  String get settingsDeleteConfirmTitle => 'உங்கள் கணக்கை நீக்கவா?';

  @override
  String settingsDeleteConfirmMessage(String word) {
    return 'இதை மீட்க முடியாது. உறுதிப்படுத்த $word எனத் தட்டச்சு செய்யவும்.';
  }

  @override
  String get settingsNotifyMaster => 'அறிவிப்புகளை அனுமதி';

  @override
  String get settingsNotifyMasterHint =>
      'உபரி எச்சரிக்கைகள், ஆர்டர் நிலை மற்றும் FarmFriend பதில்கள்.';

  @override
  String get settingsNotifyDeviceTitle => 'இந்தத் தொலைபேசியில்';

  @override
  String get settingsNotifyOrders => 'ஆர்டர் புதுப்பிப்புகள்';

  @override
  String get settingsNotifyOrdersHint =>
      'உங்கள் ஆர்டர் உறுதியானபோது, அனுப்பப்பட்டபோது அல்லது வந்து சேர்ந்தபோது.';

  @override
  String get settingsNotifyCommunity => 'சமூகப் பதில்கள்';

  @override
  String get settingsNotifyCommunityHint => 'உங்கள் இடுகைக்கு யாராவது கருத்துத் தெரிவிக்கும்போது.';

  @override
  String get settingsNotifyNews => 'செய்தி அறிவிப்புகள்';

  @override
  String get settingsNotifyNewsHint => 'விவசாயச் செய்திகள், எச்சரிக்கைகள் மற்றும் அறிவித்தல்கள்.';

  @override
  String get settingsPushTitle => 'புஷ் அறிவிப்புகள்';

  @override
  String get settingsPushHint =>
      'செயலி மூடியிருந்தாலும் FarmFriend உங்களுக்கு அறிவிக்க அனுமதியுங்கள்.';

  @override
  String get settingsEnablePush => 'புஷ் அறிவிப்புகளை இயக்கு';

  @override
  String get settingsPushEnabled => 'புஷ் அறிவிப்புகள் இயக்கத்தில் உள்ளன.';

  @override
  String get settingsPushDenied =>
      'அறிவிப்புகள் தடுக்கப்பட்டுள்ளன. உங்கள் தொலைபேசி அமைப்புகளில் அனுமதியுங்கள்.';

  @override
  String get settingsChangePassword => 'கடவுச்சொல்லை மாற்று';

  @override
  String get settingsCurrentPassword => 'தற்போதைய கடவுச்சொல்';

  @override
  String get settingsNewPassword => 'புதிய கடவுச்சொல்';

  @override
  String get settingsConfirmPassword => 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get settingsUpdatePassword => 'கடவுச்சொல்லைப் புதுப்பி';

  @override
  String get settingsPasswordUpdated => 'கடவுச்சொல் புதுப்பிக்கப்பட்டது.';

  @override
  String get settingsGoogleAccount => 'நீங்கள் Google மூலம் உள்நுழைந்துள்ளீர்கள்';

  @override
  String get settingsGoogleAccountHint =>
      'மின்னஞ்சல் மூலமும் உள்நுழைய விரும்பினால் ஒரு கடவுச்சொல்லை அமைக்கவும்.';

  @override
  String get settingsSetPassword => 'கடவுச்சொல்லை அமை';

  @override
  String get settingsPasswordSet =>
      'கடவுச்சொல் சேமிக்கப்பட்டது. இனி மின்னஞ்சல் மற்றும் கடவுச்சொல் மூலம் உள்நுழையலாம்.';

  @override
  String settingsPhoneAccount(String phone) {
    return '$phone என்ற தொலைபேசி எண் மூலம் உள்நுழைந்துள்ளீர்கள்';
  }

  @override
  String get settingsAddEmailPassword => 'மின்னஞ்சல் மற்றும் கடவுச்சொல்லைச் சேர்';

  @override
  String get settingsAddEmailHint =>
      'விருப்பத்திற்குரியது. மின்னஞ்சல் முகவரி மூலமும் உள்நுழைய உதவும்.';

  @override
  String get settingsEmailPasswordAdded =>
      'சேமிக்கப்பட்டது. முகவரியை உறுதிப்படுத்த உங்கள் மின்னஞ்சலைப் பாருங்கள்.';

  @override
  String get aboutTagline => 'நடுவதற்கு முன் திட்டமிடுங்கள்.';

  @override
  String aboutVersion(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get aboutWebPortal => 'இணைய தளத்தைத் திற';

  @override
  String get aboutPrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get aboutTerms => 'பயன்பாட்டு விதிமுறைகள்';

  @override
  String get aboutLicences => 'திறந்த மூல உரிமங்கள்';

  @override
  String get aboutCreditsTitle => 'நன்றி';

  @override
  String get aboutCredits =>
      'இலங்கை விவசாயிகளுக்காக Horizon Campus ஆய்வுக் குழுவால் உருவாக்கப்பட்டது.';

  @override
  String get aboutLinkFailed => 'இணைப்பைத் திறக்க முடியவில்லை.';

  @override
  String get supportTitle => 'உதவியைத் தொடர்புகொள்ள';

  @override
  String get supportNewTitle => 'புதிய செய்தி அனுப்பு';

  @override
  String get supportNewSubtitle =>
      'நிர்வாகி உங்கள் செய்தியைப் பார்த்து, தேவைப்பட்டால் பதிலளிப்பார்.';

  @override
  String get supportSubject => 'தலைப்பு';

  @override
  String get supportSubjectHint => 'இது எதைப் பற்றியது?';

  @override
  String get supportDescription => 'விவரம்';

  @override
  String get supportDescriptionHint => 'உங்கள் பிரச்சினை அல்லது கேள்வியை விவரிக்கவும்';

  @override
  String get supportSend => 'செய்தியை அனுப்பு';

  @override
  String get supportSent => 'செய்தி அனுப்பப்பட்டது. தேவைப்பட்டால் நிர்வாகி பதிலளிப்பார்.';

  @override
  String get supportMineTitle => 'நான் அனுப்பிய செய்திகள்';

  @override
  String get supportEmpty => 'இதுவரை செய்திகள் எதுவும் அனுப்பப்படவில்லை.';

  @override
  String get supportAdminReplied => 'நிர்வாகி பதிலளித்துள்ளார்';

  @override
  String get supportNewReply => 'புதிய பதில்';

  @override
  String get supportDetailTitle => 'செய்தி விவரங்கள்';

  @override
  String get supportYourMessage => 'உங்கள் செய்தி';

  @override
  String get supportAdminReply => 'நிர்வாகியின் பதில்';

  @override
  String supportSentOn(String date) {
    return 'அனுப்பியது: $date';
  }

  @override
  String supportRepliedOn(String date) {
    return 'பதிலளித்தது: $date';
  }

  @override
  String get supportNoReplyYet =>
      'இன்னும் பதில் இல்லை. நிர்வாகி உங்கள் செய்தியைப் பார்த்து, தேவைப்பட்டால் பதிலளிப்பார்.';

  @override
  String get supportReplyNotifTitle => 'உங்கள் செய்திக்கு நிர்வாகி பதிலளித்துள்ளார்';

  @override
  String get weatherTitle => 'வானிலை';

  @override
  String weatherTemp(String value) {
    return '$value°C';
  }

  @override
  String get weatherCardUnavailable => 'வானிலை தகவல் இல்லை';

  @override
  String get weatherHumidity => 'ஈரப்பதம்';

  @override
  String get weatherWind => 'காற்று';

  @override
  String weatherWindValue(String value) {
    return 'மணிக்கு $value கி.மீ.';
  }

  @override
  String get weatherRainChance => 'மழை வாய்ப்பு';

  @override
  String get weatherAdviceTitle => 'வயல் வேலைக்கான ஆலோசனை';

  @override
  String get weatherAdviceAvoidSpraying => 'இன்று தெளிப்பதைத் தவிர்க்கவும்';

  @override
  String get weatherAdviceAvoidSprayingDetail =>
      'இன்று மழை பெய்யக்கூடும். பூச்சிக்கொல்லியும் உரமும் பலன் தரும் முன் கழுவப்பட்டுவிடலாம்.';

  @override
  String get weatherAdviceIrrigate => 'அதிகாலை அல்லது மாலையில் நீர் பாய்ச்சவும்';

  @override
  String get weatherAdviceIrrigateDetail =>
      'இன்று வெப்பம் மிக அதிகம். நீர் வீணாகாமல் இருக்க குளிர்ந்த நேரத்தில் பயிர்களுக்கு நீர் பாய்ச்சுங்கள்.';

  @override
  String get weatherAdviceGood => 'வயல் வேலைக்கு நல்ல நாள்';

  @override
  String get weatherAdviceGoodDetail => 'இன்று கனமழையோ கடும் வெப்பமோ எதிர்பார்க்கப்படவில்லை.';

  @override
  String get weatherHourlyTitle => 'மழை வாய்ப்பு — அடுத்த 24 மணி நேரம்';

  @override
  String get weatherHourlyEmpty => 'மணிநேர மழைத் தகவல் தற்போது கிடைக்கவில்லை.';

  @override
  String weatherHourlyTooltip(String time, String percent) {
    return '$time · $percent';
  }

  @override
  String get weatherDailyTitle => '7 நாள் முன்னறிவிப்பு';

  @override
  String get weatherDailyEmpty => '7 நாள் முன்னறிவிப்பு தற்போது கிடைக்கவில்லை.';

  @override
  String get weatherToday => 'இன்று';

  @override
  String weatherHighLow(String high, String low) {
    return '$high° / $low°';
  }

  @override
  String get weatherLocationHint =>
      'உங்கள் சுயவிவரத்தில் உள்ள மாவட்டத்திற்கான வானிலை காட்டப்படுகிறது.';

  @override
  String get weatherChangeDistrict => 'மாவட்டத்தை மாற்று';

  @override
  String get weatherSource => 'வானிலைத் தரவு: Open-Meteo.com';

  @override
  String get weatherCondClear => 'தெளிவான வானம்';

  @override
  String get weatherCondPartlyCloudy => 'ஓரளவு மேகமூட்டம்';

  @override
  String get weatherCondCloudy => 'மேகமூட்டம்';

  @override
  String get weatherCondFog => 'மூடுபனி';

  @override
  String get weatherCondDrizzle => 'சிறு மழை';

  @override
  String get weatherCondRain => 'மழை';

  @override
  String get weatherCondShowers => 'இடைவிட்ட மழை';

  @override
  String get weatherCondSnow => 'பனி';

  @override
  String get weatherCondThunderstorm => 'இடியுடன் கூடிய மழை';

  @override
  String get weatherCondUnknown => 'வானிலை';
}
