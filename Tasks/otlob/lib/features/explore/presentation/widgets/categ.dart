import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/features/explore/data/services/api_service.dart';

import 'package:otlob/features/explore/data/models/categ.dart';

class Categ extends StatelessWidget {
  const Categ({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.bgColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/filter-products',
            arguments: {'title': category.name, 'categoryId': category.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              category.imageUrl != null
                  ? Image.network(
                      category.imageUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _iconFallback(),
                    )
                  : _iconFallback(),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconFallback() => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(category.emoji, style: const TextStyle(fontSize: 28)),
    ),
  );
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<CategoryModel>> _future = ExploreService().getCategories();

  void _retry() => setState(() => _future = ExploreService().getCategories());

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'CATEGORIES',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        FutureBuilder<List<CategoryModel>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (snap.hasError) {
              debugPrint('Categories FutureBuilder error: ${snap.error}');
              return SliverToBoxAdapter(
                child: Center(
                  child: TextButton(
                    onPressed: _retry,
                    child: const Text('Something went wrong. Tap to retry'),
                  ),
                ),
              );
            }

            final categories = snap.data ?? [];
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 84,
                ),
                itemBuilder: (_, i) => Categ(category: categories[i]),
              ),
            );
          },
        ),
      ],
    );
  }
}
