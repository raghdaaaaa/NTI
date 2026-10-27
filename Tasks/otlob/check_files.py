import os
files = [
    r'features\auth\presentation\screens\log_in.dart',
    r'features\cart\presentation\screens\cart.dart',
    r'features\explore\presentation\screens\explore.dart',
    r'features\home\presentation\screens\home_screen.dart',
    r'features\orders\presentation\screens\order.dart',
]
for f in files:
    exists = os.path.exists(f)
    print(f"{f}: {'EXISTS' if exists else 'MISSING'}")