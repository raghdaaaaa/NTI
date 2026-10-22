import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Explore/models/brands.dart';
import 'package:otlob/Features/Screens/Explore/models/categ.dart';
import 'package:otlob/Features/Screens/Explore/services/api_service.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';
import 'package:otlob/Core/shared/brands_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/categories_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/home_app_bar.dart';
import 'package:otlob/Core/shared/search_bar.dart';
import 'package:otlob/Core/shared/product_card.dart';
import 'package:otlob/Features/Screens/Home/Widgets/promo_banner.dart';
import 'package:otlob/Features/Screens/Home/Widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ExploreService();

  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  List<ProductModel> _products = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _service.getCategories(),
        _service.getBrands(),
        getProducts(),
      ]);

      if (!mounted) return;
      setState(() {
        _categories = results[0] as List<CategoryModel>;
        _brands = results[1] as List<BrandModel>;
        _products = results[2] as List<ProductModel>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Something went wrong'),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(),
                  SizedBox(height: 18),
                  HomeSearchBar(hint: 'Search for restaurants near you'),
                  SizedBox(height: 20),
                  PromoBanner(),
                  SizedBox(height: 24),
                  SectionHeader(title: 'Categories', actionText: 'See all'),
                  SizedBox(height: 16),
                  CategoriesSection(),
                  SizedBox(height: 24),
                  SectionHeader(title: 'Brands'),
                  SizedBox(height: 12),
                  BrandsSection(items: ['Starbucks', 'Costa', 'Cilantro']),
                  SizedBox(height: 24),
                  SectionHeader(title: 'Popular right now'),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
