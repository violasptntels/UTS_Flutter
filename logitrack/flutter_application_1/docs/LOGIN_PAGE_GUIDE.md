# Dokumentasi Login Page

## 📋 Overview
`LoginPage` adalah halaman autentikasi untuk aplikasi LogiTrack. Halaman ini memungkinkan kurir untuk login sebelum mengakses daftar pengiriman.

---

## 🎨 Fitur Utama

✅ **Form Validation** - Validasi username dan password
✅ **Password Security** - Password tersembunyi dengan toggle show/hide
✅ **Modern UI** - Card-based design dengan rounded corners
✅ **Loading State** - Loading indicator saat proses login
✅ **Error Feedback** - Pesan error yang user-friendly

---

## 📸 Widget Structure

```
LoginPage (StatefulWidget)
├── Scaffold
│   └── SingleChildScrollView
│       └── Card (Main Container)
│           └── Form (with GlobalKey)
│               ├── Logo & Title (Header)
│               ├── Username TextFormField
│               ├── Password TextFormField
│               │   ├── obscureText: _isObscure
│               │   ├── suffixIcon: Toggle Button
│               │   └── validator: _validatePassword
│               └── Login Button
```

---

## 🔐 Password Field Details

### Properties
- **obscureText**: `true` (tersembunyi secara default)
- **Validator**: Minimal 6 karakter, tidak boleh kosong
- **Toggle**: Icon button untuk show/hide password
- **Icon**: `Icons.lock` (prefix), `Icons.visibility`/`Icons.visibility_off` (suffix)

### Validasi Password
```dart
String? _validatePassword(String? value) {
  // Cek 1: Tidak boleh kosong
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  
  // Cek 2: Minimal 6 karakter
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  
  return null; // Valid
}
```

---

## 🔄 State Variables

```dart
class _LoginPageState extends State<LoginPage> {
  /// Form validation key
  final _formKey = GlobalKey<FormState>();
  
  /// Input controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  /// Password visibility state
  bool _isObscure = true;
  
  /// Loading state
  bool _isLoading = false;
}
```

---

## 🚀 Contoh Penggunaan

### 1. Navigasi ke Login Page
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginPage()),
);
```

### 2. Handle Login Success
```dart
// Setelah login berhasil, navigasi ke halaman home
Navigator.pushReplacementNamed(context, '/home');
```

### 3. Custom API Integration
```dart
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });
    
    // Call API untuk login
    loginUser(
      username: _usernameController.text,
      password: _passwordController.text,
    ).then((response) {
      setState(() {
        _isLoading = false;
      });
      
      if (response.success) {
        // Store token dan navigasi
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    });
  }
}
```

---

## 🎯 Input Validation

### Username Validation
- ✅ Tidak boleh kosong
- ✅ Minimum: 1 karakter

### Password Validation
- ✅ Tidak boleh kosong
- ✅ Minimum: 6 karakter
- ✅ Dapat berisi karakter apapun

---

## 🎨 Styling

### Colors
- **Primary**: `Colors.blueAccent`
- **Text Error**: `Colors.red`
- **Background**: `Colors.grey[100]`

### Border Radius
- **Card**: 16
- **Input Fields**: 12

### Elevation
- **Card**: 8

---

## ♻️ Lifecycle

### initState
```dart
// Controllers sudah dibuat saat field dideklarasikan
```

### dispose
```dart
@override
void dispose() {
  _usernameController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

---

## 📝 TODO Features

- [ ] Integrasi dengan REST API untuk login real
- [ ] Simpan token autentikasi di local storage
- [ ] Validasi email (jika username adalah email)
- [ ] Forgot password functionality
- [ ] Social media login integration
- [ ] Biometric authentication

---

## 📂 File Location

- Page: `lib/pages/login_page.dart`
- Dokumentasi: `docs/LOGIN_PAGE_GUIDE.md`

---

## 🔗 Related Files

- Model: `lib/models/delivery_task.dart`
- Main: `lib/main.dart`
- Test: `test/widget_test.dart`

---
