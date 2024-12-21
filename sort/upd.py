import os
import json
import shutil

source_dir = "./temp/data"
target_dir = "./data"
removed_list_path = "./data/removed_list.txt"

def json_data(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
        return {key: data[key] for key in ('screen_name', 'name', 'description')}

with open(removed_list_path, 'r') as removed_list_file:
    removed_list = removed_list_file.read().splitlines()

for filename in os.listdir(source_dir):
    if filename.endswith('.json'):
        source_file_path = os.path.join(source_dir, filename)
        target_file_path = os.path.join(target_dir, filename)

        if os.path.isfile(target_file_path):
            source_data = json_data(source_file_path)
            with open(target_file_path, 'r') as target_file:
                target_data = json.load(target_file)
            target_data = {key: target_data[key] for key in ('screen_name', 'name', 'description')}

            if source_data != target_data:
                shutil.copy2(source_file_path, target_file_path)
        else:
            with open(source_file_path, 'r') as source_file:
                source_id = json.load(source_file).get('id')
            if source_id and source_id not in removed_list:
                shutil.copy2(source_file_path, target_file_path)
