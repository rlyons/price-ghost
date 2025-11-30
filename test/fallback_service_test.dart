import 'package:flutter_test/flutter_test.dart';
import 'package:price_ghost/services/fallback_service.dart';
import 'package:price_ghost/services/upcitemdb_service.dart';
import 'package:price_ghost/services/barcode_lookup_service.dart';
import 'package:price_ghost/services/product_lookup_service.dart';
import 'package:price_ghost/models/product_info.dart';

/// Mock ProductLookupService for testing
class MockProductLookupService implements ProductLookupService {
  final String _serviceName;
  final bool _isAvailable;
  final ProductInfo? Function(String)? _lookupResult;
  final bool _shouldThrow;
  int lookupCallCount = 0;

  MockProductLookupService({
    required String serviceName,
    bool isAvailable = true,
    ProductInfo? Function(String)? lookupResult,
    bool shouldThrow = false,
  })  : _serviceName = serviceName,
        _isAvailable = isAvailable,
        _lookupResult = lookupResult,
        _shouldThrow = shouldThrow;

  @override
  String get serviceName => _serviceName;

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<ProductInfo?> lookup(String ean) async {
    lookupCallCount++;
    if (_shouldThrow) {
      throw Exception('Mock service error');
    }
    return _lookupResult?.call(ean);
  }
}

