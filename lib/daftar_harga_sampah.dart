import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import 'berita_screen.dart';
import 'home_screen.dart';
import 'nasabah_screen.dart';
import 'video_screen.dart';

class SampahPage extends StatefulWidget {
  const SampahPage({Key? key}) : super(key: key);

  @override
  _SampahPageState createState() => _SampahPageState();
}

class _SampahPageState extends State<SampahPage> {
  String currentPage = 'Sampah';
  List<Sampah> sampahList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSampahData().then((sampahData) {
      setState(() {
        sampahList = sampahData;
        isLoading = false; // Setelah data dimuat, atur isLoading ke false
      });
    });
  }

  Future<List<Sampah>> _fetchSampahData() async {
    final response = await http
        .get(Uri.parse('https://banksampahapi.sppapp.com/get_sampah.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Sampah.fromJson(data)).toList();
    } else {
      throw Exception(
          'Failed to load sampah - Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sampah Page',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        iconTheme:
            const IconThemeData(color: Colors.white, size: 24.0, opacity: 2.0),
        elevation: 0,
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(), // Indikator loading
              )
            : GridView.builder(
                padding: const EdgeInsets.only(top: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.7,
                ),
                itemCount: sampahList.length,
                itemBuilder: (context, index) {
                  return SampahCard(sampah: sampahList[index]);
                },
              ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
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
}

class SampahCard extends StatelessWidget {
  final Sampah sampah;

  const SampahCard({Key? key, required this.sampah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.green[600]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              sampah.imageUrl,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sampah.nama,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Jenis: ${sampah.jenis}',
                    style: const TextStyle(fontSize: 14)),
                Text('Harga: Rp.${sampah.harga}',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sampah {
  final String nama;
  final String jenis;
  final String harga;
  final String imageUrl;

  Sampah({
    required this.nama,
    required this.jenis,
    required this.harga,
    required this.imageUrl,
  });

  factory Sampah.fromJson(Map<String, dynamic> json) {
    return Sampah(
      nama: json['name'],
      jenis: json['jenis'],
      harga: json['harga'],
      imageUrl:
          'https://banksampah.sppapp.com/uploads/hargasampah/${json['image']}',
    );
  }
}
