# 🎯 Ringkasan Algoritma FutureBuilder - 3 Kondisi

## 📊 Visual Flowchart

```
┌─────────────────────────────────────────────────────────────┐
│                  APLIKASI DIJALANKAN                        │
│              (initState dipanggil)                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│          FutureBuilder tracking Future object               │
│                                                              │
│  _futureDeliveryTasks = fetchDeliveryTasks()               │
│  (HTTP request ke API)                                      │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   ┌─────────┐   ┌────────────┐    ┌──────────┐
   │ WAITING │   │   ERROR    │    │   DATA   │
   │         │   │            │    │          │
   │ Process │   │   Failed   │    │ Success  │
   │  Loaded │   │   Error    │    │  Loaded  │
   └────┬────┘   └─────┬──────┘    └────┬─────┘
        │              │                 │
        ▼              ▼                 ▼
┌──────────────┐ ┌────────────────┐ ┌──────────────┐
│   Loading    │ │ Error Message  │ │  ListView    │
│   Spinner    │ │ + Retry Button │ │  with Cards  │
│              │ │                │ │              │
│ "Memuat..."  │ │ "Gagal Memuat" │ │ Pengiriman   │
│              │ │ "Coba Lagi"    │ │ items list   │
└──────────────┘ └────────────────┘ └──────────────┘
```

---

## 1️⃣ KONDISI: ConnectionState.waiting (LOADING)

### Kapan Terjadi?
```
Timeline:
T+0s: API request dikirim
T+0-5s: Menunggu response server
       → ConnectionState = WAITING
T+5s: Response diterima
```

### Apa yang Ditampilkan?
```dart
┌─────────────────────────────┐
│   🔄 Loading Indicator      │
│   (Spinner berputar)        │
│                             │
│ "Memuat daftar pengiriman..." │
└─────────────────────────────┘
```

### Code:
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),    // Spinner animation
        SizedBox(height: 16),
        Text('Memuat daftar pengiriman...'),
      ],
    ),
  );
}
```

### User Experience:
- ✅ User tahu aplikasi sedang loading
- ✅ Visual feedback dengan spinner
- ✅ Pesan informatif
- ✅ User tidak bingung

---

## 2️⃣ KONDISI: snapshot.hasError (ERROR)

### Kapan Terjadi?
```
Kemungkinan Penyebab:
├─ Network Error
│  ├─ Tidak ada internet connection
│  ├─ Timeout (server tidak response)
│  └─ Connection lost
├─ Server Error
│  ├─ Status 500 (Internal Server Error)
│  ├─ Status 404 (Not Found)
│  ├─ Status 401 (Unauthorized)
│  └─ Status 503 (Service Unavailable)
├─ Parsing Error
│  ├─ JSON format invalid
│  └─ Data type mismatch
└─ Exception
   ├─ Null pointer
   └─ Other runtime errors
