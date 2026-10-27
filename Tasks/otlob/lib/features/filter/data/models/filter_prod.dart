import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/features/home/data/models/product_model.dart';

const List<ProductModel> filterProducts = [
  ProductModel(
    id: '1',
    name: 'Double Caramel Frappuccino',
    brand: 'Starbucks',
    category: 'Frappuccino',
    price: 200,
    imagePath: AppAssets.drink,
  ),
  ProductModel(
    id: '2',
    name: 'Blueberry Cheesecake',
    brand: 'Starbucks',
    category: 'Cake',
    price: 155,
    imagePath: AppAssets.cake,
  ),
  ProductModel(
    id: '3',
    name: 'Double Caramel Frappuccino',
    brand: 'Starbucks',
    category: 'Frappuccino',
    price: 200,
    imagePath: AppAssets.drink,
  ),
  ProductModel(
    id: '4',
    name: 'Blueberry Cheesecake',
    brand: 'Starbucks',
    category: 'Cake',
    price: 155,
    imagePath: AppAssets.cake,
  ),
];

const List<ProductModel> brandsProducts = [
  ProductModel(
    id: '1',
    name: 'Double Caramel Frappuccino',
    brand: 'Costa',
    category: 'Latte',
    price: 120.0,
    imagePath: AppAssets.drink,
  ),
  ProductModel(
    id: '2',
    name: 'Dark Chocolate Latte',
    brand: 'Costa',
    category: 'Latte',
    price: 145.0,
    imagePath: AppAssets.drink,
  ),
];
