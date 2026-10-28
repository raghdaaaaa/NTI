import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/core/shared/counter.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
    required this.isAdding,
  });

  final double price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool isAdding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(31, 114, 114, 114),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Counter
            Counter(
              quantity: quantity,
              onAdd: onIncrease,
              onRemove: onDecrease,
            ),
            const SizedBox(width: 16),
            // Add
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: isAdding ? null : onAdd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isAdding
                          ? 'Adding...'
                          : 'Add to cart · ${price.toStringAsFixed(0)} EGP',
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
