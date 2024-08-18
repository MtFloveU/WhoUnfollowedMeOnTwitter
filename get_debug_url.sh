#!/bin/bash

# 获取调试端点 URL
DEBUG_URL=$(curl -s http://localhost:9222/json | jq -r '.[0].webSocketDebuggerUrl')

# 输出调试端点 URL
echo $DEBUG_URL

