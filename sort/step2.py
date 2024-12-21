import os
import json

source_dir = "./temp/data"
target_dir = "./data"
single_unfollower_path = os.path.join(source_dir, "single-unfollower.txt")

with open(single_unfollower_path, 'w') as single_unfollower_file:
    for filename in os.listdir(target_dir):
        if filename.endswith('.json'):
            target_file_path = os.path.join(target_dir, filename)
            source_file_path = os.path.join(source_dir, filename)

            if os.path.isfile(source_file_path):
                try:
                    with open(target_file_path, 'r') as target_file:
                        target_data = json.load(target_file)
                    with open(source_file_path, 'r') as source_file:
                        source_data = json.load(source_file)

                    followed_by_target = target_data.get('followed_by')
                    followed_by_source = source_data.get('followed_by')

                    if followed_by_target == "true" and (followed_by_source == "false" or followed_by_source is None):
                        single_unfollower_file.write(f"{target_data['id']}\n")

                except json.JSONDecodeError:
                    print(f"Error decoding JSON in file: {target_file_path} or {source_file_path}")
                except KeyError:
                    print(f"Key 'id' not found in file: {target_file_path} or {source_file_path}")
