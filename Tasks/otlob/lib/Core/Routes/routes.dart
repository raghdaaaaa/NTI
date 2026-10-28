import 'package:flutter/material.dart';
import 'package:otlob/core/network/api_client.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/shared/bottom_nav.dart';
import 'package:otlob/features/account/presentation/screens/account_screen.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/auth/presentation/screens/log_in.dart';
import 'package:otlob/features/auth/presentation/screens/sign_up.dart';
import 'package:otlob/features/auth/presentation/screens/startup_screen.dart';
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
import 'package:otlob/features/orders/presentation/screens/checkout.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    AuthSession? session,
  }) {
    switch (settings.name) {
      case AppRoutes.startup:
        return MaterialPageRoute(
          builder: (_) =>
              StartupScreen(session: session ?? AuthSession.instance),
        );

      case AppRoutes.debug:
        return MaterialPageRoute(builder: (_) => const DebugScreen());

      case AppRoutes.main:
        return _mainRoute(session: session);

      case AppRoutes.explore:
        return _mainRoute(session: session, initialIndex: 1);

      case AppRoutes.cart:
        return _mainRoute(session: session, initialIndex: 2);

      case AppRoutes.orders:
        return _mainRoute(session: session, initialIndex: 3);

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LogInScreen(
            authService: AuthService(session: session ?? AuthSession.instance),
          ),
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(
            authService: AuthService(session: session ?? AuthSession.instance),
          ),
        );

      case AppRoutes.checkout:
        if (!ApiClient.hasAccessToken) {
          return _loginRoute(session);
        }
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

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

  static Route<dynamic> _mainRoute({
    AuthSession? session,
    int initialIndex = 0,
  }) {
    final activeSession = session ?? AuthSession.instance;
    if (!ApiClient.hasAccessToken) {
      return _loginRoute(activeSession);
    }

    return MaterialPageRoute(
      builder: (_) => MainShell(
        initialIndex: initialIndex,
        pages: const [
          HomeScreen(),
          Explore(),
          CartScreen(),
          OrderScreen(),
          AccountScreen(),
        ],
      ),
    );
  }

  static Route<dynamic> _loginRoute(AuthSession? session) {
    return MaterialPageRoute(
      builder: (_) => LogInScreen(
        authService: AuthService(session: session ?? AuthSession.instance),
      ),
    );
  }
}
