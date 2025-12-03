# Dokumentasi TextFormField Password dengan Validasi

## 📋 Overview
File ini berisi panduan lengkap untuk membuat TextFormField password yang aman dengan:
- Text tersembunyi secara default (obscureText)
- Validasi: password tidak boleh kosong
- Validasi: password minimal 6 karakter
- Toggle show/hide password dengan icon button

---

## 🔧 State Variables

Deklarasikan variabel berikut di dalam State class:

```dart
/// Variable untuk mengontrol visibilitas password
/// true = password tersembunyi (default)
/// false = password terlihat
bool _isObscure = true;

/// TextEditingController untuk menangkap input password
final TextEditingController _passwordController = TextEditingController();

/// GlobalKey untuk form validation
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
```

---

## ✅ Validator Function

Fungsi ini akan dijalankan otomatis saat form.validate() dipanggil:

```dart
/// Fungsi untuk validasi password
/// Password tidak boleh kosong dan minimal 6 karakter
String? _validatePassword(String? value) {
  // KETENTUAN 1: Password tidak boleh kosong
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  
  // KETENTUAN 2: Password minimal 6 karakter
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  
  // Jika lolos kedua validasi, return null (valid)
  return null;
}
```

---

## 🔐 Password Input Widget

Gunakan TextFormField berikut di dalam Form widget dengan GlobalKey:

```dart
TextFormField(
  /// Controller untuk mengambil nilai input
  controller: _passwordController,
  
  /// KETENTUAN 1: obscureText = true (password tersembunyi)
  obscureText: _isObscure,
  
  decoration: InputDecoration(
    labelText: 'Password',
    hintText: 'Masukkan password Anda',
    
    /// Icon di sebelah kiri (lock icon)
    prefixIcon: const Icon(Icons.lock),
    
    /// SUFFIX ICON: Tombol toggle show/hide password
    suffixIcon: IconButton(
      /// Icon berubah berdasarkan state _isObscure
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      
      /// Toggle password visibility
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
    ),
    
    /// Border styling
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    
    /// Border saat field fokus
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.blueAccent,
        width: 2,
      ),
    ),
    
    /// Error border
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
  ),
  
  /// KETENTUAN 2 & 3: Validator
  validator: _validatePassword,
)
```

---

## 🚀 Cara Menggunakan

### 1. Wrap TextFormField dengan Form Widget
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      // ... TextFormField password di sini ...
    ],
  ),
)
```

### 2. Validasi saat submit button diklik
```dart
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Form valid - lanjutkan proses login
      print('Password: ${_passwordController.text}');
    }
  },
  child: const Text('Login'),
)
```

### 3. Cleanup di dispose() method
```dart
@override
void dispose() {
  _passwordController.dispose();
  super.dispose();
}
```

---

## 🎯 Fitur Keamanan

- ✅ Text tersembunyi secara default (obscureText: true)
- ✅ User bisa toggle show/hide dengan icon button
- ✅ Validasi: tidak boleh kosong
- ✅ Validasi: minimal 6 karakter
- ✅ Error message yang user-friendly
- ✅ Icon visual yang jelas (lock + visibility toggle)
- ✅ Styling yang konsisten dengan theme aplikasi

---

## 📝 Contoh Implementasi Lengkap

Lihat file `lib/pages/login_page.dart` untuk contoh implementasi lengkap halaman login dengan password field yang aman.

---
