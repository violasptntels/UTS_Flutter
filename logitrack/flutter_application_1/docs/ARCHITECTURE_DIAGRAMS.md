# 🎨 LogiTrack Application Architecture & Flow

## Complete Application Flow Diagram

```
╔════════════════════════════════════════════════════════════════════════════╗
║                         LOGITRACK APPLICATION                             ║
║                      Complete Milestone 1 Flow                            ║
╚════════════════════════════════════════════════════════════════════════════╝

                            ┌─────────────────┐
                            │  main.dart      │
                            │  Entry Point    │
                            └────────┬────────┘
                                     │
                    ┌────────────────┴────────────────┐
                    │   LogiTrackApp Setup            │
                    │   - Theme (Blue primary)        │
                    │   - Material Design 3           │
                    │   - Routes definition           │
                    └────────────────┬────────────────┘
                                     │
                    ┌────────────────▼────────────────┐
                    │    home: LoginPage              │
                    │    routes: {'/dashboard': ...}  │
                    └────────────────┬────────────────┘
                                     │
         ╔═══════════════════════════▼═══════════════════════════════╗
         ║           SCREEN 1: LOGIN PAGE                           ║
         ║        (lib/pages/login_page.dart)                       ║
         ╠═══════════════════════════════════════════════════════════╣
         ║                                                           ║
         ║  ┌─────────────────────────────────────────────────────┐ ║
         ║  │        🚚 LogiTrack                                 │ ║
         ║  │   Aplikasi Pelacakan Pengiriman                     │ ║
         ║  │                                                     │ ║
         ║  │  Username: ░░░░░░░░░░░ [person icon]               │ ║
         ║  │                                                     │ ║
         ║  │  Password: ••••••••••• [lock icon] [eye icon]       │ ║
         ║  │           Validasi: Tidak kosong, min 6 karakter    │ ║
         ║  │                                                     │ ║
         ║  │  ┌──────────────────────────────────────┐          │ ║
         ║  │  │       Login (Loading...)            │          │ ║
         ║  │  │    ⟳ (2 second delay)              │          │ ║
         ║  │  └──────────────────────────────────────┘          │ ║
         ║  │                                                     │ ║
         ║  │  ✓ Login berhasil! (Snackbar)                      │ ║
         ║  └─────────────────────────────────────────────────────┘ ║
         ║                                                           ║
         ║  STATE:                                                  ║
         ║  • _usernameController -> TextEditingController         ║
         ║  • _passwordController -> TextEditingController         ║
         ║  • _isObscure -> bool (show/hide password)              ║
         ║  • _isLoading -> bool (loading indicator)               ║
         ║                                                           ║
         ║  VALIDATION:                                            ║
         ║  ✓ Username: Not empty                                  ║
         ║  ✓ Password: Not empty, min 6 chars                     ║
         ║                                                           ║
         ║  NAVIGATION:                                            ║
         ║  pushReplacementNamed('/dashboard')                     ║
         ║  → Prevents back navigation                             ║
         ╚═══════════════════════════════════════════════════════════╝
                                     │
                    ┌────────────────▼────────────────┐
                    │  Form Validation (2 steps)      │
                    │  1. Check fields not empty      │
                    │  2. Check password length       │
                    │  3. If valid: proceed           │
                    │  4. If invalid: show errors     │
                    └────────────────┬────────────────┘
                                     │
                         ┌───────────▼───────────┐
                         │  Wait 2 seconds       │
                         │  (Simulated API call) │
                         └───────────┬───────────┘
                                     │
                         ┌───────────▼───────────┐
                         │  Show success message │
                         │  Navigate to          │
                         │  Dashboard Page       │
                         └───────────┬───────────┘
                                     │
         ╔═══════════════════════════▼═══════════════════════════════╗
         ║        SCREEN 2: DASHBOARD PAGE                         ║
         ║      (lib/pages/dashboard_page.dart)                    ║
         ║         WITH FUTUREBUILDER (3 STATES)                  ║
         ╠═══════════════════════════════════════════════════════════╣
         ║                                                           ║
         ║  ┌──────────────────────────────────────────────────────┐║
         ║  │      Dashboard Pengiriman              [Logout] │ ║
         ║  ├──────────────────────────────────────────────────────┤║
         ║  │                                                      ││
         ║  │  FutureBuilder<List<DeliveryTask>>                 ││
         ║  │  future: _futureDeliveryTasks                      ││
         ║  │  builder: (context, snapshot) { ... }             ││
         ║  │                                                      ││
         ║  ├──────────────────────────────────────────────────────┤║
         ║  │                                                      ││
         ║  │  ┌─ STATE 1: ConnectionState.waiting ──────┐       ││
         ║  │  │  (API request in progress)              │       ││
         ║  │  │                                          │       ││
         ║  │  │        ⟳ Memuat daftar pengiriman...   │       ││
         ║  │  │      (CircularProgressIndicator)        │       ││
         ║  │  └──────────────────────────────────────────┘       ││
         ║  │                                                      ││
         ║  │  ┌─ STATE 2: snapshot.hasError ─────────────┐       ││
         ║  │  │  (API call failed)                       │       ││
         ║  │  │                                          │       ││
         ║  │  │              ⚠️ Error Icon              │       ││
         ║  │  │        Gagal Memuat Data                │       ││
         ║  │  │                                          │       ││
         ║  │  │   Error: Request timeout - server        │       ││
         ║  │  │   tidak merespons                        │       ││
         ║  │  │                                          │       ││
         ║  │  │    ┌─────────────────────────┐          │       ││
         ║  │  │    │  🔄 Coba Lagi          │          │       ││
         ║  │  │    │  (_retryFetch())       │          │       ││
         ║  │  │    └─────────────────────────┘          │       ││
         ║  │  └──────────────────────────────────────────┘       ││
         ║  │                                                      ││
         ║  │  ┌─ STATE 3: snapshot.hasData ──────────────┐       ││
         ║  │  │  (API call successful, data loaded)      │       ││
         ║  │  │                                          │       ││
         ║  │  │  📋 ListView.builder (itemCount: 10)    │       ││
         ║  │  │                                          │       ││
         ║  │  │  ┌─ Item 1 ─────────────────────────┐  │       ││
         ║  │  │  │ 🚚 Resi: INV-0001                │  │       ││
         ║  │  │  │    Penerima: User 1              │  │       ││
         ║  │  │  │    Status: [Proses] (Blue)       │  │       ││
         ║  │  │  └───────────────────────────────────┘  │       ││
         ║  │  │                                          │       ││
         ║  │  │  ┌─ Item 2 ─────────────────────────┐  │       ││
         ║  │  │  │ 🚚 Resi: INV-0002                │  │       ││
         ║  │  │  │    Penerima: User 2              │  │       ││
         ║  │  │  │    Status: [Dikirim] (Green)     │  │       ││
         ║  │  │  └───────────────────────────────────┘  │       ││
         ║  │  │                                          │       ││
         ║  │  │  ... (8 more items)                      │       ││
         ║  │  │                                          │       ││
         ║  │  └──────────────────────────────────────────┘       ││
         ║  │                                                      ││
         ║  └──────────────────────────────────────────────────────┘║
         ║                                                           ║
         ║  API CALL:                                              ║
         ║  GET https://jsonplaceholder.typicode.com/todos?_limit=10
         ║                                                           ║
         ║  TIMEOUT: 10 seconds                                    ║
         ║  STATUS CODE CHECK: 200 = Success                       ║
         ║                                                           ║
         ║  DATA MAPPING:                                          ║
         ║  ├─ id (JSON) → id (int)                               ║
         ║  ├─ id (JSON) → resi (formatted "INV-XXXX")           ║
         ║  ├─ userId (JSON) → penerima ("User #")               ║
         ║  └─ completed (JSON) → isDelivered (bool)             ║
         ║                                                           ║
         ║  ERROR HANDLING:                                        ║
         ║  ├─ Network error → Displayed as error message         ║
         ║  ├─ Timeout → "Request timeout"                        ║
         ║  ├─ HTTP error → "Status: 500" etc                     ║
         ║  └─ Parse error → Exception caught and displayed       ║
         ║                                                           ║
         ║  WIDGETS:                                               ║
         ║  ├─ CircularProgressIndicator (loading state)          ║
         ║  ├─ Icon (error icon)                                  ║
         ║  ├─ ElevatedButton (retry)                             ║
         ║  ├─ ListView.builder (data display)                    ║
         ║  ├─ Card (item wrapper)                                ║
         ║  ├─ ListTile (item content)                            ║
         ║  └─ Container (status badge)                           ║
         ╚═══════════════════════════════════════════════════════════╝
```

