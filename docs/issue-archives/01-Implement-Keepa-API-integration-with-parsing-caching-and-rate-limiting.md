Description:
Implement a robust Keepa API integration that replaces the existing demo fallback. The Keepa integration should:
- Accept EAN/UPC input and, if necessary, convert to ASIN/Keepa identifiers.
- Query Keepa REST API with the required parameters and API key.
- Parse product title, current price, 90-day price history, and all-time low from the Keepa response.
- Cache successful responses for 24 hours in a local storage layer to avoid frequent API calls.
- Implement retries and exponential backoff for transient failures; handle rate limiting (429) by backing off.
- Validate and sanitize Keepa responses to guard against missing fields or invalid types.

Implementation details:
- Update `lib/services/keepa_service.dart` to replace demo fallback with a real Keepa data parser.
- Use `http` client injected via provider to allow unit testing by mocking `http.Client`.
- Store cache in either `shared_preferences` for local caching or a persistent database like Supabase, behind a caching provider.
- Delegates:
  - Request/response parsing functions in `lib/services/keepa_parser.dart`.
  - A `KeepaCache` helper class that handles storing + retrieving cached responses.

Tests to add:
- Unit tests for Keepa parsing with sample Keepa response JSON (include multiple formats: with/without price history).
- Mocked HTTP integration tests that ensure KeepaService handles 200 responses and 429 errors appropriately.
- Cache tests that confirm the data is returned from cache within 24 hours.

Acceptance criteria:
- KeepaService returns `ProductInfo` with accurate fields for a valid EAN.
- Cached responses are used when valid and within 24 hours.
- Rate-limited responses trigger a back-off policy and do not crash the app.
- All new functions covered by unit tests.

Notes:
- Keepa requires using a valid key and may require domain/market settings; confirm required params with Keepa docs.
- Add dev instructions to README to provide KEEPA_API_KEY using `--dart-define`.
