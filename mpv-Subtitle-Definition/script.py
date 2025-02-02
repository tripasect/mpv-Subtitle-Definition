import glob
import os
import sys
import re

from openai import OpenAI

from nltk import pos_tag
from nltk.corpus import wordnet as wn
from nltk.stem import WordNetLemmatizer

from dotenv import load_dotenv
load_dotenv()
API_KEY = os.getenv("OPENAI_API_KEY")
if not API_KEY:
    sys.exit("Error: OPENAI_API_KEY not found in .env file.")
client = OpenAI(api_key=API_KEY)


def define_words(string):
    query = f'''"{string}"

Define these words. Provide a clear, dictionary-style definition for each one of them. No introductions, explanations, disclaimers, *, _ or formatting other than indentations and structured definitions. Provide one example sentence for each one. Try to be as concise as possible.
'''
    chat_completion = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": query}],
    )
    return chat_completion.choices[0].message.content


def get_wordnet_pos(treebank_tag):
    if treebank_tag.startswith('J'):
        return wn.ADJ
    elif treebank_tag.startswith('V'):
        return wn.VERB
    elif treebank_tag.startswith('N'):
        return wn.NOUN
    elif treebank_tag.startswith('R'):
        return wn.ADV
    else:
        return wn.NOUN


def clean_word(word):
    word = word.lower()
    word = re.sub(r"^[^\w]+|[^\w]+$", "", word)
    tokens = word.split()
    lemmatizer = WordNetLemmatizer()
    tagged_tokens = pos_tag(tokens)
    cleaned_tokens = []
    for token, tag in tagged_tokens:
        wn_tag = get_wordnet_pos(tag)
        lemma = lemmatizer.lemmatize(token, pos=wn_tag)
        if token.endswith("ss") and lemma == token[:-1]:
            lemma = token
        cleaned_tokens.append(lemma)
    return " ".join(cleaned_tokens)


def find_obscure_words(input_string, known_words_dir=None):
    if known_words_dir is None:
        known_words_dir = os.path.join(os.path.dirname(__file__), 'word-lists')
    words = input_string.split()
    processed_words = []
    for word in words:
        cleaned = clean_word(word)
        if cleaned:
            processed_words.append(cleaned)
    known_words = set()
    pattern = os.path.join(known_words_dir, '*.txt')
    txt_files = glob.glob(pattern)
    if not txt_files:
        print(f"Error: No .txt files found in directory '{known_words_dir}'.")
        sys.exit(1)
    for filepath in txt_files:
        try:
            with open(filepath, 'r') as f:
                for line in f:
                    word_from_file = line.strip().lower()
                    if word_from_file:
                        known_words.add(word_from_file)
        except Exception as e:
            print(f"Error reading file '{filepath}': {e}")
            sys.exit(1)
    obscure_words = []
    for word in processed_words:
        if word.lower() not in known_words and "'" not in word:
            obscure_words.append(word)
    return obscure_words


def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py 'input string'")
        sys.exit(1)
    input_string = sys.argv[1]
    obscure_words = find_obscure_words(input_string)
    if obscure_words:
        words_list = '[' + ', '.join(f'"{word}"' for word in obscure_words) + ']'
        print(define_words(words_list))
    else:
        print("KNOWN")


if __name__ == '__main__':
    main()