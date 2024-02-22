// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';

import 'screen_login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? _nameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _addressErrorText;
  String? _telephoneErrorText;

  File? _photoKTPPath;
  File? _photoDiriPath;

  bool _photoKTPError = false;
  bool _photoDiriError = false;

  Future<XFile?> _pickImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    return pickedImage;
  }

  Future<void> _validateFields() async {
    final fullName = _fullNameController.text.trim();
    final address = _addressController.text.trim();
    final telephone = _telephoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validasi untuk Fullname
    if (fullName.isEmpty) {
      setState(() {
        _nameErrorText = 'Fullname tidak boleh kosong';
      });
      return;
    } else {
      setState(() {
        _nameErrorText = null;
      });
    }

    // Validasi untuk Address
    if (address.isEmpty) {
      setState(() {
        _addressErrorText = 'Address tidak boleh kosong';
      });
      return;
    } else {
      setState(() {
        _addressErrorText = null;
      });
    }

    // Validasi untuk Telephone
    if (telephone.isEmpty) {
      setState(() {
        _telephoneErrorText = 'Telephone tidak boleh kosong';
      });
      return;
    } else {
      setState(() {
        _telephoneErrorText = null;
      });
    }

    // Validasi untuk Email
    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email tidak boleh kosong';
      });
      return;
    } else if (!isValidEmail(email)) {
      setState(() {
        _emailErrorText = 'Masukkan email yang valid';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password tidak boleh kosong';
      });
    } else if (password.length < 7) {
      setState(() {
        _passwordErrorText =
            'Password harus terdiri dari setidaknya 7 karakter';
      });
    } else {
      setState(() {
        _passwordErrorText = null;
      });
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordErrorText = 'Konfirmasi Password tidak boleh kosong';
      });
    } else if (confirmPassword != password) {
      setState(() {
        _confirmPasswordErrorText = 'Konfirmasi Password tidak sesuai';
      });
    } else {
      setState(() {
        _confirmPasswordErrorText = null;
      });
    }

    // Validasi untuk Photo KTP
    if (_photoKTPPath == null || _photoKTPPath!.path.isEmpty) {
      setState(() {
        _photoKTPError = true;
      });
      return;
    } else {
      setState(() {
        _photoKTPError = false;
      });
    }

    // Validasi untuk Photo Diri
    if (_photoDiriPath == null || _photoDiriPath!.path.isEmpty) {
      setState(() {
        _photoDiriError = true;
      });
      return;
    } else {
      setState(() {
        _photoDiriError = false;
      });
    }

    if (_nameErrorText == null &&
        _emailErrorText == null &&
        _passwordErrorText == null &&
        _confirmPasswordErrorText == null &&
        _addressErrorText == null &&
        _telephoneErrorText == null &&
        !_photoKTPError &&
        !_photoDiriError) {
      // Prepare data for registration
      final registrationData = {
        'nama': fullName,
        'no_rekening': '',
        'email': email,
        'password': password,
        'address': address,
        'nomor_handphone': telephone,
        'foto_ktp': '',
        'foto_diri': '',
        // Add more data as needed
      };

      // Prepare files for upload
      final photoKTPFile = await http.MultipartFile.fromPath(
        'foto_ktp',
        _photoKTPPath!.path,
      );

      final photoDiriFile = await http.MultipartFile.fromPath(
        'foto_diri',
        _photoDiriPath!.path,
      );

      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://banksampahapi.sppapp.com/register.php'),
      );

      // Add fields to the request
      registrationData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add files to the request
      request.files.add(photoKTPFile);
      request.files.add(photoDiriFile);

      try {
        // Send the request
        final response = await request.send();

        if (response.statusCode == 200) {
          // Successful registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate to login page after successful registration
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } else {
          // Handle registration errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Registrasi',
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registrasi To Continue',
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
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
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              errorText: _emailErrorText,
                              prefixIcon: const Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              onChanged: (value) {
                                setState(() {
                                  _passwordErrorText = null;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Masukkan Password',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  errorText: _passwordErrorText,
                                  prefixIcon: const LineIcon.key()),
                            ),
                            IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_confirmPasswordVisible,
                              onChanged: (value) {
                                setState(() {
                                  _confirmPasswordErrorText = null;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Konfirmasi Password',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                  errorText: _confirmPasswordErrorText,
                                  prefixIcon: const LineIcon.key()),
                            ),
                            IconButton(
                              icon: Icon(_confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _fullNameController,
                          onChanged: (value) {
                            setState(() {
                              _nameErrorText = null;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Fullname',
                              labelStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              errorText: _nameErrorText,
                              prefixIcon: const Icon(Icons.person_2_outlined)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _addressController,
                          onChanged: (value) {
                            setState(() {
                              _addressErrorText = null;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              errorText: _addressErrorText,
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _telephoneController,
                          onChanged: (value) {
                            setState(() {
                              _telephoneErrorText = null;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Telephone',
                              labelStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              errorText: _telephoneErrorText,
                              prefixIcon: const Icon(Icons.phone_outlined)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _photoKTPPath != null
                                ? _photoKTPPath!.path.split('/').last
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Foto KTP',
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            errorText: _photoKTPError
                                ? 'Foto KTP tidak boleh kosong'
                                : null,
                            prefixIcon: const Icon(Icons.image_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.file_upload),
                              onPressed: () async {
                                final pickedImage = await _pickImage();
                                if (pickedImage != null) {
                                  setState(() {
                                    _photoKTPPath = File(pickedImage.path);
                                    _photoKTPError = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _photoDiriPath != null
                                ? _photoDiriPath!.path.split('/').last
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Foto Diri',
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            errorText: _photoDiriError
                                ? 'Foto Diri tidak boleh kosong'
                                : null,
                            prefixIcon: const Icon(Icons.image_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.file_upload),
                              onPressed: () async {
                                final pickedImage = await _pickImage();
                                if (pickedImage != null) {
                                  setState(() {
                                    _photoDiriPath = File(pickedImage.path);
                                    _photoDiriError = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        ElevatedButton(
                          onPressed: () async {
                            await _validateFields();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 64),
                            backgroundColor: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Registrasi',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Sudah punya akun?',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
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
