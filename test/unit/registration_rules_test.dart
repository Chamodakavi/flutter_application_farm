import 'package:farmfriend/features/registration/domain/bucket_rules.dart';
import 'package:farmfriend/features/registration/domain/bucket_status.dart';
import 'package:farmfriend/features/registration/domain/register_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'registration_fakes.dart';

void main() {
  group('SurplusLevel.fromRatio (spec §13.2)', () {
    test('default thresholds: <60% low, 60–85% medium, 85–100% high, ≥100% full', () {
      expect(SurplusLevel.fromRatio(0), SurplusLevel.low);
      expect(SurplusLevel.fromRatio(0.599), SurplusLevel.low);
      expect(SurplusLevel.fromRatio(0.6), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.849), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.85), SurplusLevel.high);
      expect(SurplusLevel.fromRatio(0.999), SurplusLevel.high);
      expect(SurplusLevel.fromRatio(1), SurplusLevel.full);
      expect(SurplusLevel.fromRatio(1.4), SurplusLevel.full);
    });

    test('thresholds can be overridden from app_config', () {
      expect(SurplusLevel.fromRatio(0.55, medium: 0.5, high: 0.9), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.87, medium: 0.5, high: 0.9), SurplusLevel.medium);
      expect(SurplusLevel.fromRatio(0.9, medium: 0.5, high: 0.9), SurplusLevel.high);
    });
  });

  group('BucketStatus', () {
    test('level follows the fill ratio', () {
      expect(bucket('CARROT', filled: 100).level, SurplusLevel.low);
      expect(bucket('CARROT', filled: 600).level, SurplusLevel.medium);
      expect(bucket('CARROT', filled: 850).level, SurplusLevel.high);
      expect(bucket('CARROT', filled: 1000).level, SurplusLevel.full);
      expect(bucket('CARROT', filled: 1200).level, SurplusLevel.full);
    });

    test('a crop without a limit counts as full', () {
      final b = bucket('CARROT', limit: 0);
      expect(b.fillRatio, 1);
      expect(b.isFull, isTrue);
    });

    test('fits compares against the remaining quota', () {
      final b = bucket('CARROT', filled: 960);
      expect(b.fits(40), isTrue);
      expect(b.fits(40.01), isFalse);
    });

    test('parses the RPC row, tolerating numeric strings', () {
      final b = BucketStatus.fromJson({
        'crop_name': 'CARROT',
        'target_limit_mt': '1000',
        'filled_mt': 250.5,
        'remaining_mt': '749.5',
        'farmer_count': 12,
        'target_fair_price': '140',
        'estimated_wholesale_price': null,
        'target_harvest_date': 'March 2027',
        'planting_date': '2026-12-01',
        'year': 2027,
        'month': 3,
      });
      expect(b.limitMt, 1000);
      expect(b.remainingMt, 749.5);
      expect(b.fairPrice, 140);
      expect(b.wholesalePrice, isNull);
      expect(b.harvestMonth, DateTime(2027, 3));
    });
  });

  group('SurplusThresholds', () {
    test('uses the configured ratios', () {
      const thresholds = SurplusThresholds(medium: 0.5, high: 0.7);
      expect(thresholds.levelOf(bucket('CARROT', filled: 550)), SurplusLevel.medium);
      expect(thresholds.levelOf(bucket('CARROT', filled: 750)), SurplusLevel.high);
      expect(thresholds.levelOf(bucket('CARROT', filled: 1000)), SurplusLevel.full);
    });

    test('a broken config falls back to BucketStatus.level', () {
      const broken = SurplusThresholds(medium: 0.9, high: 0.5);
      expect(broken.isValid, isFalse);
      final b = bucket('CARROT', filled: 700);
      expect(broken.levelOf(b), b.level);
      expect(broken.levelOf(b), SurplusLevel.medium);
    });
  });

  group('RegisterResult.fromJson (spec §7.2)', () {
    test('success', () {
      final r = RegisterResult.fromJson({
        'status': 'success',
        'registration_id': 42,
        'crop_name': 'CARROT',
        'remaining_mt': '860',
      });
      expect(r, isA<RegisterSuccess>());
      r as RegisterSuccess;
      expect(r.registrationId, 42);
      expect(r.cropName, 'CARROT');
      expect(r.remainingMt, 860);
    });

    test('surplus_warning with alternatives', () {
      final r = RegisterResult.fromJson({
        'status': 'surplus_warning',
        'crop_name': 'CARROT',
        'limit_mt': 1000,
        'filled_mt': 960,
        'remaining_mt': 40,
        'alternatives': [
          {'crop_name': 'BEANS', 'remaining_mt': 500, 'target_fair_price': 120},
          {'crop_name': 'LEEKS', 'remaining_mt': '75.5'},
        ],
      });
      expect(r, isA<RegisterSurplus>());
      r as RegisterSurplus;
      expect(r.limitMt, 1000);
      expect(r.filledMt, 960);
      expect(r.remainingMt, 40);
      expect(r.alternatives, hasLength(2));
      expect(r.alternatives.first.cropName, 'BEANS');
      expect(r.alternatives.first.fairPrice, 120);
      expect(r.alternatives.last.remainingMt, 75.5);
      expect(r.alternatives.last.fairPrice, isNull);
    });

    test('surplus_warning without alternatives defaults to an empty list', () {
      final r = RegisterResult.fromJson({'status': 'surplus_warning', 'remaining_mt': 0});
      expect((r as RegisterSurplus).alternatives, isEmpty);
    });

    test('no_target', () {
      expect(RegisterResult.fromJson({'status': 'no_target'}), isA<RegisterNoTarget>());
    });

    test('invalid_amount', () {
      expect(RegisterResult.fromJson({'status': 'invalid_amount'}), isA<RegisterInvalid>());
    });

    test('a status this app version does not know becomes unknown', () {
      expect(RegisterResult.fromJson({'status': 'farmer_cap_reached'}), isA<RegisterUnknown>());
    });
  });

  group('preCheckSurplus (instant client-side check)', () {
    final buckets = [
      bucket('CARROT', filled: 960, fairPrice: 140),
      bucket('BEANS', filled: 500, fairPrice: 120),
      bucket('LEEKS', filled: 990),
      bucket('CABBAGE', filled: 1000),
    ];

    test('null when the amount fits or the crop is not cached', () {
      expect(preCheckSurplus(buckets, 'CARROT', 40), isNull);
      expect(preCheckSurplus(buckets, 'TOMATOES', 40), isNull);
      expect(preCheckSurplus(const [], 'CARROT', 40), isNull);
    });

    test('warns with cached numbers and suggests crops that can take the amount', () {
      final warning = preCheckSurplus(buckets, 'carrot', 100)!;
      expect(warning.cropName, 'CARROT');
      expect(warning.limitMt, 1000);
      expect(warning.remainingMt, 40);
      expect(warning.alternatives.map((a) => a.cropName), ['BEANS']);
      expect(warning.alternatives.single.fairPrice, 120);
    });

    test('falls back to any crop with room; never suggests full crops', () {
      final warning = preCheckSurplus(buckets, 'CARROT', 5000)!;
      expect(warning.alternatives.map((a) => a.cropName), ['BEANS', 'LEEKS']);
    });
  });

  test('sortForPicker puts roomy crops first and full crops last', () {
    final sorted = sortForPicker([
      bucket('CABBAGE', filled: 1000),
      bucket('LEEKS', filled: 990),
      bucket('BEANS', filled: 500),
    ]);
    expect(sorted.map((b) => b.cropName), ['BEANS', 'LEEKS', 'CABBAGE']);
  });

  test('registrableRemainder never rounds above what is left', () {
    expect(registrableRemainder(40), 40);
    expect(registrableRemainder(12.349), 12.34);
    expect(registrableRemainder(0.004), 0);
    expect(registrableRemainder(-5), 0);
  });

  test('amountFieldText keeps at most two decimals and drops a trailing .0', () {
    expect(amountFieldText(100), '100');
    expect(amountFieldText(8.09372), '8.09');
    expect(amountFieldText(12.5), '12.5');
  });

  test('OutlookFilter matches surplus levels', () {
    expect(OutlookFilter.all.matches(SurplusLevel.full), isTrue);
    expect(OutlookFilter.available.matches(SurplusLevel.low), isTrue);
    expect(OutlookFilter.available.matches(SurplusLevel.medium), isTrue);
    expect(OutlookFilter.available.matches(SurplusLevel.high), isFalse);
    expect(OutlookFilter.almostFull.matches(SurplusLevel.high), isTrue);
    expect(OutlookFilter.full.matches(SurplusLevel.full), isTrue);
    expect(OutlookFilter.full.matches(SurplusLevel.high), isFalse);
  });

  group('free-text dates (target_harvest_date / planting_date)', () {
    setUpAll(initializeDateFormatting);

    test('formats parseable text', () {
      expect(formatLooseDate('2027-03-15', 'en'), '15 Mar 2027');
      expect(formatLooseDate('2027-03-15T00:00:00Z', 'en'), '15 Mar 2027');
      expect(formatLooseDate('15/03/2027', 'en'), '15 Mar 2027');
      expect(formatLooseDate('15 March 2027', 'en'), '15 Mar 2027');
      expect(formatLooseDate('2027-03', 'en'), 'March 2027');
      expect(formatLooseDate('March 2027', 'en'), 'March 2027');
      expect(formatLooseDate('Mar 2027', 'en'), 'March 2027');
    });

    test('keeps the raw text when it is not a date, null when empty', () {
      expect(formatLooseDate('Mid March (Yala)', 'en'), 'Mid March (Yala)');
      expect(formatLooseDate('  ', 'en'), isNull);
      expect(formatLooseDate(null, 'en'), isNull);
    });

    test('targetMonth prefers year/month, then the parsed text', () {
      expect(bucket('CARROT', year: 2027, month: 3).targetMonth, DateTime(2027, 3));
      expect(bucket('CARROT', harvestDate: '2027-04-20').targetMonth, DateTime(2027, 4));
      expect(bucket('CARROT', harvestDate: 'soon').targetMonth, isNull);
    });
  });
}
