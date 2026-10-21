class CartItemModel {
  final String name;
  final String brand;
  final String category;
  final String? image;
  final int price;
  final int quantity;

  const CartItemModel({
    required this.name,
    required this.brand,
    required this.category,
    this.image,
    required this.price,
    required this.quantity,
  });
}

const cartItems = [
  CartItemModel(
    name: 'Double Caramel Frappuccino',
    brand: 'Starbucks',
    category: 'Frappuccino',
    image: 'Assets/images/drink.png',
    price: 400,
    quantity: 2,
  ),
  CartItemModel(
    name: 'Hot Caramel Macchiato',
    brand: 'On The Run',
    category: 'Macchiato',
    image: 'Assets/images/cake.png',
    price: 240,
    quantity: 2,
  ),
];
