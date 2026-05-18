class RiwayatHasil {
  final int id;
  final String nama;
  final String hasilPrediksi;
  final int nilaiK;
  final double skor;
  final String tanggal;
  final Map<String, double>? nilai;

  RiwayatHasil({
    required this.id,
    required this.nama,
    required this.hasilPrediksi,
    required this.nilaiK,
    required this.skor,
    required this.tanggal,
    this.nilai,
  });

  factory RiwayatHasil.fromJson(Map<String, dynamic> json) {
    return RiwayatHasil(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      hasilPrediksi: json['hasil_prediksi'] ?? json['hasil'] ?? '',
      nilaiK: json['nilai_k'] ?? 3,
      skor: (json['skor'] ?? 0.0).toDouble(),
      tanggal: json['tanggal'] ?? json['created_at'] ?? '',
      nilai: json['nilai'] != null ? Map<String, double>.from(json['nilai']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'hasil_prediksi': hasilPrediksi,
      'nilai_k': nilaiK,
      'skor': skor,
      'tanggal': tanggal,
      'nilai': nilai,
    };
  }
}
