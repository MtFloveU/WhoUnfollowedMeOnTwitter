#!/bin/bash
clear
pkill -f chromium
pkill -f vnc
figlet -k -W "Who"
figlet -k -W "Unfollowed"
figlet -k -W "Me?"
echo 'By Twitter @Ak1raQ_love'
echo ' '
sleep 1
7z a -t7z -mx=3 follow.7z follower/ following/
echo "Starting Chromium in the VNC Server..."
vncserver :2
sleep 5
export DISPLAY=:2
DISPLAY=:2 chromium-browser "about:blank"  --start-maximized --remote-debugging-port=9222 --no-sandbox --disable-gpu --ignore-certificate-errors &
sleep 5
echo "Chromium is already running. Opening the website..."
./get_debug_url.sh | xargs -I {} python3 ./open-0.py {} > /dev/null
sleep 6
wscat -c $(./get_debug_url.sh) -x "{\"id\":1,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"document.querySelector('.css-1jxf684.r-bcqeeo.r-1ttztb7.r-qvutc0.r-poiln3.r-1b43r93.r-1cwl3u0.r-b88u0q')?.textContent\",\"returnByValue\":true}}" | jq -r '.result.result.value' | sed 's/,//g' > ./temp/target_number-2.txt
wscat -c $(./get_debug_url.sh) -x "{\"id\":1,\"method\":\"Runtime.evaluate\",\"params\":{\"expression\":\"document.querySelectorAll('.css-1jxf684.r-bcqeeo.r-1ttztb7.r-qvutc0.r-poiln3.r-1b43r93.r-1cwl3u0.r-b88u0q')[1]?.textContent\",\"returnByValue\":true}}" | jq -r '.result.result.value' | sed 's/,//g' > ./temp/target_number-1.txt
echo "The number was loaded."
./get_debug_url.sh | xargs -I {} python3 ./open-1.py {} > /dev/null
echo "Waiting for the website fully loaded..."
sleep 5
echo "Clear database..."
./get_debug_url.sh | xargs -I {} python3 ./cleardb.py {} > /dev/null
sleep 2
clear
echo "Fetching Followers..."
./get_debug_url-2.sh
sleep 3
python3 ./scroll.py
sleep 2
echo "Followers Fetched. Exporting..."
./get_debug_url.sh | xargs -I {} python3 ./export-1.py {}
sleep 3
./second.sh
exit 0
