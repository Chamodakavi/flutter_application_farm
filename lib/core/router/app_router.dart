import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

import '../../features/app_gate/presentation/maintenance_screen.dart';
import '../../features/app_gate/presentation/update_required_screen.dart';
import '../../features/auth/presentation/check_email_screen.dart';
import '../../features/auth/presentation/complete_profile_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/language_select_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/phone_login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/cart/presentation/checkout_screen.dart';
import '../../features/cart/presentation/order_success_screen.dart';
import '../../features/cart/presentation/orders_screen.dart';
import '../../features/chatbot/presentation/chat_screen.dart';
import '../../features/community/presentation/community_screen.dart';
import '../../features/community/presentation/create_post_screen.dart';
import '../../features/community/presentation/my_posts_screen.dart';
import '../../features/community/presentation/post_detail_screen.dart';
import '../../features/community/presentation/saved_posts_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/marketplace/presentation/marketplace_screen.dart';
import '../../features/marketplace/presentation/product_detail_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/news/presentation/news_detail_screen.dart';
import '../../features/news/presentation/news_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/prices/presentation/price_detail_screen.dart';
import '../../features/prices/presentation/prices_screen.dart';
import '../../features/prices/presentation/profit_planner_screen.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/registration/presentation/crop_outlook_detail_screen.dart';
import '../../features/registration/presentation/crop_outlook_screen.dart';
import '../../features/registration/presentation/my_quotas_screen.dart';
import '../../features/registration/presentation/register_quota_screen.dart';
import '../../features/settings/presentation/about_screen.dart';
import '../../features/settings/presentation/account_settings_screen.dart';
import '../../features/settings/presentation/credentials_screen.dart';
import '../../features/settings/presentation/language_settings_screen.dart';
import '../../features/settings/presentation/notification_settings_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/support/presentation/complaint_detail_screen.dart';
import '../../features/support/presentation/contact_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../config/app_config_provider.dart';
import '../config/env.dart';
import '../l10n/l10n_ext.dart';
import '../l10n/locale_provider.dart';
import '../supabase/supabase_providers.dart';
import '../widgets/widgets.dart';
import 'routes.dart';
import 'shell_scaffold.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Reachable without a session.
const _publicRoutes = {
  Routes.splash,
  Routes.language,
  Routes.onboarding,
  Routes.login,
  Routes.phoneLogin,
  Routes.otp,
  Routes.signup,
  Routes.checkEmail,
  Routes.forgot,
  Routes.reset,
};

/// What the guard needs to know, decoupled from Riverpod so the decision
/// table can be unit-tested.
class GuardState {
  const GuardState({
    required this.gate,
    required this.languageChosen,
    required this.signedIn,
    required this.recoveringPassword,
    required this.profileLoaded,
    required this.profileFailed,
    required this.profileComplete,
  });

  final AppGate gate;
  final bool languageChosen;
  final bool signedIn;
  final bool recoveringPassword;
  final bool profileLoaded;
  final bool profileFailed;
  final bool profileComplete;
}

/// The redirect rules from spec §8.2 plus the version gate (§11.33). Returns
/// the location to go to, or null to stay on [location].
String? guardRedirect(GuardState s, String location) {
  if (s.gate == AppGate.maintenance) {
    return location == Routes.maintenance ? null : Routes.maintenance;
  }
  if (s.gate == AppGate.updateRequired) {
    return location == Routes.updateRequired ? null : Routes.updateRequired;
  }
  if (location == Routes.maintenance || location == Routes.updateRequired) return Routes.splash;

  if (!s.languageChosen) return location == Routes.language ? null : Routes.language;

  if (!s.signedIn) return _publicRoutes.contains(location) ? null : Routes.login;

  if (s.recoveringPassword) return location == Routes.reset ? null : Routes.reset;

  if (!s.profileLoaded) {
    // Still loading: stay (splash or the tapped button shows progress). On
    // failure the splash offers Retry and Sign out.
    return s.profileFailed && location != Routes.splash ? Routes.splash : null;
  }
  if (!s.profileComplete) {
    return location == Routes.completeProfile ? null : Routes.completeProfile;
  }
  if (_publicRoutes.contains(location) || location == Routes.completeProfile) return Routes.home;
  return null;
}

