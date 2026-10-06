/// Supabase table and view names. Exact — the web app depends on them (spec §6).
abstract final class Tables {
  static const users = 'users',
      nationalTargets = 'national_targets',
      farmerRegistrations = 'farmer_registrations',
      cropRegistrations = 'crop_registrations',
      productionLimits = 'production_limits',
      products = 'products',
      cart = 'cart',
      orders = 'orders',
      orderItems = 'order_items',
      news = 'news',
      posts = 'posts',
      feedPosts = 'feed_posts',
      postLikes = 'post_likes',
      comments = 'comments',
      savedPosts = 'saved_posts',
      notifications = 'notifications',
      complaints = 'complaints',
      chatHistories = 'n8n_chat_histories',
      priceForecasts = 'crop_price_forecasts',
      priceHistory = 'crop_price_history',
      priceOverview = 'crop_price_overview',
      appConfig = 'app_config',
      deviceTokens = 'device_tokens',
      analyticsEvents = 'analytics_events',
      appFeedback = 'app_feedback';
}

/// Postgres functions (spec §7.2).
abstract final class Rpc {
  static const getBucketStatus = 'get_bucket_status',
      registerHarvest = 'register_harvest',
      placeOrder = 'place_order',
      cancelOrder = 'cancel_order',
      isAdmin = 'is_admin';
}

/// Edge Functions (spec §7.4).
abstract final class EdgeFn {
  static const agribotChat = 'agribot-chat', deleteAccount = 'delete-account';
}

/// Storage buckets (spec §7.5 — confirm names with web).
abstract final class Buckets {
  static const postImages = 'post-images', avatars = 'avatars';
}

/// Deep-link targets registered in Supabase Auth → URL Configuration (spec §4.3).
abstract final class DeepLinks {
  static const scheme = 'lk.farmfriend.app';
  static const loginCallback = '$scheme://login-callback';
  static const resetPassword = '$scheme://reset-password';
}

abstract final class AppConst {
  static const pageSize = 20;
  static const currency = 'LKR';
  static const chatTimeout = Duration(seconds: 45);
  static const networkTimeout = Duration(seconds: 20);

  /// Display estimate only; `app_config.shipping_fee_lkr` overrides it and the
  /// total returned by `place_order` always wins.
  static const shippingFee = 350.0;

  static const surplusMediumRatio = 0.6;
  static const surplusHighRatio = 0.85;

  static const maxPostLength = 2000;
  static const maxHarvestMt = 10000.0;
  static const forecastStaleAfter = Duration(days: 45);
}
