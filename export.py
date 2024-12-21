import asyncio
import websockets
import json
import time
import sys

async def send_js_code(uri, script):
    async with websockets.connect(uri) as websocket:
        js_code = {
            "id": 1,
            "method": "Runtime.evaluate",
            "params": {
                "expression": script
            }
        }
        await websocket.send(json.dumps(js_code))
        response = await websocket.recv()
        print(response)

async def main(uri):
    scripts = [
        "document.querySelector('.btn.btn-sm.p-0.w-9.h-9').click();",
        "document.querySelector('.checkbox').click();",
        "document.querySelector('.btn.btn-primary').click();",
        "document.querySelectorAll('.btn.btn-primary')[1].click();",
        "document.querySelectorAll('.btn.btn-sm.p-0.w-9.h-9')[1].click();",
        "document.querySelectorAll('.checkbox')[12].click();",
        "document.querySelectorAll('.btn.btn-primary')[2].click();",
        "document.querySelectorAll('.btn.btn-primary')[3].click();"
    ]

    for script in scripts:
        await send_js_code(uri, script)
        await asyncio.sleep(1)

# 从命令行参数中获取 WebSocket URL
if __name__ == "__main__":
    with open('./temp/debug_url.txt', 'r') as file:
        websocket_url = file.read().strip()
    asyncio.run(main(websocket_url))  # 使用 asyncio.run() 来启动主函数
