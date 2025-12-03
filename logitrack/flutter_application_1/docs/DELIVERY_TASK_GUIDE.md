# Dokumentasi DeliveryTask Model

## 📋 Overview
`DeliveryTask` adalah model class yang merepresentasikan data tugas pengiriman dari REST API. Class ini digunakan untuk parsing JSON data dan mapping ke object Dart.

---

## 📦 REST API Response Format

```json
{
    "id": 101,
    "resi": "LOG-8821",
    "penerima": "Budi Santoso",
    "is_delivered": false
}
```

---

## 🏗️ Class Properties

| Property | Type | Deskripsi |
|----------|------|-----------|
| `id` | `int` | ID unik untuk setiap tugas pengiriman |
| `resi` | `String` | Nomor resi pengiriman (contoh: LOG-8821) |
| `penerima` | `String` | Nama penerima barang pengiriman |
| `isDelivered` | `bool` | Status pengiriman (true = sudah dikirim, false = dalam proses) |

---

## 🔨 Constructor

```dart
/// Membuat instance DeliveryTask baru
final task = DeliveryTask(
  id: 101,
  resi: 'LOG-8821',
  penerima: 'Budi Santoso',
  isDelivered: false,
);
```

---

## 🔄 Factory Method: fromJson()

Digunakan untuk parsing JSON data dari REST API:

```dart
/// Parsing JSON dari API response
final jsonData = {
  "id": 101,
  "resi": "LOG-8821",
  "penerima": "Budi Santoso",
  "is_delivered": false
};

final task = DeliveryTask.fromJson(jsonData);

// Akses properties
print(task.id);          // 101
print(task.resi);        // LOG-8821
print(task.penerima);    // Budi Santoso
print(task.isDelivered); // false
```

---

## 💾 Method: toJson()

Mengubah object DeliveryTask menjadi Map (JSON). Berguna untuk mengirim data ke server atau menyimpan ke database lokal:

```dart
final task = DeliveryTask(
  id: 101,
  resi: 'LOG-8821',
  penerima: 'Budi Santoso',
  isDelivered: true,
);

// Convert to JSON
Map<String, dynamic> jsonData = task.toJson();
// Hasil:
// {
//   'id': 101,
//   'resi': 'LOG-8821',
//   'penerima': 'Budi Santoso',
//   'is_delivered': true,
// }
```

---

## 📋 Method: copyWith()

Membuat copy dari DeliveryTask dengan beberapa properti yang berbeda. Berguna untuk immutability dan state management:

```dart
final task = DeliveryTask(
  id: 101,
  resi: 'LOG-8821',
  penerima: 'Budi Santoso',
  isDelivered: false,
);

// Update hanya isDelivered menjadi true
final updatedTask = task.copyWith(isDelivered: true);

print(updatedTask.id);          // 101 (sama)
print(updatedTask.resi);        // LOG-8821 (sama)
print(updatedTask.penerima);    // Budi Santoso (sama)
print(updatedTask.isDelivered); // true (berubah)
```

---

## 🖨️ Method: toString()

Override toString() untuk debugging. Mempermudah visualisasi data saat development:

```dart
final task = DeliveryTask(
  id: 101,
  resi: 'LOG-8821',
  penerima: 'Budi Santoso',
  isDelivered: false,
);

print(task);
// Output: DeliveryTask(id: 101, resi: LOG-8821, penerima: Budi Santoso, isDelivered: false)
```

---

## 🚀 Contoh Penggunaan dengan API

```dart
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/delivery_task.dart';

Future<DeliveryTask> fetchDeliveryTask(int id) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/deliveries/$id'),
  );

  if (response.statusCode == 200) {
    // Parse JSON response
    final jsonData = jsonDecode(response.body);
    return DeliveryTask.fromJson(jsonData);
  } else {
    throw Exception('Failed to load delivery task');
  }
}

// Penggunaan
void main() async {
  try {
    final task = await fetchDeliveryTask(101);
    print('Resi: ${task.resi}');
    print('Penerima: ${task.penerima}');
    print('Status: ${task.isDelivered ? "Dikirim" : "Dalam Proses"}');
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## 📝 Contoh Penggunaan dengan List

```dart
// Parsing multiple delivery tasks dari API
List<DeliveryTask> parseDeliveryTasks(List<dynamic> jsonArray) {
  return jsonArray.map((item) => DeliveryTask.fromJson(item)).toList();
}

// Contoh usage
final jsonData = [
  {
    "id": 101,
    "resi": "LOG-8821",
    "penerima": "Budi Santoso",
    "is_delivered": false
  },
  {
    "id": 102,
    "resi": "LOG-8822",
    "penerima": "Ani Wijaya",
    "is_delivered": true
  },
];

final tasks = parseDeliveryTasks(jsonData);
for (var task in tasks) {
  print('${task.resi} - ${task.penerima}');
}
```

---

## ✅ Fitur Model

- ✅ Constructor dengan semua parameter required
- ✅ Factory method `fromJson()` untuk parsing dari API
- ✅ Method `toJson()` untuk convert ke JSON
- ✅ Method `copyWith()` untuk immutability
- ✅ Override `toString()` untuk debugging
- ✅ Fully documented dengan komentar

---

## 📂 File Location

- Model: `lib/models/delivery_task.dart`
- Dokumentasi: `docs/DELIVERY_TASK_GUIDE.md`

---
