/// Route paths (spec §9.2). Shared links on the web domain use the same paths,
/// so deep links map straight onto these.
abstract final class Routes {
  // Start-up and auth
  static const splash = '/splash';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const phoneLogin = '/login/phone';
  static const otp = '/login/otp';
  static const signup = '/signup';
  static const checkEmail = '/signup/check-email';
  static const forgot = '/forgot';
  static const reset = '/reset';
  static const completeProfile = '/complete-profile';
  static const updateRequired = '/update-required';
  static const maintenance = '/maintenance';

  // Bottom-navigation tabs
  static const home = '/home';
  static const market = '/market';
  static const register = '/register';
  static const community = '/community';
  static const more = '/more';

  // Inside tabs
  static const weather = '/home/weather';
  static const myQuotas = '/register/my-quotas';
  static const communityNew = '/community/new';
  static const communityMine = '/community/mine';
  static const communitySaved = '/community/saved';

  // Full-screen destinations
  static const outlook = '/outlook';
  static const news = '/news';
  static const cart = '/cart';
  static const checkout = '/cart/checkout';
  static const orders = '/orders';
  static const support = '/support';
  static const notifications = '/notifications';
  static const chat = '/chat';
  static const prices = '/prices';
  static const planner = '/planner';
  static const settings = '/settings';
  static const settingsAccount = '/settings/account';
  static const settingsNotifications = '/settings/notifications';
  static const settingsCredentials = '/settings/credentials';
  static const settingsLanguage = '/settings/language';
  static const settingsAbout = '/settings/about';

  // --- Parameterised paths ---------------------------------------------------

  static String product(int id) => '/market/product/$id';
  static String post(int id, {bool focusComment = false}) =>
      '/community/post/$id${focusComment ? '?comment=1' : ''}';
  static String editPost(int id) => '/community/new?edit=$id';
  static String newsDetail(int id) => '/news/$id';
  static String orderSuccess(int orderId) => '/cart/success/$orderId';
  static String ordersWith(int orderId) => '/orders?open=$orderId';
  static String complaint(int id) => '/support/$id';
  static String outlookCrop(String crop) => '/outlook/${Uri.encodeComponent(crop)}';
  static String priceDetail(String crop) => '/prices/${Uri.encodeComponent(crop)}';

  /// Marketplace pre-filtered by category and/or search text.
  static String marketWith({String? category, String? query}) =>
      _withQuery(market, {'category': category, 'q': query});

  /// Register screen with the crop (database key) and amount prefilled.
  static String registerWith({String? crop, double? amountMt}) =>
      _withQuery(register, {'crop': crop, 'amount': amountMt?.toString()});

  /// Crop Outlook filtered to crops that still have room.
  static const outlookAvailable = '/outlook?filter=available';

  /// Profit Planner prefilled; [month] is `yyyy-MM`.
  static String plannerWith({String? crop, String? month}) =>
      _withQuery(planner, {'crop': crop, 'month': month});

  /// AgriBot chat with the question typed in for the user.
  static String chatWith(String prompt) => _withQuery(chat, {'prompt': prompt});

  /// Contact Support with the subject prefilled.
  static String supportWith(String subject) => _withQuery(support, {'subject': subject});

  static String otpFor(String digits) => _withQuery(otp, {'phone': digits});
  static String checkEmailFor(String email) => _withQuery(checkEmail, {'email': email});

  static String _withQuery(String path, Map<String, String?> params) {
    final clean = {
      for (final e in params.entries)
        if (e.value != null && e.value!.isNotEmpty) e.key: e.value!,
    };
    return clean.isEmpty ? path : Uri(path: path, queryParameters: clean).toString();
  }
}
