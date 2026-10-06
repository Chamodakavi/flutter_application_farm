# FarmFriend — mobile app

Farmer app for crop demand, price forecasting and surplus prevention, with the
AgriBot assistant. Flutter + Riverpod on the same Supabase project as the web
app. English, සිංහල and தமிழ்.

The full specification is [docs/FarmFriend_Mobile_Architecture.md](docs/FarmFriend_Mobile_Architecture.md).
This README covers how to run and work on the code.

## Run it

1. Install Flutter (stable, 3.47 or newer) and add it to your PATH.
2. Create `env/dev.json` from `env/example.json` and fill in the two required
   values from the web app's `.env.local`:

   | Key | Take it from |
   |---|---|
   | `SUPABASE_URL` | `NEXT_PUBLIC_SUPABASE_URL` |
   | `SUPABASE_PUBLISHABLE_KEY` | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY` |
   | `GOOGLE_WEB_CLIENT_ID` (optional) | `GOOGLE_CLIENT_ID` — the **web** client ID |

   Only public values go in these files. The Google client secret, service-role
   key and n8n URL never belong in the app. `env/*.json` is gitignored.
3. Run:

   ```bash
   flutter pub get
   flutter run --dart-define-from-file=env/dev.json
   ```

Started without the env file, the app shows a "not configured" screen instead
of crashing.

## Everyday commands

```bash
flutter analyze
flutter test                                   # unit + widget tests
dart run build_runner build                    # after editing a @freezed model
flutter gen-l10n                               # after editing lib/l10n/*.arb
flutter build appbundle --release --dart-define-from-file=env/prod.json \
  --obfuscate --split-debug-info=build/symbols
```

The integration test needs a device and a **staging** test account — see the
header of `integration_test/app_flow_test.dart`.

## How the code is organised

```
lib/
  main.dart, bootstrap.dart, app.dart   start-up, error handlers, MaterialApp.router
  core/        config, theme, router, Supabase, cache, errors, l10n helpers,
               analytics, notifications and the shared widget catalogue
  features/    one folder per feature: data/ (repository) → domain/ (models)
               → presentation/ (controllers, screens, widgets)
  l10n/        app_en.arb, app_si.arb, app_ta.arb (+ generated classes)
```

Rules the code follows:

- Screen → Riverpod controller → repository → Supabase. Widgets never call
  Supabase. Repositories throw `AppException`; `context.showError(e)` turns it
  into localized text.
- Business rules that must match the web (quota check, order placement) are
  Postgres RPCs; the app only calls them.
- No hard-coded user-facing strings: add a key to all three ARB files.
- Row Level Security is the security boundary. Client checks are UX only, and
  the app never sends `u_role`.
- Riverpod providers are written by hand (no `riverpod_generator`); only the
  data models use code generation (freezed + json_serializable).

## What the backend must provide

The app is coded against the contract in spec §7: the tables, the
`feed_posts` and `crop_price_overview` views, the RPCs `get_bucket_status`,
`register_harvest`, `place_order`, `cancel_order`, the Edge Functions
`agribot-chat` and `delete-account`, and the `post-images` / `avatars` storage
buckets. Supabase dashboard settings (redirect URLs
`lk.farmfriend.app://login-callback` and `lk.farmfriend.app://reset-password`,
Google client IDs, phone provider, realtime tables) are listed in spec §4.3.

Until a piece exists, the screen that needs it shows its error state with
Retry; nothing else is affected.

## Still to set up outside the code

- **Application ID.** `lk.farmfriend.app` is a placeholder in
  `android/app/build.gradle.kts` and the iOS project. Choose the final one
  before the first Play upload — it cannot change afterwards.
- **Google Sign-In (native).** Create Android and iOS OAuth clients (spec
  §8.4), add all client IDs to Supabase → Auth → Google, put the web client ID
  in `env/*.json`, and add the reversed iOS client ID to
  `ios/Runner/Info.plist` (there is a marked placeholder). Without
  `GOOGLE_WEB_CLIENT_ID` the app falls back to the browser sign-in flow.
- **Push notifications (Firebase).** The code is in place but stays switched
  off until Firebase is configured: run `flutterfire configure`, which adds
  `google-services.json`, `GoogleService-Info.plist` and the Google Services
  Gradle plugin. In-app realtime notifications work without it.
- **Release signing.** Create the upload keystore and `android/key.properties`
  (spec §20.1). Until then release builds are signed with the debug key.
- **App Links.** Shared web links open the app only after
  `/.well-known/assetlinks.json` (Android) and `apple-app-site-association`
  (iOS) are published on the web host (spec §9.3).
- **Crash reporting.** Set `SENTRY_DSN` in the env file to turn Sentry on.
- **Translations.** The Sinhala and Tamil strings need a native-speaker review
  before release.

## Deviations from the spec

- Package versions are the current stable ones (Riverpod 3, go_router 18,
  freezed 4), newer than the baselines in spec §2.1.
- `flutter_markdown` is discontinued; `flutter_markdown_plus` replaces it.
- OTP autofill uses Flutter's built-in one-time-code autofill instead of the
  `sms_autofill` plugin.
- Weather uses the district of the profile; there is no GPS option because the
  spec's package list has no location plugin.
- Checkout asks only for the phone number: `orders` has no address column.
- Community cards open the post to comment (no inline comment box on each
  card), and editing a post changes its text only, not its photo.
- The product grid sizes its cards from the text height instead of a fixed
  0.62 aspect ratio, so Sinhala and Tamil labels fit at large text sizes.

## Assumptions to confirm with the backend owner

These follow spec §22 and the notes of each feature; the app degrades
gracefully (empty or error state) where one does not hold.

- `get_bucket_status()` returns `year`, `month`, `planting_date` and
  `allowed_extent_ha`; they drive the forecast context and the land → tonnes
  helper on the Register screen.
- One active national target per crop (`register_harvest` takes only a crop
  name), and the same UPPERCASE crop spellings in targets, registrations and
  forecasts.
- `order_items.order_id` has a foreign key to `orders.id` (orders are read with
  their items embedded).
- `feed_posts` computes `liked_by_me` / `saved_by_me` from `auth.uid()`;
  `post_likes` and `saved_posts` are unique per `(user_id, post_id)`; deleting
  a post cascades to its likes, comments and saves.
- Comment author names need a `comments.user_id → users` relationship that
  farmers may read; without it other people's comments show as "Farmer".
- Farmers may read their own `n8n_chat_histories` rows and update
  `complaints.read_at`.
- The web portal serves `/privacy` and `/terms` (linked from About).
