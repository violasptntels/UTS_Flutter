# 📁 Struktur Project LogiTrack

```
logitrack/
└── flutter_application_1/
    ├── android/                          # Build configuration untuk Android
    ├── ios/                              # Build configuration untuk iOS
    ├── linux/                            # Build configuration untuk Linux
    ├── macos/                            # Build configuration untuk macOS
    ├── windows/                          # Build configuration untuk Windows
    ├── web/                              # Build configuration untuk Web
    │
    ├── lib/                              # 📚 SOURCE CODE
    │   ├── main.dart                     # ⭐ Entry point aplikasi
    │   │
    │   ├── models/                       # 🔧 Model classes
    │   │   ├── pengiriman.dart          # Model pengiriman lokal
    │   │   └── delivery_task.dart       # Model dari REST API
    │   │
    │   ├── pages/                        # 📄 Halaman-halaman aplikasi
    │   │   └── login_page.dart          # Halaman login
    │   │
    │   └── widgets/                      # 🎨 Custom widgets
    │       └── pengiriman_card.dart     # Widget kartu pengiriman
    │
    ├── docs/                             # 📖 DOKUMENTASI
    │   ├── README.md                     # Index dokumentasi
    │   ├── PASSWORD_FIELD_GUIDE.md       # Panduan password field
    │   ├── DELIVERY_TASK_GUIDE.md        # Panduan DeliveryTask model
    │   └── LOGIN_PAGE_GUIDE.md           # Panduan halaman login
    │
    ├── test/                             # 🧪 Unit & Widget tests
    │   └── widget_test.dart              # Test file
    │
    ├── build/                            # 🔨 Build output (generated)
    │
    ├── pubspec.yaml                      # 📦 Project dependencies & configuration
    ├── pubspec.lock                      # 🔒 Dependency lock file
    ├── analysis_options.yaml             # ⚙️ Lint rules configuration
    ├── flutter_application_1.iml         # IDE configuration
    └── README.md                         # Project README
```

---

## 📚 Penjelasan Setiap Folder

### `/lib` - Source Code
Berisi semua kode Dart aplikasi yang akan dijalankan.

- **main.dart** - Entry point aplikasi, konfigurasi app dan halaman utama
- **models/** - Model classes untuk struktur data
- **pages/** - Halaman/screen yang ditampilkan di aplikasi
- **widgets/** - Custom widgets yang bisa digunakan kembali

### `/docs` - Dokumentasi
Panduan lengkap tentang implementasi setiap fitur.

- **README.md** - Index dan quick start guide
- **PASSWORD_FIELD_GUIDE.md** - Cara membuat password field yang aman
- **DELIVERY_TASK_GUIDE.md** - Cara menggunakan model DeliveryTask
- **LOGIN_PAGE_GUIDE.md** - Cara menggunakan halaman login

### `/test` - Unit & Widget Tests
File testing untuk memastikan kode berfungsi dengan baik.

### `/build` - Build Output
Folder yang dibuat otomatis saat flutter build/run.

### Platform Folders
- **android/**, **ios/**, **linux/**, **macos/**, **windows/**, **web/**
  Konfigurasi native untuk setiap platform.

---

## 🎯 File-file Penting

| File | Deskripsi |
|------|-----------|
| `pubspec.yaml` | Dependencies dan configuration |
| `main.dart` | Entry point aplikasi |
| `login_page.dart` | Halaman login dengan form validation |
| `delivery_task.dart` | Model untuk data pengiriman dari API |
| `pengiriman_card.dart` | Widget menampilkan satu kartu pengiriman |
| `docs/README.md` | Index dokumentasi lengkap |

---

## 📊 Model Classes

### 1. DeliveryTask
```dart
// Dari REST API
DeliveryTask(
  id: 101,
  resi: "LOG-8821",
  penerima: "Budi Santoso",
  isDelivered: false,
)
```
📄 File: `lib/models/delivery_task.dart`
📖 Docs: `docs/DELIVERY_TASK_GUIDE.md`

### 2. Pengiriman
```dart
// Model lokal
Pengiriman(
  nomorResi: "INV-2024001",
  tujuanPengiriman: "Jl. Merdeka No. 10, Bandung",
  statusPengiriman: "proses",
)
```
📄 File: `lib/models/pengiriman.dart`

---

## 🎨 Widget Classes

### PengirimanCard
Widget untuk menampilkan satu pengiriman dalam bentuk card.
- Leading: Icon paket (Icons.local_shipping)
- Title: Nomor resi
- Subtitle: Tujuan pengiriman
- Trailing: Status dengan warna berbeda

📄 File: `lib/widgets/pengiriman_card.dart`

---

## 📄 Pages/Screens

### LoginPage
Halaman login dengan form validation dan password security.
- Username input dengan validation
- Password input dengan obscureText toggle
- Loading state saat login
- Error feedback

📄 File: `lib/pages/login_page.dart`
📖 Docs: `docs/LOGIN_PAGE_GUIDE.md`

---

## 🚀 Quick Commands

```bash
# Navigate to project
cd flutter_application_1

# Get dependencies
flutter pub get

# Run aplikasi di Chrome
flutter run -d chrome

# Run aplikasi di device/emulator Android
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios

# Build Web
flutter build web
```

---

## ✅ Checklist Struktur

- [x] Model classes di `/lib/models`
- [x] Pages di `/lib/pages`
- [x] Custom widgets di `/lib/widgets`
- [x] Main entry point di `/lib/main.dart`
- [x] Documentation di `/docs`
- [x] Tests di `/test`
- [x] Configuration files (pubspec.yaml, analysis_options.yaml)

---

## 🔗 Dependencies (dari pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

**Last Updated**: December 3, 2025
