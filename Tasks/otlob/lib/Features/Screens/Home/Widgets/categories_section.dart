import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1.5)
                : Border.all(color: AppColors.divider, width: 1),
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textGrey,
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryItem(
          icon: Icons.local_cafe,
          label: 'Frappuccino',
          isSelected: true,
        ),
        CategoryItem(icon: Icons.coffee, label: 'Latte'),
        CategoryItem(icon: Icons.bakery_dining, label: 'Mocha'),
        CategoryItem(icon: Icons.coffee_maker, label: 'Macchiato'),
      ],
    );
  }
}
