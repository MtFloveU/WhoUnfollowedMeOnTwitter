# Who unfollowed me on Twitter?

A Linux script to check the diff of your X/Twitter follower/following list.

# Warning

The script is for my personal use. It may cause bugs and errors when run on your computer. Make sure that you can understand the code's meaning and make changes when necessary.

# Requirements

- A Linux computer

- A VNC Server

- Python3 with websockets module

- Chromium with Tampermonkey installed

- Sign in to your Twitter account in Chromium

- Install and enable [twitter-web-exporter](https://github.com/prinsss/twitter-web-exporter) script in Tampermonkey

- Expend the menu of twitter-web-exporter

- Ports 2, 5902, and 9992 are idle

- 7-zip and jq installed

- Enter your Twitter ID to id.txt

# Usage

Clone the repository and run the script `first.sh`.

## First Run

You must obtain an initial version of the follow list to use this script.

1. Visit https://x.com/[Your-Twitter-ID]/followers/ in Chromium.
2. Scroll to the bottom of the list.
3. Click the cat icon on the left to expand the menu.
4. Click the arrowhead on Line 1, then click `Export Data` and `Start Export`.
5. Use the same method to export the following list.
6. Move the json file from the Download folder to the path `follower/json/init.json` and `following/json/init.json`.
7. Edit `follower/json/recent.txt` and `following/json/recent.txt` then fill in the absolute path corresponding to json.

# Push to Telegram bot

Enter your Telegram bot API key to `tgapi.txt`.

Enter your Telegram User ID (a number) to `tguserid.txt`

# Contact Me

Contact me on [Twitter](https://x.com/Akirameru_QwQ) @Akirameru_QwQ.
