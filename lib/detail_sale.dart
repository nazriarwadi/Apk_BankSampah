import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'home_screen.dart';

class DetailSaleItemPage extends StatefulWidget {
  final SaleItem saleItem;

  const DetailSaleItemPage({Key? key, required this.saleItem}) : super(key: key);

  @override
  _DetailSaleItemPageState createState() => _DetailSaleItemPageState();
}

class _DetailSaleItemPageState extends State<DetailSaleItemPage> {
  // Add a GlobalKey for the RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
      ),
      // Wrap the content in RefreshIndicator
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    'https://banksampah.sppapp.com/uploads/media_mobile/sale/${widget.saleItem.imagePath}',
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailItem(LineIcons.tag, 'Nama Sampah', widget.saleItem.name),
                _buildDetailItem(LineIcons.mapMarker, 'Alamat', widget.saleItem.address),
                _buildDetailItem(LineIcons.weight, 'Berat', widget.saleItem.weight),
                _buildDetailItem(LineIcons.phone, 'Telepon', widget.saleItem.phone),
                _buildDetailItem(LineIcons.recycle, 'Jenis Sampah', widget.saleItem.sampahType),
                _buildDetailItem(LineIcons.infoCircle, 'Deskripsi', widget.saleItem.description),
                _buildDetailItem(LineIcons.calendar, 'Tanggal Dibuat', widget.saleItem.created),
                const SizedBox(height: 4),
                _buildDetailItem(
                  LineIcons.checkCircle,
                  'Status',
                  _buildStatusBadge(widget.saleItem.status),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Implement your logic to refresh data here
    // For example, refetch data from the server

    // Simulating a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    // After refreshing, rebuild the widget
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildDetailItem(IconData icon, String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  value is Widget
                      ? value
                      : Text('$value'),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    String statusBadgeText;
    Color statusBadgeColor;

    switch (status) {
      case 'Y':
        statusBadgeText = 'Menunggu';
        statusBadgeColor = Colors.green;
        break;
      case 'J':
        statusBadgeText = 'Sedang Dijemput';
        statusBadgeColor = Colors.orange;
        break;
      case 'N':
        statusBadgeText = 'Sudah Selesai';
        statusBadgeColor = Colors.red;
        break;
      default:
        statusBadgeText = 'NO';
        statusBadgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: statusBadgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusBadgeText,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
