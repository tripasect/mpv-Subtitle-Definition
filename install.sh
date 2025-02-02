#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Step 1: Create a virtual environment if it doesn't exist
if [ -d ".venv" ]; then
    echo "Virtual environment '.venv' already exists."
else
    echo "Creating virtual environment '.venv'..."
    python3 -m venv .venv
    echo "Virtual environment created."
fi

# Step 2: Upgrade pip and install requirements
if [ ! -f "requirements.txt" ]; then
    echo "Error: requirements.txt not found in the current directory."
    exit 1
fi

# Determine the pip path based on OS
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    PIP_PATH="./.venv/Scripts/pip.exe"
    PYTHON_PATH="./.venv/Scripts/python.exe"
else
    PIP_PATH="./.venv/bin/pip"
    PYTHON_PATH="./.venv/bin/python"
fi

echo "Upgrading pip..."
"$PIP_PATH" install --upgrade pip

echo "Installing Python packages from requirements.txt..."
"$PIP_PATH" install -r requirements.txt
echo "Packages installed."

# Step 3: Download NLTK data
echo "Downloading NLTK data..."
"$PYTHON_PATH" -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger'); nltk.download('wordnet')"
echo "NLTK data downloaded."

# Step 4: Create .env file with OpenAI API key if it doesn't exist
if [ -f ".env" ]; then
    echo ".env file already exists."
else
    echo "Creating .env file."
    read -rp "Enter your OpenAI API key: " OPENAI_API_KEY
    if [ -z "$OPENAI_API_KEY" ]; then
        echo "No API key provided. .env file will not be created."
    else
        echo "OPENAI_API_KEY=${OPENAI_API_KEY}" > .env
        echo ".env file created."
    fi
fi

echo -e "\nInstallation complete. Run mpv and try it out!"