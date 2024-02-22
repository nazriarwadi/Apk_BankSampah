// ignore_for_file: unused_field, duplicate_ignore, unused_element
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'home_screen.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({Key? key}) : super(key: key);

  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _tanggalPenjualanController = TextEditingController();
  final TextEditingController _deskripsiPenjualan = TextEditingController();

  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  late String _jenisSampah;
  String _kategoriHarga = '';

  List<Sampah> dropdownData = [];
  String? _selectedKategoriHarga;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _jenisSampah = 'Organik';
    fetchDropdownData();
    _selectedKategoriHarga = null; // Set a default or empty value
  }

  Future<void> fetchDropdownData() async {
    try {
      // Replace the URL with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://banksampahapi.sppapp.com/get_sampah.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          // Assuming Sampah class has a constructor that takes Map<String, dynamic>
          dropdownData = responseData.map((data) => Sampah.fromJson(data)).toList();
        });
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email_pengguna', email);

      final response = await http.get(
        Uri.parse('https://banksampahapi.sppapp.com/get_profile.php?email=$email'),
      );

      if (response.statusCode == 200) {
        // Assuming your API response is a JSON with a field 'id_akunuser'
        final Map<String, dynamic> data = json.decode(response.body);
        dynamic id_akunuser = data['id_akunuser'];

        // Check if id_akunuser is not null or empty
        if (id_akunuser != null) {
          return id_akunuser.toString();
        } else {
          return null;
        }
      } else {
        // Handle errors
        return null;
      }
    } catch (e) {
      // Handle exceptions
      return null;
    }
  }

  Future<void> _sellWaste() async {
    try {
      // Retrieve email_pengguna from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email_pengguna = prefs.getString('email_pengguna');

      // Ensure that email_pengguna is not null
      if (email_pengguna == null || email_pengguna.isEmpty) {
        return;
      }

      // Fetch user ID from the API
      String? id_akunuser = await getUserIdByEmail(email_pengguna);

      // Ensure that id_akunuser is not null
      if (id_akunuser == null || id_akunuser.isEmpty) {
        return;
      }

      const url = 'https://banksampahapi.sppapp.com/post_jual_sampah.php';

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields to the request
      request.fields['user_id'] = id_akunuser;
      request.fields['name_sampah'] = _namaBarangController.text;
      request.fields['alamat'] = _alamatController.text;
      request.fields['berat'] = _beratController.text;
      request.fields['telpon'] = _noHpController.text;
      request.fields['created'] = _tanggalPenjualanController.text;
      request.fields['jenis_sampah'] = _jenisSampah;
      request.fields['sampah_id'] = _selectedKategoriHarga ?? '';
      request.fields['deskripsi'] = _deskripsiPenjualan.text;

      // Add image file to the request
      if (_selectedImage != null) {
        var imageFile = await http.MultipartFile.fromPath('image_sale', _selectedImage!.path);
        request.files.add(imageFile);
      }

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        _showSuccessMessageAndNavigateToHome();
      } else {
      }
    } catch (e) {
    }
  }

  void _showSuccessMessageAndNavigateToHome() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Berhasil jual sampah!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _tanggalPenjualanController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Penjualan Sampah Page',
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white, size: 24.0, opacity: 2.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTextField(_namaBarangController, 'Nama Barang'),
              const SizedBox(height: 16),
              _buildTextField(_alamatController, 'Alamat'),
              const SizedBox(height: 16),
              _buildTextField(_beratController, 'Berat Sampah (kg)', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_noHpController, 'No HP', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(
                _tanggalPenjualanController,
                'Tanggal Penjualan',
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
              ),
              const SizedBox(height: 16),
              _buildDropdownField('Jenis Sampah', ['Organik', 'Non-Organik'], (value) {
                setState(() {
                  _jenisSampah = value!;
                });
              }),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Kategori Harga Bersih/Tidak',
                  border: OutlineInputBorder(),
                ),
                value: _selectedKategoriHarga,
                items: dropdownData.map((Sampah sampah) {
                  return DropdownMenuItem(
                    value: sampah.sampahId,
                    child: Text(sampah.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategoriHarga = value.toString();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildTextField(_deskripsiPenjualan, 'Catatan (Opsional)', maxLines: 3),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _sellWaste,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 146),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Jual Sampah', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController? controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int? maxLines,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      cursorColor: Colors.green,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
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
        suffixIcon: suffixIcon,
        suffixText: label == 'Berat Sampah (kg)' ? 'Kg' : '',
        suffixStyle: const TextStyle(color: Colors.green),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField(
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
      items: options.map((String option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      value: label == 'Jenis Sampah' ? _jenisSampah : _kategoriHarga,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gambar Sampah',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _selectedImage != null ? 'Change image' : 'Pick an image',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class Sampah {
    final String sampahId;
    final String name;

    Sampah({required this.sampahId, required this.name});

    factory Sampah.fromJson(Map<String, dynamic> json) {
      return Sampah(
        sampahId: json['sampah_id'],
        name: json['name'],
      );
    }
  }
