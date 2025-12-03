import 'package:flutter/material.dart';
import '../models/pengiriman.dart';

/// Widget untuk menampilkan satu kartu pengiriman dengan Card dan ListTile
/// Widget ini menampilkan informasi pengiriman dalam format yang ringkas dan menarik
class PengirimanCard extends StatelessWidget {
  /// Data pengiriman yang akan ditampilkan
  final Pengiriman pengiriman;

  /// Constructor untuk PengirimanCard
  const PengirimanCard({
    super.key,
    required this.pengiriman,
  });

  /// Fungsi untuk mendapatkan warna status berdasarkan jenis status pengiriman
  /// Mengembalikan warna yang berbeda untuk setiap status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'proses':
        return Colors.blue; // Status proses berwarna biru
      case 'dikirim':
        return Colors.green; // Status dikirim berwarna hijau
      case 'gagal':
        return Colors.red; // Status gagal berwarna merah
      default:
        return Colors.grey; // Status lainnya berwarna abu-abu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card memberikan shadow dan border radius otomatis untuk tampilan yang lebih baik
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        // LEADING: Icon paket pengiriman (Icons.local_shipping)
        // Icon ini ditampilkan di sebelah kiri kartu
        leading: Icon(
          Icons.local_shipping,
          color: Colors.blueAccent,
          size: 32,
        ),

        // TITLE: Nomor resi pengiriman (contoh: INV-2024001)
        // Ditampilkan dengan font tebal dan ukuran lebih besar
        title: Text(
          pengiriman.nomorResi,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        // SUBTITLE: Tujuan pengiriman (contoh: Jl. Merdeka No. 10, Bandung)
        // Ditampilkan di bawah nomor resi dengan warna abu-abu
        subtitle: Text(
          pengiriman.tujuanPengiriman,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          // maxLines: 1 dan overflow untuk menghindari text yang terlalu panjang
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // TRAILING: Status pengiriman berupa teks "proses" berwarna biru
        // Status ditampilkan dalam bentuk badge atau chip di sebelah kanan
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          // Dekorasi untuk membuat latar belakang status dengan warna sesuai status
          decoration: BoxDecoration(
            color: _getStatusColor(pengiriman.statusPengiriman),
            borderRadius: BorderRadius.circular(20), // Membuat sudut melengkung
          ),
          child: Text(
            pengiriman.statusPengiriman,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
