Description:
Integrate analytics and crash reporting to gain insights and monitor app health.

Implementation details:
- Add Firebase Analytics integration and events for key actions (scan success, view product, add to watchlist, purchase).
- Add crash reporting with Sentry or Firebase Crashlytics, integrate into release builds.
- Use logging in services and attach user context for better debugging.

Tests:
- Manual tests verifying that events are logged and crash reports appear in the dashboard.

Acceptance criteria:
- Analytics events show up in Firebase Analytics or chosen analytics platform for dev builds.
- Crash reports appear when triggered by a sample crash; bucket and user context align correctly.
