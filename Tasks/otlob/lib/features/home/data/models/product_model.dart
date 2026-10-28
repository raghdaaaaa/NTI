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
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imagePath: _resolveImageUrl(pic),
      description: json['description']?.toString(),
      pictureUrl: pic,
      brandId: json['brandId'] as int?,
      categoryId: json['categoryId'] as int?,
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
    final url = pictureUrl.toString();
    if (url.startsWith('http')) return url;
    return 'https://talabat639.runasp.net/$url';
  }
}
