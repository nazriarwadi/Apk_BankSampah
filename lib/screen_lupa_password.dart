// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
//import 'package:apk_jual_sampah/screen_succes_change_password.dart';
import 'package:apk_jual_sampah/screen_login.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'screen_fail_change_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

// Future<void> sendPasswordResetEmail(String email) async {
//   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// }

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? _emailErrorText;

  String? _validateFields() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!isValidEmail(email)) {
      return 'Masukkan email yang valid';
    }

    return null;
  }

  // Future<bool> isEmailRegistered(String email) async {
  //   try {
  //     final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

  //     return signInMethods.isNotEmpty;
  //   } on FirebaseAuthException {
  //     return false;
  //   }
  // }

  // void _sendResetCode() async {
  //   final email = _emailController.text.trim();

  //   // Validate email
  //   if (email.isEmpty || !isValidEmail(email)) {
  //     setState(() {
  //       _emailErrorText = email.isEmpty ? 'Email tidak boleh kosong' : 'Masukkan email yang valid';
  //     });
  //     return;
  //   }

  //   try {
  //     // Check if the user exists
  //     //UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: 'dummy_password', // Provide a dummy password
  //     );

  //     // User creation was successful, which means the email is not registered
  //     await userCredential.user?.delete(); // Delete the dummy user
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const PasswordChangeFailurePage(),
  //       ),
  //     );
  //   } catch (e) {
  //     // If an error occurs, check if it's an email already in use error
  //     if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
  //       // Email is registered, send reset password email
  //       await sendPasswordResetEmail(email);

  //       // Show SnackBar
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Email reset password telah dikirim ke $email',
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //           backgroundColor: Colors.green,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );

  //       // Navigate to halaman sukses setelah menampilkan SnackBar
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PasswordChangeSuccessPage(email: email),
  //         ),
  //       );
  //     } else {
  //       // Handle other errors
  //       // Navigate to halaman kegagalan jika terjadi error
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const PasswordChangeFailurePage(),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Ganti dengan warna sesuai keinginan
    ));
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Lupa Password',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masukkan email Anda untuk reset password',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) => _validateFields(),
                            onChanged: (value) {
                              setState(() {
                                _emailErrorText = null;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Masukkan Email',
                              labelStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.green, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                              errorText: _emailErrorText,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 64),
                              backgroundColor: Colors.green,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Send Code',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun?', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                child: const Text('Login', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
