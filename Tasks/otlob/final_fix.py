import os

# Fix the home screen import
home_screen = r'features\home\presentation\screens\home_screen.dart'
with open(home_screen, 'r', encoding='utf-8') as f:
    content = f.read()
# Replace the old Explore model imports with new paths
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/brands.dart",
    "package:otlob/features/explore/data/models/brands.dart"
)
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/categ.dart",
    "package:otlob/features/explore/data/models/categ.dart"
)
with open(home_screen, 'w', encoding='utf-8') as f:
    f.write(content)
print(f"Fixed: {os.path.basename(home_screen)}")

# Fix categories section widget
categories_widget = r'features\home\presentation\widgets\categories_section.dart'
with open(categories_widget, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace(
    "package:otlob/Features/Screens/Explore/models/categ.dart",
    "package:otlob/features/explore/data/models/categ.dart"
)
with open(categories_widget, 'w', encoding='utf-8') as f:
    f.write(content)
print(f"Fixed: {os.path.basename(categories_widget)}")

print("\nAll remaining import fixes done.")