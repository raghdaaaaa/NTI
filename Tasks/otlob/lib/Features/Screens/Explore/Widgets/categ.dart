import 'package:flutter/material.dart';

import '../models/categ.dart';

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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 25)),
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
}

class Categories extends StatelessWidget {
  const Categories({super.key});

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
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 84,
            ),
            itemBuilder: (context, i) => Categ(category: categories[i]),
          ),
        ),
      ],
    );
  }
}
