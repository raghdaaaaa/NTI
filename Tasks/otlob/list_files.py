import os
for root, dirs, files in os.walk(r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Screens'):
    for f in files:
        print(os.path.join(root, f))
print("---")
for root, dirs, files in os.walk(r'F:\nti_flutter\NTI\Tasks\otlob\lib\Features\Screens\Auth\Widgets'):
    for f in files:
        print(os.path.join(root, f))