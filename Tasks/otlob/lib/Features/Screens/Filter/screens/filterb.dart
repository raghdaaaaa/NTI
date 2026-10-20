import 'package:flutter/material.dart';
import 'package:otlob/Core/shared/brands_section.dart';
import 'package:otlob/Core/shared/product_card.dart';
import 'package:otlob/Core/shared/search_bar.dart';
import 'package:otlob/Features/Screens/Filter/models/filter_prod.dart';
import 'package:otlob/Features/Screens/Filter/widgets/back_header.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';

class FilterB extends StatefulWidget {
  const FilterB({super.key});

  @override
  State<FilterB> createState() => _FilterBState();
}

class _FilterBState extends State<FilterB> {
  static const List<ProductModel> _products = brandsProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(child: BackHeader(title: 'Latte')),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: HomeSearchBar(hint: 'Search Products...'),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: BrandsSection(
                items: const ['Relevance', 'Price ↑', 'Price ↓', 'A – Z'],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: _products[index]),
                childCount: _products.length,
              ),
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
