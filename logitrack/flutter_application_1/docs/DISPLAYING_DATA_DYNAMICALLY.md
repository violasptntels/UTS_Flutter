# 📊 Menampilkan Data Dinamis dengan FutureBuilder

## 📋 Overview
Dokumentasi ini menjelaskan logika alur kerja (algoritma) untuk menampilkan daftar tugas pengiriman dari REST API ke halaman Dashboard menggunakan widget `FutureBuilder`.

---

## 🔄 Algoritma & Alur Kerja

### Flow Diagram
```
┌─────────────────────────────────────────────────────────────┐
│                      Aplikasi Dimulai                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│         FutureBuilder memanggil Future (API Request)        │
│                                                              │
│  Future: fetchDeliveryTasks() / http.get('/api/tasks')      │
└────────────────────────┬────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
    ┌─────────┐   ┌──────────┐   ┌──────────┐
    │ Waiting │   │  Error   │   │   Data   │
    │ (Loading)│   │ (Failed) │   │ (Success)│
    └─────────┘   └──────────┘   └──────────┘
          │              │              │
          ▼              ▼              ▼
    [Loading UI]  [Error UI]  [Display Data]
```

---

## 🎯 3 Kondisi ConnectionState

### 1️⃣ ConnectionState.waiting (Loading State)

**Kapan Terjadi:**
- API request sedang dikirim
- Data belum diterima dari server
- Tunggu respons dari server

**UI yang Ditampilkan:**
```
┌─────────────────────────────┐
│   Loading Indicator...      │
│   (Circular Progress Bar)   │
│                             │
│   "Memuat daftar pengiriman"│
└─────────────────────────────┘
```

**Code Example:**
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Memuat daftar pengiriman...'),
      ],
    ),
  );
}
```

**Alur Kerja:**
1. User membuka halaman Dashboard
2. FutureBuilder memulai API request
3. Status: `ConnectionState.waiting`
4. Tampilkan loading indicator
5. Tunggu respons server...

---

### 2️⃣ snapshot.hasError (Error State)

**Kapan Terjadi:**
- Koneksi internet gagal
- Server error (status 500, 404, etc)
- Timeout API request
- Parse JSON error
- Exception/Error dalam proses

**UI yang Ditampilkan:**
```
┌──────────────────────────────┐
│   ❌ Error!                  │
│                              │
│   "Gagal memuat data"        │
│   "Pesan error detail..."    │
│                              │
│   [Retry Button]             │
└──────────────────────────────┘
```

**Code Example:**
```dart
if (snapshot.hasError) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 64,
        ),
        SizedBox(height: 16),
        Text(
          'Gagal memuat data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          snapshot.error.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Retry: Panggil FutureBuilder lagi
            setState(() {
              _futureDeliveryTasks = fetchDeliveryTasks();
            });
          },
          child: Text('Coba Lagi'),
        ),
      ],
    ),
  );
}
```

**Alur Kerja:**
1. API request dikirim
2. Server menolak/error
3. Status: `snapshot.hasError = true`
4. Exception ditangkap di `snapshot.error`
5. Tampilkan error message
6. User bisa klik "Retry" untuk coba ulang

---

### 3️⃣ snapshot.hasData (Success State)

**Kapan Terjadi:**
- API request berhasil
- Data diterima dari server
- JSON berhasil di-parse
- Data siap ditampilkan

**UI yang Ditampilkan:**
```
┌──────────────────────────────┐
│   Dashboard - Daftar Pengiriman
│                              │
│  [Pengiriman Card 1]         │
│  Resi: LOG-8821              │
│  Penerima: Budi Santoso      │
│  Status: Proses              │
│                              │
│  [Pengiriman Card 2]         │
│  Resi: LOG-8822              │
│  Penerima: Ani Wijaya        │
│  Status: Dikirim             │
│                              │
│  [Pengiriman Card 3]         │
│  ...                         │
└──────────────────────────────┘
```

**Code Example:**
```dart
if (snapshot.hasData) {
  // Data tersedia - tampilkan ListView
  final List<DeliveryTask> tasks = snapshot.data!;
  
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      return Card(
        child: ListTile(
          leading: Icon(Icons.local_shipping),
          title: Text('Resi: ${task.resi}'),
          subtitle: Text(task.penerima),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.isDelivered ? 'Dikirim' : 'Proses',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    },
  );
}
```

**Alur Kerja:**
1. API request berhasil mendapat response
2. JSON di-parse menjadi List<DeliveryTask>
3. Status: `snapshot.hasData = true`
4. Data tersimpan di `snapshot.data`
5. Tampilkan ListView dengan data
6. Setiap item ditampilkan dalam Card/ListTile

---

## 🔌 API Integration Flow

### 1. Definisikan Future Function
```dart
/// Fungsi untuk fetch data dari API
Future<List<DeliveryTask>> fetchDeliveryTasks() async {
  try {
    // 1. Kirim HTTP GET request ke API
    final response = await http.get(
      Uri.parse('https://api.example.com/deliveries'),
    );

    // 2. Cek status code respons
    if (response.statusCode == 200) {
      // 3. Parse JSON response menjadi List
      final List<dynamic> jsonData = jsonDecode(response.body);
      
      // 4. Convert tiap item menjadi DeliveryTask
      return jsonData.map((item) {
        return DeliveryTask.fromJson(item);
      }).toList();
    } else {
      // Error: Server return status code error
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  } catch (e) {
    // Error: Network error, timeout, parse error, dll
    throw Exception('Error: $e');
  }
}
```

### 2. Deklarasikan Future di State Class
```dart
class _DashboardPageState extends State<DashboardPage> {
  /// Menyimpan Future object
  /// Digunakan oleh FutureBuilder
  late Future<List<DeliveryTask>> _futureDeliveryTasks;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Future saat State dibuat
    _futureDeliveryTasks = fetchDeliveryTasks();
  }

  // ... rest of the code
}
```

### 3. Implementasikan FutureBuilder
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Dashboard Pengiriman')),
    body: FutureBuilder<List<DeliveryTask>>(
      // 1. Masukkan Future yang akan di-track
      future: _futureDeliveryTasks,
      
      // 2. Builder function dipanggil setiap state berubah
      builder: (context, snapshot) {
        // ========== KONDISI 1: LOADING ==========
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // ========== KONDISI 2: ERROR ==========
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 64),
                SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureDeliveryTasks = fetchDeliveryTasks();
                    });
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        
        // ========== KONDISI 3: SUCCESS ==========
        if (snapshot.hasData) {
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return PengirimanCard(
                pengiriman: Pengiriman(
                  nomorResi: tasks[index].resi,
                  tujuanPengiriman: tasks[index].penerima,
                  statusPengiriman: tasks[index].isDelivered 
                      ? 'dikirim' 
                      : 'proses',
                ),
              );
            },
          );
        }
        
        // Fallback (tidak seharusnya sampai sini)
        return Center(child: Text('Tidak ada data'));
      },
    ),
  );
}
```

