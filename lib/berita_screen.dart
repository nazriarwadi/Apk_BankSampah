import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

import 'daftar_harga_sampah.dart';
import 'detail_berita.dart';
import 'home_screen.dart';
import 'nasabah_screen.dart';
import 'video_screen.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String currentPage = 'Berita'; // Atur halaman awal
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNewsData().then((newsData) {
      setState(() {
        newsList = newsData;
      });
    });
  }

  Future<List<News>> _fetchNewsData() async {
    try {
      final response = await http
          .get(Uri.parse('https://banksampahapi.sppapp.com/get_berita.php'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => News.fromJson(data)).toList();
      } else {
        print('Failed to load news - Status code: ${response.statusCode}');
        return []; // Return an empty list or handle the error in a way suitable for your app
      }
    } catch (error) {
      print('Failed to load news - Error: $error');
      return []; // Return an empty list or handle the error in a way suitable for your app
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavBarItem(LineIcons.home, 'Home', currentPage == 'Home', () {
            _navigateToPage(context, const HomePage());
          }),
          _buildNavBarItem(LineIcons.youtube, 'Video', currentPage == 'Video',
              () {
            _navigateToPage(context, const VideoPage());
          }),
          _buildNavBarItem(
              LineIcons.moneyBill, 'Sampah', currentPage == 'Sampah', () {
            _navigateToPage(context, const SampahPage());
          }),
          _buildNavBarItem(
              LineIcons.newspaper, 'Berita', currentPage == 'Berita', () {
            _navigateToPage(context, const NewsPage());
          }),
          _buildNavBarItem(LineIcons.user, 'Account', currentPage == 'Nasabah',
              () {
            _navigateToPage(context, const NasabahPage());
          }),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
      IconData icon, String label, bool isCurrentPage, VoidCallback onTap) {
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'News Page',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        iconTheme:
            const IconThemeData(color: Colors.white, size: 24.0, opacity: 2.0),
        elevation: 0, // Remove app bar shadow
      ),
      backgroundColor: Colors.green,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: FutureBuilder<List<News>>(
          future: _fetchNewsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              newsList = snapshot.data!;
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return NewsCard(news: news);
                },
                physics: const ClampingScrollPhysics(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail berita
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(news: news),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 3, // Tambahkan elevasi untuk memberikan efek bayangan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green[600]!, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                news.imageUrl,
                height: 150, // Tentukan tinggi gambar
                width: double.infinity, // Agar gambar memenuhi lebar layar
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(news.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(news.date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class News {
  final String title;
  final String imageUrl; // Tambahkan properti imageUrl
  final String content;
  final String date;

  News({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['judul_berita'],
      imageUrl:
          'https://banksampah.sppapp.com/uploads/article/${json['image']}',
      content: json['isi_berita'],
      date: json['created'],
    );
  }
}
