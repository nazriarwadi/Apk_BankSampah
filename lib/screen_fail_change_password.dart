import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'screen_lupa_password.dart';

class PasswordChangeFailurePage extends StatelessWidget {
  const PasswordChangeFailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.red, // Ganti dengan warna sesuai keinginan
    ));
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
                    'assets/image/Animation_Fail.json', // Ganti dengan file animasi untuk kegagalan
                    width: 230,
                    height: 230,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Failed to Change Password',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Maaf, email anda tidak terdaftar di aplikasi ini. Silakan masukkan email anda yang terdaftar supaya bisa merubah password.',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60), backgroundColor: Colors.red, // Ganti dengan warna sesuai keinginan
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Kembali Masukkan Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
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
