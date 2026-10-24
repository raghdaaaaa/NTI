import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Explore/models/brands.dart';
import 'package:otlob/Features/Screens/Explore/services/api_service.dart';

class Brands extends StatefulWidget {
  const Brands({super.key});

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  late Future<List<BrandModel>> _future = ExploreService().getBrands();

  void _retry() => setState(() => _future = ExploreService().getBrands());

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              'BRANDS',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        FutureBuilder<List<BrandModel>>(
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
              debugPrint('Brands FutureBuilder error: ${snap.error}');
              return SliverToBoxAdapter(
                child: Center(
                  child: TextButton(
                    onPressed: _retry,
                    child: const Text('Something went wrong. Tap to retry'),
                  ),
                ),
              );
            }

            final brands = snap.data ?? [];
            return SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverList.separated(
                itemCount: brands.length,
                separatorBuilder: (_, _) => const SizedBox(height: 11),
                itemBuilder: (_, i) => BrandCard(brand: brands[i]),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.brand});
  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final firstLetter = brand.name.isNotEmpty ? brand.name[0] : '?';

    return Material(
      color: Colors.white,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/filter-products',
            arguments: {'title': brand.name, 'brandId': brand.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 251, 240, 236),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5A36),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  brand.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
