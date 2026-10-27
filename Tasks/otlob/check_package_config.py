import json
with open(r'lib\.dart_tool\package_config.json', 'r') as f:
    data = json.load(f)
    for entry in data['packages']:
        if 'otlob' in entry['name']:
            print(entry['name'])
            print(entry['rootUri'])