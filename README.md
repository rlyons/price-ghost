# Price Ghost

A cross-platform Flutter app (iOS + Android) prototype for scanning barcodes to fetch price history and set watch alerts.

## Setup

1. Ensure Flutter 3.24+ and Dart 3.5 are installed and configured:

```bash
flutter --version
```

2. Install dependencies and run the app:

```bash
cd price-ghost
flutter pub get
flutter run
```

3. Provide API keys & GitHub repository initialization

API key:
- Add NAMES: use `flutter_dotenv` or `--dart-define` to provide your `KEEPA_API_KEY` securely. Example (local run):
	```bash
	export KEEPA_API_KEY="your_keepa_key_here"
	flutter run --dart-define=KEEPA_API_KEY=$KEEPA_API_KEY
	```

GitHub repo initialization (use the GitHub CLI):

```bash
cd price-ghost
git init
git add .
git commit -m "Initial commit: Price Ghost Flutter app skeleton"
# Create public repo and push
gh repo create price-ghost --public --source=. --remote=origin --push
```

## Notes
- Keepa API key placeholder is in `lib/services/keepa_service.dart`. Replace it with a real key and store keys securely using environment variables or `flutter_dotenv` and not in code.
- This skeleton includes a placeholder scanner screen that simulates barcode scans.
- Run tests:

```bash
flutter test
```

## Next steps
- Implement full scanner integration (mobile_scanner) and live camera feed
- Implement Keepa API integration
- Add Supabase watchlist logic and Firebase messaging for push notifications
