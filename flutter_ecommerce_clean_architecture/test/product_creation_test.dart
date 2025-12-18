import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // update import to your project name

void main() {
  testWidgets('Test product creation', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    // Tap the FloatingActionButton to go to Add Product screen
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // We expect to be on Add Product screen
    expect(find.text('Add Product'), findsOneWidget);

    // Try saving with empty fields (should show validation errors)
    final saveButton = find.text('Create Product');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);

    // Enter valid data
    await tester.enterText(find.widgetWithText(TextFormField, 'Product Title'), 'Headphones');
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
