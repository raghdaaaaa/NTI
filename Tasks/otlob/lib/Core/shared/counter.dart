import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_colors.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.quantity,
    this.onAdd,
    this.onRemove,
    this.size = 36,
  });

  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleBtn(
            icon: Icons.remove,
            size: size,
            bg: const Color.fromARGB(255, 246, 246, 246),
            iconColor: AppColors.textGrey,
            onTap: onRemove,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _CircleBtn(
            icon: Icons.add,
            size: size,
            bg: AppColors.primary,
            iconColor: Colors.white,
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
    required this.icon,
    required this.size,
    required this.bg,
    required this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final double size;
  final Color bg;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
