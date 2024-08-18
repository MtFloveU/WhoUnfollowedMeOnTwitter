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
    # JavaScript 命令列表
    scripts = [
        "document.querySelector('.btn.btn-sm.p-0.w-9.h-9').click();",
        "document.querySelector('.btn.btn-primary').click();",
        "document.querySelectorAll('.btn.btn-primary')[1].click();"
    ]

    # 执行每个命令，并在命令之间等待一秒
    for script in scripts:
        await send_js_code(uri, script)
        time.sleep(1)

# 从命令行参数中获取 WebSocket URL
if __name__ == "__main__":
    websocket_url = sys.argv[1]
    asyncio.get_event_loop().run_until_complete(main(websocket_url))

