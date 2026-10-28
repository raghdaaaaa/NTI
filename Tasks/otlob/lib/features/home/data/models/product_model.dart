class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String imagePath;
  final String? description;
  final String? pictureUrl;
  final int? brandId;
  final int? categoryId;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.imagePath,
    this.description,
    this.pictureUrl,
    this.brandId,
    this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final pic = json['pictureUrl']?.toString();
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: _stringValue(json['brand']),
      category: _stringValue(json['category']),
      price: _toDouble(json['price']),
      imagePath: _resolveImageUrl(pic),
      description: json['description']?.toString(),
      pictureUrl: pic,
      brandId: _toInt(json['brandId']),
      categoryId: _toInt(json['categoryId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'pictureUrl': pictureUrl,
      'brandId': brandId,
      'categoryId': categoryId,
    };
  }

  static String _resolveImageUrl(dynamic pictureUrl) {
    if (pictureUrl == null) return '';
    final url = pictureUrl.toString().trim();
    if (url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    final path = url.startsWith('/') ? url.substring(1) : url;
    return 'https://talabat639.runasp.net/$path';
  }

  static String _stringValue(dynamic value) {
    if (value is Map) return value['name']?.toString() ?? '';
    return value?.toString() ?? '';
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
