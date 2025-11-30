Description:
Create a server-side process that checks watchlist items' prices periodically and sends push notifications via FCM when specified conditions are met.

Implementation details:
- Implement a Cloud Function (Node.js or Python) or Supabase scheduled function that:
  - Queries watchlist table for watchers and thresholds.
  - Calls Keepa/UPC fallback for current price.
  - Evaluates prediction rules; if price drops by configured % or triggers a 'BUY NOW' signal, send a notification via a push service (FCM/OneSignal).
- The Cloud Function should be idempotent, paginated, and handle rate limits.
- Add database fields: `user_id`, `ean`, `target_price`, `last_notified_at`, `notification_frequency`.
- Provide a secure configuration for API keys and FCM server keys.

Tests to add:
- Unit tests for the pricing logic that determine when to notify.
- Integration tests or mock tests to ensure the function handles paginated watchlist and pushes notifications.

Acceptance criteria:
- Cloud Function triggers on a schedule and evaluates watchlist entries.
- Notifications are sent with title/body and a deep link to the app product detail.
- Function respects `last_notified_at` & `notification_frequency` and avoids duplicate notifications.
- Documentation update describing the function and how to deploy it.
