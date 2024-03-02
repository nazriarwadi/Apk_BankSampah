import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_jual_sampah/home_screen.dart'; // Update with the correct import

void main() {
  testWidgets('Test if HomePage UI renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Check if important widgets are present
    expect(find.text('Saldo Anda'), findsOneWidget);
    expect(find.text('Rp 0'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Your Trash'), findsOneWidget);
  });
}
