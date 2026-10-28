import 'package:flutter/material.dart';
import 'package:otlob/features/orders/presentation/widgets/order_status.dart';
import 'package:otlob/features/orders/data/models/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});
  final OrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              textAlign: TextAlign.start,
              order.date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final img in order.images.take(2))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        img,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imageFallback(),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 36, thickness: 0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.itemsCount} items · ${order.deliveryType}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  '${order.total.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
    width: 50,
    height: 50,
    color: const Color(0xFFF3F4F6),
    child: const Icon(Icons.fastfood_outlined, color: Colors.grey),
  );
}
