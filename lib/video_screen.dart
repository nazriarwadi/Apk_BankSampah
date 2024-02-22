import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'berita_screen.dart';
import 'daftar_harga_sampah.dart';
import 'home_screen.dart';
import 'nasabah_screen.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String currentPage = 'Video';
  late Future<List<Video>> videoList;

  @override
  void initState() {
    super.initState();
    videoList = fetchVideoData();
  }

  Future<List<Video>> fetchVideoData() async {
    final response = await http.get(Uri.parse('https://banksampahapi.sppapp.com/get_video.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Video.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load video - Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Video Page',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white, size: 24.0, opacity: 2.0),
      ),
      backgroundColor: Colors.green,
      body: FutureBuilder<List<Video>>(
        future: videoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final video = snapshot.data![index];
                  return VideoCard(
                    video: video,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoScreen(video: video),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavBarItem(LineIcons.home, 'Home', currentPage == 'Home', () {
            _navigateToPage(context, const HomePage());
          }),
          _buildNavBarItem(LineIcons.youtube, 'Video', currentPage == 'Video', () {}),
          _buildNavBarItem(LineIcons.moneyBill, 'Sampah', currentPage == 'Sampah', () {
            _navigateToPage(context, const SampahPage());
          }),
          _buildNavBarItem(LineIcons.newspaper, 'Berita', currentPage == 'Berita', () {
            _navigateToPage(context, const NewsPage());
          }),
          _buildNavBarItem(LineIcons.user, 'Account', currentPage == 'Nasabah', () {
            _navigateToPage(context, const NasabahPage());
          }),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    IconData icon,
    String label,
    bool isCurrentPage,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentPage ? Colors.black : Colors.transparent,
            ),
            padding: const EdgeInsets.all(4),
            child: Icon(icon,
                color: isCurrentPage ? Colors.white : Colors.white, size: 23),
          ),
          Text(
            label,
            style: TextStyle(
              color: isCurrentPage ? Colors.white : Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;

  const VideoCard({
    Key? key,
    required this.video,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green[600]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(video.link) ?? '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                          controlsVisibleAtStart: false,
                          hideControls: true,
                        ),
                      ),
                      showVideoProgressIndicator: false,
                      progressIndicatorColor: Colors.red,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  video.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoScreen extends StatefulWidget {
  final Video video;

  const FullScreenVideoScreen({Key? key, required this.video}) : super(key: key);

  @override
  _FullScreenVideoScreenState createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  @override
  void initState() {
    super.initState();
    // Sembunyikan status bar saat masuk ke halaman fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
    // Tampilkan kembali status bar saat keluar dari halaman fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        // Tampilkan kembali status bar saat tombol kembali ditekan
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: RotatedBox(
            quarterTurns: 0,
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(widget.video.link) ?? '',
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                  controlsVisibleAtStart: false,
                ),
              ),
              showVideoProgressIndicator: false,
              progressIndicatorColor: Colors.red,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Video {
  final String name;
  final String description;
  final String link;

  Video({
    required this.name,
    required this.description,
    required this.link,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      description: json['description'],
      link: json['link'],
    );
  }
}