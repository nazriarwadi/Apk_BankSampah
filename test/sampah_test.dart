import 'package:apk_jual_sampah/daftar_harga_sampah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Test if SampahCard UI renders correctly', (WidgetTester tester) async {
      Sampah sampah = Sampah(
        nama: 'Test Sampah',
        jenis: 'Organik',
        harga: '10000',
        imageUrl: 'https://example.com/test.jpg',
      );
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SampahCard(sampah: sampah),
          ),
        ),
      );
      // Verify that the SampahCard UI renders correctly.
      expect(find.text('Test Sampah'), findsOneWidget);
      expect(find.text('Jenis: Organik'), findsOneWidget);
      expect(find.text('Harga: Rp.10000'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
}
