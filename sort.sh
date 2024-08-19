#!/bin/bash
echo 'Processing...'
TIME=$(date +"%Y-%m-%d-%H-%M-%S")
[ ! -s ./follower/last.txt ] && cat ./follower/json/init.json | grep 'screen_name' | sort > ./follower/init.txt
[ ! -s ./follower/last.txt ] && echo "./follower/init.txt" > ./follower/recent.txt
mv ~/Downloads/twitter-Followers* ./follower/json/$TIME.json
mv $(cat ./follower/json/last.txt) ./follower/json/old/
mv ./follower/json/recent.txt ./follower/json/last.txt
echo ./follower/json/$TIME.json > ./follower/json/recent.txt
mv $(cat ./follower/last.txt) ./follower/old/
cat ./follower/json/$TIME.json | grep 'screen_name' | sort > ./follower/$TIME.txt
mv ./follower/recent.txt ./follower/last.txt
echo ./follower/$TIME.txt > ./follower/recent.txt
sleep 2
[ ! -s ./following/last.txt ] && cat ./following/json/init.json | grep 'screen_name' | sort > ./following/init.txt
[ ! -s ./following/last.txt ] && echo "./following/init.txt" > ./following/recent.txt
mv ~/Downloads/twitter-Following* ./following/json/$TIME.json
mv $(cat ./following/json/last.txt) ./following/json/old/
mv ./following/json/recent.txt ./following/json/last.txt
echo ./following/json/$TIME.json > ./following/json/recent.txt
mv $(cat ./following/last.txt) ./following/old/
cat ./following/json/$TIME.json | grep 'screen_name' | sort > ./following/$TIME.txt
mv ./following/recent.txt ./following/last.txt
echo ./following/$TIME.txt > ./following/recent.txt
echo 'Done.'
clear
sleep 1
echo '**'$(grep -o 'screen_name' ./follower/$TIME.txt | wc -l)' Followers, Diff:''**' > ./diff.txt
echo "Unfollowers: " >> ./diff.txt
diff $(cat ./follower/last.txt) $(cat ./follower/recent.txt) | grep '<' >> ./diff.txt
echo "New Followers: " >> ./diff.txt
diff $(cat ./follower/last.txt) $(cat ./follower/recent.txt) | grep '>' >> ./diff.txt
echo " " >> ./diff.txt
echo '**'$(grep -o 'screen_name' ./following/$TIME.txt | wc -l)' Following, Diff:''**' >> ./diff.txt
echo "Unfollowing: " >> ./diff.txt
diff $(cat ./following/last.txt) $(cat ./following/recent.txt) | grep '<' >> ./diff.txt
echo "New Following: " >> ./diff.txt
diff $(cat ./following/last.txt) $(cat ./following/recent.txt) | grep '>' >> ./diff.txt
sed -i 's/"/`/g' ./diff.txt
python3 ./tgbot.py
clear
rm -rf ./temp/*
cat ./diff.txt
