import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // update import to your project name
import 'package:flutter_application_1/features/product/data/repositories/product_repository_impl.dart';

void main() {
  testWidgets('Navigate to detail page and back', (tester) async {
    await tester.pumpWidget(EcommerceApp(repository: ProductRepositoryImpl()));
    await tester.pumpAndSettle();

    // Tap the first product "Laptop"
    await tester.tap(find.text('Laptop'));
    await tester.pumpAndSettle();

    // We should be on the detail page
    expect(find.text('Laptop'), findsWidgets);  // In AppBar and Body

    // Tap the back button in AppBar
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Returned to home screen
    expect(find.text('My E-commerce Shop'), findsOneWidget);
  });
}
