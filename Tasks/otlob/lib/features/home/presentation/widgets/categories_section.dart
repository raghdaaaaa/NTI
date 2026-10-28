import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/features/explore/data/models/categ.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color = isSelected ? AppColors.primaryLight : category.bgColor;
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
          child: category.imageUrl != null && category.imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    category.imageUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Center(
                      child: Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          category.name,
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
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<CategoryModel>? onSelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: onSelected == null ? null : () => onSelected!(category),
              child: CategoryItem(
                category: category,
                isSelected: category.id == selectedCategoryId,
              ),
            ),
          );
        },
      ),
    );
  }
}
