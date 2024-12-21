import os
import glob
import json

# 定义源目录和目标目录
source_dir = "./temp/data"
os.makedirs(source_dir, exist_ok=True)  # 确保源目录存在

def process_json_files(file_pattern, source_dir):
    """
    解析 JSON 文件并将数据按 id 保存到单独的文件中。

    :param file_pattern: JSON 文件的路径模式（支持通配符）
    :param source_dir: 保存解析后 JSON 文件的目录
    """
    for file_path in glob.glob(file_pattern):
        with open(file_path, 'r', encoding='utf-8') as file:
            try:
                # 逐条解析 JSON 数组中的对象
                json_data = json.load(file)
                for item in json_data:
                    item_id = item.get('id')
                    if not item_id:
                        continue

                    # 保存每个对象到一个单独的 JSON 文件
                    output_path = os.path.join(source_dir, f"{item_id}.json")
                    with open(output_path, 'w', encoding='utf-8') as output_file:
                        json.dump(item, output_file, ensure_ascii=False, indent=4)
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON in file {file_path}: {e}")

# 处理 Followers 和 Following JSON 文件
process_json_files(os.path.expanduser("~/Downloads/twitter-Followers-*.json"), source_dir)
process_json_files(os.path.expanduser("~/Downloads/twitter-Following-*.json"), source_dir)

