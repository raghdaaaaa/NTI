import os
import re

# Fix filter screens - replace Features/Screens/Filter with features/filter
for target_file in [
    r'features\filter\presentation\screens\filterb.dart',
    r'features\filter\presentation\screens\filterc.dart',
    r'features\filter\presentation\screens\filter_products.dart',
]:
    with open(target_file, 'r', encoding='utf-8') as f:
        content = f.read()
    # Replace the old Filter references
    content = content.replace(
        "package:otlob/Features/Screens/Filter/",
        "package:otlob/features/filter/"
    )
    # Replace core/shared references - these widgets are now in feature-specific locations
    # But keep them if they're still referenced; otherwise remove
    # For now, let's just remove the core/shared references that are filter-specific
    content = content.replace(
        "package:otlob/core/shared/brands_section.dart\n",
        ""
    )
    content = content.replace(
        "package:otlob/core/shared/product_card.dart\n",
        ""
    )
    content = content.replace(
        "package:otlob/core/shared/search_bar.dart\n",
        ""
    )
    with open(target_file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Fixed: {os.path.basename(target_file)}")

# Fix orders screens - replace Features/Screens/Orders with features/orders
for target_file in [
    r'features\orders\presentation\screens\order.dart',
    r'features\orders\presentation\widgets\order_card.dart',
]:
    with open(target_file, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(
        "package:otlob/Features/Screens/Orders/",
        "package:otlob/features/orders/"
    )
    with open(target_file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Fixed: {os.path.basename(target_file)}")

print("\nAll filter and orders fixes done.")