void main() {
  group('FallbackService', () {
    late FallbackService fallbackService;

    setUp(() {
      fallbackService = FallbackService();
    });

    test('has services initialized', () {
      expect(fallbackService.services.length, equals(2));
      expect(fallbackService.services[0], isA<UPCitemdbService>());
      expect(fallbackService.services[1], isA<BarcodeLookupService>());
    });

    test('has availableServices getter', () {
      expect(fallbackService.availableServices, isA<List<String>>());
    });

    test('hasAvailableServices returns true when services are available', () {
      final mockService = MockProductLookupService(
        serviceName: 'Mock',
        isAvailable: true,
      );
      final service = FallbackService(services: [mockService]);
      expect(service.hasAvailableServices, isTrue);
    });

    test('hasAvailableServices returns false when no services available', () {
      final mockService = MockProductLookupService(
        serviceName: 'Mock',
        isAvailable: false,
      );
      final service = FallbackService(services: [mockService]);
      expect(service.hasAvailableServices, isFalse);
    });

    test('lookup returns result from first available service', () async {
      final expectedProduct = ProductInfo(
        ean: '123456789012',
        title: 'Test Product',
        currentPrice: 29.99,
        prices90: List<double>.filled(90, 29.99),
        allTimeLow: 24.99,
      );
      
      final mockService = MockProductLookupService(
        serviceName: 'Mock',
        isAvailable: true,
        lookupResult: (_) => expectedProduct,
      );
      
      final service = FallbackService(services: [mockService]);
      final result = await service.lookup('123456789012');
      
      expect(result, isNotNull);
      expect(result!.ean, equals('123456789012'));
      expect(result.title, equals('Test Product'));
      expect(result.currentPrice, equals(29.99));
      expect(mockService.lookupCallCount, equals(1));
    });

    test('lookup skips unavailable services', () async {
      final unavailableService = MockProductLookupService(
        serviceName: 'Unavailable',
        isAvailable: false,
      );
      
      final availableProduct = ProductInfo(
        ean: '123456789012',
        title: 'Available Product',
        currentPrice: 19.99,
        prices90: List<double>.filled(90, 19.99),
        allTimeLow: 14.99,
      );
      
      final availableService = MockProductLookupService(
        serviceName: 'Available',
        isAvailable: true,
        lookupResult: (_) => availableProduct,
      );
      
      final service = FallbackService(services: [unavailableService, availableService]);
      final result = await service.lookup('123456789012');
      
      expect(unavailableService.lookupCallCount, equals(0));
      expect(availableService.lookupCallCount, equals(1));
      expect(result, isNotNull);
      expect(result!.title, equals('Available Product'));
    });

    test('lookup tries next service when first returns null', () async {
      final firstService = MockProductLookupService(
        serviceName: 'First',
        isAvailable: true,
        lookupResult: (_) => null,
      );
      
      final secondProduct = ProductInfo(
        ean: '123456789012',
        title: 'Second Service Product',
        currentPrice: 39.99,
        prices90: List<double>.filled(90, 39.99),
        allTimeLow: 34.99,
      );
      
      final secondService = MockProductLookupService(
        serviceName: 'Second',
        isAvailable: true,
        lookupResult: (_) => secondProduct,
      );
      
      final service = FallbackService(services: [firstService, secondService]);
      final result = await service.lookup('123456789012');
      
      expect(firstService.lookupCallCount, equals(1));
      expect(secondService.lookupCallCount, equals(1));
      expect(result, isNotNull);
      expect(result!.title, equals('Second Service Product'));
    });

    test('lookup tries next service when first throws error', () async {
      final failingService = MockProductLookupService(
        serviceName: 'Failing',
        isAvailable: true,
        shouldThrow: true,
      );
      
      final workingProduct = ProductInfo(
        ean: '123456789012',
        title: 'Working Service Product',
        currentPrice: 49.99,
        prices90: List<double>.filled(90, 49.99),
        allTimeLow: 44.99,
      );
      
      final workingService = MockProductLookupService(
        serviceName: 'Working',
        isAvailable: true,
        lookupResult: (_) => workingProduct,
      );
      
      final service = FallbackService(services: [failingService, workingService]);
      final result = await service.lookup('123456789012');
      
      expect(failingService.lookupCallCount, equals(1));
      expect(workingService.lookupCallCount, equals(1));
      expect(result, isNotNull);
      expect(result!.title, equals('Working Service Product'));
    });

    test('lookup returns null when all services fail', () async {
      final failingService1 = MockProductLookupService(
        serviceName: 'Failing1',
        isAvailable: true,
        shouldThrow: true,
      );
      
      final failingService2 = MockProductLookupService(
        serviceName: 'Failing2',
        isAvailable: true,
        lookupResult: (_) => null,
      );
      
      final service = FallbackService(services: [failingService1, failingService2]);
      final result = await service.lookup('123456789012');
      
      expect(result, isNull);
    });

    test('availableServices returns only available service names', () {
      final availableService = MockProductLookupService(
        serviceName: 'Available',
        isAvailable: true,
      );
      
      final unavailableService = MockProductLookupService(
        serviceName: 'Unavailable',
        isAvailable: false,
      );
      
      final service = FallbackService(services: [availableService, unavailableService]);
      final available = service.availableServices;
      
      expect(available.length, equals(1));
      expect(available, contains('Available'));
      expect(available, isNot(contains('Unavailable')));
    });
  });

  group('UPCitemdbService', () {
    late UPCitemdbService service;

    setUp(() {
      service = UPCitemdbService();
    });

    test('is a ProductLookupService', () {
      expect(service, isA<UPCitemdbService>());
      expect(service.serviceName, equals('UPCitemdb'));
    });

    test('isAvailable returns false when no API key configured', () {
      // Without dotenv configured, isAvailable should return false
      expect(service.isAvailable, isFalse);
    });
  });

  group('BarcodeLookupService', () {
    late BarcodeLookupService service;

    setUp(() {
      service = BarcodeLookupService();
    });

    test('is a ProductLookupService', () {
      expect(service, isA<BarcodeLookupService>());
      expect(service.serviceName, equals('Barcode Lookup'));
    });

    test('isAvailable returns false when no API key configured', () {
      // Without dotenv configured, isAvailable should return false
      expect(service.isAvailable, isFalse);
    });
  });

  group('ProductInfo', () {
    test('creates valid ProductInfo with all required fields', () {
      final product = ProductInfo(
        ean: '123456789012',
        title: 'Test Product',
        currentPrice: 99.99,
        prices90: List<double>.filled(90, 99.99),
        allTimeLow: 79.99,
      );

      expect(product.ean, equals('123456789012'));
      expect(product.title, equals('Test Product'));
      expect(product.currentPrice, equals(99.99));
      expect(product.prices90.length, equals(90));
      expect(product.allTimeLow, equals(79.99));
    });

    test('handles empty prices list', () {
      final product = ProductInfo(
        ean: '123456789012',
        title: 'Test Product',
        currentPrice: 0.0,
        prices90: [],
        allTimeLow: 0.0,
      );

      expect(product.prices90, isEmpty);
    });
  });
}