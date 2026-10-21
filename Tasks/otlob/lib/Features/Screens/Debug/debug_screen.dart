import 'package:flutter/material.dart';
import 'package:otlob/Core/Routes/app_routes.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const product = ProductModel(
    id: '1',
    name: 'Dummy Product',
    brand: 'Test Brand',
    category: 'Food',
    price: 49.99,
    imagePath: 'assets/images/placeholder.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Auth Screens'),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),
          ListTile(
            title: const Text('Sign Up'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.signUp);
            },
          ),
          const Divider(),
          const Text('Main Screens'),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            title: const Text('Details'),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.details,
                arguments: product,
              );
            },
          ),
          ListTile(
            title: const Text('Explore'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.explore);
            },
          ),
          ListTile(
            title: const Text('Filterc'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.filter);
            },
          ),
          ListTile(
            title: const Text('Filterb'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.filterb);
            },
          ),
          ListTile(
            title: const Text('Cart'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.orders);
            },
          ),
        ],
      ),
    );
  }
}
