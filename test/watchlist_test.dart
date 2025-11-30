import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_ghost/services/watchlist_service.dart';

void main() {
  group('WatchlistService', () {
    test('add and remove to watchlist', () async {
      SharedPreferences.setMockInitialValues({});
      final service = WatchlistService();
      await service.addToWatchlist('123');
      var list = await service.loadWatchlist();
      expect(list, contains('123'));
      await service.removeFromWatchlist('123');
      list = await service.loadWatchlist();
      expect(list, isNot(contains('123')));
    });
  });
}
