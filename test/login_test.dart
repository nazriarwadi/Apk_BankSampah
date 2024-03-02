import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_jual_sampah/screen_login.dart'; // Update with the correct import

void main() {
  testWidgets('Test if LoginPage UI renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Check if important widgets are present
    expect(find.text('Halaman Login'), findsOneWidget);
    expect(find.text('Login To Continue'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('Test if LoginPage validates fields correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Simulate tapping on the login button without entering any data
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error messages are displayed
    expect(find.text('Masukkan email yang valid'), findsOneWidget);
  });
}
