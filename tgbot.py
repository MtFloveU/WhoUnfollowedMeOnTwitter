import asyncio
import nest_asyncio
from telegram import Bot
from telegram.constants import ParseMode

nest_asyncio.apply()

def get_token_and_user_id():
    with open('./tgapikey.txt', 'r') as token_file:
        token = token_file.read().strip()
    with open('./tguserid.txt', 'r') as user_id_file:
        user_id = int(user_id_file.read().strip())
    return token, user_id

TOKEN, USER_ID = get_token_and_user_id()

bot = Bot(token=TOKEN)

async def send_file_content():
    try:
        with open('diff.txt', 'r') as file:
            content = file.read()

        await bot.send_message(
            chat_id=USER_ID,
            text=content,
            parse_mode=ParseMode.MARKDOWN
        )
        print("File content sent successfully!")
    except Exception as e:
        print(f"Error: {e}")

def main():
    asyncio.run(send_file_content())

if __name__ == '__main__':
    main()
