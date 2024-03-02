import 'package:apk_jual_sampah/penjualan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test if PenjualanPage UI renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: PenjualanPage(),
      ),
    );
    
    // Check if important widgets are present
    expect(find.text('Penjualan Sampah Page'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
