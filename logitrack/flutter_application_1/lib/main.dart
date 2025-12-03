import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';

/// Fungsi main - entry point aplikasi LogiTrack
void main() {
  runApp(const LogiTrackApp());
}

/// Widget utama aplikasi LogiTrack
/// Aplikasi ini digunakan untuk menampilkan daftar pengiriman kurir secara ringkas
class LogiTrackApp extends StatelessWidget {
  const LogiTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Konfigurasi aplikasi
      title: 'LogiTrack',
      theme: ThemeData(
        // Tema warna aplikasi menggunakan blue sebagai warna utama
        primarySwatch: Colors.blue,
        // Menggunakan Material Design 3 untuk tampilan yang lebih modern
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      // Halaman awal aplikasi - MULAI DARI LOGIN PAGE
      home: const LoginPage(),
      // Definisikan named routes untuk navigasi antar halaman
      routes: {
        '/dashboard': (context) => const DashboardPage(),
      },
      // Menyembunyikan debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
