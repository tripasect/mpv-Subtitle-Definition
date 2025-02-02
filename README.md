# Preview
https://github.com/user-attachments/assets/49ad32c3-a4fb-4d44-9795-27a1ef1f8381



<img src="https://raw.githubusercontent.com/mpv-player/mpv.io/master/source/images/mpv-logo-128.png" width="25px" align="absmiddle"> **mpv-Subtitle-Definition** is an [mpv-player](https://github.com/mpv-player/mpv) extension put together to help language learners better understand difficult or obscure words appearing in movie or video subtitles when using mpv. When triggered by a key (`TAB` or `ENTER`), it reads the current subtitle text displayed on screen, sends it to a Python script that extracts challenging words, and then uses ChatGPT's API to look up their definitions. The definitions are then returned to the Lua script and displayed on-screen (OSD) for easy reference.

## Features

- **Real-Time Assistance:** Instantly provides definitions for difficult or obscure words in subtitles.
- **Seamless Integration:** Triggered directly from mpv using configurable keys (TAB/ENTER).
- **Automated Word Analysis:** Utilizes a Python script to parse subtitle text and detect challenging vocabulary.
- **Powered by ChatGPT:** Leverages ChatGPT’s API to retrieve clear, dictionary-style definitions with example sentences.
- **Customizable:** Easily extendable and modifiable to suit your needs.

# Prerequisites

- **mpv:** Ensure you have mpv installed on your system. If you don't, visit [mpv-player](https://github.com/mpv-player/mpv) for more information.
- **Python 3.6+:** The Python script requires Python 3.6 or higher.

# Installation

1. Clone this repository in the scripts folder of mpv and de-nest the .lua file:

```bash
cd ~/.config/mpv/scripts
git clone https://github.com/tripasect/mpv-Subtitle-Definition.git
cd mpv-Subtitle-Definition
mv mpv-Subtitle-Definition.lua ..
```

2.	Create and activate a virtual environment `.venv` (*required*):

```bash
python3 -m venv .venv
source .venv/bin/activate
```


3.	Install the required Python packages:

```bash
pip install -r requirements.txt
```


4.	Download NLTK data (if not already installed):

```bash
python -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger'); nltk.download('wordnet')"
```


5.	Create a .env file in the project root and add your OpenAI API key to it:
```bash
touch .env
nano .env
```

```file
# .env
OPENAI_API_KEY=your_openai_api_key_here
```


# Usage
- Start mpv and play your video.
- Trigger the script: While watching the video, press `TAB` or `ENTER` to capture the current subtitle text.
- View definitions: The extension will pause the playback, analyze the subtitle text and, if difficult words are found, show their definitions on the screen. If no difficult words are found, it simply resumes the playback without querying ChatGPT at all.

# Customization
  - Known Words List: To prevent common words from being looked up, maintain a directory of text files containing known words. Add or update .txt files in directory path `/word-lists` if necessary.
  - Key Bindings: Adjust the Lua script to change the trigger key if needed.


Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.


Happy viewing and learning!
