import os
import re

# Define import path replacements
# Pattern: old_subpath -> new_subpath
# We'll replace the package path substrings

import_me_patterns = [
    # Auth feature imports
    (r"package:otlob/Features/Screens/Auth/Screens/", "package:otlob/features/auth/presentation/screens/"),
    (r"package:otlob/Features/Screens/Auth/Widgets/", "package:otlob/features/auth/presentation/widgets/"),
    # Cart feature imports
    (r"package:otlob/Features/Screens/Cart/Screens/", "package:otlob/features/cart/presentation/screens/"),
    (r"package:otlob/Features/Screens/Cart/Models/", "package:otlob/features/cart/data/models/"),
    (r"package:otlob/Features/Screens/Cart/Widgets/", "package:otlob/features/cart/presentation/widgets/"),
    # Debug feature imports
    (r"package:otlob/Features/Screens/Debug/", "package:otlob/features/debug/presentation/screens/"),
    # Details feature imports
    (r"package:otlob/Features/Screens/Details/Screens/", "package:otlob/features/details/presentation/screens/"),
    (r"package:otlob/Features/Screens/Details/Widgets/", "package:otlob/features/details/presentation/widgets/"),
    # Explore feature imports
    (r"package:otlob/Features/Screens/Explore/Screens/", "package:otlob/features/explore/presentation/screens/"),
    (r"package:otlob/Features/Screens/Explore/Models/", "package:otlob/features/explore/data/models/"),
    (r"package:otlob/Features/Screens/Explore/Widgets/", "package:otlob/features/explore/presentation/widgets/"),
    (r"package:otlob/Features/Screens/Explore/services/", "package:otlob/features/explore/data/services/"),
    # Filter feature imports
    (r"package:otlob/Features/Screens/Filter/Screens/", "package:otlob/features/filter/presentation/screens/"),
    (r"package:otlob/Features/Screens/Filter/Models/", "package:otlob/features/filter/data/models/"),
    (r"package:otlob/Features/Screens/Filter/Widgets/", "package:otlob/features/filter/presentation/widgets/"),
    # Home feature imports
    (r"package:otlob/Features/Screens/Home/Models/", "package:otlob/features/home/data/models/"),
    (r"package:otlob/Features/Screens/Home/Screens/", "package:otlob/features/home/presentation/screens/"),
    (r"package:otlob/Features/Screens/Home/Widgets/", "package:otlob/features/home/presentation/widgets/"),
    # Orders feature imports
    (r"package:otlob/Features/Screens/Orders/Screens/", "package:otlob/features/orders/presentation/screens/"),
    (r"package:otlob/Features/Screens/Orders/Models/", "package:otlob/features/orders/data/models/"),
    (r"package:otlob/Features/Screens/Orders/Widgets/", "package:otlob/features/orders/presentation/widgets/"),
]

# Core imports that should remain valid
core_imports = [
    (r"package:otlob/Core/Constants/", "package:otlob/core/constants/"),
    (r"package:otlob/Core/Routes/", "package:otlob/core/routes/"),
    (r"package:otlob/Core/network/", "package:otlob/core/network/"),
    (r"package:otlob/Core/shared/", "package:otlob/core/shared/"),
]

def update_imports(filepath):
    """Update import paths in a Dart file."""
    if not os.path.exists(filepath):
        print(f"  FILE NOT FOUND: {filepath}")
        return False
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    changes = []
    
    # Apply feature-specific import replacements
    for old_pattern, new_pattern in import_me_patterns:
        # Use regex to find and replace the pattern (case-insensitive for the path part)
        # But we need to be careful to only match import statements
        if old_pattern in content:
            # Replace the pattern
            new_content = re.sub(
                r"'" + re.escape(old_pattern) + r"([^']*)'", 
                r"'" + new_pattern + r"\1'", 
                content
            )
            if new_content != content:
                changes.append(f"  {old_pattern} -> {new_pattern}")
                content = new_content
    
    # Apply core import fixes (ensure correct case)
    for old_pattern, new_pattern in core_imports:
        if old_pattern in content:
            new_content = re.sub(
                r"'" + re.escape(old_pattern) + r"([^']*)'", 
                r"'" + new_pattern + r"\1'", 
                content
            )
            if new_content != content:
                changes.append(f"  {old_pattern} -> {new_pattern}")
                content = new_content
    
    # Only write if changes were made
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

# List of all moved files
moved_files = [
    # Auth
    r'features\auth\presentation\screens\log_in.dart',
    r'features\auth\presentation\screens\sign_up.dart',
    r'features\auth\presentation\widgets\driver.dart',
    r'features\auth\presentation\widgets\footer.dart',
    r'features\auth\presentation\widgets\forms.dart',
    r'features\auth\presentation\widgets\header.dart',
    r'features\auth\presentation\widgets\log_option.dart',
    r'features\auth\presentation\widgets\remember.dart',
    # Cart
    r'features\cart\presentation\screens\cart.dart',
    r'features\cart\presentation\widgets\card.dart',
    r'features\cart\presentation\widgets\summary.dart',
    r'features\cart\data\models\cart.dart',
    # Debug
    r'features\debug\presentation\screens\debug_screen.dart',
    # Details
    r'features\details\presentation\screens\details.dart',
    r'features\details\presentation\widgets\add_button.dart',
    r'features\details\presentation\widgets\image_product.dart',
    r'features\details\presentation\widgets\product_info.dart',
    # Explore
    r'features\explore\presentation\screens\explore.dart',
    r'features\explore\presentation\widgets\brands.dart',
    r'features\explore\presentation\widgets\categ.dart',
    r'features\explore\presentation\widgets\header.dart',
    r'features\explore\data\models\brands.dart',
    r'features\explore\data\models\categ.dart',
    r'features\explore\data\services\api_service.dart',
    # Filter
    r'features\filter\presentation\screens\filterb.dart',
    r'features\filter\presentation\screens\filterc.dart',
    r'features\filter\presentation\screens\filter_products.dart',
    r'features\filter\presentation\widgets\back_header.dart',
    r'features\filter\data\models\filter_prod.dart',
    # Home
    r'features\home\presentation\screens\home_screen.dart',
    r'features\home\presentation\widgets\categories_section.dart',
    r'features\home\presentation\widgets\home_app_bar.dart',
    r'features\home\presentation\widgets\promo_banner.dart',
    r'features\home\presentation\widgets\section_header.dart',
    r'features\home\data\models\product_model.dart',
    # Orders
    r'features\orders\presentation\screens\order.dart',
    r'features\orders\presentation\widgets\order_card.dart',
    r'features\orders\presentation\widgets\order_status.dart',
    r'features\orders\data\models\order.dart',
]

print("Updating import paths...")
total_fixed = 0
for filepath in moved_files:
    fixed = update_imports(filepath)
    if fixed:
        total_fixed += 1
        # Read the file to see what was changed
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        # Show the import lines
        for line in content.split('\n')[:5]:
            if 'import' in line.lower():
                print(f"  UPDATED: {filepath}: {line.strip()}")

print(f"\nTotal files with import updates: {total_fixed}")