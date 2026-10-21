import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Explore/Widgets/brands.dart';

import '../../../../Core/shared/bottom_nav.dart';
import '../Widgets/categ.dart';
import '../Widgets/header.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  int _index = 0;

  final List<Widget> _pages = [
    SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Header()),
          const Categories(),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          const Brands(),
        ],
      ),
    ),

    const Center(child: Text('Explore')),
    const Center(child: Text('Cart')),
    const Center(child: Text('Orders')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: BottomNav(
          currentIndex: 1,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
