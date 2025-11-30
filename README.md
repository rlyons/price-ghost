# Price Ghost

Price Ghost is a cross-platform Flutter prototype that scans product barcodes and looks up price history and price-change alerts.

## Features
- Barcode scanning (mobile_scanner)
- Price history chart (Keepa integration or demo fallback)
- Watchlist (local or Supabase-backed)
- Push notifications (Firebase Messaging + local notifications) - placeholder
- Modern UI elements (glassmorphism card, animated scan brackets)

## Setup

1. Install Flutter 3.24+ and Dart 3.5

```bash
flutter --version
```

2. Clone the repo and install dependencies

```bash
cd price-ghost
flutter pub get
```

3. Provide API keys and run the app

- Keepa API (optional, for real price data):
	```bash
	export KEEPA_API_KEY="your_keepa_key"
	flutter run --dart-define=KEEPA_API_KEY=$KEEPA_API_KEY
	```
- Supabase (optional, for server-side watchlist & persistence):
	```bash
	export SUPABASE_URL="https://xyzcompany.supabase.co"
	export SUPABASE_KEY="public-anon-key"
	flutter run --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_KEY=$SUPABASE_KEY
	```
- Note: For Firebase Messaging, add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and follow FlutterFire setup:
	https://firebase.flutter.dev/docs/overview

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on:

- Setting up your development environment
- Creating issues using our templates
- Submitting pull requests
- Code style and testing requirements
- Security best practices

### Issue Templates

We provide several issue templates in `.github/ISSUE_TEMPLATE/`:
- **Bug Report**: For reporting bugs and issues
- **Feature Request**: For proposing new features
- **Documentation**: For documentation improvements
- **Question**: For asking questions about the project

### Archived Issues

Detailed feature implementation plans are archived in `docs/issue-archives/` for reference when working on major features.

### Developer Scripts

Helper scripts are available in `scripts/dev/`:
- `create_repo_and_push.sh`: Create GitHub repo and push code
- `create_github_issues.sh`: Create issues from archived templates

These require the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

## Local testing

```bash
flutter test
flutter analyze
```

## How it works
- The scanner screen uses `mobile_scanner` to detect barcodes and triggers Keepa lookups via a `KeepaService` provider.
- A `WatchlistService` persists local watchlist entries to `shared_preferences`. If configured, Supabase can store/retrieve watchlist entries.
- `NotificationService` uses Firebase Messaging and local notifications to show alerts (foreground and background handlers are placeholders and need proper cloud scheduling for reliable push notifications).

## Notes & Next Steps

- Keepa is optional. If you don't have a key, the demo fallback provides synthetic price data.
- To enable Supabase, create a `watches` table with columns: `ean` (text), `user_id` (text, optional), and `created_at` (timestamp).
- For production: implement server-side background checks, proper API call parsing for Keepa, rate limit handling, and secure key storage.
- See [open issues](https://github.com/rlyons/price-ghost/issues) for planned features and improvements.
