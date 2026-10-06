import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/errors/error_mapper.dart';
import 'package:farmfriend/core/l10n/crop_labels.dart';
import 'package:farmfriend/core/notifications/push_service.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/core/supabase/storage_service.dart';
import 'package:farmfriend/core/utils/app_status.dart';
import 'package:farmfriend/core/utils/formatters.dart';
import 'package:farmfriend/core/utils/json_utils.dart';
import 'package:farmfriend/core/utils/validators.dart';
import 'package:farmfriend/features/auth/presentation/otp_screen.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() async {
    loadTestLabels();
    await initializeDateFormatting();
  });

  group('Fmt', () {
    test('money matches the web formats', () {
      expect(Fmt.rs(160), 'Rs. 160.00');
      expect(Fmt.rs(1130), 'Rs. 1,130.00');
      expect(Fmt.lkr(650), 'LKR 650');
      expect(Fmt.lkr(1130.5), 'LKR 1,130.5');
      expect(Fmt.perKg(245), 'Rs. 245/kg');
      expect(Fmt.rs(null), '—');
    });

    test('amounts use up to two decimals', () {
      expect(Fmt.mt(66), '66 MT');
      expect(Fmt.mt(66.256), '66.26 MT');
      expect(Fmt.amount(1200), '1,200');
      expect(Fmt.percent(-8.24), '8.2%');
    });

    test('dates are formatted, never raw ISO, and follow the locale', () {
      final d = DateTime(2026, 10, 5, 9, 41);
      expect(Fmt.date(d, 'en'), '5 Oct 2026');
      expect(Fmt.monthYear(DateTime(2027, 3), 'en'), 'March 2027');
      expect(Fmt.date(d, 'si'), isNot(contains('Oct')));
      expect(Fmt.date(d, 'ta'), isNot(contains('Oct')));
      expect(Fmt.date(null, 'en'), '—');
    });

    test('titleCase turns database crop keys into names', () {
      expect(Fmt.titleCase('ASH PLANTAINS'), 'Ash Plantains');
      expect(Fmt.titleCase('carrot'), 'Carrot');
    });
  });

  group('Validators', () {
    test('Sri Lankan mobile numbers', () {
      for (final ok in ['771234567', '0771234567', '+94771234567', '077 123 4567']) {
        expect(Validators.isPhone(ok), isTrue, reason: ok);
      }
      for (final bad in ['', '12345', '0112345678', '+9477123456', '77123456a']) {
        expect(Validators.isPhone(bad), isFalse, reason: bad);
      }
      expect(Validators.normalizePhone('0771234567'), '+94771234567');
      expect(Validators.normalizePhone('771234567'), '+94771234567');
      expect(Validators.normalizePhone('abc'), isNull);
      expect(Validators.isMobileDigits('771234567'), isTrue);
      expect(Validators.isMobileDigits('0771234567'), isFalse);
    });

    test('password needs 8 characters, a letter and a number', () {
      expect(Validators.isStrongPassword('farm2026'), isTrue);
      expect(Validators.isStrongPassword('farmfarm'), isFalse);
      expect(Validators.isStrongPassword('12345678'), isFalse);
      expect(Validators.isStrongPassword('f1'), isFalse);
    });

    test('harvest amount: positive, max two decimals, capped', () {
      expect(Validators.isAmount('100'), isTrue);
      expect(Validators.isAmount('0.25'), isTrue);
      expect(Validators.isAmount('0'), isFalse);
      expect(Validators.isAmount('-5'), isFalse);
      expect(Validators.isAmount('1.234'), isFalse);
      expect(Validators.isAmount('10001'), isFalse);
      expect(Validators.isAmount('abc'), isFalse);
    });

    test('email', () {
      expect(Validators.isEmail('farmer@example.com'), isTrue);
      expect(Validators.isEmail('farmer@'), isFalse);
      expect(Validators.isEmail('farmer example.com'), isFalse);
    });
  });

  group('tolerant parsing', () {
    test('AppStatus.fromDb ignores case and unknown values', () {
      expect(AppStatus.fromDb('Pending'), AppStatus.pending);
      expect(AppStatus.fromDb('APPROVED'), AppStatus.approved);
      expect(AppStatus.fromDb(' cancelled '), AppStatus.cancelled);
      expect(AppStatus.fromDb('Canceled'), AppStatus.cancelled);
      expect(AppStatus.fromDb('On hold'), AppStatus.unknown);
      expect(AppStatus.fromDb(null), AppStatus.unknown);
    });

    test('SurplusLevel thresholds (spec 13.2)', () {
      expect(SurplusLevel.fromRatio(0.59), SurplusLevel.low);
      expect(SurplusLevel.fromRatio(0.6), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.84), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.85), SurplusLevel.high);
      expect(SurplusLevel.fromRatio(0.99), SurplusLevel.high);
      expect(SurplusLevel.fromRatio(1), SurplusLevel.full);
      // Thresholds can be tuned from app_config.
      expect(SurplusLevel.fromRatio(0.5, medium: 0.4, high: 0.7), SurplusLevel.medium);
    });

    test('varchar and numeric columns', () {
      expect(asInt('12'), 12);
      expect(asInt('12.0'), 12);
      expect(asInt(null), 0);
      expect(asInt('n/a'), 0);
      expect(asDouble('3.5'), 3.5);
      expect(asDoubleOrNull(''), isNull);
      expect(asStringList(['a', null, 'b']), ['a', 'b']);
      expect(asStringList('{a,"b c"}'), ['a', 'b c']);
      expect(asStringList(null), isEmpty);
      expect(asBool('true'), isTrue);
      expect(asBool(0), isFalse);
    });
  });

  group('CropLabels', () {
    test('localizes database keys and fixes model spellings', () {
      expect(CropLabels.forLocale('en', 'DRUMSTIC'), 'Drumstick');
      expect(CropLabels.forLocale('en', 'RADDISH'), 'Radish');
      expect(CropLabels.forLocale('si', 'CARROT'), 'කැරට්');
      expect(CropLabels.forLocale('ta', 'TOMATOES'), 'தக்காளி');
      // Unknown crops fall back to Title Case English.
      expect(CropLabels.forLocale('si', 'SWEET POTATO'), 'Sweet Potato');
    });

    test('search matches any language', () {
      expect(CropLabels.matches('CARROT', 'කැර'), isTrue);
      expect(CropLabels.matches('CARROT', 'car'), isTrue);
      expect(CropLabels.matches('CARROT', 'bean'), isFalse);
      expect(CropLabels.knownCrops, hasLength(14));
    });
  });

  group('AppConfig version gate', () {
    test('compareVersions', () {
      expect(compareVersions('1.0.0', '1.0.1'), lessThan(0));
      expect(compareVersions('1.2.0', '1.10.0'), lessThan(0));
      expect(compareVersions('2.0.0', '1.9.9'), greaterThan(0));
      expect(compareVersions('1.0.0+12', '1.0.0'), 0);
      expect(compareVersions('1.0', '1.0.0'), 0);
    });

    test('requiresUpdate / hasUpdate / maintenance', () {
      const config = AppConfig(minSupportedVersion: '1.2.0', latestVersion: '1.4.0');
      expect(config.requiresUpdate('1.1.9'), isTrue);
      expect(config.requiresUpdate('1.2.0'), isFalse);
      expect(config.hasUpdate('1.3.0'), isTrue);
      expect(config.hasUpdate('1.4.0'), isFalse);
      expect(const AppConfig().requiresUpdate('0.0.1'), isFalse);
      expect(const AppConfig(maintenanceMessage: '  ').inMaintenance, isFalse);
      expect(const AppConfig(maintenanceMessage: 'Back at 6').inMaintenance, isTrue);
      expect(const AppConfig().shippingFee, 350);
    });

    test('parses the app_config row', () {
      final config = AppConfig.fromJson({
        'min_supported_version': '1.0.0',
        'shipping_fee_lkr': '400',
        'surplus_medium_ratio': 0.5,
        'chat_limit_per_min': 10,
      });
      expect(config.shippingFee, 400);
      expect(config.mediumRatio, 0.5);
      expect(config.highRatio, 0.85);
    });
  });

  group('error mapping', () {
    test('Postgres codes', () {
      expect(
        mapError(const PostgrestException(message: 'denied', code: '42501')),
        isA<PermissionFailure>(),
      );
      expect(
        mapError(const PostgrestException(message: 'dup', code: '23505')),
        isA<ConflictFailure>(),
      );
      expect(
        mapError(const PostgrestException(message: 'none', code: 'PGRST116')),
        isA<NotFoundFailure>(),
      );
    });

    test('auth errors keep their code', () {
      final byCode = mapError(const AuthException('x', code: 'invalid_credentials'));
      expect(byCode, const AppException.auth('invalid_credentials'));
      final byMessage = mapError(const AuthException('Invalid login credentials'));
      expect(byMessage, const AppException.auth('invalid_credentials'));
    });

    test('AppException passes through and unknowns are wrapped', () {
      expect(mapError(const AppException.notFound()), isA<NotFoundFailure>());
      expect(mapError(StateError('boom')), isA<UnknownFailure>());
    });
  });

  group('deep links', () {
    test('push payloads map to routes (TC_PUSH_01)', () {
      expect(PushService.routeFor({'type': 'surplus', 'crop': 'CARROT'}), '/outlook/CARROT');
      expect(
        PushService.routeFor({'type': 'surplus', 'crop': 'ASH PLANTAINS'}),
        '/outlook/ASH%20PLANTAINS',
      );
      expect(PushService.routeFor({'type': 'order', 'order_id': '8'}), '/orders?open=8');
      expect(PushService.routeFor({'type': 'complaint', 'complaint_id': 3}), '/support/3');
      expect(PushService.routeFor({'type': 'broadcast'}), Routes.notifications);
      expect(PushService.routeFor({'route': '/prices/CARROT'}), '/prices/CARROT');
      expect(PushService.routeFor({}), Routes.notifications);
    });

    test('route helpers encode parameters', () {
      expect(Routes.registerWith(crop: 'BITTER GOURD'), '/register?crop=BITTER+GOURD');
      expect(Routes.registerWith(), '/register');
      expect(Routes.plannerWith(crop: 'CARROT', month: '2027-03'), '/planner?crop=CARROT&month=2027-03');
      expect(Uri.parse(Routes.chatWith('Price of carrot?')).queryParameters['prompt'], 'Price of carrot?');
      expect(Routes.post(5, focusComment: true), '/community/post/5?comment=1');
    });
  });

  test('post image thumbnails', () {
    const url = 'https://x.supabase.co/storage/v1/object/public/post-images/uid/abc.jpg';
    expect(StorageService.thumbUrl(url), url.replaceFirst('abc.jpg', 'abc_thumb.jpg'));
    // Images uploaded from the web (other buckets/paths) are left untouched.
    expect(StorageService.thumbUrl('https://example.com/a.png'), 'https://example.com/a.png');
  });

  test('OTP resend limiter allows three resends per ten minutes', () {
    final limiter = OtpResendLimiter();
    final t0 = DateTime(2026, 1, 1, 10);
    for (var i = 0; i < 3; i++) {
      expect(limiter.canResend('771234567', t0), isTrue);
      limiter.record('771234567', t0);
    }
    expect(limiter.canResend('771234567', t0.add(const Duration(minutes: 5))), isFalse);
    expect(limiter.canResend('779999999', t0), isTrue);
    expect(limiter.canResend('771234567', t0.add(const Duration(minutes: 11))), isTrue);
  });

  group('AppUser', () {
    test('profile is complete with name and phone', () {
      expect(const AppUser(id: '1', name: 'Nimal', phone: '+94771234567').isProfileComplete, isTrue);
      expect(const AppUser(id: '1', name: 'Nimal').isProfileComplete, isFalse);
      expect(const AppUser(id: '1', name: '  ', phone: '+94771234567').isProfileComplete, isFalse);
    });

    test('parses a users row and never needs u_role from the app', () {
      final user = AppUser.fromJson({
        'id': 'abc',
        'u_name': 'Nimal',
        'u_surname': 'Perera',
        'u_tel': '+94771234567',
        'u_role': 'Admin',
        'u_notify': false,
      });
      expect(user.displayName, 'Nimal Perera');
      expect(user.initial, 'N');
      expect(user.isAdmin, isTrue);
      expect(user.notify, isFalse);
      expect(AppUser.fromJson({'id': 'x'}).role, 'farmer');
    });
  });
}
