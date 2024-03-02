import 'package:apk_jual_sampah/detail_sale.dart';
import 'package:apk_jual_sampah/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test if DetailSaleItemPage initializes correctly', (WidgetTester tester) async {
    // Mock SaleItem data for testing
    final SaleItem mockSaleItem = SaleItem(
      imagePath: 'path/to/image.jpg',
      name: 'Sample Item',
      address: 'Sample Address',
      weight: '10 Kg',
      phone: '123-456-789',
      sampahType: 'Plastic',
      description: 'Sample description',
      created: '2022-01-01',
      status: 'Y',
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: DetailSaleItemPage(saleItem: mockSaleItem),
      ),
    );

    // Verify that the title is displayed.
    expect(find.text('Detail Penjualan'), findsOneWidget);

    // Verify that SaleItem details are displayed.
    expect(find.text('Sample Item'), findsOneWidget);
    expect(find.text('Sample Address'), findsOneWidget);
    expect(find.text('10 Kg'), findsOneWidget);
    expect(find.text('123-456-789'), findsOneWidget);
    expect(find.text('Plastic'), findsOneWidget);
    expect(find.text('Sample description'), findsOneWidget);
    expect(find.text('2022-01-01'), findsOneWidget);
    expect(find.text('Menunggu'), findsOneWidget); // Assuming 'Y' corresponds to 'Menunggu'
  });

  testWidgets('Test if refresh works correctly', (WidgetTester tester) async {
    // Mock SaleItem data for testing
    final SaleItem mockSaleItem = SaleItem(
      imagePath: 'path/to/image.jpg',
      name: 'Sample Item',
      address: 'Sample Address',
      weight: '10 Kg',
      phone: '123-456-789',
      sampahType: 'Plastic',
      description: 'Sample description',
      created: '2022-01-01',
      status: 'Y',
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: DetailSaleItemPage(saleItem: mockSaleItem),
      ),
    );
  });

  // Add more test cases as needed.
}