/// Re-runs the guard whenever auth, profile, language or the version gate
/// change.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref
      ..listen(authStateProvider, (_, next) {
        if (next.value?.event == AuthChangeEvent.passwordRecovery) {
          ref.read(passwordRecoveryProvider.notifier).start();
        }
        notifyListeners();
      })
      ..listen(profileProvider, (_, _) => notifyListeners())
      ..listen(localeControllerProvider, (_, _) => notifyListeners())
      ..listen(appGateProvider, (_, _) => notifyListeners())
      ..listen(passwordRecoveryProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);

  GuardState read() {
    final profile = ref.read(profileProvider);
    return GuardState(
      gate: ref.read(appGateProvider),
      languageChosen: ref.read(localeControllerProvider.notifier).hasUserChoice,
      signedIn: ref.read(supabaseClientProvider).auth.currentSession != null,
      recoveringPassword: ref.read(passwordRecoveryProvider),
      profileLoaded: profile.value != null,
      profileFailed: profile.hasError && !profile.isLoading,
      profileComplete: profile.value?.isProfileComplete ?? false,
    );
  }

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    observers: [if (Env.sentryDsn.isNotEmpty) SentryNavigatorObserver()],
    redirect: (context, state) {
      // Supabase consumes its own auth deep links (login-callback,
      // reset-password); they are not app routes.
      final uri = state.uri;
      if (uri.host == 'login-callback' ||
          uri.host == 'reset-password' ||
          uri.path.contains('login-callback') ||
          uri.path.contains('reset-password')) {
        return Routes.splash;
      }
      return guardRedirect(read(), state.matchedLocation);
    },
    errorBuilder: (context, state) => const _NotFoundScreen(),
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.splash),
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.language, builder: (_, _) => const LanguageSelectScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: Routes.login,
        builder: (_, _) => const LoginScreen(),
        routes: [
          GoRoute(path: 'phone', builder: (_, _) => const PhoneLoginScreen()),
          GoRoute(
            path: 'otp',
            builder: (_, state) =>
                OtpScreen(phoneDigits: state.uri.queryParameters['phone'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: Routes.signup,
        builder: (_, _) => const SignupScreen(),
        routes: [
          GoRoute(
            path: 'check-email',
            builder: (_, state) => CheckEmailScreen(email: state.uri.queryParameters['email']),
          ),
        ],
      ),
      GoRoute(path: Routes.forgot, builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(path: Routes.reset, builder: (_, _) => const ResetPasswordScreen()),
      GoRoute(path: Routes.completeProfile, builder: (_, _) => const CompleteProfileScreen()),
      GoRoute(path: Routes.updateRequired, builder: (_, _) => const UpdateRequiredScreen()),
      GoRoute(path: Routes.maintenance, builder: (_, _) => const MaintenanceScreen()),

      // --- Bottom-navigation shell (spec §9.1) -------------------------------
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => ShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, _) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'weather',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, _) => const WeatherScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.market,
                builder: (_, state) => MarketplaceScreen(
                  key: ValueKey(state.uri.query),
                  initialCategory: state.uri.queryParameters['category'],
                  initialQuery: state.uri.queryParameters['q'],
                ),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, state) =>
                        ProductDetailScreen(productId: _int(state.pathParameters['id'])),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.register,
                builder: (_, state) => RegisterQuotaScreen(
                  key: ValueKey(state.uri.query),
                  initialCrop: state.uri.queryParameters['crop'],
                  initialAmount: double.tryParse(state.uri.queryParameters['amount'] ?? ''),
                ),
                routes: [
                  GoRoute(
                    path: 'my-quotas',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, _) => const MyQuotasScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.community,
                builder: (_, _) => const CommunityScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, state) => CreatePostScreen(
                      editPostId: int.tryParse(state.uri.queryParameters['edit'] ?? ''),
                    ),
                  ),
                  GoRoute(
                    path: 'mine',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, _) => const MyPostsScreen(),
                  ),
                  GoRoute(
                    path: 'saved',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, _) => const SavedPostsScreen(),
                  ),
                  GoRoute(
                    path: 'post/:id',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (_, state) => PostDetailScreen(
                      postId: _int(state.pathParameters['id']),
                      focusComment: state.uri.queryParameters['comment'] == '1',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.more, builder: (_, _) => const MoreScreen())],
          ),
        ],
      ),

      // --- Full-screen destinations ------------------------------------------
      GoRoute(
        path: Routes.outlook,
        builder: (_, state) => CropOutlookScreen(
          availableOnly: state.uri.queryParameters['filter'] == 'available',
        ),
        routes: [
          GoRoute(
            path: ':crop',
            builder: (_, state) =>
                CropOutlookDetailScreen(cropName: state.pathParameters['crop'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: Routes.prices,
        builder: (_, _) => const PricesScreen(),
        routes: [
          GoRoute(
            path: ':crop',
            builder: (_, state) => PriceDetailScreen(cropName: state.pathParameters['crop'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: Routes.planner,
        builder: (_, state) => ProfitPlannerScreen(
          initialCrop: state.uri.queryParameters['crop'],
          initialMonth: state.uri.queryParameters['month'],
        ),
      ),
      GoRoute(
        path: Routes.news,
        builder: (_, _) => const NewsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => NewsDetailScreen(newsId: _int(state.pathParameters['id'])),
          ),
        ],
      ),
      GoRoute(
        path: Routes.cart,
        builder: (_, _) => const CartScreen(),
        routes: [
          GoRoute(path: 'checkout', builder: (_, _) => const CheckoutScreen()),
          GoRoute(
            path: 'success/:orderId',
            builder: (_, state) =>
                OrderSuccessScreen(orderId: _int(state.pathParameters['orderId'])),
          ),
        ],
      ),
      GoRoute(
        path: Routes.orders,
        builder: (_, state) =>
            OrdersScreen(openOrderId: int.tryParse(state.uri.queryParameters['open'] ?? '')),
      ),
      GoRoute(
        path: Routes.support,
        builder: (_, state) => ContactScreen(initialSubject: state.uri.queryParameters['subject']),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) =>
                ComplaintDetailScreen(complaintId: _int(state.pathParameters['id'])),
          ),
        ],
      ),
      GoRoute(path: Routes.notifications, builder: (_, _) => const NotificationsScreen()),
      GoRoute(
        path: Routes.chat,
        builder: (_, state) => ChatScreen(initialPrompt: state.uri.queryParameters['prompt']),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'account', builder: (_, _) => const AccountSettingsScreen()),
          GoRoute(path: 'notifications', builder: (_, _) => const NotificationSettingsScreen()),
          GoRoute(path: 'credentials', builder: (_, _) => const CredentialsScreen()),
          GoRoute(path: 'language', builder: (_, _) => const LanguageSettingsScreen()),
          GoRoute(path: 'about', builder: (_, _) => const AboutScreen()),
        ],
      ),
    ],
  );

  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
});

int _int(String? value) => int.tryParse(value ?? '') ?? 0;

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.appName,
    body: EmptyState(
      icon: Icons.explore_off_outlined,
      title: context.l10n.errorPageNotFound,
      actionLabel: context.l10n.errorGoHome,
      onAction: () => context.go(Routes.home),
    ),
  );
}
