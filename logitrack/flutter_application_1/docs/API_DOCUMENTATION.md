# 📡 Contoh REST API & Response

## API Endpoint untuk Delivery Tasks

### Base URL
```
https://api.logitrack.com/v1
```

---

## 1. GET - Daftar Semua Pengiriman

### Request
```http
GET /deliveries
Content-Type: application/json
Authorization: Bearer {token}
```

### Response (200 - Success)
```json
[
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
  {
    "id": 103,
    "resi": "LOG-8823",
    "penerima": "Rian Pratama",
    "is_delivered": false
  },
  {
    "id": 104,
    "resi": "LOG-8824",
    "penerima": "Siti Nurhaliza",
    "is_delivered": true
  },
  {
    "id": 105,
    "resi": "LOG-8825",
    "penerima": "Ahmad Rizki",
    "is_delivered": false
  }
]
```

### Parsing di Dart
```dart
Future<List<DeliveryTask>> fetchDeliveryTasks() async {
  final response = await http.get(
    Uri.parse('https://api.logitrack.com/v1/deliveries'),
    headers: {
      'Authorization': 'Bearer ${token}',
    },
  );

  if (response.statusCode == 200) {
    // Parse JSON response
    final List<dynamic> jsonData = jsonDecode(response.body);
    
    // Convert ke List<DeliveryTask>
    return jsonData.map((item) {
      return DeliveryTask.fromJson(item);
    }).toList();
  }
}
```

---

## 2. GET - Single Pengiriman by ID

### Request
```http
GET /deliveries/101
Content-Type: application/json
Authorization: Bearer {token}
```

### Response (200 - Success)
```json
{
  "id": 101,
  "resi": "LOG-8821",
  "penerima": "Budi Santoso",
  "is_delivered": false
}
```

### Parsing di Dart
```dart
Future<DeliveryTask> fetchDeliveryTask(int id) async {
  final response = await http.get(
    Uri.parse('https://api.logitrack.com/v1/deliveries/$id'),
  );

  if (response.statusCode == 200) {
    return DeliveryTask.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('Pengiriman tidak ditemukan');
  }
}
```

---

## 3. POST - Update Status Pengiriman

### Request
```http
POST /deliveries/101/mark-delivered
Content-Type: application/json
Authorization: Bearer {token}

Body:
{
  "is_delivered": true,
  "delivered_at": "2024-12-03T14:30:00Z"
}
```

### Response (200 - Success)
```json
{
  "id": 101,
  "resi": "LOG-8821",
  "penerima": "Budi Santoso",
  "is_delivered": true,
  "delivered_at": "2024-12-03T14:30:00Z"
}
```

### Parsing di Dart
```dart
Future<DeliveryTask> markAsDelivered(int id) async {
  final response = await http.post(
    Uri.parse('https://api.logitrack.com/v1/deliveries/$id/mark-delivered'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    },
    body: jsonEncode({
      'is_delivered': true,
      'delivered_at': DateTime.now().toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return DeliveryTask.fromJson(jsonDecode(response.body));
  }
}
```

---

## 🔴 Error Responses

### 400 - Bad Request
```json
{
  "error": "invalid_request",
  "message": "Missing required field: penerima"
}
```

### 401 - Unauthorized
```json
{
  "error": "unauthorized",
  "message": "Invalid or expired token"
}
```

### 404 - Not Found
```json
{
  "error": "not_found",
  "message": "Pengiriman dengan ID 999 tidak ditemukan"
}
```

### 500 - Server Error
```json
{
  "error": "internal_server_error",
  "message": "Terjadi kesalahan pada server"
}
```

### Error Handling di Dart
```dart
try {
  final response = await http.get(
    Uri.parse('https://api.logitrack.com/v1/deliveries'),
  ).timeout(Duration(seconds: 10));

  if (response.statusCode == 200) {
    // Success
    return jsonDecode(response.body);
  } else if (response.statusCode == 401) {
    throw Exception('Autentikasi gagal - login ulang diperlukan');
  } else if (response.statusCode == 404) {
    throw Exception('Data tidak ditemukan');
  } else if (response.statusCode == 500) {
    throw Exception('Server sedang bermasalah, coba lagi nanti');
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
} on TimeoutException {
  throw Exception('Request timeout - server tidak merespons');
} on SocketException {
  throw Exception('Tidak ada koneksi internet');
} catch (e) {
  throw Exception('Error: $e');
}
```

---

## 📊 HTTP Status Codes

| Code | Status | Arti |
|------|--------|------|
| 200 | OK | Request berhasil |
| 201 | Created | Resource berhasil dibuat |
| 204 | No Content | Request berhasil, tidak ada data |
| 400 | Bad Request | Request format salah |
| 401 | Unauthorized | Perlu autentikasi |
| 403 | Forbidden | Tidak punya akses |
| 404 | Not Found | Resource tidak ada |
| 500 | Server Error | Kesalahan server |
| 503 | Service Unavailable | Server sedang down |

---

## 🔐 Authentication

### Bearer Token Pattern
```dart
final headers = {
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  'Content-Type': 'application/json',
};

final response = await http.get(
  Uri.parse(apiUrl),
  headers: headers,
);
```

### Storing Token Securely
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Save token
await storage.write(key: 'auth_token', value: token);

// Retrieve token
final token = await storage.read(key: 'auth_token');

// Delete token (logout)
await storage.delete(key: 'auth_token');
```

---

## 📝 Testing dengan Postman

### 1. Set up Environment Variables
```
base_url: https://api.logitrack.com/v1
token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2. GET Request
```
GET {{base_url}}/deliveries
Headers:
  Authorization: Bearer {{token}}
```

### 3. POST Request
```
POST {{base_url}}/deliveries
Headers:
  Authorization: Bearer {{token}}
  Content-Type: application/json
Body:
{
  "resi": "LOG-8826",
  "penerima": "Kurnia Sari",
  "is_delivered": false
}
```

---

## 🛠️ Mock API (untuk testing tanpa server nyata)

### Menggunakan Mock Server
```dart
// Gunakan mock HTTP client untuk testing
void main() {
  group('API Tests', () {
    test('fetchDeliveryTasks returns list', () async {
      // Mock response
      final mockResponse = [
        {
          "id": 101,
          "resi": "LOG-8821",
          "penerima": "Budi Santoso",
          "is_delivered": false
        }
      ];

      // Mock http.get
      when(mockHttp.get(any)).thenAnswer((_) async => 
        http.Response(jsonEncode(mockResponse), 200)
      );

      // Test
      final tasks = await fetchDeliveryTasks();
      expect(tasks.length, 1);
      expect(tasks[0].resi, 'LOG-8821');
    });
  });
}
```

---

## 📋 API Documentation Template

```
# DeliveryTask API

## Endpoints

### List All Deliveries
GET /deliveries

Query Parameters:
- page: int (default: 1)
- limit: int (default: 20)
- status: string (proses|dikirim|failed)

Response:
Array of DeliveryTask objects

### Get Delivery by ID
GET /deliveries/{id}

Response:
Single DeliveryTask object

### Update Delivery Status
PUT /deliveries/{id}
Body:
{
  "is_delivered": boolean,
  "notes": string
}

Response:
Updated DeliveryTask object
```

---

**Last Updated**: December 3, 2025
