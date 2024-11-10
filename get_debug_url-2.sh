#!/bin/bash
ID=$(cat info/id.txt)
JSON_DATA=$(curl -s http://localhost:9222/json)
MATCHED_BLOCK=$(echo "$JSON_DATA" | jq -r --arg id "$ID" '.[] | select(.url | contains($id))')
while true
do
if [ -n "$MATCHED_BLOCK" ]; then
    DEBUG_URL=$(echo "$MATCHED_BLOCK" | jq -r '.webSocketDebuggerUrl')
    echo "$DEBUG_URL" > ./temp/debug_url.txt
    cat ./temp/debug_url.txt
    break
else
    echo "$ID not found."
    sleep 1
fi
done
