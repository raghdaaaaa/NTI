import 'package:flutter/material.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/shared/bottom_nav.dart';
import 'package:otlob/core/shared/cart_header.dart';
import 'package:otlob/core/shared/submit_button.dart';
import 'package:otlob/features/cart/data/models/cart.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/features/cart/presentation/widgets/card.dart';
import 'package:otlob/features/cart/presentation/widgets/summary.dart';
import 'package:otlob/features/orders/data/models/order.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartService = CartService();
  CustomerBasketModel _basket = const CustomerBasketModel(items: []);
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    CartService.basketUpdates.addListener(_onBasketUpdated);
    _loadBasket();
  }

  @override
  void dispose() {
    CartService.basketUpdates.removeListener(_onBasketUpdated);
    super.dispose();
  }

  void _onBasketUpdated() {
    final basket = CartService.basketUpdates.value;
    if (!mounted || basket == null) return;
    setState(() {
      _basket = basket;
      _error = null;
      _isLoading = false;
    });
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
      });
    } on CartException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshAfterMutationFailure(String message) async {
    try {
      final basket = await _cartService.getBasket();
      if (!mounted) return;
      setState(() {
        _basket = basket;
        _error = message;
      });
    } on CartException catch (refreshError) {
      if (!mounted) return;
      setState(() {
        _error =
            '$message The current basket could not be reloaded: '
            '${refreshError.message}';
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
      });
    } on CartException catch (error) {
      if (!mounted) return;
      await _refreshAfterMutationFailure(error.message);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _removeItem(CartItemModel item) async {
    final productId = item.id;
    if (_isUpdating || productId == null || productId <= 0) return;

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove item?'),
        content: const Text(
          'The basket API only supports clearing the entire basket. '
          'The app will rebuild the basket with the other items.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (shouldRemove != true || !mounted) return;

    setState(() {
      _isUpdating = true;
      _error = null;
    });

    try {
      final basket = await _cartService.removeItem(productId);
      if (!mounted) return;
      setState(() => _basket = basket);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item removed from cart.')));
    } on CartException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
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
                  onDelete: canUpdate ? () => _removeItem(item) : null,
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
              child: OrderSummary(subtotal: _subtotal, deliveryFee: null),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: SubmitButton(
                onTap: _isUpdating
                    ? null
                    : () async {
                        final order = await Navigator.pushNamed(
                          context,
                          AppRoutes.checkout,
                        );
                        if (!context.mounted || order is! OrderModel) return;
                        await _loadBasket();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed.')),
                        );
                        tabIndex.value = 3;
                      },
                title: 'Proceed to Checkout',
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ],
      ),
    );
  }
}
