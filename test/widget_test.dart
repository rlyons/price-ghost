import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_ghost/main.dart';

void main() {
  testWidgets('App loads and shows placeholder scanner', (WidgetTester tester) async {
    await tester.pumpWidget(const PriceGhostApp());
    expect(find.text('Camera preview placeholder'), findsOneWidget);
    expect(find.text('Simulate Scan'), findsOneWidget);
  });
}
