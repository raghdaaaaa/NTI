import 'package:flutter/material.dart';
import 'package:otlob/core/shared/cart_header.dart';
import 'package:otlob/core/shared/submit_button.dart';
import 'package:otlob/features/cart/data/models/cart.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/features/cart/presentation/widgets/card.dart';
import 'package:otlob/features/cart/presentation/widgets/summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const double _deliveryFee = 25;

  final _cartService = CartService();
  CustomerBasketModel _basket = const CustomerBasketModel(items: []);
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBasket();
  }

  Future<void> _loadBasket() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final basket = await _cartService.getBasket();
      if (!mounted) return;
      setState(() {
        _basket = basket;
        _isLoading = false;
      });
    } on CartException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(CartItemModel item, int quantity) async {
    final productId = item.id;
    if (_isUpdating || productId == null || productId <= 0 || quantity < 1) {
      return;
    }

    setState(() {
      _isUpdating = true;
      _error = null;
    });

    try {
      final basket = await _cartService.updateItemQuantity(
        productId: productId,
        quantity: quantity,
      );
      if (!mounted) return;
      setState(() {
        _basket = basket;
        _isUpdating = false;
      });
    } on CartException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _isUpdating = false;
      });
    }
  }

  double get _subtotal => _basket.items.fold<double>(
    0,
    (total, item) => total + item.price * item.quantity,
  );

  int get _itemCount =>
      _basket.items.fold<int>(0, (total, item) => total + item.quantity);

  @override
  Widget build(BuildContext context) {
    final hasItems = _basket.items.isNotEmpty;
    final total = _subtotal + _deliveryFee;

    return Padding(
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
                      subtitle:
                          '$_itemCount items · ${formatBasketAmount(_subtotal)} EGP',
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_error != null)
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: _isUpdating ? null : _loadBasket,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (!hasItems)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('Your cart is empty.')),
              ),
            )
          else ...[
            SliverList.separated(
              itemCount: _basket.items.length,
              itemBuilder: (context, index) {
                final item = _basket.items[index];
                final canUpdate =
                    !_isUpdating && item.id != null && item.id! > 0;
                return CartItemCard(
                  item: item,
                  onAdd: canUpdate
                      ? () => _updateQuantity(item, item.quantity + 1)
                      : null,
                  onRemove: canUpdate && item.quantity > 1
                      ? () => _updateQuantity(item, item.quantity - 1)
                      : null,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: OrderSummary(
                subtotal: _subtotal,
                deliveryFee: _deliveryFee,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: SubmitButton(
                onTap: () {},
                title: 'Proceed to Checkout · ${formatBasketAmount(total)} EGP',
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ],
      ),
    );
  }
}
