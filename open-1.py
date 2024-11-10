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
    with open('info/id.txt', 'r') as file:
        id_value = file.read().strip()

    scripts = [
        f"window.open('https://x.com/{id_value}/followers')"
    ]

    for script in scripts:
        await send_js_code(uri, script)
        time.sleep(1)

if __name__ == "__main__":
    websocket_url = sys.argv[1]
    asyncio.get_event_loop().run_until_complete(main(websocket_url))
