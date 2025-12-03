# 📚 Dokumentasi LogiTrack

Folder ini berisi dokumentasi lengkap untuk aplikasi LogiTrack - Aplikasi Pelacakan Pengiriman untuk Kurir.

---

## 📖 Daftar Dokumentasi

### 1. **PASSWORD_FIELD_GUIDE.md**
Panduan lengkap membuat TextFormField password yang aman dengan:
- Text tersembunyi (obscureText)
- Validasi: tidak boleh kosong
- Validasi: minimal 6 karakter
- Toggle show/hide password

**Gunakan untuk**: Membuat input password field yang aman di halaman login atau form manapun.

---

### 2. **DELIVERY_TASK_GUIDE.md**
Dokumentasi model class `DeliveryTask` yang merepresentasikan data tugas pengiriman dari REST API.

**Fitur**:
- Constructor dengan parameter required
- Factory method `fromJson()` untuk parsing JSON
- Method `toJson()` untuk convert ke JSON
- Method `copyWith()` untuk immutability
- Contoh penggunaan dengan API

**Gunakan untuk**: Memahami cara kerja model DeliveryTask dan integrasi dengan REST API.

---

### 3. **LOGIN_PAGE_GUIDE.md**
Dokumentasi halaman login yang menampilkan:
- Form validation untuk username dan password
- Password field yang aman
- Loading state saat login
- Styling dan tema modern

**Gunakan untuk**: Memahami implementasi LoginPage dan cara integrasi dengan API.

---

### 4. **DISPLAYING_DATA_DYNAMICALLY.md** ⭐ NEW
Dokumentasi lengkap tentang menampilkan data dinamis dari REST API menggunakan **FutureBuilder**.

**Isi**:
- Algoritma & alur kerja FutureBuilder
- 3 Kondisi utama:
  - 🟡 `ConnectionState.waiting` - Loading indicator
  - 🔴 `snapshot.hasError` - Error handling dengan retry
  - 🟢 `snapshot.hasData` - Menampilkan data
- Flow diagram
- Contoh implementasi lengkap
- Best practices
- Advanced features (pagination, pull-to-refresh, caching)

**Gunakan untuk**: Memahami cara fetch data dari API dan menampilkannya dengan FutureBuilder.

---

### 5. **FUTUREBUILDER_3_CONDITIONS.md** ⭐ NEW
Ringkasan visual dan detail tentang 3 kondisi FutureBuilder:
- Visual flowchart
- Kapan setiap kondisi terjadi
- UI yang ditampilkan
- Code examples
- Best practices

**Gunakan untuk**: Quick reference tentang handling 3 kondisi FutureBuilder.

---

### 6. **API_DOCUMENTATION.md** ⭐ NEW
Dokumentasi lengkap tentang REST API LogiTrack:
- Endpoint definitions
- Request/Response examples
- Error handling
- Authentication (Bearer Token)
- HTTP status codes
- Testing dengan Postman
- Mock API untuk development

**Gunakan untuk**: Memahami struktur API dan cara mengintegrasikannya dengan aplikasi.

---

### 7. **PROJECT_STRUCTURE.md**
Penjelasan struktur folder dan file dalam project LogiTrack.

```
lib/
├── main.dart                    # Entry point aplikasi
├── models/
│   ├── pengiriman.dart         # Model untuk pengiriman lokal
│   └── delivery_task.dart      # Model untuk pengiriman dari API
├── pages/
│   └── login_page.dart         # Halaman login
└── widgets/
    └── pengiriman_card.dart    # Widget kartu pengiriman

docs/
├── README.md                    # File ini
├── PASSWORD_FIELD_GUIDE.md      # Panduan password field
├── DELIVERY_TASK_GUIDE.md       # Panduan DeliveryTask model
└── LOGIN_PAGE_GUIDE.md          # Panduan halaman login
```

---

## 🚀 Quick Start

### 1. Menjalankan Aplikasi
```bash
cd flutter_application_1
flutter pub get
flutter run -d chrome
```

### 2. Lint & Analyze
```bash
flutter analyze
```

### 3. Run Tests
```bash
flutter test
```

---

## 📋 Checklist Implementasi

- [x] Model `DeliveryTask` dengan factory method fromJson()
- [x] Model `Pengiriman` untuk data lokal
- [x] Widget `PengirimanCard` untuk menampilkan pengiriman
- [x] Halaman `LoginPage` dengan form validation
- [x] TextFormField password yang aman
- [x] Test file yang valid
- [x] Dokumentasi lengkap

---

## 🔐 Fitur Keamanan

### Password Field
- ✅ Text tersembunyi secara default
- ✅ Toggle show/hide dengan icon button
- ✅ Validasi: tidak boleh kosong
- ✅ Validasi: minimal 6 karakter
- ✅ Error message user-friendly

### Form Validation
- ✅ Username validation
- ✅ Password validation
- ✅ Visually clear error messages

---

## 📚 Struktur REST API

### Endpoint: Get Delivery Task
```
GET /api/deliveries/{id}

Response:
{
    "id": 101,
    "resi": "LOG-8821",
    "penerima": "Budi Santoso",
    "is_delivered": false
}
```

Untuk parsing response, gunakan:
```dart
final task = DeliveryTask.fromJson(jsonData);
```

---

## 🎨 UI Components

### Card-based Design
- Menggunakan Material Card dengan elevation
- Rounded corners (BorderRadius)
- Consistent padding dan spacing

### Icons
- `Icons.local_shipping` - Icon paket pengiriman
- `Icons.lock` - Icon password field
- `Icons.visibility` - Icon show password
- `Icons.visibility_off` - Icon hide password
- `Icons.person` - Icon username field

### Colors
- `Colors.blueAccent` - Primary color
- `Colors.green` - Status dikirim
- `Colors.red` - Status gagal
- `Colors.grey` - Status lainnya

---

## 🐛 Troubleshooting

### Error: "Undefined class 'TextEditingController'"
**Penyebab**: Import `package:flutter/material.dart` hilang
**Solusi**: Pastikan semua file memiliki import yang benar

### Error: "The name 'MyApp' isn't a class"
**Penyebab**: Nama class di main.dart berubah menjadi `LogiTrackApp`
**Solusi**: Update test file untuk menggunakan `LogiTrackApp` bukan `MyApp`

---

## 📞 Kontak & Support

Untuk pertanyaan atau feedback, silakan hubungi:
- Nama Aplikasi: **LogiTrack**
- Versi: **1.0.0**
- Flutter Version: **3.35.6**

---

## 📝 Catatan

- Semua file memiliki komentar yang menjelaskan bagian penting
- Code mengikuti Dart style guide
- Semua dependencies sudah diinclude di pubspec.yaml

---

**Last Updated**: December 3, 2025

---
