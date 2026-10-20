import 'package:flutter/material.dart';
import 'package:otlob/Core/shared/bottom_nav.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';
import 'package:otlob/Core/shared/brands_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/categories_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/home_app_bar.dart';
import 'package:otlob/Core/shared/search_bar.dart';
import 'package:otlob/Core/shared/product_card.dart';
import 'package:otlob/Features/Screens/Home/Widgets/promo_banner.dart';
import 'package:otlob/Features/Screens/Home/Widgets/section_header.dart';
import 'package:otlob/Features/Screens/Filter/models/filter_prod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<ProductModel> _products = filterProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: BottomNav(currentIndex: 0, onTap: (i) {}),
      ),
    );
  }
}
