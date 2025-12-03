/// Model class untuk data tugas pengiriman dari REST API
/// Class ini merepresentasikan satu tugas pengiriman yang diterima dari server
class DeliveryTask {
  /// ID unik untuk setiap tugas pengiriman
  /// Digunakan untuk mengidentifikasi tugas di database
  final int id;

  /// Nomor resi pengiriman (contoh: LOG-8821)
  /// Digunakan sebagai tracking number untuk pelanggan
  final String resi;

  /// Nama penerima barang pengiriman
  /// Contoh: "Budi Santoso"
  final String penerima;

  /// Status pengiriman
  /// true = sudah dikirim/delivered
  /// false = masih dalam proses pengiriman
  final bool isDelivered;

  /// Constructor untuk membuat instance DeliveryTask
  /// Semua parameter adalah required
  DeliveryTask({
    required this.id,
    required this.resi,
    required this.penerima,
    required this.isDelivered,
  });

  /// Factory constructor untuk parsing data dari JSON
  /// Mengubah data JSON dari REST API menjadi object DeliveryTask
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// final jsonData = {
  ///   "id": 101,
  ///   "resi": "LOG-8821",
  ///   "penerima": "Budi Santoso",
  ///   "is_delivered": false
  /// };
  /// final task = DeliveryTask.fromJson(jsonData);
  /// ```
  factory DeliveryTask.fromJson(Map<String, dynamic> json) {
    return DeliveryTask(
      /// Mengambil nilai 'id' dari JSON dan cast ke int
      id: json['id'] as int,
      /// Mengambil nilai 'resi' dari JSON dan cast ke String
      resi: json['resi'] as String,
      /// Mengambil nilai 'penerima' dari JSON dan cast ke String
      penerima: json['penerima'] as String,
      /// Mengambil nilai 'is_delivered' dari JSON dan cast ke bool
      isDelivered: json['is_delivered'] as bool,
    );
  }

  /// Method untuk mengubah DeliveryTask menjadi Map (JSON)
  /// Berguna ketika ingin mengirim data ke server atau menyimpan ke database lokal
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// final task = DeliveryTask(...);
  /// final jsonData = task.toJson();
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resi': resi,
      'penerima': penerima,
      'is_delivered': isDelivered,
    };
  }

  /// Override toString untuk debugging
  /// Mempermudah visualisasi data saat development
  @override
  String toString() {
    return 'DeliveryTask(id: $id, resi: $resi, penerima: $penerima, isDelivered: $isDelivered)';
  }

  /// Method untuk membuat copy dari DeliveryTask dengan beberapa properti yang berbeda
  /// Berguna untuk immutability dan state management
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// final updatedTask = task.copyWith(isDelivered: true);
  /// ```
  DeliveryTask copyWith({
    int? id,
    String? resi,
    String? penerima,
    bool? isDelivered,
  }) {
    return DeliveryTask(
      id: id ?? this.id,
      resi: resi ?? this.resi,
      penerima: penerima ?? this.penerima,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }
}
