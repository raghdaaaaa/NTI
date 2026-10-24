class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String imagePath;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.imagePath,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imagePath: _resolveImageUrl(json['pictureUrl']),
    );
  }

  static String _resolveImageUrl(dynamic pictureUrl) {
    if (pictureUrl == null) return '';
    final url = pictureUrl.toString();
    if (url.startsWith('http')) return url;
    return 'https://talabat639.runasp.net/$url';
  }
}
