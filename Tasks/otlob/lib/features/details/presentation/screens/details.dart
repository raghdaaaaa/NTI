import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/features/details/presentation/widgets/add_button.dart';
import 'package:otlob/features/details/presentation/widgets/product_info.dart';
import 'package:otlob/features/home/data/models/product_model.dart';
import 'package:otlob/features/details/presentation/widgets/image_product.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageProduct(imagePath: AppAssets.donuts),
            const SizedBox(height: 5),
            ProductInfo(product: product),
          ],
        ),
      ),
      bottomNavigationBar: const AddButton(),
    );
  }
}
