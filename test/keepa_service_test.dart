import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_ghost/services/keepa_service.dart';

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
}
