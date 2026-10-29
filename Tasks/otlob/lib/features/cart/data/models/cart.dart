class CartItemModel {
  final int? id;
  final String name;
  final String brand;
  final String category;
  final String? image;
  final double price;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final picture = json['pictureUrl']?.toString().trim();
    return CartItemModel(
      id: _toInt(json['productId']) ?? _toInt(json['id']),
      name: json['productName']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: _resolvePictureUrl(picture),
      price: _toDouble(json['price']),
      quantity: (_toInt(json['quantity']) ?? 1).clamp(1, 0x7fffffff).toInt(),
    );
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

  static String? _resolvePictureUrl(String? picture) {
    if (picture == null || picture.isEmpty) return null;
    if (picture.startsWith('http')) return picture;
    final path = picture.startsWith('/') ? picture.substring(1) : picture;
    return 'https://talabat639.runasp.net/$path';
  }
}

class CustomerBasketModel {
  final String? id;
  final List<CartItemModel> items;

  const CustomerBasketModel({this.id, required this.items});

  factory CustomerBasketModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems != null && rawItems is! List) {
      throw const FormatException('Basket items must be a list.');
    }

    return CustomerBasketModel(
      id: json['id']?.toString(),
      items: (rawItems as List? ?? []).map((item) {
        if (item is! Map) {
          throw const FormatException('Basket item data is invalid.');
        }
        return CartItemModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(),
    );
  }
}

String formatBasketAmount(num amount) {
  if (amount == amount.roundToDouble()) return amount.toStringAsFixed(0);
  return amount.toStringAsFixed(2);
}
