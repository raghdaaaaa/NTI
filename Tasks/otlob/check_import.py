with open(r'features\auth\presentation\screens\log_in.dart', 'r') as f:
    lines = f.readlines()
    for i, line in enumerate(lines[:10], 1):
        print(f"{i}: {line.rstrip()}")