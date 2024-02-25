import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:apk_jual_sampah/berita_screen.dart';
import 'package:apk_jual_sampah/daftar_harga_sampah.dart';
import 'package:apk_jual_sampah/video_screen.dart';
import 'package:apk_jual_sampah/penjualan_screen.dart';
import 'package:apk_jual_sampah/nasabah_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_sale.dart';
import 'screen_notifikasi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentPage = 'Home'; // Atur halaman awal
  List<SaleItem> saleItems = []; // List to store sale items
  String saldo = 'Rp 0';
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    // Fetch sale items when the widget is initialized
    fetchSaleItems();
    fetchSaleItems();
    // Fetch saldo when the widget is initialized
    fetchSaldo();
  }

  void _navigateToDetailPage(BuildContext context, SaleItem saleItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSaleItemPage(saleItem: saleItem),
      ),
    );
  }

  Future<String?> getUserIdByEmail(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.get(
        Uri.parse(
            'https://banksampahapi.sppapp.com/get_profile.php?email=$email'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        dynamic id_akunuser = data['id_akunuser'];

        // Check if id_akunuser is not null or empty
        if (id_akunuser != null) {
          // Save id_akunuser to SharedPreferences
          prefs.setString('id_akunuser', id_akunuser.toString());

          // Log id_akunuser to console
          print('id_akunuser: $id_akunuser');

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

  Future<void> fetchSaleItems() async {
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

      // Now you have the id_akunuser, use it to fetch sale items
      final response = await http.get(
        Uri.parse(
            'https://banksampahapi.sppapp.com/get_sale.php?id_akunuser=$id_akunuser'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          saleItems = (responseData['data'] as List<dynamic>)
              .map((data) => SaleItem.fromJson(data))
              .toList();
        });
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> fetchSaldo() async {
    try {
      // Retrieve id_akunuser from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id_akunuser = prefs.getString('id_akunuser');

      // Ensure that id_akunuser is not null
      if (id_akunuser == null || id_akunuser.isEmpty) {
        return;
      }

      // Replace the URL with your actual API endpoint
      final response = await http.get(
        Uri.parse(
            'https://banksampahapi.sppapp.com/get_saldo.php?id_akunuser=$id_akunuser'),
      );

      if (response.statusCode == 200) {
        // Parse the response as a List<dynamic>
        final List<dynamic> responseData = json.decode(response.body);

        // Summing up kredit values for multiple saldo records
        double totalSaldo = 0.0;
        for (Map<String, dynamic> saldoData in responseData) {
          if (saldoData.containsKey('kredit')) {
            totalSaldo += double.parse(saldoData['kredit'].toString());
          }
        }

        // Format saldo with commas for better readability
        String formattedSaldo = totalSaldo.toStringAsFixed(2);
        formattedSaldo = NumberFormat.currency(locale: 'id', symbol: 'Rp ')
            .format(double.parse(formattedSaldo));

        setState(() {
          saldo = formattedSaldo;
        });
      } else {
        // Handle HTTP errors
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Anda',
                    style: GoogleFonts.robotoCondensed(
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    saldo,
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(LineIcons.bell, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              //margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchTerm = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search di sini...',
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              searchTerm = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Trash',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (saleItems.isEmpty)
              _buildEmptySaleItems()
            else
              Container(
                height: MediaQuery.of(context).size.height - 80,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio:
                        0.8, // Sesuaikan nilai ini untuk mengatur tinggi
                  ),
                  itemCount: saleItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _navigateToDetailPage(context, saleItems[index]);
                      },
                      child: _buildUploadedWasteItem(
                        context,
                        saleItems[index].name,
                        saleItems[index].imagePath,
                        saleItems[index].description,
                        saleItems[index].weight,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToPage(context, const PenjualanPage());
        },
        backgroundColor: Colors.green,
        child: const Icon(LineIcons.shoppingBasket, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  Widget _buildUploadedWasteItem(
    BuildContext context,
    String name,
    String imagePath,
    String description,
    String weight,
  ) {
    if (name.toLowerCase().contains(searchTerm.toLowerCase())){
      return SizedBox(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.green, width: 2.0),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150, // Adjusted height for the image container
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://banksampah.sppapp.com/uploads/media_mobile/sale/$imagePath',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description.length > 20
                          ? '${description.substring(0, 20)}...' // Tampilkan hanya 50 karakter pertama
                          : description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Weight: $weight',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildEmptySaleItems() {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LineIcons.shoppingBasket, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Data Your Trash Maih Kosong, Untuk menampilkan Data Nya silahkan Jual Sampah Dengan Menekan tombol Keranjang Di Bawah Kanan Layar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SaleItem {
  final String name;
  final String imagePath;
  final String description;
  final String weight;
  final String sampahType;
  final String address;
  final String phone;
  final String created;
  final String status;

  SaleItem(
      {required this.name,
      required this.imagePath,
      required this.description,
      required this.weight,
      required this.sampahType,
      required this.address,
      required this.created,
      required this.phone,
      required this.status});

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
        name: json['name_sampah'],
        imagePath: json['image_sale'],
        description: json['deskripsi'],
        weight: json['berat'],
        sampahType: json['jenis_sampah'],
        address: json['alamat'],
        created: json['created'],
        phone: json['telpon'],
        status: json['status']);
  }
}
