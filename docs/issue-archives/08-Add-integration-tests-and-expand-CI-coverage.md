Description:
Add automated integration tests and expand CI configurations so the repo enforces code quality and test coverage.

Implementation details:
- Add integration tests for scanning, product lookup (mocking Keepa), watchlist workflows (local and Supabase), and push notification flows.
- Expand `.github/workflows/flutter_ci.yml` to run Flutter analyze, unit tests, widget tests, and integration tests (Android/iOS emulators or using `integration_test` plugin).
- Add code coverage reporting and publish the coverage artifact in CI.
- Add a linting step (e.g., `dart format` and `flutter analyze`) and pre-commit hook in `.githooks` or using Husky-like tools.

Tests:
- Integration test for scanning workflow that simulates a camera scan and asserts navigation to product detail.
- Integration test for watchlist persistence and Supabase sync (mock or using test Supabase instance).

Acceptance criteria:
- CI pipeline runs on PRs and must pass all tests and analysis before merging.
- Code coverage is reported and fails the pipeline if coverage drops below a threshold (e.g., 60% baseline for now).