```

### Apa yang Ditampilkan?
```dart
┌──────────────────────────────┐
│   ❌ Error!                  │
│                              │
│   "Gagal memuat data"        │
│   "Error: Network timeout"   │
│                              │
│   ┌──────────────────────┐   │
│   │   🔄 COBA LAGI      │   │
│   └──────────────────────┘   │
└──────────────────────────────┘
```

### Code:
```dart
if (snapshot.hasError) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error icon
        Icon(Icons.error_outline, color: Colors.red, size: 64),
        SizedBox(height: 16),
        
        // Error title
        Text(
          'Gagal memuat data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        
        // Error message detail
        Text(
          snapshot.error.toString(),  // Pesan error dari exception
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        
        // Retry button
        ElevatedButton(
          onPressed: () {
            setState(() {
              // Buat Future baru untuk retry
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

### User Experience:
- ✅ User tahu ada error
- ✅ Pesan error yang jelas
- ✅ Bisa retry dengan tombol
- ✅ Tidak stuck di loading state

---

## 3️⃣ KONDISI: snapshot.hasData (SUCCESS)

### Kapan Terjadi?
```
Timeline:
T+0s: API request dikirim
T+0-5s: Menunggu response
T+5s: Response diterima (status 200)
T+6s: JSON di-parse menjadi List<DeliveryTask>
T+7s: Data siap ditampilkan
     → snapshot.hasData = true
```

### Apa yang Ditampilkan?
```dart
┌────────────────────────────────┐
│  Dashboard Pengiriman          │
├────────────────────────────────┤
│ [Card 1]                       │
│ 📦 Resi: LOG-8821              │
│    Penerima: Budi Santoso      │
│    Status: 🔵 Proses           │
├────────────────────────────────┤
│ [Card 2]                       │
│ 📦 Resi: LOG-8822              │
│    Penerima: Ani Wijaya        │
│    Status: 🟢 Dikirim          │
├────────────────────────────────┤
│ [Card 3]                       │
│ 📦 Resi: LOG-8823              │
│    Penerima: Budi Santoso      │
│    Status: 🔵 Proses           │
└────────────────────────────────┘
```

### Code:
```dart
if (snapshot.hasData) {
  final List<DeliveryTask> tasks = snapshot.data!;
  
  // Cek jika list kosong
  if (tasks.isEmpty) {
    return Center(child: Text('Tidak ada data pengiriman'));
  }

  // Tampilkan ListView
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
            decoration: BoxDecoration(
              color: task.isDelivered ? Colors.green : Colors.blue,
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

### User Experience:
- ✅ Data ditampilkan dengan jelas
- ✅ Format yang mudah dibaca
- ✅ Status pengiriman terlihat dengan warna
- ✅ User bisa lihat semua pengiriman

---

## 📊 Tabel Perbandingan 3 Kondisi

| Kondisi | ConnectionState | Apa | UI | User Feedback |
|---------|-----------------|-----|----|----|
| **1. Waiting** | `waiting` | API sedang diproses | Loading spinner | Sedang loading... |
| **2. Error** | `done` | Request failed | Error message + retry | Ada masalah, coba ulang |
| **3. Data** | `done` | Request berhasil | ListView dengan data | Data berhasil dimuat |

---

## 🔄 Sequence Diagram

```
User                FutureBuilder         API Server
│                        │                     │
│─ Open App ────────────>│                     │
│                        │─ HTTP GET ────────>│
│                        │  (waiting state)    │
│    [Loading]           │                     │
│                        │                 [Processing]
│                        │<──── Response ──────│
│                        │  (status 200)       │
│                        │  JSON data          │
│                        │─ Parse JSON        │
│                        │─ Convert to        │
│                        │  List<Task>        │
│                        │─ Update builder    │
│    [Display List]      │   (hasData = true) │
│    [Show Cards]        │                    │
│                        │                    │
```

---

## 💡 Best Practices

### ✅ DO's:

```dart
// ✅ BAIK: Selalu handle 3 kondisi
if (snapshot.connectionState == ConnectionState.waiting) {
  // Loading UI
} else if (snapshot.hasError) {
  // Error UI dengan retry
} else if (snapshot.hasData) {
  // Success UI dengan data
}

// ✅ BAIK: Gunakan meaningful messages
Text('Memuat daftar pengiriman...')
Text('Gagal memuat data. Periksa koneksi internet Anda.')

// ✅ BAIK: Implement retry functionality
ElevatedButton(
  onPressed: () {
    setState(() {
      _futureDeliveryTasks = fetchDeliveryTasks();
    });
  },
  child: Text('Coba Lagi'),
)

// ✅ BAIK: Show loading indicator
CircularProgressIndicator()
Text('Memuat...')
```

### ❌ DON'Ts:

```dart
// ❌ BURUK: Tidak handle error
if (snapshot.hasData) {
  // Apa jika error? User bingung
}

// ❌ BURUK: Panggil API di builder (infinite loop)
builder: (context, snapshot) {
  fetchDeliveryTasks(); // JANGAN!
}

// ❌ BURUK: Abaikan loading state
// User tidak tahu sedang loading

// ❌ BURUK: Error message terlalu teknis
Text('socket error: connection refused')

// ❌ BURUK: Tidak ada retry
// User stuck jika error
```

---

## 🎯 Kesimpulan

### FutureBuilder Flow:
1. **Initiate**: Future dimulai → `connectionState = waiting`
2. **Wait**: User lihat loading indicator
3. **Complete**: Future selesai dengan 2 kemungkinan:
   - ✅ **Success**: `hasData = true` → tampilkan ListView
   - ❌ **Failure**: `hasError = true` → tampilkan error + retry
4. **User Action**: Klik retry atau interact dengan data

### Key Points:
- 🟡 **Waiting**: Loading state - tampilkan spinner
- 🔴 **Error**: Gagal load - tampilkan error message + retry button
- 🟢 **Data**: Sukses load - tampilkan ListView dengan cards

### Remember:
> **FutureBuilder adalah pattern terbaik untuk async UI di Flutter!**

---

**Last Updated**: December 3, 2025
