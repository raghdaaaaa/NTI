import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/features/details/presentation/widgets/add_button.dart';
import 'package:otlob/features/details/presentation/widgets/product_info.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/details/presentation/widgets/image_product.dart';
import 'package:otlob/features/details/data/services/product_details_service.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.product});
  final ProductModel? product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _service = ProductDetailsService();
  final _cartService = CartService();
  late ProductModel? _product = widget.product;
  bool _isLoading = false;
  bool _isAdding = false;
  int _quantity = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (_product == null) return;
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = _product;
    if (product == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final details = await _service.getProductDetails(product.id);
      if (!mounted) return;
      setState(() {
        _product = details;
      });
    } on ProductDetailsException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addToCart() async {
    final product = _product;
    final productId = int.tryParse(product?.id ?? '');
    if (productId == null || productId <= 0) {
      _showMessage('This product has no valid ID and cannot be added.');
      return;
    }

    setState(() => _isAdding = true);
    try {
      await _cartService.updateItemQuantity(
        productId: productId,
        quantity: _quantity,
      );
      if (!mounted) return;
      _showMessage('Added to cart.');
    } on CartException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _increaseQuantity() {
    if (_isAdding) return;
    setState(() => _quantity++);
  }

  void _decreaseQuantity() {
    if (_isAdding || _quantity <= 1) return;
    setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    if (product == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Product details are unavailable.'),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading) const LinearProgressIndicator(minHeight: 2),
            ImageProduct(
              imagePath: product.imagePath.isEmpty
                  ? AppAssets.donuts
                  : product.imagePath,
            ),
            const SizedBox(height: 5),
            ProductInfo(product: product),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: _isLoading ? null : _loadProduct,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AddButton(
        price: product.price,
        quantity: _quantity,
        onAdd: _addToCart,
        onIncrease: _isAdding ? null : _increaseQuantity,
        onDecrease: _isAdding || _quantity <= 1 ? null : _decreaseQuantity,
        isAdding: _isAdding,
      ),
    );
  }
}
