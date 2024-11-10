#!/bin/bash
clear
echo "Parparing to fetch the following list..."
./get_debug_url.sh | xargs -I {} python3 ./open-2.py {} > /dev/null
sleep 5
echo "Fetching following..."
./get_debug_url-2.sh
python3 ./scroll-2.py
sleep 2
echo "Following fetched. Exporting..."
./get_debug_url.sh | xargs -I {} python3 ./export-2.py {} > /dev/null
sleep 5
FOLDER_PATH="/home/akira/Downloads"
while true; do
    if ls "$FOLDER_PATH"/*Following*.json 1> /dev/null 2>&1; then
        echo "Found JSON file."
        break
    else
        echo "JSON file not found. Retrying..."
        sleep 2
	./get_debug_url.sh | xargs -I {} python3 ./export-2.py {}
    fi
done
echo "Still working..."
pkill -f chromium
pkill -f vnc
clear
./sort.sh
exit 0
