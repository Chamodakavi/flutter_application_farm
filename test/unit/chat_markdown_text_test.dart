import 'package:farmfriend/features/chatbot/data/speech_services.dart';
import 'package:farmfriend/features/chatbot/domain/markdown_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stripMarkdown', () {
    test('leaves plain text alone', () {
      expect(stripMarkdown('Plant beans next month.'), 'Plant beans next month.');
      expect(stripMarkdown('  spaced   out  '), 'spaced out');
      expect(stripMarkdown(''), '');
    });

    test('removes emphasis marks but keeps the words', () {
      expect(
        stripMarkdown('**Carrot** is *almost* __full__ and _risky_.'),
        'Carrot is almost full and risky.',
      );
      expect(
        stripMarkdown('***Very*** important, ~~not~~ optional'),
        'Very important, not optional',
      );
    });

    test('keeps arithmetic and snake_case untouched', () {
      expect(stripMarkdown('2 * 3 * 4 = 24'), '2 * 3 * 4 = 24');
      expect(stripMarkdown('use crop_price_forecasts table'), 'use crop_price_forecasts table');
    });

    test('removes headings, quotes and rules', () {
      expect(
        stripMarkdown('## Prices this month ##\n\n> Check with your officer\n\n---\nDone'),
        'Prices this month\n\nCheck with your officer\n\nDone',
      );
    });

    test('flattens bullet, numbered and task lists', () {
      expect(stripMarkdown('- Beans\n* Leeks\n+ Carrot'), 'Beans\nLeeks\nCarrot');
      expect(stripMarkdown('1. Prepare soil\n2) Sow seeds'), '1. Prepare soil\n2. Sow seeds');
      expect(stripMarkdown('- [x] Watered\n- [ ] Fertilised'), 'Watered\nFertilised');
    });

    test('keeps link and image text, drops the addresses', () {
      expect(
        stripMarkdown('See [the market](https://farmfriend.lk/market) today.'),
        'See the market today.',
      );
      expect(
        stripMarkdown('![Carrot seeds](https://x.test/c.png) in stock'),
        'Carrot seeds in stock',
      );
      expect(stripMarkdown('Visit <https://farmfriend.lk> now'), 'Visit now');
    });

    test('unwraps code and HTML', () {
      expect(stripMarkdown('Run `register` now'), 'Run register now');
      expect(stripMarkdown('```dart\nfinal a = 1;\n```\nafter'), 'final a = 1;\nafter');
      expect(stripMarkdown('Line one<br>Line <b>two</b>'), 'Line oneLine two');
    });

    test('reads table rows as lists and skips the divider', () {
      expect(
        stripMarkdown('| Crop | Price |\n|------|------:|\n| Carrot | 240 |\n| Beans | 310 |'),
        'Crop, Price\nCarrot, 240\nBeans, 310',
      );
    });

    test('works on Sinhala and Tamil text', () {
      expect(stripMarkdown('**කැරට්** මිල රු. 240\n- බෝංචි'), 'කැරට් මිල රු. 240\nබෝංචි');
      expect(stripMarkdown('### விலை\n*கேரட்* ரூ. 240'), 'விலை\nகேரட் ரூ. 240');
    });

    test('collapses the gaps left behind', () {
      expect(stripMarkdown('One\n\n\n\n---\n\n\nTwo'), 'One\n\nTwo');
    });
  });

  group('speech locales', () {
    test('map the app language to recognition and voice locales', () {
      expect(sttLocaleFor('si'), 'si_LK');
      expect(sttLocaleFor('ta'), 'ta_LK');
      expect(sttLocaleFor('en'), 'en_US');
      expect(ttsLocaleFor('si'), 'si-LK');
      expect(ttsLocaleFor('ta'), 'ta-IN');
      expect(ttsLocaleFor('en'), 'en-US');
    });

    test('pickSpeechLocale prefers the exact locale in either spelling', () {
      expect(pickSpeechLocale('si', ['en_US', 'si_LK']), 'si_LK');
      expect(pickSpeechLocale('si', ['en-US', 'si-LK']), 'si-LK');
      expect(pickSpeechLocale('en', ['en_GB', 'en_US']), 'en_US');
    });

    test('pickSpeechLocale falls back to the same language elsewhere', () {
      expect(pickSpeechLocale('ta', ['en_US', 'ta_IN', 'ta_SG']), 'ta_IN');
      expect(pickSpeechLocale('en', ['en_GB']), 'en_GB');
    });

    test('pickSpeechLocale gives null when the language is not on the device', () {
      expect(pickSpeechLocale('si', ['en_US', 'hi_IN', 'sin_XX']), isNull);
      expect(pickSpeechLocale('ta', const []), isNull);
    });
  });
}
