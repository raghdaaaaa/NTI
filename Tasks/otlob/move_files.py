import os
import shutil

# Source -> Destination mapping for screens
screen_moves = [
    # Auth
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Screens\log_in.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\screens\log_in.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Screens\sign_up.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\screens\sign_up.dart'),
    # Cart
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Cart\Screens\cart.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\cart\presentation\screens\cart.dart'),
    # Debug
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Debug\debug_screen.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\debug\presentation\screens\debug_screen.dart'),
    # Details
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Details\Screens\details.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\details\presentation\screens\details.dart'),
    # Explore
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Screens\explore.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\presentation\screens\explore.dart'),
    # Filter
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Filter\Screens\filterb.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\filter\presentation\screens\filterb.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Filter\Screens\filterc.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\filter\presentation\screens\filterc.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Filter\Screens\filter_products.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\filter\presentation\screens\filter_products.dart'),
    # Home
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Screens\home_screen.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\presentation\screens\home_screen.dart'),
    # Orders
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Orders\Screens\order.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\orders\presentation\screens\order.dart'),
]

# Widget moves
widget_moves = [
    # Auth widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\driver.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\driver.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\footer.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\footer.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\forms.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\forms.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\header.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\header.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\log_option.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\log_option.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets\remember.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\auth\presentation\widgets\remember.dart'),
    # Cart widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Cart\Widgets\card.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\cart\presentation\widgets\card.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Cart\Widgets\summary.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\cart\presentation\widgets\summary.dart'),
    # Details widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Details\Widgets\add_button.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\details\presentation\widgets\add_button.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Details\Widgets\image_product.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\details\presentation\widgets\image_product.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Details\Widgets\product_info.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\details\presentation\widgets\product_info.dart'),
    # Explore widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Widgets\brands.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\presentation\widgets\brands.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Widgets\categ.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\presentation\widgets\categ.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Widgets\header.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\presentation\widgets\header.dart'),
    # Filter widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Filter\Widgets\back_header.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\filter\presentation\widgets\back_header.dart'),
    # Home widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Widgets\categories_section.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\presentation\widgets\categories_section.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Widgets\home_app_bar.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\presentation\widgets\home_app_bar.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Widgets\promo_banner.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\presentation\widgets\promo_banner.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Widgets\section_header.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\presentation\widgets\section_header.dart'),
    # Orders widgets
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Orders\Widgets\order_card.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\orders\presentation\widgets\order_card.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Orders\Widgets\order_status.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\orders\presentation\widgets\order_status.dart'),
]

# Model moves
model_moves = [
    # Cart model
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Cart\Models\cart.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\cart\data\models\cart.dart'),
    # Explore models
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Models\brands.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\data\models\brands.dart'),
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\Models\categ.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\data\models\categ.dart'),
    # Filter model
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Filter\Models\filter_prod.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\filter\data\models\filter_prod.dart'),
    # Home model
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Home\Models\product_model.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\home\data\models\product_model.dart'),
    # Orders model
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Orders\Models\order.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\orders\data\models\order.dart'),
]

# Service moves (only feature-specific services, not api_client.dart in core/)
service_moves = [
    # Explore service
    (r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Explore\services\api_service.dart', r'F:\nti_flutter\NTI\Tasks\otlob\features\explore\data\services\api_service.dart'),
]

moved = 0
skipped = 0
errors = 0

print("Moving screens...")
for src, dst in screen_moves:
    try:
        if os.path.exists(src):
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.move(src, dst)
            moved += 1
            print(f"  Moved: {os.path.basename(src)} -> {os.path.relpath(dst)}")
        else:
            print(f"  NOT FOUND: {os.path.basename(src)}")
            skipped += 1
    except Exception as e:
        print(f"  ERROR moving {os.path.basename(src)}: {e}")
        errors += 1

print("\nMoving widgets...")
for src, dst in widget_moves:
    try:
        if os.path.exists(src):
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.move(src, dst)
            moved += 1
            print(f"  Moved: {os.path.basename(src)} -> {os.path.relpath(dst)}")
        else:
            print(f"  NOT FOUND: {os.path.basename(src)}")
            skipped += 1
    except Exception as e:
        print(f"  ERROR moving {os.path.basename(src)}: {e}")
        errors += 1

print("\nMoving models...")
for src, dst in model_moves:
    try:
        if os.path.exists(src):
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.move(src, dst)
            moved += 1
            print(f"  Moved: {os.path.basename(src)} -> {os.path.relpath(dst)}")
        else:
            print(f"  NOT FOUND: {os.path.basename(src)}")
            skipped += 1
    except Exception as e:
        print(f"  ERROR moving {os.path.basename(src)}: {e}")
        errors += 1

print("\nMoving services...")
for src, dst in service_moves:
    try:
        if os.path.exists(src):
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.move(src, dst)
            moved += 1
            print(f"  Moved: {os.path.basename(src)} -> {os.path.relpath(dst)}")
        else:
            print(f"  NOT FOUND: {os.path.basename(src)}")
            skipped += 1
    except Exception as e:
        print(f"  ERROR moving {os.path.basename(src)}: {e}")
        errors += 1

print(f"\n\nTotal: {moved} moved, {skipped} skipped, {errors} errors")