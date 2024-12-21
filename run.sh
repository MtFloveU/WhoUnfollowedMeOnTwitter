#!/bin/bash
clear
rm -rf ./temp/*
pkill -f chromium
pkill -f vncserver
figlet -k -W "FDAP"
echo 'https://github.com/MtFloveU/twitter_fdap'
echo ' '
sleep 2
echo "Starting the VNC Server..."
vncserver :2 -xstartup "/usr/bin/xterm"
sleep 1
export DISPLAY=:2
DISPLAY=:2 chromium-browser "about:blank" --start-maximized --remote-debugging-port=9222 --no-sandbox --disable-gpu > /dev/null 2>&1 &
while true; do
  sleep 0.1
  if curl -s http://127.0.0.1:9222/json > /dev/null; then
    printf "\r[✓] Starting Chromium browser\n"
    break
  fi
done
echo "Chromium is already running. Opening the website..."
./get_debug_url.sh | xargs -I {} python3 ./open-0.py {} > /dev/null
sleep 1
./get_debug_url-2.sh
python3 ./get_followers_count.py
echo "The number was loaded."
./get_debug_url.sh | xargs -I {} python3 ./open-1.py {} > /dev/null
echo "Waiting for the website fully loaded..."
sleep 3
echo "Fetching your follower lists..."

while [ "$(cat ./temp/fetched-followers.txt)" != "1" ]; do
    ./get_debug_url-2.sh
    python3 ./scroll.py
done

echo "Fetching your following lists..."
while [ "$(cat ./temp/fetched-following.txt)" != "1" ]; do
    ./get_debug_url-2.sh
    python3 ./scroll-2.py
done
echo "Exporting..."
./get_debug_url.sh | xargs -I {} python3 ./export.py {}
sleep 0.5
./sort.sh
rm -rf ./temp/*
pkill -f chromium
pkill -f chrome
pkill -f vncserver
pkill -f tigervnc
echo "Contant me on Twitter @Ak1raQ_love"
exit 0