---

## 📊 State Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    DASHBOARD PAGE STATE FLOW                    │
└─────────────────────────────────────────────────────────────────┘

initState() {
  _futureDeliveryTasks = fetchDeliveryTasks()
}
                    │
                    ▼
        ┌───────────────────────┐
        │  Future Created        │
        │  API call initiated    │
        └───────────┬───────────┘
                    │
    ┌───────────────┼───────────────┐
    │               │               │
    ▼               ▼               ▼
 ┌─────┐      ┌─────────┐      ┌─────────┐
 │WAIT │      │ SUCCESS │      │ ERROR   │
 │🟡   │      │ 🟢      │      │ 🔴      │
 └─────┘      └─────────┘      └─────────┘
    │              │               │
    │              │               │
    ▼              ▼               ▼
 Loading       ListView         Error UI
 Spinner       + Data           + Retry
 
    │              │               │
    └──────────────┼───────────────┘
                   │
                   ▼
            ┌──────────────┐
            │ FutureBuilder│
            │ Rebuilds UI  │
            └──────────────┘
```

---

## 🔄 Navigation & Route Setup

```
┌────────────────────────────────────────────────────────────────┐
│                    NAVIGATION ARCHITECTURE                      │
└────────────────────────────────────────────────────────────────┘

main.dart:
  ├─ MaterialApp(
  │  ├─ title: 'LogiTrack'
  │  ├─ theme: ThemeData(...)
  │  ├─ home: LoginPage()  ◄─── Initial route
  │  └─ routes: {
  │     └─ '/dashboard': (ctx) => DashboardPage()
  │  }
  └─)

