import os
import re

# Search for old import patterns in all moved files
old_patterns = [
    r"Features/Screens/Auth",
    r"Features/Screens/Cart",
    r"Features/Screens/Debug",
    r"Features/Screens/Details",
    r"Features/Screens/Explore",
    r"Features/Screens/Filter",
    r"Features/Screens/Home",
    r"Features/Screens/Orders",
    r"Features/Screens/Cart/models",
    r"Features/Screens/Cart/widgets",
    r"Features/Screens/Explore/models",
    r"Features/Screens/Explore/widgets",
    r"Features/Screens/Explore/services",
    r"Features/Screens/Filter/models",
    r"Features/Screens/Filter/widgets",
    r"Features/Screens/Home/models",
    r"Features/Screens/Home/widgets",
    r"Features/Screens/Orders/models",
    r"Features/Screens/Orders/widgets",
]

found_any = False
for root, dirs, files in os.walk('features'):
    for f in files:
        if not f.endswith('.dart'):
            continue
        filepath = os.path.join(root, f)
        with open(filepath, 'r', encoding='utf-8') as fh:
            content = fh.read()
        for pattern in old_patterns:
            if re.search(pattern, content):
                print(f"  {os.path.relpath(filepath)}: matches '{pattern}'")
                found_any = True

if not found_any:
    print("No old import patterns found - all imports updated!")