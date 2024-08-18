import asyncio
import websockets
import json
import re
import time

async def send_js_code(uri, script):
    async with websockets.connect(uri) as websocket:
        js_code = {
            "id": 1,
            "method": "Runtime.evaluate",
            "params": {
                "expression": script,
                "returnByValue": True
            }
        }
        await websocket.send(json.dumps(js_code))
        response = await websocket.recv()
        return json.loads(response)

async def monitor_page(uri, target_number):
    while True:
        try:
            found = await check_page_content(uri, target_number)
            if found:
                print("Exiting script after finding the number.")
                return
            await scroll_page(uri)
        except websockets.exceptions.ConnectionClosedError as e:
            print(f"Connection closed, retrying: {e}")
            await asyncio.sleep(1)  # 等待1秒后重试连接

async def check_page_content(uri, target_number):
    try:
        # 执行 JavaScript 获取页面内容
        js_code = "Array.from(document.querySelectorAll('.text-sm.text-base-content.leading-5.text-opacity-70.m-0')).map(el => el.innerText).join(' ')"
        response = await send_js_code(uri, js_code)

        # 解析获取的内容
        page_content = response.get("result", {}).get("result", {}).get("value", "")

        # 使用正则表达式提取数字
        numbers = re.findall(r'\d+', page_content)
        print(f"Captured numbers: {numbers}")  # 打印捕获到的所有数字

        # 计算范围
        target_number = int(target_number)
        lower_bound = target_number - 10
        upper_bound = target_number + 10

        # 查找是否有数字在目标范围内
        found = any(lower_bound <= int(match) <= upper_bound
                    for match in numbers)

        if found:
            print(f"Found a number within range: [{lower_bound}-{upper_bound}]")
            await asyncio.sleep(2)
            return True
        else:
            print("No number found within range")
            return False
    except websockets.exceptions.ConnectionClosedError as e:
        print(f"WebSocket error: {e}")
        raise

async def scroll_page(uri):
    async with websockets.connect(uri) as websocket:
        for _ in range(5):  # 增加滑动次数
            await send_js_code(uri, "window.scrollBy(0, window.innerHeight * 3)")  # 每次滑动3倍窗口高度
            await asyncio.sleep(0.5)
        js_code = "Array.from(document.querySelectorAll('.text-sm.text-base-content.leading-5.text-opacity-70.m-0')).map(el => el.innerText).join(' ')"
        response = await send_js_code(uri, js_code)
        page_content = response.get("result", {}).get("result", {}).get("value", "")
        print(f"Page content after scrolling: {page_content}")

async def main():
    with open('./temp/debug_url.txt', 'r') as file:
        websocket_url = file.read().strip()

    with open('./temp/target_number-2.txt', 'r') as file:
        target_number = file.read().strip()

    await monitor_page(websocket_url, target_number)

if __name__ == "__main__":
    asyncio.run(main())
