// lib/models/kampus.dart

class Kampus {
  final int id;
  final String nama;
  final String alamat;
  final String noTelp;
  final String kategori;
  final double latitude;
  final double longitude;
  final String jurusan;

  Kampus({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelp,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
  });

  factory Kampus.fromJson(Map<String, dynamic> json) {
    return Kampus(
      id: json['id'] ?? 0,
      nama: json['nama_kampus'] ?? 'Nama tidak tersedia',

      // --- PERBAIKAN UTAMA DI SINI ---
      alamat: json['alamat'] ?? 'Alamat tidak tersedia', // Ganti dari 'alamat_lengkap'
      // -----------------------------

      noTelp: json['no_telpon'] ?? '-',
      kategori: json['kategori'] ?? 'Kategori tidak diketahui',
      jurusan: json['jurusan'] ?? 'Jurusan tidak tersedia',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}