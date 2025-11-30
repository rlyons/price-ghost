Title: Implement UPC/EAN fallback services (UPCitemdb, Barcode Lookup)

Description:
When Keepa is unavailable or doesn't provide product information, implement fallback services that query UPC/EAN product lookup APIs such as UPCitemdb or Barcode Lookup.

Implementation details:
- Create a `lib/services/fallback_service.dart` responsible for querying fallback APIs.
- Implement `UPCitemdbService` and `BarcodeLookupService`, each implementing a common interface `ProductLookupService`.
- KeepaService should call `FallbackService.lookup(ean)` when the Keepa query returns no product details or on specific error codes.
- Add configurable API keys via environment variables (e.g., `UPCITEMDB_KEY`).

Tests to add:
- Unit tests mocking fallback service responses and validate the `ProductInfo` mapping.
- Integration test that simulates Keepa failing and verifying fallback is used.

Acceptance criteria:
- When Keepa returns no product data, a fallback service is invoked.
- Fallback service returns `ProductInfo` with minimum fields (title, current price, approximate price history if available).
- All new code is covered by unit tests.
