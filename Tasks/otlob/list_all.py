import os
features = ['Auth', 'Cart', 'Debug', 'Details', 'Explore', 'Filter', 'Home', 'Orders']
for f in features:
    base = rf'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\{f}'
    screens_dir = os.path.join(base, 'Screens')
    widgets_dir = os.path.join(base, 'Widgets')
    models_dir = os.path.join(base, 'Models')
    
    print(f"=== {f} Screens ===")
    if os.path.exists(screens_dir):
        for root, dirs, files in os.walk(screens_dir):
            for file in files:
                print(os.path.join(root, file))
    
    print(f"=== {f} Widgets ===")
    if os.path.exists(widgets_dir):
        for root, dirs, files in os.walk(widgets_dir):
            for file in files:
                print(os.path.join(root, file))
    
    print(f"=== {f} Models ===")
    if os.path.exists(models_dir):
        for root, dirs, files in os.walk(models_dir):
            for file in files:
                print(os.path.join(root, file))
    print()