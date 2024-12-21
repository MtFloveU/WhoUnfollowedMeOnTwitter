#!/bin/bash
mkdir -p "./temp/data"
if [[ -n $(ls -A ./temp/data) ]]; then
  rm ./temp/data/*
fi
source_dir="./temp/data"  # 源目录路径
target_dir="./data"  # 目标目录路径

# 清空所有txt文件
> "$source_dir/mutual_unfollow.txt"
> "$source_dir/single-unfollower.txt"
> "$source_dir/single-unfollowing.txt"
echo "Processing JSON files, this may take a while..."
# Step 1: Processing Followers JSON files
jq -c '.[]' ~/Downloads/twitter-Followers-*.json | while read -r item; do
  id=$(echo "$item" | jq -r '.id')
  echo "$item" | jq . > "$source_dir/${id}.json"
done

# Step 2: Processing Following JSON files
jq -c '.[]' ~/Downloads/twitter-Following-*.json | while read -r item; do
  id=$(echo "$item" | jq -r '.id')
  echo "$item" | jq . > "$source_dir/${id}.json"
done

echo "🕒Time: "$(date +"%Y-%m-%d %H:%M:%S")" "$(date +%Z)"" > ./diff.txt
echo '*'$(cat ./temp/target_number-1.txt)' Followers, '$(cat ./temp/target_number-2.txt)' Following*' >> ./diff.txt

# Step 1: Checking for mutual unfollow
for target_file in "$target_dir"/*.json; do
  filename=$(basename "$target_file")
  source_file="$source_dir/$filename"

  if [[ ! -f "$source_file" ]]; then
    jq -r '.id' "$target_file" >> "$source_dir/mutual_unfollow.txt"
  fi
done

# Step 2: Checking followed_by status
for target_file in "$target_dir"/*.json; do
  filename=$(basename "$target_file")
  source_file="$source_dir/$filename"

  if [[ -f "$source_file" ]]; then
    followed_by_target=$(jq -r '.followed_by' "$target_file")
    followed_by_source=$(jq -r '.followed_by' "$source_file")

    if [[ "$followed_by_target" == "true" && ( "$followed_by_source" == "false" || "$followed_by_source" == "null" ) ]]; then
      jq -r '.id' "$target_file" >> "$source_dir/single-unfollower.txt"
    fi
  fi
done

# Step 3: Checking following status
for target_file in "$target_dir"/*.json; do
  filename=$(basename "$target_file")
  source_file="$source_dir/$filename"

  if [[ -f "$source_file" ]]; then
    following_target=$(jq -r '.following' "$target_file")
    following_source=$(jq -r '.following' "$source_file")

    if [[ "$following_target" == "true" && ( "$following_source" == "false" || "$following_source" == "null" ) ]]; then
      jq -r '.id' "$target_file" >> "$source_dir/single-unfollowing.txt"
    fi
  fi
done

# Output Mutual Unfollow, Single Unfollower and Single Unfollowing lists
echo "*Mutual Unfollow or removed:*" >> ./diff.txt
while IFS= read -r id; do
  target_file="$target_dir/$id.json"

  if [[ -f "$target_file" ]]; then
    name=$(jq -r '.name' "$target_file")
    screen_name=$(jq -r '.screen_name' "$target_file")
    echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
    jq '.removed = "true"' "$target_file" > $target_file-temp.json
    mv $target_file-temp.json $target_file
    echo $id >> ./data/removed_list.txt
  fi
done < "$source_dir/mutual_unfollow.txt"

echo "" >> ./diff.txt

echo "*Single Unfollower:*" >> ./diff.txt
while IFS= read -r id; do
  target_file="$target_dir/$id.json"

  if [[ -f "$target_file" ]]; then
    name=$(jq -r '.name' "$target_file")
    screen_name=$(jq -r '.screen_name' "$target_file")
    echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
  fi
done < "$source_dir/single-unfollower.txt"

echo "" >> ./diff.txt

echo "*Single Unfollowing:*" >> ./diff.txt
while IFS= read -r id; do
  target_file="$target_dir/$id.json"

  if [[ -f "$target_file" ]]; then
    name=$(jq -r '.name' "$target_file")
    screen_name=$(jq -r '.screen_name' "$target_file")
    echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
  fi
done < "$source_dir/single-unfollowing.txt"

echo "" >> ./diff.txt

echo "*Returners:*" >> ./diff.txt

mapfile -t removed_list < ./data/removed_list.txt

for source_file in "$source_dir"/*.json; do
  id=$(jq -r '.id' "$source_file")

  if [[ " ${removed_list[@]} " =~ " $id " ]]; then
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
      jq 'del(.removed)' "$target_file"
      removed_list=("${removed_list[@]/$id}")
    fi
  fi
done

printf "%s\n" "${removed_list[@]}" > ./data/removed_list.txt

echo "Updating data..."
for source_file in "$source_dir"/*.json; do
  filename=$(basename "$source_file")
  target_file="$target_dir/$filename"

  if [ -f "$target_file" ]; then
    source_data=$(jq -c '{screen_name, name, description}' "$source_file")
    target_data=$(jq -c '{screen_name, name, description}' "$target_file")

    if [ "$source_data" != "$target_data" ]; then
      cp "$source_file" "$target_file"
    fi
  else
    id=$(jq -r '.id' "$source_file")
    if ! grep -q "$id" ./data/removed_list.txt; then
      cp "$source_file" "$target_file"
    fi
  fi
done
  cd ./data
  git add --all
  git commit -m "$(date +"%Y-%m-%d %H:%M:%S")"
  cd ..
if [[ -s "info/tguserid.txt" ]] && [[ -s "info/tgapikey.txt" ]]; then
  echo "Pushing to your Telegram bot..."
  python3 tgbot.py
fi

if [[ -s "info/githubrepo.txt" ]]; then
  echo "Pushing to your GitHub repository..."
  cd ./data
  git push --force
  cd ..
fi

cat ./diff.txt
