Description:
Implement Supabase-based authentication and persist watchlist entries server-side. Ensure local watchlist syncs with server when authenticated, and merge logic handles conflicts.

Implementation details:
- Add `supabase_flutter` auth flows (Sign-up, Sign-in, Sign-out) in `lib/services/auth_service.dart`.
- Update `SupabaseService` to include watchlist CRUD for a specific `user_id`.
- Update `WatchlistService` to prefer server sync when `supabase_provider` returns a `SupabaseService` instance.
- Provide a `Account` screen for sign-in/out and show user-friendly messages.
- Add conflict resolution rules: local changes while offline should push to server on auth available; server changes should be merged into local list with the server's timestamps.

Tests to add:
- Auth tests mocking Supabase responses.
- End-to-end tests for watchlist sync (can be integration tests with a test Supabase project).

Acceptance criteria:
- Users can sign in and out using Supabase auth flows.
- Watchlist entries persist to Supabase and appear on other devices when signed in.
- Local watchlist is used when not signed in, and sync occurs when signing in.
- UI shows sync status and handles conflicts gracefully.
