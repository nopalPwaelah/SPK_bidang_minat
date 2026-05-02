class HasilModel {
  final String hasil;

  HasilModel({required this.hasil});

  factory HasilModel.fromJson(Map<String, dynamic> json) {
    return HasilModel(
      hasil: json['hasil'] ?? '',
    );
  }
}