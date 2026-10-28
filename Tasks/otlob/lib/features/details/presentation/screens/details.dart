import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/features/details/presentation/widgets/add_button.dart';
import 'package:otlob/features/details/presentation/widgets/product_info.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/details/presentation/widgets/image_product.dart';
import 'package:otlob/features/details/data/services/product_details_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.product});
  final ProductModel? product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _service = ProductDetailsService();
  late ProductModel? _product = widget.product;
  bool _isLoading = false;
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
        _isLoading = false;
      });
    } on ProductDetailsException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _isLoading = false;
      });
    }
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
      bottomNavigationBar: AddButton(price: product.price),
    );
  }
}
