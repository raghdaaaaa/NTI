import 'package:flutter/material.dart';

import '../models/order.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final isDelivered = status == OrderStatus.delivered;
    final color = isDelivered
        ? const Color(0xFF1E8E3E)
        : const Color(0xFFE65100);
    final bg = isDelivered ? const Color(0xFFE6F4EA) : const Color(0xFFFFF1E0);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isDelivered ? 'Delivered' : 'Processing',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
