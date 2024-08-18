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

def escape_markdown(text: str) -> str:
    return text.replace('_', '\\_')\
               .replace('*', '\\*')\
               .replace('[', '\\[')\
               .replace(']', '\\]')\
               .replace('(', '\\(')\
               .replace(')', '\\)')\
               .replace('~', '\\~')\
               .replace('`', '\\`')\
               .replace('>', '\\>')\
               .replace('#', '\\#')\
               .replace('+', '\\+')\
               .replace('-', '\\-')\
               .replace('=', '\\=')\
               .replace('|', '\\|')\
               .replace('{', '\\{')\
               .replace('}', '\\}')\
               .replace('.', '\\.')\
               .replace('!', '\\!')

async def send_file_content():
    try:
        with open('./diff.txt', 'r') as file:
            content = file.read()

        escaped_content = escape_markdown(content)

        await bot.send_message(
            chat_id=USER_ID,
            text=escaped_content,
            parse_mode=ParseMode.MARKDOWN
        )
        print("File content sent successfully!")
    except Exception as e:
        print(f"Error: {e}")

def main():
    asyncio.run(send_file_content())

if __name__ == '__main__':
    main()
