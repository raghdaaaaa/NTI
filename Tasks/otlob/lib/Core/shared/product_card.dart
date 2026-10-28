import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/features/cart/data/services/cart_service.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _cartService = CartService();
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(onTap: _openDetails, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: widget.product.imagePath.isEmpty
                      ? Container(
                          width: double.infinity,
                          color: AppColors.divider,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.textLight,
                            size: 40,
                          ),
                        )
                      : Image.network(
                          widget.product.imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 400,
                          errorBuilder: (context, error, stack) => Container(
                            width: double.infinity,
                            color: AppColors.divider,
                            child: const Icon(
                              Icons.image,
                              color: AppColors.textLight,
                              size: 40,
                            ),
                          ),
                        ),
                ),
                // Category tag
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tagBg.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.product.category,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.brand,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.product.price.toInt()}',
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            'EGP',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Material(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: _isAdding ? null : _addToCart,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: _isAdding
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void _openDetails() {
    Navigator.pushNamed(
      context,
      AppRoutes.details,
      arguments: widget.product,
    );
  }

  Future<void> _addToCart() async {
    final productId = int.tryParse(widget.product.id);
    if (productId == null || productId <= 0) {
      _showMessage('This product has no valid ID and cannot be added.');
      return;
    }

    setState(() => _isAdding = true);
    try {
      await _cartService.addItem(productId: productId, quantity: 1);
      if (mounted) _showMessage('Added to cart.');
    } on CartException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
