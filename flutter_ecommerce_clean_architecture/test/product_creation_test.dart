import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // update import to your project name
import 'package:flutter_application_1/features/product/data/repositories/product_repository_impl.dart';

void main() {
  testWidgets('Test product creation', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(EcommerceApp(repository: ProductRepositoryImpl()));
    await tester.pumpAndSettle();

    // Tap the FloatingActionButton to go to Add Product screen
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // We expect to be on Add Product screen
    expect(find.text('Add Product'), findsOneWidget);

    // Try saving with empty fields (should show validation errors)
    final saveButton = find.text('Save');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(2));

    // Enter valid data
    await tester.enterText(find.widgetWithText(TextFormField, 'Product Name'), 'Headphones');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Noise cancelling headphones');

    // Save product
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Returned to HomeScreen
    expect(find.text('My E-commerce Shop'), findsOneWidget);

    // New product should appear in the list
    expect(find.text('Headphones'), findsOneWidget);
  });
}
