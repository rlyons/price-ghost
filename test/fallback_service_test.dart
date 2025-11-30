import 'package:flutter_test/flutter_test.dart';
import 'package:price_ghost/services/fallback_service.dart';
import 'package:price_ghost/services/upcitemdb_service.dart';
import 'package:price_ghost/services/barcode_lookup_service.dart';

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
  });
}