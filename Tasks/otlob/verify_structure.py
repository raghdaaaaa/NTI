import os

for root, dirs, files in os.walk('features'):
    if 'view_models' in root:
        continue
    level = root.replace('features/', '').count(os.sep)
    indent = '  ' * level
    print(f'{indent}{os.path.basename(root)}/')
    sub_indent = '  ' * (level + 1)
    for file in files:
        print(f'{sub_indent}{file}')