---

## 📊 Tabel Perbandingan 3 Kondisi

| Kondisi | Saat Terjadi | Apa yang Ditampilkan | User Experience |
|---------|-----------|---------------------|-----------------|
| **Waiting** | API sedang diproses | Loading indicator, spinning circle, "Memuat..." | User menunggu |
| **Error** | Request gagal/error | Error icon, pesan error, tombol retry | User tahu ada error, bisa coba ulang |
| **Data** | Request berhasil | ListView dengan semua data pengiriman | User lihat daftar pengiriman |

---

## 🎯 Best Practices

### ✅ DO's:
- ✅ Gunakan `FutureBuilder` untuk async operations
- ✅ Selalu handle 3 kondisi: waiting, error, hasData
- ✅ Tampilkan meaningful error messages
- ✅ Implement retry functionality
- ✅ Use proper loading indicators
- ✅ Cache data jika diperlukan

### ❌ DON'Ts:
- ❌ Panggil API di builder method (bisa infinite loop)
- ❌ Abaikan error state
- ❌ Tampilkan error message yang terlalu teknis
- ❌ Tidak ada loading indicator
- ❌ Hardcode API URLs

---

## 🔧 Advanced Features

### 1. Pagination
```dart
int _page = 1;

void loadMoreData() {
  _page++;
  setState(() {
    _futureDeliveryTasks = fetchDeliveryTasks(page: _page);
  });
}
```

### 2. Pull to Refresh
```dart
Future<void> _onRefresh() async {
  setState(() {
    _futureDeliveryTasks = fetchDeliveryTasks();
  });
  return await _futureDeliveryTasks;
}

RefreshIndicator(
  onRefresh: _onRefresh,
  child: FutureBuilder<List<DeliveryTask>>(
    // ... builder code
  ),
)
```

### 3. Caching
```dart
List<DeliveryTask>? _cachedTasks;

Future<List<DeliveryTask>> fetchDeliveryTasks() async {
  if (_cachedTasks != null) {
    return _cachedTasks!;
  }
  
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    _cachedTasks = parseData(response.body);
    return _cachedTasks!;
  }
  throw Exception('Failed to load');
}
```

---

## 📝 Contoh Implementasi Lengkap

File: `lib/pages/dashboard_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/delivery_task.dart';
import '../widgets/pengiriman_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<DeliveryTask>> _futureDeliveryTasks;

  @override
  void initState() {
    super.initState();
    _futureDeliveryTasks = fetchDeliveryTasks();
  }

  Future<List<DeliveryTask>> fetchDeliveryTasks() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/deliveries'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => DeliveryTask.fromJson(item)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Pengiriman'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DeliveryTask>>(
        future: _futureDeliveryTasks,
        builder: (context, snapshot) {
          // 1️⃣ LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat daftar pengiriman...'),
                ],
              ),
            );
          }

          // 2️⃣ ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureDeliveryTasks = fetchDeliveryTasks();
                      });
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // 3️⃣ SUCCESS STATE
          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            
            if (tasks.isEmpty) {
              return Center(
                child: Text('Tidak ada data pengiriman'),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.local_shipping, color: Colors.blueAccent),
                    title: Text('Resi: ${tasks[index].resi}'),
                    subtitle: Text(tasks[index].penerima),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tasks[index].isDelivered 
                            ? Colors.green 
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tasks[index].isDelivered ? 'Dikirim' : 'Proses',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text('Tidak ada data'));
        },
      ),
    );
  }
}
```

---

## 🎓 Kesimpulan

### FutureBuilder Workflow:
1. **Initiate**: Future dimulai saat `initState()`
2. **Wait**: FutureBuilder track progress → `ConnectionState.waiting`
3. **Resolve**: Future selesai dengan 2 kemungkinan:
   - ✅ **Success**: `snapshot.hasData` → tampilkan data
   - ❌ **Failure**: `snapshot.hasError` → tampilkan error
4. **Display**: UI update berdasarkan state

### 3 Kondisi Penting:
| # | Kondisi | Trigger | Display |
|---|---------|---------|---------|
| 1 | **Waiting** | Future sedang berjalan | Loading indicator |
| 2 | **Error** | Exception/error terjadi | Error message + retry |
| 3 | **Data** | Future complete dengan data | ListView dengan data |

---

**Last Updated**: December 3, 2025
