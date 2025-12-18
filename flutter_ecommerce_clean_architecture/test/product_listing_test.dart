import 'package:flutter/material.dart';            // ✅ Add this
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Product list displays and updates', (tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    // Initial products should exist (Laptop, Smartphone)
    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Smartphone'), findsOneWidget);

    // Add a product
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Product Title'), 'Tablet');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Android tablet');

    await tester.tap(find.text('Create Product'));
    await tester.pumpAndSettle();

    // Tablet must appear
    expect(find.text('Tablet'), findsOneWidget);
  });
}
