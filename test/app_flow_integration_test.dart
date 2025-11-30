import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_ghost/models/product_info.dart';
import 'package:price_ghost/services/keepa_service.dart';
import 'package:price_ghost/services/fallback_service.dart';
import 'package:price_ghost/providers/watchlist_provider.dart';
import 'mocks/mock_product_lookup_service.dart';

void main() {

  group('App Flow Integration Tests', () {
    late MockProductLookupService mockService;
    late KeepaService keepaService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      // Create mock service that returns demo data
      mockService = MockProductLookupService(
        serviceName: 'MockService',
        lookupResult: (ean) => ProductInfo(
          ean: ean,
          title: 'Integration Test Product',
          currentPrice: 99.99,
          allTimeLow: 79.99,
          prices90: List<double>.filled(90, 89.99),
        ),
      );

      // Create KeepaService with custom fallback service
      final fallbackService = FallbackService(services: [mockService]);
      keepaService = KeepaService(fallbackService: fallbackService);
    });

    test('Product lookup flow: KeepaService with fallback integration', () async {
      // Test that product lookup works through the full service stack
      final product = await keepaService.fetchProductInfo('123456789012');

      expect(product.ean, equals('123456789012'));
      expect(product.title, contains('Integration Test Product'));
      expect(product.currentPrice, equals(99.99));
      expect(product.allTimeLow, equals(79.99));
      expect(product.prices90.length, equals(90));
    });

    test('Buy signal prediction integration', () async {
      final product = await keepaService.fetchProductInfo('123456789012');

      // Test buy signal prediction
      final signal = keepaService.predictBuySignal(product.prices90, product.currentPrice);
      expect(signal, isNotNull);
      expect(['BUY NOW', 'WAIT', 'NEVER'], contains(signal));
    });

    test('Error handling: fallback to demo data when services fail', () async {
      // Create mock service that throws
      final errorMock = MockProductLookupService(
        serviceName: 'ErrorService',
        shouldThrow: true,
      );

      final errorKeepaService = KeepaService(
        fallbackService: FallbackService(services: [errorMock]),
      );

      // When fallback services fail and no API key, should return demo data
      final product = await errorKeepaService.fetchProductInfo('invalid');

      expect(product.ean, equals('invalid'));
      expect(product.title, contains('Demo Product'));
      expect(product.currentPrice, greaterThan(0));
    });

    test('Watchlist provider full lifecycle', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Test watchlist operations
      final watchlistNotifier = container.read(watchlistProvider.notifier);

      // Start empty
      var watchlist = container.read(watchlistProvider);
      expect(watchlist, isEmpty);

      // Add item
      await watchlistNotifier.add('123456789012');
      watchlist = container.read(watchlistProvider);
      expect(watchlist, contains('123456789012'));
      expect(watchlist.length, equals(1));

      // Add another item
      await watchlistNotifier.add('987654321098');
      watchlist = container.read(watchlistProvider);
      expect(watchlist, contains('123456789012'));
      expect(watchlist, contains('987654321098'));
      expect(watchlist.length, equals(2));

      // Remove first item
      await watchlistNotifier.remove('123456789012');
      watchlist = container.read(watchlistProvider);
      expect(watchlist, isNot(contains('123456789012')));
      expect(watchlist, contains('987654321098'));
      expect(watchlist.length, equals(1));

      // Remove last item
      await watchlistNotifier.remove('987654321098');
      watchlist = container.read(watchlistProvider);
      expect(watchlist, isEmpty);
    });

    test('Fallback service integration', () async {
      // Test with multiple services
      final service1 = MockProductLookupService(
        serviceName: 'Service1',
        lookupResult: (ean) => ProductInfo(
          ean: ean,
          title: 'From Service 1',
          currentPrice: 100.0,
          allTimeLow: 80.0,
          prices90: List<double>.filled(90, 90.0),
        ),
      );

      final service2 = MockProductLookupService(
        serviceName: 'Service2',
        isAvailable: false, // This one is not available
      );

      final testKeepaService = KeepaService(
        fallbackService: FallbackService(services: [service1, service2]),
      );

      final product = await testKeepaService.fetchProductInfo('123456789012');

      expect(product.title, equals('From Service 1'));
      expect(service1.lookupCallCount, equals(1));
      expect(service2.lookupCallCount, equals(0)); // Should not be called since service1 worked
    });

    test('Fallback service tries next on failure', () async {
      final failingService = MockProductLookupService(
        serviceName: 'FailingService',
        shouldThrow: true,
      );

      final successService = MockProductLookupService(
        serviceName: 'SuccessService',
        lookupResult: (ean) => ProductInfo(
          ean: ean,
          title: 'From Success Service',
          currentPrice: 50.0,
          allTimeLow: 40.0,
          prices90: List<double>.filled(90, 45.0),
        ),
      );

      final testKeepaService = KeepaService(
        fallbackService: FallbackService(services: [failingService, successService]),
      );

      final product = await testKeepaService.fetchProductInfo('123456789012');

      expect(product.title, equals('From Success Service'));
      expect(failingService.lookupCallCount, equals(1));
      expect(successService.lookupCallCount, equals(1));
    });
  });
}