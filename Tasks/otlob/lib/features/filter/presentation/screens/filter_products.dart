import 'package:flutter/material.dart';
import 'package:otlob/core/shared/brands_section.dart';
import 'package:otlob/core/shared/product_card.dart';
import 'package:otlob/core/shared/search_bar.dart';
import 'package:otlob/features/explore/data/services/api_service.dart';
import 'package:otlob/features/filter/presentation/widgets/back_header.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

class FilterProducts extends StatefulWidget {
  const FilterProducts({
    super.key,
    required this.title,
    this.categoryId,
    this.brandId,
  });
  final String title;
  final int? categoryId;
  final int? brandId;

  @override
  State<FilterProducts> createState() => _FilterProductsState();
}

class _FilterProductsState extends State<FilterProducts> {
  late Future<List<ProductModel>> _future;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _future = ExploreService().getFilteredProducts(
      categoryId: widget.categoryId,
      brandId: widget.brandId,
      search: _search,
    );
  }

  void _searchProducts(String search) {
    setState(() {
      _search = search;
      _future = ExploreService().getFilteredProducts(
        categoryId: widget.categoryId,
        brandId: widget.brandId,
        search: _search,
      );
    });
  }

  void _retry() => setState(
    () => _future = ExploreService().getFilteredProducts(
      categoryId: widget.categoryId,
      brandId: widget.brandId,
      search: _search,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(child: BackHeader(title: widget.title)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: HomeSearchBar(
                hint: 'Search Products...',
                onSubmitted: _searchProducts,
              ),
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
          FutureBuilder<List<ProductModel>>(
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
                debugPrint('Products FutureBuilder error: ${snap.error}');
                return SliverToBoxAdapter(
                  child: Center(
                    child: TextButton(
                      onPressed: _retry,
                      child: const Text('Something went wrong. Tap to retry'),
                    ),
                  ),
                );
              }
              final products = snap.data ?? [];
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.62,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
