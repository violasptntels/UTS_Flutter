import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/delivery_task.dart';

/// Halaman Dashboard untuk menampilkan daftar pengiriman
/// Widget ini menggunakan FutureBuilder untuk menampilkan data dinamis dari API
/// dengan 3 kondisi: waiting, error, dan hasData
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Future untuk menyimpan request ke API
  /// Widget FutureBuilder akan track state dari Future ini
  late Future<List<DeliveryTask>> _futureDeliveryTasks;

  @override
  void initState() {
    super.initState();
    /// Inisialisasi Future saat State dibuat
    /// Ini akan memicu API call ke server
    _futureDeliveryTasks = fetchDeliveryTasks();
  }

  /// Fungsi untuk fetch daftar pengiriman dari API
  /// 
  /// Menggunakan JSONPlaceholder API (mock API publik)
  /// https://jsonplaceholder.typicode.com/todos
  /// 
  /// Alur Kerja:
  /// 1. Kirim HTTP GET request ke API server
  /// 2. Tunggu response dari server
  /// 3. Jika success (status 200): parse JSON menjadi list dari DeliveryTask objects
  /// 4. Jika error: throw exception
  /// 
  /// Bisa throw exception pada kondisi:
  /// - Network error (no internet, timeout)
  /// - Server error (status 500, 404, dll)
  /// - JSON parse error
  /// - Timeout
  Future<List<DeliveryTask>> fetchDeliveryTasks() async {
    try {
      /// LANGKAH 1: Kirim HTTP GET request dengan timeout 10 detik
      /// Menggunakan JSONPlaceholder API (publik, tidak perlu authentication)
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=10'),
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - server tidak merespons');
        },
      );

      /// LANGKAH 2: Cek status code response
      if (response.statusCode == 200) {
        /// SUCCESS: Server merespons dengan data
        
        /// LANGKAH 3: Parse JSON response menjadi List
        final List<dynamic> jsonData = jsonDecode(response.body);

        /// LANGKAH 4: Convert tiap item JSON menjadi DeliveryTask object
        /// Mapping JSONPlaceholder todos ke DeliveryTask:
        /// - id dari JSON -> id di DeliveryTask
        /// - title dari JSON -> resi di DeliveryTask
        /// - userId dari JSON -> penerima di DeliveryTask
        /// - completed dari JSON -> isDelivered di DeliveryTask
        return jsonData.map((item) {
          final id = item['id'] as int;
          return DeliveryTask(
            id: id,
            resi: 'INV-${id.toString().padLeft(4, '0')}',
            penerima: 'User ${item['userId']}',
            isDelivered: item['completed'] ?? false,
          );
        }).toList();
      } else {
        /// ERROR: Server return error status code
        throw Exception(
          'Gagal memuat data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      /// EXCEPTION: Network error, timeout, parse error, dll
      /// Rethrow exception sehingga FutureBuilder bisa catch
      throw Exception('Error: $e');
    }
  }

  /// Fungsi untuk retry fetch data (digunakan jika ada error)
  /// Akan reset Future dan menjalankan API call ulang
  void _retryFetch() {
    setState(() {
      /// Buat Future baru untuk menjalankan API call ulang
      _futureDeliveryTasks = fetchDeliveryTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// APP BAR: Header dengan judul Dashboard
      appBar: AppBar(
        title: const Text(
          'Dashboard Pengiriman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),

      /// BODY: FutureBuilder untuk menampilkan data dinamis
      /// FutureBuilder track 3 kondisi: waiting, error, hasData
      body: FutureBuilder<List<DeliveryTask>>(
        /// 1. Masukkan Future yang akan di-track
        /// FutureBuilder akan listen ke future ini
        future: _futureDeliveryTasks,

        /// 2. Builder function dipanggil setiap kali state Future berubah
        /// Menerima 2 parameter:
        /// - context: BuildContext
        /// - snapshot: AsyncSnapshot berisi data, error, dan connectionState
        builder: (context, snapshot) {
          /// ========================================
          /// 🟡 KONDISI 1: ConnectionState.waiting
          /// ========================================
          /// Ditampilkan saat:
          /// - API request sedang dikirim
          /// - Menunggu response dari server
          /// - Data belum diterima
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Loading indicator - circular progress bar
                  const CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                  const SizedBox(height: 24),
                  /// Loading text untuk memberitahu user
                  const Text(
                    'Memuat daftar pengiriman...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          /// ========================================
          /// 🔴 KONDISI 2: snapshot.hasError
          /// ========================================
          /// Ditampilkan saat:
          /// - API request gagal/error
          /// - Network error (no internet, timeout)
          /// - Server error (status 500, 404, dll)
          /// - JSON parse error
          /// - Exception dalam proses
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Error icon untuk visual feedback
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 24),

                  /// Error title
                  const Text(
                    'Gagal Memuat Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Error message (apa yang terjadi)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      /// snapshot.error berisi exception message
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Retry button - untuk coba ulang fetch data
                  ElevatedButton.icon(
                    onPressed: _retryFetch,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          /// ========================================
          /// 🟢 KONDISI 3: snapshot.hasData
          /// ========================================
          /// Ditampilkan saat:
          /// - API request berhasil
          /// - Data diterima dan di-parse dengan sukses
          /// - Data siap ditampilkan
          if (snapshot.hasData) {
            /// Ambil data dari snapshot
            /// snapshot.data berisi List<DeliveryTask> yang telah di-parse
            final List<DeliveryTask> tasks = snapshot.data!;

            /// Cek jika list kosong (tidak ada pengiriman)
            if (tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak ada data pengiriman',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            /// Tampilkan ListView dengan semua data pengiriman
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                /// Ambil data pengiriman untuk index saat ini
                final task = tasks[index];

                /// Build Card untuk setiap pengiriman
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    /// LEADING: Icon paket pengiriman
                    leading: Icon(
                      Icons.local_shipping,
                      color: Colors.blueAccent,
                      size: 32,
                    ),

                    /// TITLE: Nomor resi pengiriman dari API
                    title: Text(
                      'Resi: ${task.resi}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    /// SUBTITLE: Nama penerima dari API
                    subtitle: Text(
                      'Penerima: ${task.penerima}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    /// TRAILING: Status pengiriman dengan warna berbeda
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        /// Warna berdasarkan status pengiriman
                        color: task.isDelivered
                            ? Colors.green
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        /// Tampilkan status: "Dikirim" atau "Proses"
                        task.isDelivered ? 'Dikirim' : 'Proses',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          /// FALLBACK: Seharusnya tidak sampai sini
          /// Tapi sebagai safety, tampilkan pesan generic
          return Center(
            child: Text('Terjadi kesalahan yang tidak terduga'),
          );
        },
      ),
    );
  }
}
