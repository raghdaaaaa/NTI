with open(r'lib\Core\Constants\routes.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace old import paths with new Feature-first paths
replacements = [
    (r"package:otlob/Features/Screens/Auth/Screens/log_in.dart", 
     r"package:otlob/features/auth/presentation/screens/log_in.dart"),
    (r"package:otlob/Features/Screens/Auth/Screens/sign_up.dart", 
     r"package:otlob/features/auth/presentation/screens/sign_up.dart"),
    (r"package:otlob/Features/Screens/Cart/screens/cart.dart", 
     r"package:otlob/features/cart/presentation/screens/cart.dart"),
    (r"package:otlob/Features/Screens/Debug/debug_screen.dart", 
     r"package:otlob/features/debug/presentation/screens/debug_screen.dart"),
    (r"package:otlob/Features/Screens/Details/Screens/details.dart", 
     r"package:otlob/features/details/presentation/screens/details.dart"),
    (r"package:otlob/Features/Screens/Explore/Screens/explore.dart", 
     r"package:otlob/features/explore/presentation/screens/explore.dart"),
    (r"package:otlob/Features/Screens/Filter/screens/filterb.dart", 
     r"package:otlob/features/filter/presentation/screens/filterb.dart"),
    (r"package:otlob/Features/Screens/Filter/screens/filterc.dart", 
     r"package:otlob/features/filter/presentation/screens/filterc.dart"),
    (r"package:otlob/Features/Screens/Filter/screens/filter_products.dart", 
     r"package:otlob/features/filter/presentation/screens/filter_products.dart"),
    (r"package:otlob/Features/Screens/Home/Models/product_model.dart", 
     r"package:otlob/features/home/data/models/product_model.dart"),
    (r"package:otlob/Features/Screens/Home/Screens/home_screen.dart", 
     r"package:otlob/features/home/presentation/screens/home_screen.dart"),
    (r"package:otlob/Features/Screens/Orders/screens/order.dart", 
     r"package:otlob/features/orders/presentation/screens/order.dart"),
    # Keep the bottom_nav shared import
    (r"package:otlob/Core/shared/bottom_nav.dart", 
     r"package:otlob/core/shared/bottom_nav.dart"),
]

for old, new in replacements:
    content = content.replace(old, new)

with open(r'lib\Core\Constants\routes.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed routes.dart")