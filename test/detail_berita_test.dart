import 'package:apk_jual_sampah/berita_screen.dart';
import 'package:apk_jual_sampah/detail_berita.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test if NewsDetailPage UI renders correctly', (WidgetTester tester) async {
    // Create a News object for testing
    News testNews = News(
      title: 'Test Title',
      date: '2024-02-28',
      content: 'Test Content',
      imageUrl: 'https://example.com/image.jpg',
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: NewsDetailPage(news: testNews),
      ),
    );
    
    // Check if important widgets are present
    expect(find.text('Detail Berita'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('2024-02-28'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
  });
}
