import 'package:flutter/material.dart';
import 'package:otlob/Core/Routes/app_routes.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const _dummyProduct = ProductModel(
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
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF00FF88),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Debug Navigator',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(label: '🔐 Auth Screens'),
          _DebugNavCard(
            icon: Icons.login_rounded,
            title: 'Login Screen',
            subtitle: AppRoutes.login,
            color: const Color(0xFF6C63FF),
            onTap: () => Navigator.pushNamed(context, AppRoutes.login),
          ),
          _DebugNavCard(
            icon: Icons.person_add_alt_1_rounded,
            title: 'Sign Up Screen',
            subtitle: AppRoutes.signUp,
            color: const Color(0xFF00C6FF),
            onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
          ),
          const SizedBox(height: 8),
          _SectionHeader(label: '🏠 Main Screens'),
          _DebugNavCard(
            icon: Icons.home_rounded,
            title: 'Home Screen',
            subtitle: AppRoutes.home,
            color: const Color(0xFF43E97B),
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          ),
          _DebugNavCard(
            icon: Icons.shopping_bag_rounded,
            title: 'Details Screen',
            subtitle: '${AppRoutes.details}  (dummy product)',
            color: const Color(0xFFFF6B6B),
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.details,
              arguments: _dummyProduct,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DebugNavCard extends StatelessWidget {
  const _DebugNavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF1E1E30),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: color.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white24,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
