with open(r'lib\Core\shared\product_card.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace old import path
content = content.replace(
    "package:otlob/Features/Screens/Home/Models/product_model.dart",
    "package:otlob/features/home/data/models/product_model.dart"
)

with open(r'lib\Core\shared\product_card.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed product_card.dart")