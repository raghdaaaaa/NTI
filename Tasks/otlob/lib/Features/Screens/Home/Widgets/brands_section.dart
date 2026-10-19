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

  static const List<String> _brands = ['Starbucks', 'Costa', 'Cilantro'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _brands.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BrandChip(
              name: _brands[index],
              isSelected: index == 0,
            ),
          );
        },
      ),
    );
  }
}
