#!/bin/bash
clear
pkill -f chromium
#pkill -f vnc
figlet -k -W "Who"
figlet -k -W "Unfollowed"
figlet -k -W "Me?"
echo 'By Twitter @Akirameru_QwQ'
echo ' '
sleep 1
read -p "Enter your Followers and Following count in order, separated by space: " num1 num2
echo "$num1" > ./temp/target_number-1.txt
echo "$num2" > ./temp/target_number-2.txt
echo "The number was loaded."
echo "Starting Chromium in the VNC Server..."
#vncserver
export DISPLAY=:2
chromium "about:blank"  --start-maximized --remote-debugging-port=9222 --no-sandbox --disable-gpu --ignore-certificate-errors &
sleep 2
echo "Chromium is already running. Opening the website..."
./get_debug_url.sh | xargs -I {} python3 ./open-1.py {} > /dev/null
echo "Waiting for the website fully loaded..."
sleep 5
clear
echo "Fetching Followers..."
./get_debug_url-2.sh
python3 ./scroll.py
sleep 2
echo "Followers Fetched. Exporting..."
./get_debug_url.sh | xargs -I {} python3 ./export-1.py {}
sleep 3
./second.sh
exit 0
