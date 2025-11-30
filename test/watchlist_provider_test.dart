import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_ghost/providers/watchlist_provider.dart';

void main() {
  test('watchlist provider add/remove', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(watchlistProvider.notifier);
    await notifier.add('111');
    var list = container.read(watchlistProvider);
    expect(list, contains('111'));
    await notifier.remove('111');
    list = container.read(watchlistProvider);
    expect(list, isNot(contains('111')));
  });
}
