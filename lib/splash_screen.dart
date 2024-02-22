// ignore_for_file: use_build_context_synchronously
import 'package:apk_jual_sampah/home_screen.dart';
import 'package:apk_jual_sampah/landing_page_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  void _checkUserAuthentication() async {
    // Delay untuk simulasi splash screen
    await Future.delayed(const Duration(seconds: 4));

    // Check apakah user sudah login sebelumnya
    if (await isUserAuthenticated()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Halaman utama setelah login
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()), // Halaman login jika belum login
      );
    }
  }

  Future<bool> isUserAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email_pengguna') != null;
  }

  Future<void> saveLoginToken(String email) async {
    // Simpan token ke SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email_pengguna', email);
  }

  Future<bool> checkLoginToken() async {
    // Periksa token di SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailPengguna = prefs.getString('email_pengguna');

    return emailPengguna != null && emailPengguna.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.green),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white60],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: CustomPaint(
                  painter: TopCirclePainter(),
                  child: const SizedBox(
                    width: 430,
                    height: 140,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: BottomCirclePainter(),
                  child: const SizedBox(
                    width: 430,
                    height: 100,
                  ),
                ),
              ),
              Center(
                child: Lottie.asset(
                  'assets/image/splash_screen.json', // Ganti dengan path animasi Lottie Anda
                  height: 230,
                  width: 230,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Text(
                  'By \nNazri Arwadi',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 5, size.height, size.width / 3, (4 * size.height) / 5);
    path.quadraticBezierTo((3 * size.width) / 3, 0, size.width, (4 * size.height) / 5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BottomCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 5, 1, size.width / 3, size.height / 5);
    path.quadraticBezierTo((3 * size.width) / 3, size.height, size.width, size.height / 5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

