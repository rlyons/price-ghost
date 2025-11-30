Title: Add more watchlist UI features: item details, thresholds, notification settings, and bulk actions

Description:
Enhance watchlist screen to be usable as a full feature set for managing watches:
- Add product details to watchlist entries (title, thumbnail, current price).
- Support setting a target price, percentage threshold, or a rule (e.g., 'notify if price < $X' or drop >= Y%).
- Add notification preferences per watchlist item (frequency, channels).
- Implement bulk actions: clear all, bulk set thresholds, export list, import list.

Implementation details:
- Update watchlist table schema and add fields for thresholds and notifications.
- Enhance `WatchlistService` and provider to save thresholds & notification metadata locally and to Supabase if configured.
- Add UI components: watchlist card with details, a modal for editing thresholds, bulk action menu.

Tests:
- Unit tests for threshold logic and notification scheduling.
- Widget tests for the watchlist detail UI and modal.

Acceptance criteria:
- Users can set thresholds and notification preferences per watchlist item.
- Bulk actions function: select multiple items and set/remove thresholds.
- Changes persist and are synced with Supabase when logged in.
