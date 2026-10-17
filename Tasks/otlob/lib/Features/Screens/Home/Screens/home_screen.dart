import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';
import 'package:otlob/Features/Screens/Home/Widgets/brands_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/categories_section.dart';
import 'package:otlob/Features/Screens/Home/Widgets/home_app_bar.dart';
import 'package:otlob/Features/Screens/Home/Widgets/home_bottom_nav.dart';
import 'package:otlob/Features/Screens/Home/Widgets/home_search_bar.dart';
import 'package:otlob/Features/Screens/Home/Widgets/product_card.dart';
import 'package:otlob/Features/Screens/Home/Widgets/promo_banner.dart';
import 'package:otlob/Features/Screens/Home/Widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Double Caramel Frappuccino',
      brand: 'Starbucks',
      category: 'Frappuccino',
      price: 200,
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80',
    ),
    ProductModel(
      id: '2',
      name: 'Blueberry Cheesecake',
      brand: 'Starbucks',
      category: 'Cake',
      price: 155,
      imageUrl: 'https://images.unsplash.com/photo-1567171466295-4afa63d45416?w=400&q=80',
    ),
    ProductModel(
      id: '3',
      name: 'Double Caramel Frappuccino',
      brand: 'Starbucks',
      category: 'Frappuccino',
      price: 200,
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&q=80',
    ),
    ProductModel(
      id: '4',
      name: 'Blueberry Cheesecake',
      brand: 'Starbucks',
      category: 'Cake',
      price: 155,
      imageUrl: 'https://images.unsplash.com/photo-1567171466295-4afa63d45416?w=400&q=80',
    ),
  ];

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
                    HomeSearchBar(),
                    SizedBox(height: 20),
                    PromoBanner(),
                    SizedBox(height: 24),
                    SectionHeader(title: 'Categories', actionText: 'See all'),
                    SizedBox(height: 16),
                    CategoriesSection(),
                    SizedBox(height: 24),
                    SectionHeader(title: 'Brands'),
                    SizedBox(height: 12),
                    BrandsSection(),
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
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
