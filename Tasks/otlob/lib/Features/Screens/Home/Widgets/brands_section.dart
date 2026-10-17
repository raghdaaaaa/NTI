import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_colors.dart';

class BrandChip extends StatelessWidget {
  final String name;
  final bool isSelected;

  const BrandChip({super.key, required this.name, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.divider,
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.white : AppColors.textDark,
        ),
      ),
    );
  }
}

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BrandChip(name: 'Starbucks', isSelected: true),
        SizedBox(width: 10),
        BrandChip(name: 'Costa'),
        SizedBox(width: 10),
        BrandChip(name: 'Cilantro'),
      ],
    );
  }
}
