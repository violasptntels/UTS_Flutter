# ⚡ QUICK REFERENCE: FutureBuilder & 3 Kondisi

## Ringkasan Cepat

### 🎯 Tujuan FutureBuilder
Menampilkan data dari API dengan automatic state management:
- Loading state (waiting)
- Error state (hasError)
- Success state (hasData)

---

## 📌 3 Kondisi dalam 30 Detik

| # | Kondisi | Kapan | Tampilkan | Code |
|---|---------|-------|-----------|------|
| **1** | `waiting` | API loading | Spinner + "Memuat..." | `CircularProgressIndicator()` |
| **2** | `hasError` | API failed | Error icon + "Gagal" + Retry | `Icon(Icons.error)` |
| **3** | `hasData` | API success | ListView dengan data | `ListView.builder()` |

---

## 📝 Template Code

```dart
// 1. Deklarasi Future di State
late Future<List<DeliveryTask>> _futureDeliveryTasks;

// 2. Initialize di initState
@override
void initState() {
  super.initState();
  _futureDeliveryTasks = fetchDeliveryTasks();
}

// 3. Build dengan FutureBuilder
@override
Widget build(BuildContext context) {
  return FutureBuilder<List<DeliveryTask>>(
    future: _futureDeliveryTasks,
    builder: (context, snapshot) {
      // 🟡 KONDISI 1: Waiting
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      
      // 🔴 KONDISI 2: Error
      if (snapshot.hasError) {
        return Column(
          children: [
            Text('Error: ${snapshot.error}'),
            ElevatedButton(
              onPressed: () => setState(() {
                _futureDeliveryTasks = fetchDeliveryTasks();
              }),
              child: Text('Retry'),
            ),
          ],
        );
      }
      
      // 🟢 KONDISI 3: Data
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index].resi),
            );
          },
        );
      }
      
      return Text('No data');
    },
  );
}
```

---

## 🔌 Fetch Data dari API

```dart
Future<List<DeliveryTask>> fetchDeliveryTasks() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/deliveries'),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => DeliveryTask.fromJson(item)).toList();
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
```

---

## ✅ Checklist

- [ ] Model class dengan `fromJson()` dibuat
- [ ] API function dibuat
- [ ] FutureBuilder di-implement
- [ ] 3 kondisi di-handle (waiting, error, data)
- [ ] Retry functionality ditambahkan
- [ ] Loading indicator ditampilkan
- [ ] Error message user-friendly
- [ ] http package ditambahkan di pubspec.yaml

---

## 🚀 Common Errors & Fixes

### Error: "The name 'http' is not defined"
**Fix**: Tambahkan `import 'package:http/http.dart' as http;`

### Error: "Future is called multiple times"
**Fix**: Deklarasikan Future di State, bukan di builder

### Error: "Null check operator used on null value"
**Fix**: Gunakan `snapshot.data!` hanya jika sudah di-check `hasData`

### App stuck di Loading
**Fix**: Ada timeout atau API not responding - implement timeout duration

---

## 💡 Tips

- Selalu handle 3 kondisi - jangan abaikan error state
- Implement retry button di error state
- Gunakan meaningful loading messages
- Cache data jika perlu mengurangi API calls
- Implement pagination untuk list besar

---

**Lihat dokumentasi lengkap di**: `DISPLAYING_DATA_DYNAMICALLY.md`

