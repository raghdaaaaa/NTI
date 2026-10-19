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
    Color color = isSelected ? AppColors.primaryLight : AppColors.white;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color,
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

  static const List<_CategoryItemData> _categories = [
    _CategoryItemData(icon: Icons.local_cafe, label: 'Frappuccino'),
    _CategoryItemData(icon: Icons.coffee, label: 'Latte'),
    _CategoryItemData(icon: Icons.bakery_dining, label: 'Mocha'),
    _CategoryItemData(icon: Icons.coffee_maker, label: 'Macchiato'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final item = _categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CategoryItem(
              icon: item.icon,
              label: item.label,
              isSelected: index == 0,
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItemData {
  final IconData icon;
  final String label;

  const _CategoryItemData({required this.icon, required this.label});
}
