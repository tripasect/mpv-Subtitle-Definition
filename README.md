# mpv-Subtitle-Definition

**mpv-Subtitle-Definition** is a tool designed to help viewers better understand difficult or obscure words appearing in movie or video subtitles when using mpv. When triggered by a key (TAB or ENTER), it reads the current subtitle text displayed on screen, sends it to a Python script that extracts challenging words, and then uses ChatGPT's API to look up their definitions. The definitions are then returned to the Lua script and displayed on-screen (OSD) for easy reference.

## Features

- **Real-Time Assistance:** Instantly provides definitions for difficult or obscure words in subtitles.
- **Seamless Integration:** Triggered directly from mpv using configurable keys (TAB/ENTER).
- **Automated Word Analysis:** Utilizes a Python script to parse subtitle text and detect challenging vocabulary.
- **Powered by ChatGPT:** Leverages ChatGPT’s API to retrieve clear, dictionary-style definitions with example sentences.
- **Customizable:** Easily extendable and modifiable to suit your needs.

## Installation

### Prerequisites

- **mpv:** Ensure you have mpv installed on your system.
- **Python 3.6+:** The Python script requires Python 3.6 or higher.
- **Lua:** mpv should have Lua scripting support enabled.

### Python Dependencies

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/tripasect/mpv-Subtitle-Definition.git
   cd mpv-Subtitle-Definition
   cp -R . ~/.config/mpv/scripts/
   cd ~/.config/mpv/scripts
   ```

2.	Create and activate a virtual environment (*required*):

```bash
python3 -m venv .venv
source venv/bin/activate
```


3.	Install the required Python packages:

```bash
pip install -r requirements.txt
```


4.	Download NLTK data (if not already installed):

```bash
python -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger'); nltk.download('wordnet')"
```


5.	Create a .env file in the project root:
  ```bash
  touch .env
  ```

6.	Add your OpenAI API key to the .env file:

```file
# .env
OPENAI_API_KEY=your_openai_api_key_here
```


## Usage
- Start mpv and load your video.
- Trigger the Script: While watching the video, press TAB or ENTER to capture the current subtitle text.
- View Definitions: The Python script will analyze the subtitle text and, if difficult words are found, send their definitions back to the Lua script. The definitions will then be displayed on-screen via mpv’s OSD.
### Customization
  - Known Words List: To prevent common words from being looked up, maintain a directory of text files containing known words. Add or update .txt files in directory path `/word-lists` if necessary.
  - Key Bindings: Adjust the Lua script to change the trigger key if needed.


Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.


Happy viewing and learning!
