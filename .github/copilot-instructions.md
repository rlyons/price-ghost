# Copilot instructions for Price Ghost

This file contains guidance for the Copilot agent when working in the Price Ghost repo.

- Use Riverpod for state management (flutter_riverpod 3.0)
- Implement scanner using mobile_scanner
- Keepa API integration in `lib/services/keepa_service.dart` (use environment variable for key)
- Tests are in `/test` folder and use flutter_test and mockito
- CI is configured in `.github/workflows/flutter_ci.yml`
