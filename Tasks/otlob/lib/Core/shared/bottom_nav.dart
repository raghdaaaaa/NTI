import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_icons.dart';
import '../constants/app_colors.dart';

final ValueNotifier<int> tabIndex = ValueNotifier(0);

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              );
            }
            return const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            );
          }),

          height: 65,
          destinations: const [
            NavigationDestination(
              icon: _NavIcon(AppIcons.home, AppColors.textGrey),
              selectedIcon: _NavIcon(AppIcons.home, AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: _NavIcon(AppIcons.search, AppColors.textGrey),
              selectedIcon: _NavIcon(AppIcons.search, AppColors.primary),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: _NavIcon(AppIcons.cart, AppColors.textGrey),
              selectedIcon: _NavIcon(AppIcons.cart, AppColors.primary),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: _NavIcon(AppIcons.order, AppColors.textGrey),
              selectedIcon: _NavIcon(AppIcons.order, AppColors.primary),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: _NavIcon(AppIcons.profile, AppColors.textGrey),
              selectedIcon: _NavIcon(AppIcons.profile, AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.path, this.color);
  final String path;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.pages, this.initialIndex = 0});

  final List<Widget> pages;
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  @override
  void initState() {
    super.initState();
    tabIndex.value = widget.initialIndex;
    tabIndex.addListener(_onTabIndexChanged);
  }

  @override
  void dispose() {
    tabIndex.removeListener(_onTabIndexChanged);
    super.dispose();
  }

  void _onTabIndexChanged() {
    if (tabIndex.value != _index) {
      setState(() => _index = tabIndex.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: widget.pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _index,
        onTap: (i) => tabIndex.value = i,
      ),
    );
  }
}
