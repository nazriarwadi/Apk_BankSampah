import 'package:apk_jual_sampah/berita_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test if NewsPage initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: NewsPage(),
    ));

    // Verify that the title is displayed.
    expect(find.text('News Page'), findsOneWidget);

    // Add more specific tests for NewsPage.
    // Example: Verify that the initial list of news is empty.
    expect(find.byType(NewsCard), findsNothing);

    // You can add more tests based on your specific requirements.
  });

  testWidgets('Test if NewsCard widget displays correctly', (WidgetTester tester) async {
    // Create a News instance for testing.
    final News testNews = News(
      title: 'Test Title',
      imageUrl: 'https://example.com/test-image.jpg',
      content: 'Test Content',
      date: '2022-01-01',
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: NewsCard(news: testNews),
    ));

    // Verify that the NewsCard displays the test news correctly.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('2022-01-01'), findsOneWidget);
  });

  // Add more tests as needed.
}
