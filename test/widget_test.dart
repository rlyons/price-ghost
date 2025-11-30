import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_ghost/main.dart';

void main() {
  testWidgets('App loads and shows placeholder scanner', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PriceGhostApp()));
    expect(find.text('Price Ghost'), findsOneWidget);
  });
}
