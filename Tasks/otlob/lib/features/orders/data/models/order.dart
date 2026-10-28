enum OrderStatus { delivered, processing }

class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String? pictureUrl;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.pictureUrl,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: _toInt(json['id']),
    productId: _toInt(json['productId']),
    productName: json['productName']?.toString() ?? '',
    pictureUrl: json['pictureUrl']?.toString(),
    quantity: _toInt(json['quantity']),
    price: _toDouble(json['price']),
  );
}

class OrderModel {
  final int id;
  final String date;
  final List<OrderItemModel> items;
  final String deliveryType;
  final double deliveryCost;
  final double subtotal;
  final double total;
  final OrderStatus status;
  final String? buyerEmail;
  final String? paymentIntentId;
  final Map<String, String> shippingAddress;

  const OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.deliveryType,
    required this.deliveryCost,
    required this.subtotal,
    required this.total,
    required this.status,
    this.buyerEmail,
    this.paymentIntentId,
    this.shippingAddress = const {},
  });

  int get itemsCount => items.fold(0, (total, item) => total + item.quantity);

  List<String> get images => items
      .map((item) => item.pictureUrl)
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .toList();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems != null && rawItems is! List) {
      throw const FormatException('Order items must be a list.');
    }

    final address = json['shippingAddress'];
    final addressMap = address is Map
        ? Map<String, dynamic>.from(address)
        : <String, dynamic>{};
    final status = json['status']?.toString().toLowerCase() ?? '';

    return OrderModel(
      id: _toInt(json['id']),
      date: _formatOrderDate(json['orderDate']),
      items: (rawItems as List? ?? []).map((item) {
        if (item is! Map) {
          throw const FormatException('Order item data is invalid.');
        }
        return OrderItemModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(),
      deliveryType: json['deliveryMethod']?.toString() ?? '',
      deliveryCost: _toDouble(json['deliveryCost']),
      subtotal: _toDouble(json['subTotal']),
      total: _toDouble(json['total']),
      status: status.contains('deliver')
          ? OrderStatus.delivered
          : OrderStatus.processing,
      buyerEmail: json['buyerEmail']?.toString(),
      paymentIntentId: json['paymentIntentId']?.toString(),
      shippingAddress: addressMap.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      ),
    );
  }
}

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;

double _toDouble(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

String _formatOrderDate(dynamic value) {
  final date = DateTime.tryParse(value?.toString() ?? '');
  if (date == null) return value?.toString() ?? '';
  final localDate = date.toLocal();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${localDate.day} ${months[localDate.month - 1]} ${localDate.year}';
}
