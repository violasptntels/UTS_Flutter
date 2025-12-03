/// Model data untuk satu pengiriman kurir LogiTrack
/// Kelas ini merepresentasikan informasi lengkap tentang satu pengiriman
class Pengiriman {
  /// Nomor resi pengiriman (contoh: INV-2024001)
  final String nomorResi;

  /// Alamat lengkap tujuan pengiriman (contoh: Jl. Merdeka No. 10, Bandung)
  final String tujuanPengiriman;

  /// Status pengiriman (proses, dikirim, gagal, dll)
  final String statusPengiriman;

  /// Constructor untuk membuat instance Pengiriman
  /// Semua parameter adalah required
  Pengiriman({
    required this.nomorResi,
    required this.tujuanPengiriman,
    required this.statusPengiriman,
  });
}
