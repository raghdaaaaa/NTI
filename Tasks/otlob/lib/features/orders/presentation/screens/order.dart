import 'package:flutter/material.dart';
import 'package:otlob/core/shared/cart_header.dart';
import 'package:otlob/features/orders/data/models/order.dart';
import 'package:otlob/features/orders/data/services/order_service.dart';
import 'package:otlob/features/orders/presentation/widgets/order_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _service = OrderService();
  late Future<List<OrderModel>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _service.getOrders();
    OrderService.orderUpdates.addListener(_refresh);
  }

  @override
  void dispose() {
    OrderService.orderUpdates.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() => _orders = _service.getOrders());
  }

  Future<void> _showOrderDetails(int id) async {
    final order = _service.getOrder(id);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #$id'),
        content: FutureBuilder<OrderModel>(
          future: order,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 72,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            final item = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${item.status.name}'),
                Text('Date: ${item.date}'),
                Text('Items: ${item.itemsCount}'),
                Text('Delivery: ${item.deliveryType}'),
                Text('Total: ${item.total.toStringAsFixed(2)} EGP'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<OrderModel>>(
          future: _orders,
          builder: (context, snapshot) {
            final orders = snapshot.data ?? const <OrderModel>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartHeader(
                  title: 'My Orders',
                  subtitle: snapshot.hasData
                      ? '${orders.length} orders'
                      : 'Your recent orders',
                ),
                const SizedBox(height: 20),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.hasError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: _refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (orders.isEmpty)
                  const Expanded(
                    child: Center(child: Text('You have no orders yet.')),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: orders.length,
                      itemBuilder: (context, index) => OrderCard(
                        order: orders[index],
                        onTap: () => _showOrderDetails(orders[index].id),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
