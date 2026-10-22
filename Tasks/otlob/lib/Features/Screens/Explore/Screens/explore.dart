import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Explore/Widgets/brands.dart';
import 'package:otlob/Features/Screens/Explore/Widgets/categ.dart';
import 'package:otlob/Features/Screens/Explore/Widgets/header.dart';

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