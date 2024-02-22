// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apk_jual_sampah/screen_login.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'berita_screen.dart';
import 'daftar_harga_sampah.dart';
import 'home_screen.dart';
import 'video_screen.dart';

class NasabahPage extends StatefulWidget {
  const NasabahPage({Key? key}) : super(key: key);

  @override
  _NasabahPageState createState() => _NasabahPageState();
}

class _NasabahPageState extends State<NasabahPage> {
  String currentPage = 'Nasabah'; // Atur halaman awal
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationStatusController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memuat data pengguna ketika widget diinisialisasi
    _fetchUserData();
  }

  // Fungsi untuk mengambil data pengguna dari API
  Future<void> _fetchUserData() async {
    try {
      // Ambil email pengguna dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email_pengguna') ?? '';

      // Ganti URL dengan URL API yang sesuai untuk mengambil data berdasarkan email
      final response = await http.get(
        Uri.parse(
            'https://banksampahapi.sppapp.com/get_profile.php?email=$email'),
      );

      if (response.statusCode == 200) {
        // Jika respons sukses, parse data JSON
        final Map<String, dynamic> userData = json.decode(response.body);

        // Perbarui state dengan data yang diambil
        setState(() {
          _nameController.text = userData['nama'] ?? 'Nama Tidak Tersedia';
          _emailController.text = userData['email'] ?? 'Email Tidak Tersedia';
          _addressController.text =
              userData['address'] ?? 'Alamat Tidak Tersedia';
          _phoneController.text =
              userData['nomor_handphone'] ?? 'No Telepon Tidak Tersedia';
          _verificationStatusController.text = userData['status_verifikasi'] ??
              'Status Verifikasi Tidak Tersedia';

          // Foto Profile dari foto_diri
          _profileImage =
              'https://banksampah.sppapp.com/uploads/avatar/${userData['foto_diri']}';

          // Nama file Foto KTP
          _ktpFileName = userData['foto_ktp'] ?? 'ktp_default.jpg';
        });
      } else {
        // Handle kesalahan jika permintaan tidak berhasil
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle kesalahan jika terjadi kesalahan selama proses
    }
  }

  String _profileImage =
      'https://banksampah.sppapp.com/uploads/avatar/'; // Menyimpan URL foto profile
  String _ktpFileName =
      'https://banksampah.sppapp.com/uploads/avatar/'; // Menyimpan nama file foto KTP

  void _logout(BuildContext context) async {
    // Hapus email dari SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email_pengguna');

    // Navigasi ke halaman login dan hapus semua rute sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );

    // Show a snackbar message indicating successful logout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda sudah logout dari akun'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account Page',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
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
        child: Column(
          children: [
            Expanded(
              child: _isEditing ? _buildEditProfile() : _buildProfile(),
            ),
            if (!_isEditing) _buildBottomButtons(), // Tombol edit dan keluar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _profileImage.isNotEmpty
                    ? Image.network(
                        _profileImage,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.person, size: 120, color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileDetail(LineIcons.user, 'Nama', _nameController.text),
          _buildProfileDetail(
              LineIcons.envelope, 'Email', _emailController.text),
          _buildProfileDetail(LineIcons.map, 'Alamat', _addressController.text),
          _buildProfileDetail(
              LineIcons.phone, 'No Telepon', _phoneController.text),
          _buildProfileDetail(LineIcons.image, 'Foto KTP', _ktpFileName),
          _buildProfileDetail(
            LineIcons.check,
            'Status Verifikasi',
            _verificationStatusController.text,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.robotoCondensed(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow
                      .ellipsis, // Ini akan menambahkan elipsis jika teks terlalu panjang
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: 58,
            backgroundImage: AssetImage('assets/image/recycl.png'),
          ),
        ),
        _buildTextField(_nameController, 'Nama'),
        _buildTextField(_emailController, 'Email', enabled: false),
        _buildTextField(_addressController, 'Alamat'),
        _buildTextField(_phoneController, 'No Telepon'),
        // Add more text fields as needed
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Implement save logic
            setState(() {
              _isEditing = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Simpan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.robotoCondensed(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value ?? 'N/A', // Gunakan nilai default jika value null
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black87),
        cursorColor: Colors.green,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Handle logout
            _logout(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.exit_to_app, color: Colors.white),
          label: const Text(
            'Keluar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
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
