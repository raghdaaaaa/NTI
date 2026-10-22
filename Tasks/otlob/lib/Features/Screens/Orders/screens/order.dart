import 'package:flutter/material.dart';
import 'package:otlob/Core/shared/cart_header.dart';
import 'package:otlob/Features/Screens/Orders/models/order.dart';
import 'package:otlob/Features/Screens/Orders/widgets/order_card.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CartHeader(
                      title: 'My Orders',
                      subtitle: '2 orders',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orders[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 150)),
          ],
        ),
      ),
    );
  }
}