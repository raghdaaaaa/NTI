import 'package:flutter/material.dart';
import 'package:otlob/features/explore/presentation/widgets/brands.dart';
import 'package:otlob/features/explore/presentation/widgets/categ.dart';
import 'package:otlob/features/explore/presentation/widgets/header.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Header()),
          const Categories(),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          const Brands(),
        ],
      ),
    );
  }
}