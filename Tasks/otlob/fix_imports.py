import os
import re

# Specific fixes for remaining old import patterns
fixes = [
    # Cart feature: replace Features/Screens/Cart with features/cart
    (r'features\cart\presentation\screens\cart.dart',
     [r"package:otlob/Features/Screens/Cart/(models|widgets)/", r"package:otlob/features/cart/data/\1/"]),
    (r'features\cart\presentation\widgets\card.dart',
     [r"package:otlob/Features/Screens/Cart/(models|widgets)/", r"package:otlob/features/cart/data/\1/"]),
    # Explore feature: replace Features/Screens/Explore with features/explore
    (r'features\explore\presentation\widgets\brands.dart',
     [r"package:otlob/Features/Screens/Explore/(models|widgets)/", r"package:otlob/features/explore/\1/"]),
    (r'features\explore\presentation\widgets\brands.dart',
     [r"\.\./\.\./models/(categ|brands)\.dart", r"features/explore/data/models/\1.dart"]),
    # Filter feature: replace Features/Screens/Filter with features/filter
    (r'features\filter\presentation\screens\filterb.dart',
     [r"package:otlob/Features/Screens/Filter/(models|widgets)/", r"package:otlob/features/filter/\1/"]),
    (r'features\filter\presentation\screens\filterc.dart',
     [r"package:otlob/Features/Screens/Filter/(models|widgets)/", r"package:otlob/features/filter/\1/"]),
    (r'features\filter\presentation\screens\filter_products.dart',
     [r"package:otlob/Features/Screens/Filter/", r"package:otlob/features/filter/"]),
    # Home feature: replace Features/Screens/Explore with features/explore
    (r'features\home\presentation\screens\home_screen.dart',
     [r"package:otlob/Features/Screens/Explore/(models)\.", r"package:otlob/features/explore/data/models."]),
    (r'features\home\presentation\widgets\categories_section.dart',
     [r"package:otlob/Features/Screens/Explore/(models)\.", r"package:otlob/features/explore/data/models."]),
    # Orders feature: replace Features/Screens/Orders with features/orders
    (r'features\orders\presentation\screens\order.dart',
     [r"package:otlob/Features/Screens/Orders/(models|widgets)/", r"package:otlob/features/orders/\1/"]),
    (r'features\orders\presentation\widgets\order_card.dart',
     [r"package:otlob/Features/Screens/Orders/(models|widgets)/", r"package:otlob/features/orders/\1/"]),
]

moved = 0
for filepath_pattern, pattern_replacements in fixes:
    # Find matching files by looking in features/
    for root, dirs, files in os.walk('features'):
        for f in files:
            if not f.endswith('.dart'):
                continue
            full_path = os.path.join(root, f)
            if filepath_pattern in full_path:
                with open(full_path, 'r', encoding='utf-8') as fh:
                    content = fh.read()
                original = content
                for old_imp, new_imp in pattern_replacements:
                    content = content.replace(old_imp, new_imp)
                if content != original:
                    with open(full_path, 'w', encoding='utf-8') as fh:
                        fh.write(content)
                    moved += 1
                    print(f"  Fixed: {os.path.relpath(full_path)}")

print(f"\nTotal files fixed: {moved}")