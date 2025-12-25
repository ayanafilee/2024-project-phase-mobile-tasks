import 'package:flutter/material.dart';            // ✅ Add this
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/features/product/data/repositories/product_repository_impl.dart';

void main() {
  testWidgets('Product list displays and updates', (tester) async {
    await tester.pumpWidget(EcommerceApp(repository: ProductRepositoryImpl()));
    await tester.pumpAndSettle();

    // Initial products should exist (Laptop, Smartphone)
    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Smartphone'), findsOneWidget);

    // Add a product
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Product Name'), 'Tablet');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Android tablet');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Tablet must appear
    expect(find.text('Tablet'), findsOneWidget);
  });
}
