#!/bin/bash
echo 'Processing JSON files...'
sleep 1
TIME=$(date +"%Y-%m-%d-%H-%M-%S")
#[ ! -s ./follower/last.txt ] && cat ./follower/init.json | grep 'screen_name' | sort > ./follower/init.txt
#[ ! -s ./follower/last.txt ] && echo "./follower/init.txt" > ./follower/recent.txt

#move json from download folder
mv ~/Downloads/twitter-Followers* ./follower/$TIME.json
mv ~/Downloads/twitter-Following* ./following/$TIME.json
#move old json
mv $(cat ./follower/last.txt) ./follower/old/
mv $(cat ./following/last.txt) ./following/old/
#replace json status
mv ./follower/recent.txt ./follower/last.txt
echo ./follower/$TIME.json > ./follower/recent.txt
mv ./following/recent.txt ./following/last.txt
echo ./following/$TIME.json > ./following/recent.txt
echo 'Loading diff...'
sleep 1
clear
sleep 1
echo "🕒Time: "$(date +"%Y-%m-%d %H:%M:%S")" CST" > ./diff.txt
echo '*'$(grep -o 'screen_name' ./follower/$TIME.json | wc -l)' Followers*' >> ./diff.txt
echo "Unfollowers: " >> ./diff.txt

#diff follower
diff <(jq -r .[].id "$(cat ./follower/last.txt)") <(jq -r .[].id "$(cat ./follower/recent.txt)") | grep '^<' | sed 's/^< //' > temp/tempid.txt
while read id; do
  name=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .name' $(cat ./follower/last.txt))
  screen_name=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .screen_name' $(cat ./follower/last.txt))
  echo "$name @\`$screen_name\`" >> diff.txt
done < temp/tempid.txt
rm temp/tempid.txt

echo " " >> ./diff.txt
echo '*'$(grep -o 'screen_name' ./following/$TIME.json | wc -l)' Followings*' >> ./diff.txt
echo "Unfollowings: " >> ./diff.txt

#diff following
diff <(jq -r .[].id "$(cat ./following/last.txt)") <(jq -r .[].id "$(cat ./following/recent.txt)") | grep '^<' | sed 's/^< //' > temp/tempid.txt
while read id; do
  name=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .name' $(cat ./following/last.txt))
  screen_name=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .screen_name' $(cat ./following/last.txt))
  echo "$name @\`$screen_name\`" >> diff.txt
done < temp/tempid.txt
rm temp/tempid.txt

python3 ./tgbot.py
clear
rm -rf ./temp/*
cat ./diff.txt
