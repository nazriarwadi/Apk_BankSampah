import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'screen_login.dart';

class PasswordChangeSuccessPage extends StatelessWidget {
  const PasswordChangeSuccessPage({Key? key, required String email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color.fromARGB(255, 211, 211, 211)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/image/success_animation.json',
                    width: 230,
                    height: 230,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password Changed!',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Tautan untuk mengatur ulang kata sandi Anda telah berhasil dikirim ke email Anda. Silakan periksa email Anda untuk mengatur kata sandi baru.',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      textAlign: TextAlign.center, // Tambahkan properti textAlign di sini
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    stystyle: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60), backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Back to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