Navigation Flow:

LoginPage ──pushReplacementNamed('/dashboard')──> DashboardPage
   │                                                    │
   │                                                    │
   └─── Prevents back navigation ◄──────────────────────┘
        User cannot return to login


Without pushReplacement (WRONG):
  User could press back button to return to login

With pushReplacement (CORRECT):
  After login, back button goes to previous app state
  Ensures authentication security
```

---

## 📦 Data Model & API Integration

```
┌────────────────────────────────────────────────────────────────┐
│             API INTEGRATION & DATA FLOW                         │
└────────────────────────────────────────────────────────────────┘

API: JSONPlaceholder (Public Mock API)
URL: https://jsonplaceholder.typicode.com/todos?_limit=10

JSON Response Example:
┌──────────────────────────────────────────────────────────────┐
│ [                                                            │
│   {                                                          │
│     "userId": 1,                                             │
│     "id": 1,                                                 │
│     "title": "delectus aut autem",                           │
│     "completed": false                                       │
│   },                                                         │
│   ... 9 more items                                           │
│ ]                                                            │
└──────────────────────────────────────────────────────────────┘
           │
           ▼
    JSON Parsing
    ├─ jsonDecode(response.body)
    └─ Map each item to DeliveryTask
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│           DATA MAPPING                                       │
├─────────────────────────────────────────────────────────────┤
│ JSON Field        →  DeliveryTask Field  →  Display         │
├─────────────────────────────────────────────────────────────┤
│ id: 1             →  id: 1               →  Internal use    │
│ id: 1             →  resi: "INV-0001"    →  "Resi: INV-0001"│
│ userId: 1         →  penerima: "User 1"  →  "Penerima: ..."│
│ completed: false  →  isDelivered: false  →  Status badge   │
└─────────────────────────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────────────┐
│     List<DeliveryTask> (10 items)                            │
└──────────────────────────────────────────────────────────────┘
           │
           ▼
        ListView
        ├─ Item 1: INV-0001 | User 1 | [Status]
        ├─ Item 2: INV-0002 | User 2 | [Status]
        ├─ Item 3: INV-0003 | User 1 | [Status]
        ... (7 more items)
        └─ Item 10: INV-0010 | User 5 | [Status]
```

---

## 🛡️ Error Handling Flow

```
┌────────────────────────────────────────────────────────────────┐
│              ERROR HANDLING & RECOVERY                          │
└────────────────────────────────────────────────────────────────┘

fetchDeliveryTasks() {
  try {
    http.get() → timeout(10s)
       │
       ├─ ✓ Success (200) → Parse JSON → Return List
       │
       ├─ ✗ Network Error → Throw Exception
       │
       ├─ ✗ Timeout → Throw Exception
       │
       └─ ✗ HTTP Error (4xx, 5xx) → Throw Exception
  }
  catch (e) {
    Throw Exception('Error: $e')
  }
}
       │
       ▼
