import 'package:apk_jual_sampah/screen_login.dart';
import 'package:apk_jual_sampah/screen_register.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.green),
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                painter: TopCirclePainter(),
                child: const SizedBox(
                  width: 430,
                  height: 120,
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
                  height: 90,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/image/landing_page.json', // Ganti path dengan nama file animasi Lottie Anda
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Selamat datang di Aplikasi Penjualan Sampah',
                    style: GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aplikasi ini membantu Anda untuk melakukan penjualan sampah dan memantau harga sampah terbaru.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black54)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigate to RegistrationPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationPage()),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green[700]!, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Daftar',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]!),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.person_add, color: Colors.green[700]!, size: 24), // Tambahkan ikon di sini
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          // Navigate to LoginPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[700],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Masuk',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.login, color: Colors.white, size: 24), // Tambahkan ikon di sini
                            ],
                          ),
                        ),
                      ),
                    ],
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

class TopCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width * 0.2, size.height, size.width * 0.33, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.67, 0, size.width, size.height * 0.8);
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
    path.quadraticBezierTo(size.width * 0.2, 1, size.width * 0.33, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.67, size.height, size.width, size.height * 0.2);
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