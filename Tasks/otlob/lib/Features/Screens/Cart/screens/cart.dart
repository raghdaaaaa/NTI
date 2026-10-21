import 'package:flutter/material.dart';
import 'package:otlob/Core/shared/cart_header.dart';
import 'package:otlob/Features/Screens/Cart/models/cart.dart';
import 'package:otlob/Features/Screens/Cart/widgets/card.dart';
import 'package:otlob/Features/Screens/Cart/widgets/summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartHeader(
                      title: 'Your Cart',
                      subtitle: '2 items · 665 EGP',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: 2,
            itemBuilder: (context, index) {
              return CartItemCard(
                item: CartItemModel(
                  name: 'name',
                  price: 10,
                  quantity: 1,
                  brand: 'brand',
                  category: 'category',
                ),
                onAdd: () {},
                onRemove: () {},
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
          const SliverToBoxAdapter(
            child: OrderSummary(subtotal: 640, deliveryFee: 25),
          ),
        ],
      ),
    );
  }
}
