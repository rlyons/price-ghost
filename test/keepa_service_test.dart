import 'package:flutter_test/flutter_test.dart';
import 'package:price_ghost/services/keepa_service.dart';

void main() {
  group('KeepaService', () {
    test('predictBuySignal returns BUY NOW for low current price', () {
      final service = KeepaService(apiKey: 'test');
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 80.0);
      expect(result, equals('BUY NOW'));
    });

    test('predictBuySignal returns NEVER for high current price', () {
      final service = KeepaService(apiKey: 'test');
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 120.0);
      expect(result, equals('NEVER'));
    });

    test('predictBuySignal returns WAIT for mid current price', () {
      final service = KeepaService(apiKey: 'test');
      final prices = List<double>.filled(90, 100.0);
      final result = service.predictBuySignal(prices, 102.0);
      expect(result, equals('WAIT'));
    });
  });
}
