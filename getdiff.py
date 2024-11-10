import asyncio
import nest_asyncio
from telegram import Update
from telegram.ext import Application, CommandHandler, CallbackContext
from telegram.constants import ParseMode
# 使用 nest_asyncio 以允许嵌套事件循环
nest_asyncio.apply()

# 使用你从BotFather获得的令牌
TOKEN = "7298014727:AAHWV_-0iV5SFRqKzAsVCUqSw9HEzsLOZTw"

# 读取文件内容的函数
async def read_file(file_path: str) -> str:
    try:
        with open(file_path, 'r') as file:
            content = file.read()
        return content
    except Exception as e:
        return f"Error reading file: {e}"

# 处理 /start 命令
async def start(update: Update, context: CallbackContext) -> None:
        await update.message.reply_text("如果你看到这条消息，那么这个机器人现在正在运行中，好耶！点击下面的目录来获取命令帮助～")

# 处理 /getdiff 命令
async def getdiff(update: Update, context: CallbackContext) -> None:
        content = await read_file('/home/akira/git/twitter/diff.txt')
        await update.message.reply_text(
                text=content,
                parse_mode=ParseMode.MARKDOWN)

async def run_bot():
    # 使用 Builder 模式创建并初始化应用程序实例
    application = Application.builder().token(TOKEN).build()

    # 添加命令处理器
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("getdiff", getdiff))

    # 启动轮询并保持机器人运行
    await application.run_polling()

def main():
    # 使用 asyncio.run() 启动主任务
    asyncio.run(run_bot())

if __name__ == '__main__':
    main()

