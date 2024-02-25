import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'home_screen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<SaleItem> saleItems = [];

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengecek pemberitahuan
    fetchSaleItems();
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
        final Map<String, dynamic> responseMap = json.decode(response.body);

        setState(() {
          if (responseMap.containsKey('data')) {
            saleItems = (responseMap['data'] as List<dynamic>)
                .map((data) => SaleItem.fromJson(data))
                .toList();

            // Filter items based on status
            saleItems =
                saleItems.where((item) => item.status == 'changed').toList();
          }
        });
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: saleItems.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: saleItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(saleItems[index].name),
                  subtitle: Text('Status: ${saleItems[index].status}'),
                );
              },
            ),
    );
  }
}
