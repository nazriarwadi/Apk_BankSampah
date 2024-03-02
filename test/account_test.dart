import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_jual_sampah/nasabah_screen.dart';
import 'package:integration_test/integration_test.dart'; // Update with the correct import

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test if NasabahPage UI renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: NasabahPage(),
      ),
    );

    // Check if important widgets are present
    expect(find.text('Account Page'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);
    expect(find.text('No Telepon'), findsOneWidget);
    expect(find.text('Status Verifikasi'), findsOneWidget);
  });
}
