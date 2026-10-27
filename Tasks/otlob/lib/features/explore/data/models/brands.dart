class BrandModel {
  final int id;
  final String name;

  const BrandModel({required this.id, required this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
