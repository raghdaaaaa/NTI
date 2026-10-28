import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_colors.dart';
import 'package:otlob/core/shared/bottom_nav.dart';
import 'package:otlob/core/shared/brands_section.dart';
import 'package:otlob/core/shared/product_card.dart';
import 'package:otlob/core/shared/search_bar.dart';
import 'package:otlob/features/explore/data/models/brands.dart';
import 'package:otlob/features/explore/data/models/categ.dart';
import 'package:otlob/features/explore/data/services/api_service.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/home/data/services/home_service.dart';
import 'package:otlob/features/home/presentation/widgets/categories_section.dart';
import 'package:otlob/features/home/presentation/widgets/home_app_bar.dart';
import 'package:otlob/features/home/presentation/widgets/promo_banner.dart';
import 'package:otlob/features/home/presentation/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _exploreService = ExploreService();
  final _homeService = HomeService();

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
        _exploreService.getCategories(),
        _exploreService.getBrands(),
        _homeService.getProducts(),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: 18),
                  const HomeSearchBar(hint: 'Search for restaurants near you'),
                  const SizedBox(height: 20),
                  const PromoBanner(),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Categories',
                    actionText: 'See all',
                    onAction: () => tabIndex.value = 1,
                  ),
                  const SizedBox(height: 16),
                  CategoriesSection(categories: _categories),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Brands'),
                  const SizedBox(height: 12),
                  BrandsSection(items: _brands.map((b) => b.name).toList()),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Popular right now'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_products.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No products available right now',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                ),
              ),
            )
          else
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
