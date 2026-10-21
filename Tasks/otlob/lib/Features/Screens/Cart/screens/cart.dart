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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
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
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverList.separated(
              itemCount: 2,
              itemBuilder: (context, index) {
                return CartItemCard(
                  item: CartItemModel(
                    name: cartItems[index].name,
                    price: cartItems[index].price,
                    quantity: cartItems[index].quantity,
                    brand: cartItems[index].brand,
                    category: cartItems[index].category,
                    image: cartItems[index].image,
                  ),
                  onAdd: () {},
                  onRemove: () {},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
            const SliverToBoxAdapter(
              child: OrderSummary(subtotal: 640, deliveryFee: 25),
            ),
          ],
        ),
      ),
    );
  }
}
