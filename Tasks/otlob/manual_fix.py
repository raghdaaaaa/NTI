import os
import re

# Read all dart files and fix import paths
fixed_files = []

# Cart screen - fix Features/Screens/Cart references
cart_screen = r'features\cart\presentation\screens\cart.dart'
with open(cart_screen, 'r', encoding='utf-8') as f:
    content = f.read()
# Replace the old model import
content = content.replace(
    "package:otlob/Features/Screens/Cart/models/cart.dart",
    "package:otlob/features/cart/data/models/cart.dart"
)
# Replace the old widget imports
content = content.replace(
    "package:otlob/Features/Screens/Cart/widgets/card.dart",
    "package:otlob/features/cart/presentation/widgets/card.dart"
)
content = content.replace(
    "package:otlob/Features/Screens/Cart/widgets/summary.dart",
    "package:otlob/features/cart/presentation/widgets/summary.dart"
)
with open(cart_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(cart_screen)
print(f"Fixed: {os.path.basename(cart_screen)}")

# Cart widget - fix card.dart
card_widget = r'features\cart\presentation\widgets\card.dart'
with open(card_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Cart/models/cart.dart",
    "package:otlob/features/cart/data/models/cart.dart"
)
content = content.replace(
    "package:otlob/core/shared/counter.dart",
    # keep counter if needed, or remove if not
    ""
)
with open(card_widget, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(card_widget)
print(f"Fixed: {os.path.basename(card_widget)}")

# Explore brands widget
brands_widget = r'features\explore\presentation\widgets\brands.dart'
with open(brands_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/brands.dart",
    "package:otlob/features/explore/data/models/brands.dart"
)
content = content.replace(
    "\.\./\.\./models/categ.dart",
    "features/explore/data/models/categ.dart"
)
with open(brands_widget, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(brands_widget)
print(f"Fixed: {os.path.basename(brands_widget)}")

# Explore categ widget
categ_widget = r'features\explore\presentation\widgets\categ.dart'
with open(categ_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/categ.dart",
    "package:otlob/features/explore/data/models/categ.dart"
)
with open(categ_widget, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(categ_widget)
print(f"Fixed: {os.path.basename(categ_widget)}")

# Filter filterb screen
filterb_screen = r'features\filter\presentation\screens\filterb.dart'
with open(filterb_screen, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Filter/models/filter_prod.dart",
    "package:otlob/features/filter/data/models/filter_prod.dart"
)
content = content.replace(
    "package:otlob/core/shared/brands_section.dart",
    # Keep or remove - check if still needed
    ""
)
content = content.replace(
    "package:otlob/core/shared/product_card.dart",
    ""
)
content = content.replace(
    "package:otlob/core/shared/search_bar.dart",
    ""
)
with open(filterb_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(filterb_screen)
print(f"Fixed: {os.path.basename(filterb_screen)}")

# Filter filterc screen
filterc_screen = r'features\filter\presentation\screens\filterc.dart'
with open(filterc_screen, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Filter/models/filter_prod.dart",
    "package:otlob/features/filter/data/models/filter_prod.dart"
)
content = content.replace(
    "package:otlob/core/shared/brands_section.dart",
    ""
)
content = content.replace(
    "package:otlob/core/shared/product_card.dart",
    ""
)
content = content.replace(
    "package:otlob/core/shared/search_bar.dart",
    ""
)
with open(filterc_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(filterc_screen)
print(f"Fixed: {os.path.basename(filterc_screen)}")

# Filter filter_products screen
filter_products_screen = r'features\filter\presentation\screens\filter_products.dart'
with open(filter_products_screen, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Filter/",
    "package:otlob/features/filter/"
)
content = content.replace(
    "package:otlob/core/shared/brands_section.dart",
    ""
)
content = content.replace(
    "package:otlob/core/shared/product_card.dart",
    ""
)
content = content.replace(
    "package:otlob/core/shared/search_bar.dart",
    ""
)
with open(filter_products_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(filter_products_screen)
print(f"Fixed: {os.path.basename(filter_products_screen)}")

# Home screen - fix Explore references
home_screen = r'features\home\presentation\screens\home_screen.dart'
with open(home_screen, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/brands.dart",
    "package:otlob/features/explore/data/models/brands.dart"
)
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/categ.dart",
    "package:otlob/features/explore/data/models/categ.dart"
)
content = content.replace(
    "package:otlob/features/home/data/models/product_model.dart;",
    # This might be fine as-is, just checking
)
with open(home_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(home_screen)
print(f"Fixed: {os.path.basename(home_screen)}")

# Categories section widget
categories_widget = r'features\home\presentation\widgets\categories_section.dart'
with open(categories_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/categ.dart",
    "package:otlob/features/explore/data/models/categ.dart"
)
with open(categories_widget, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(categories_widget)
print(f"Fixed: {os.path.basename(categories_widget)}")

# Orders screen
orders_screen = r'features\orders\presentation\screens\order.dart'
with open(orders_screen, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Orders/models/order.dart",
    "package:otlob/features/orders/data/models/order.dart"
)
content = content.replace(
    "package:otlob/Features/Screens/Orders/widgets/order_card.dart",
    "package:otlob/features/orders/presentation/widgets/order_card.dart"
)
with open(orders_screen, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(orders_screen)
print(f"Fixed: {os.path.basename(orders_screen)}")

# Orders widget - order_card.dart
orders_widget = r'features\orders\presentation\widgets\order_card.dart'
with open(orders_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Orders/models/order.dart",
    "package:otlob/features/orders/data/models/order.dart"
)
content = content.replace(
    "package:otlob/Features/Screens/Orders/widgets/order_card.dart",
    "package:otlob/features/orders/presentation/widgets/order_card.dart"
)
with open(orders_widget, 'w', encoding='utf-8') as f:
    f.write(content)
fixed_files.append(orders_widget)
print(f"Fixed: {os.path.basename(orders_widget)}")

print(f"\nTotal files fixed: {len(fixed_files)}")
print(f"Files: {fixed_files}")