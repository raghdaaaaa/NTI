import 'package:flutter/material.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/features/auth/presentation/screens/log_in.dart';
import 'package:otlob/features/auth/presentation/screens/sign_up.dart';
import 'package:otlob/features/cart/presentation/screens/cart.dart';
import 'package:otlob/features/debug/presentation/screens/debug_screen.dart';
import 'package:otlob/features/details/presentation/screens/details.dart';
import 'package:otlob/features/explore/presentation/screens/explore.dart';
import 'package:otlob/features/filter/presentation/screens/filterb.dart';
import 'package:otlob/features/filter/presentation/screens/filter_products.dart';
import 'package:otlob/features/filter/presentation/screens/filterc.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/home/presentation/screens/home_screen.dart';
import 'package:otlob/features/orders/presentation/screens/order.dart';
import 'package:otlob/core/shared/bottom_nav.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.debug:
        return MaterialPageRoute(builder: (_) => const DebugScreen());

      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => const MainShell(
            pages: [
              HomeScreen(),
              Explore(),
              CartScreen(),
              OrderScreen(),
              Center(child: Text('Profile')),
            ],
          ),
        );

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LogInScreen());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.details:
        final product = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              DetailsScreen(product: product is ProductModel ? product : null),
        );

      case AppRoutes.filter:
        return MaterialPageRoute(builder: (_) => const FilterC());

      case AppRoutes.filterb:
        return MaterialPageRoute(builder: (_) => const FilterB());

      case AppRoutes.filterProducts:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FilterProducts(
            title: args?['title'] ?? '',
            categoryId: args?['categoryId'],
            brandId: args?['brandId'],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
