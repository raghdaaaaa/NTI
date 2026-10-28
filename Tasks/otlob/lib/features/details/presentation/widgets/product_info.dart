import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (product.brand.isNotEmpty)
                _TagChip(label: product.brand, bg: true),
              if (product.category.isNotEmpty)
                _TagChip(label: product.category),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            product.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: '${product.price.toStringAsFixed(0)} ',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              children: const [
                TextSpan(
                  text: 'EGP',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 32, color: Color.fromARGB(255, 230, 222, 222)),
          const Text(
            'ABOUT THIS ITEM',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.description?.trim().isNotEmpty == true
                ? product.description!.trim()
                : 'No description available.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.bg = false});
  final String label;
  final bool bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg
            ? AppColors.primary.withValues(alpha: 0.1)
            : const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: bg ? AppColors.primary : Colors.grey.shade700,
        ),
      ),
    );
  }
}
