import 'package:apk_jual_sampah/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test if VideoPage initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: VideoPage(),
      ),
    );

    // Verify that the AppBar is displayed
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Test if loading indicator is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: VideoPage(),
      ),
    );

    // Verify that the loading indicator is displayed while waiting for data
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Example of testing the VideoCard widget
  testWidgets('Test if VideoCard widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VideoCard(
          video: Video(
            name: 'Video Name',
            description: 'Video Description',
            link: 'https://www.youtube.com/watch?v=example',
          ),
          onTap: () {},
        ),
      ),
    );

    // Verify that the VideoCard displays video details
    expect(find.text('Video Name'), findsOneWidget);
    expect(find.text('Video Description'), findsOneWidget);
    expect(find.byType(YoutubePlayer), findsOneWidget);
  });
}
