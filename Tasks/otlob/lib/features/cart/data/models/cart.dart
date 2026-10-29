import 'dart:math' as math;

const _baseUrl = 'https://talabat639.runasp.net';

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
    return CartItemModel(
      id: _toInt(json['productId'] ?? json['id']),
      name: json['productName']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: _pictureUrl(json['pictureUrl']?.toString().trim()),
      price: num.tryParse('${json['price']}')?.toDouble() ?? 0,
      quantity: math.max(1, _toInt(json['quantity']) ?? 1),
    );
  }

  static int? _toInt(dynamic value) => num.tryParse('$value')?.toInt();

  static String? _pictureUrl(String? picture) {
    if (picture == null || picture.isEmpty) return null;
    if (picture.startsWith('http')) return picture;
    return '$_baseUrl/${picture.replaceFirst(RegExp(r'^/'), '')}';
  }
}

class CustomerBasketModel {
  final String? id;
  final List<CartItemModel> items;

  const CustomerBasketModel({this.id, required this.items});

  factory CustomerBasketModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return CustomerBasketModel(
      id: json['id']?.toString(),
      items: [
        for (final item in rawItems)
          CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
    );
  }
}

String formatBasketAmount(num amount) =>
    amount.toStringAsFixed(amount == amount.roundToDouble() ? 0 : 2);
