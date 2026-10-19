import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_assets.dart';
import 'package:otlob/Features/Screens/Details/Widgets/product_info.dart';
import 'package:otlob/Features/Screens/Home/Models/product_model.dart';
import 'package:otlob/Features/Screens/Details/Widgets/image_product.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ImageProduct(imagePath: AppAssets.donuts),
            ProductInfo(product: product),
          ],
        ),
      ),
    );
  }
}
