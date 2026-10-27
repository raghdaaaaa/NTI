import 'package:flutter/material.dart';
import 'package:otlob/core/shared/brands_section.dart';
import 'package:otlob/core/shared/product_card.dart';
import 'package:otlob/core/shared/search_bar.dart';
import 'package:otlob/features/filter/data/models/filter_prod.dart';
import 'package:otlob/features/filter/presentation/widgets/back_header.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

class FilterC extends StatefulWidget {
  const FilterC({super.key});

  @override
  State<FilterC> createState() => _FilterCState();
}

class _FilterCState extends State<FilterC> {
  static const List<ProductModel> _products = filterProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(child: BackHeader(title: 'Costa')),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: HomeSearchBar(hint: 'Search Products...'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: BrandsSection(
                items: const ['Relevance', 'Price ↑', 'Price ↓', 'A – Z'],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.builder(
              itemBuilder: (context, index) =>
                  ProductCard(product: _products[index]),
              itemCount: _products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.62,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
