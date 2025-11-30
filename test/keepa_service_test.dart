import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_ghost/services/keepa_service.dart';
import 'package:price_ghost/services/keepa_cache.dart';
import 'package:price_ghost/services/fallback_service.dart';
import 'package:price_ghost/models/product_info.dart';
import 'mocks/mock_product_lookup_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KeepaService', () {
    late KeepaService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = KeepaService();
    });

    test('predictBuySignal returns BUY NOW for low current price', () {
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 80.0);
      expect(result, equals('BUY NOW'));
    });

    test('predictBuySignal returns NEVER for high current price', () {
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 120.0);
      expect(result, equals('NEVER'));
    });

    test('predictBuySignal returns WAIT for mid current price', () {
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 102.0);
      expect(result, equals('WAIT'));
    });

    test('predictBuySignal returns NEVER for empty prices', () {
      final result = service.predictBuySignal([], 100.0);
      expect(result, equals('NEVER'));
    });

    test('fetchProductInfo returns demo data', () async {
      final result = await service.fetchProductInfo('123456789012');

      expect(result.ean, equals('123456789012'));
      expect(result.title, contains('Demo Product'));
      expect(result.prices90.length, equals(90));
      expect(result.currentPrice, greaterThan(0));
      expect(result.allTimeLow, greaterThan(0));
    });

    test('can create service with custom parameters', () {
      final customService = KeepaService();
      expect(customService, isA<KeepaService>());
    });
  });

  group('KeepaService fallback integration', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('uses fallback service when no API key is configured', () async {
      final fallbackProduct = ProductInfo(
        ean: '123456789012',
        title: 'Fallback Product',
        currentPrice: 29.99,
        prices90: List<double>.filled(90, 29.99),
        allTimeLow: 24.99,
      );

      final mockService = MockProductLookupService(
        serviceName: 'MockFallback',
        isAvailable: true,
        lookupResult: (_) => fallbackProduct,
      );

      final fallbackService = FallbackService(services: [mockService]);
      final cache = KeepaCache(prefs);
      
      final keepaService = KeepaService(
        cache: cache,
        fallbackService: fallbackService,
      );

      final result = await keepaService.fetchProductInfo('123456789012');

      // When no API key is configured, it should use fallback
      expect(mockService.lookupCallCount, equals(1));
      expect(result.ean, equals('123456789012'));
      expect(result.title, equals('Fallback Product'));
      expect(result.currentPrice, equals(29.99));
    });

    test('returns demo data when fallback service is not available', () async {
      final mockService = MockProductLookupService(
        serviceName: 'MockFallback',
        isAvailable: false,
      );

      final fallbackService = FallbackService(services: [mockService]);
      final cache = KeepaCache(prefs);
      
      final keepaService = KeepaService(
        cache: cache,
        fallbackService: fallbackService,
      );

      final result = await keepaService.fetchProductInfo('123456789012');

      // Should not call fallback (not available)
      expect(mockService.lookupCallCount, equals(0));
      // Should return demo data
      expect(result.ean, equals('123456789012'));
      expect(result.title, contains('Demo Product'));
    });

    test('returns demo data when fallback returns null', () async {
      final mockService = MockProductLookupService(
        serviceName: 'MockFallback',
        isAvailable: true,
        lookupResult: (_) => null,
      );

      final fallbackService = FallbackService(services: [mockService]);
      final cache = KeepaCache(prefs);
      
      final keepaService = KeepaService(
        cache: cache,
        fallbackService: fallbackService,
      );

      final result = await keepaService.fetchProductInfo('123456789012');

      // Should call fallback
      expect(mockService.lookupCallCount, equals(1));
      // Should return demo data when fallback returns null
      expect(result.ean, equals('123456789012'));
      expect(result.title, contains('Demo Product'));
    });

    test('works without fallback service configured', () async {
      final cache = KeepaCache(prefs);
      
      final keepaService = KeepaService(
        cache: cache,
        fallbackService: null,
      );

      final result = await keepaService.fetchProductInfo('123456789012');

      // Should return demo data
      expect(result.ean, equals('123456789012'));
      expect(result.title, contains('Demo Product'));
    });
  });

  group('FallbackService hasAvailableServices', () {
    test('returns true when at least one service is available', () {
      final availableService = MockProductLookupService(
        serviceName: 'Available',
        isAvailable: true,
      );
      final unavailableService = MockProductLookupService(
        serviceName: 'Unavailable',
        isAvailable: false,
      );

      final fallback = FallbackService(services: [unavailableService, availableService]);
      expect(fallback.hasAvailableServices, isTrue);
    });

    test('returns false when no services are available', () {
      final unavailableService1 = MockProductLookupService(
        serviceName: 'Unavailable1',
        isAvailable: false,
      );
      final unavailableService2 = MockProductLookupService(
        serviceName: 'Unavailable2',
        isAvailable: false,
      );

      final fallback = FallbackService(services: [unavailableService1, unavailableService2]);
      expect(fallback.hasAvailableServices, isFalse);
    });
  });
}
