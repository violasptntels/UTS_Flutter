import 'package:flutter/material.dart';

/// Import DashboardPage untuk navigasi setelah login (opsional, jika menggunakan direct navigation)

/// Halaman Login untuk aplikasi LogiTrack
/// Halaman ini menangani autentikasi pengguna (kurir) sebelum mengakses daftar pengiriman
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Form key untuk validasi form
  /// Digunakan untuk menvalidasi dan mengontrol form
  final _formKey = GlobalKey<FormState>();

  /// TextEditingController untuk input username
  /// Menangkap dan menyimpan nilai yang diketik user di field username
  final _usernameController = TextEditingController();

  /// TextEditingController untuk input password
  /// Menangkap dan menyimpan nilai yang diketik user di field password
  final _passwordController = TextEditingController();

  /// State untuk mengontrol visibilitas password
  /// true = password tersembunyi (obscure)
  /// false = password terlihat
  bool _isObscure = true;

  /// State untuk menampilkan loading indicator saat proses login
  bool _isLoading = false;

  @override
  void dispose() {
    /// Membersihkan TextEditingController untuk menghindari memory leak
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk validasi username
  /// Username tidak boleh kosong
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  /// Fungsi untuk validasi password
  /// Password tidak boleh kosong dan minimal 6 karakter
  String? _validatePassword(String? value) {
    // Validasi 1: Password tidak boleh kosong
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    // Validasi 2: Password minimal 6 karakter
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null; // Validasi berhasil
  }

  /// Fungsi untuk menangani proses login
  /// Memvalidasi form dan mengirim request ke server
  void _handleLogin() {
    // Validasi form - jika ada error validation, form tidak valid
    if (_formKey.currentState!.validate()) {
      // Form valid, lanjut proses login
      setState(() {
        _isLoading = true;
      });

      // Simulasi API call (dalam aplikasi nyata, hubungi REST API di sini)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Navigasi ke halaman Dashboard setelah login berhasil
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login berhasil!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
          // Navigasi ke DashboardPage dan hapus LoginPage dari stack
          // Sehingga user tidak bisa back ke login
          Navigator.of(context).pushReplacementNamed('/dashboard');
          // Alternatif jika belum setup named routes:
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => const DashboardPage()),
          // );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// HEADER: Logo dan judul aplikasi
                      Icon(
                        Icons.local_shipping,
                        size: 64,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'LogiTrack',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aplikasi Pelacakan Pengiriman',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// INPUT USERNAME
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Masukkan username Anda',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: _validateUsername,
                      ),
                      const SizedBox(height: 16),

                      /// INPUT PASSWORD DENGAN KEAMANAN
                      /// ===================================
                      /// Widget ini menampilkan password field yang aman dengan:
                      /// 1. Text tersembunyi secara default (obscureText)
                      /// 2. Validasi: tidak boleh kosong dan minimal 6 karakter
                      /// 3. Toggle button untuk menampilkan/menyembunyikan password
                      /// ===================================
                      TextFormField(
                        controller: _passwordController,
                        /// KETENTUAN 1: obscureText = true untuk menyembunyikan password
                        /// Menggunakan state_isObscure untuk toggle visibilitas
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Masukkan password Anda',
                          prefixIcon: const Icon(Icons.lock),
                          /// SUFFIX ICON: Tombol untuk toggle show/hide password
                          suffixIcon: IconButton(
                            icon: Icon(
                              /// Menampilkan icon berbeda berdasarkan state
                              /// Jika password tersembunyi, tampilkan eye icon
                              /// Jika password terlihat, tampilkan eye_slash icon
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            /// Fungsi untuk toggle obscureText
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        /// KETENTUAN 2 & 3: Validasi password
                        /// - Tidak boleh kosong
                        /// - Minimal 6 karakter
                        validator: _validatePassword,
                      ),
                      /// ===================================
                      /// END: Input Password Widget
                      /// ===================================

                      const SizedBox(height: 24),

                      /// TOMBOL LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
