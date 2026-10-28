import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.hint,
    this.onSubmitted,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 13),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textGrey,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 10),
          Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.filter_alt_outlined,
                  color: AppColors.textDark,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
