import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Constants/app_icons.dart';
import '../Constants/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          );
        }
        return const TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        );
      }),

      height: 70,
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
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
