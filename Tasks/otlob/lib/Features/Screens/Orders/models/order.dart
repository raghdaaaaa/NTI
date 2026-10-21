enum OrderStatus { delivered, processing }

class OrderModel {
  final int id;
  final String date;
  final List<String> images;
  final int itemsCount;
  final String deliveryType;
  final int total;
  final OrderStatus status;

  const OrderModel({
    required this.id,
    required this.date,
    required this.images,
    required this.itemsCount,
    required this.deliveryType,
    required this.total,
    required this.status,
  });
}

const orders = [
  OrderModel(
    id: 10245,
    date: '15 Aug 2026',
    images: ['Assets/images/drink.png', 'Assets/images/cake.png'],
    itemsCount: 3,
    deliveryType: 'Express',
    total: 560,
    status: OrderStatus.delivered,
  ),
  OrderModel(
    id: 10189,
    date: '12 Aug 2026',
    images: ['Assets/images/drink.png', 'Assets/images/cake.png'],
    itemsCount: 3,
    deliveryType: 'Standard',
    total: 415,
    status: OrderStatus.processing,
  ),
];
