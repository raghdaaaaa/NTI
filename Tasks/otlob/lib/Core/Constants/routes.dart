import 'package:flutter/material.dart';
import 'package:otlob/Core/Routes/app_routes.dart';
import 'package:otlob/Features/Screens/Auth/Screens/log_in.dart';
import 'package:otlob/Features/Screens/Auth/Screens/sign_up.dart';
import 'package:otlob/Features/Screens/Cart/screens/cart.dart';
import 'package:otlob/Features/Screens/Debug/debug_screen.dart';
import 'package:otlob/Features/Screens/Details/Screens/details.dart';
import 'package:otlob/Features/Screens/Explore/Screens/explore.dart';
import 'package:otlob/Features/Screens/Filter/screens/filterb.dart';
import 'package:otlob/Features/Screens/Filter/screens/filterc.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';
import 'package:otlob/Features/Screens/Home/Screens/home_screen.dart';
import 'package:otlob/Features/Screens/Orders/screens/order.dart';
import 'package:otlob/Core/shared/bottom_nav.dart';

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
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(product: product),
        );

      case AppRoutes.filter:
        return MaterialPageRoute(builder: (_) => const FilterC());

      case AppRoutes.filterb:
        return MaterialPageRoute(builder: (_) => const FilterB());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