FutureBuilder catches exception
       │
       ├─ snapshot.hasError = true
       │
       └─ Display Error State:
          ├─ Error icon
          ├─ Error message
          └─ Retry button

User clicks Retry:
       │
       └─> _retryFetch()
           └─> setState(() {
               _futureDeliveryTasks = fetchDeliveryTasks()
           })
               └─> FutureBuilder re-executes
```

---

## 📱 Widget Tree Structure

```
LogiTrackApp
├─ MaterialApp
│  ├─ home: LoginPage
│  │  └─ Scaffold
│  │     ├─ AppBar
│  │     └─ body: Center
│  │        └─ SingleChildScrollView
│  │           └─ Card
│  │              └─ Form
│  │                 ├─ TextFormField (username)
│  │                 ├─ TextFormField (password)
│  │                 │  └─ suffixIcon: IconButton
│  │                 └─ ElevatedButton (login)
│  │
│  └─ routes:
│     └─ '/dashboard': DashboardPage
│        └─ Scaffold
│           ├─ AppBar
│           └─ body: FutureBuilder<List<DeliveryTask>>
│              ├─ State 1 (waiting):
│              │  └─ Center
│              │     └─ Column
│              │        ├─ CircularProgressIndicator
│              │        └─ Text
│              │
│              ├─ State 2 (error):
│              │  └─ Center
│              │     └─ Column
│              │        ├─ Icon (error)
│              │        ├─ Text (title)
│              │        ├─ Text (message)
│              │        └─ ElevatedButton (retry)
│              │
│              └─ State 3 (data):
│                 └─ ListView.builder
│                    └─ Card
│                       └─ ListTile
│                          ├─ leading: Icon
│                          ├─ title: Text (resi)
│                          ├─ subtitle: Text (penerima)
│                          └─ trailing: Container (status)
```

---

## 🎨 Color Scheme

```
Primary Color: Colors.blueAccent (#2196F3)
  Used in:
  - AppBar background
  - Button backgrounds
  - Text/icons highlights
  - Icon colors

Status Colors (in cards):
  - In Progress: Blue (#2196F3)
  - Delivered: Green (#4CAF50)
  - Failed: Red (#F44336)
  - Default: Grey (#9E9E9E)

Background:
  - Cards: White
  - App: Light grey (Colors.grey[100])
  - Text: Default dark/grey
```

---

## 📋 Dependencies & Versions

```
Flutter SDK: 3.35.6
Dart SDK: 3.9.2

Dependencies:
  flutter: SDK
  cupertino_icons: ^1.0.2  (iOS icons)
  http: ^1.1.0              (HTTP requests)

Dev Dependencies:
  flutter_test: SDK
  flutter_lints: ^5.0.0
  lints: ^5.1.1
```

---

## ✅ Validation Rules

```
LOGIN PAGE VALIDATION:
├─ Username Field
│  └─ Rule: Cannot be empty
│     Error: "Username tidak boleh kosong"
│
└─ Password Field
   ├─ Rule 1: Cannot be empty
   │  Error: "Password tidak boleh kosong"
   │
   └─ Rule 2: Minimum 6 characters
      Error: "Password minimal 6 karakter"

FORM VALIDATION:
  - Uses FormState.validate()
  - Returns only if all fields pass
  - If any field fails, form invalid
  - Shows individual error messages
```

---

## 🚀 Performance Optimization

```
UI Performance:
  ✓ ListView.builder (lazy loading)
    → Only renders visible items
    → Saves memory for large lists

  ✓ FutureBuilder (one-time fetch)
    → API call happens once per page load
    → Not rebuilt unnecessarily

  ✓ Timeout handling (10 seconds)
    → Prevents hanging on slow network
    → User gets feedback

Memory Management:
  ✓ TextEditingController.dispose()
    → Releases memory when done
    → Prevents memory leaks

  ✓ Card elevation & shadow
    → Efficient rendering
    → Material Design standard

State Management:
  ✓ StatefulWidget.setState()
    → Only rebuilds affected widgets
    → Efficient state updates

  ✓ FutureBuilder snapshot caching
    → Doesn't refetch on rebuild
    → Efficient async handling
```

---

This completes Milestone 1 with full architecture documentation! ✅
