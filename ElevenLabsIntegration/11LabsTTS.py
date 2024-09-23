# Import necessary libraries
import requests  # Used for making HTTP requests
import json  # Used for working with JSON data
from pathlib import Path
import sys

# Gets input text
# Check if the correct number of arguments is passed
if len(sys.argv) != 2:
    print("sys.argv length is " + str(len(sys.argv)) + " It should be 2\nUsage: python filename.py <input_value>\nsys.argv: " + str(sys.argv))
    sys.exit(1)

# Get the input from the command line
input_value = sys.argv[1]
print("Input value is: " + input_value)

# Gets path to secrets .json in order to get the Elevenlabs API key
# Get the directory where the script is located
current_dir = Path(__file__).parent

# Move up one level to project folder and then go to config/secrets.json
json_file_path = current_dir.parent / 'config' / 'secrets.json'

# Open and read the JSON file
with json_file_path.open('r') as json_file:
    config_data = json.load(json_file)

# Access the API key
api_key = config_data.get('apiKey')

# Define constants for the script
CHUNK_SIZE = 1024  # Size of chunks to read/write at a time
XI_API_KEY = api_key  # Your API key for authentication
VOICE_ID = "XB0fDUnXU5powFXDhCwa"  # ID of the voice model to use
TEXT_TO_SPEAK = input_value  # Text you want to convert to speech
OUTPUT_PATH = "TTSMerge/TTS.wav"  # Path to save the output audio file

# Construct the URL for the Text-to-Speech API request
tts_url = f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}/stream"

# Set up headers for the API request, including the API key for authentication
headers = {
    "Accept": "application/json",
    "xi-api-key": XI_API_KEY
}

# Set up the data payload for the API request, including the text and voice settings
data = {
    "text": TEXT_TO_SPEAK,
    "model_id": "eleven_multilingual_v2",
    "voice_settings": {
        "stability": 0.5,
        "similarity_boost": 0.8,
        "style": 0.0,
        "use_speaker_boost": True
    }
}

# Make the POST request to the TTS API with headers and data, enabling streaming response
response = requests.post(tts_url, headers=headers, json=data, stream=True)

# Check if the request was successful
if response.ok:
    # Open the output file in write-binary mode
    with open(OUTPUT_PATH, "wb") as f:
        # Read the response in chunks and write to the file
        for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
            f.write(chunk)
    # Inform the user of success
    print("Eleven Labs Audio stream saved successfully.")
else:
    # Print the error message if the request was not successful
    print("Error message: " + response.text)
