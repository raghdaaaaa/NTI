import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_colors.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';

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
            children: const [
              _TagChip(label: 'Cilantro'),
              _TagChip(label: 'Donuts'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Glazed Donuts",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: '${"180"} ',
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
              fontSize: 12,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          Text(
            """Classic ring donuts hand-dipped in a signature\n 
sugar glaze while still warm from the fryer.\n
Light, pillowy and irresistibly sweet.""",
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              height: 1,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label}) : color = null;
  final String label;
  final Color? color;

  bool get isColor => color == null ? false : true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isColor ? color : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isColor ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
