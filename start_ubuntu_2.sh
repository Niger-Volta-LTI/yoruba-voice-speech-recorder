#!/usr/bin/env bash
set -e

# Activate virtual environment
source voiceRecorderEnv/bin/activate

# Optional: useful on some Ubuntu/Wayland systems if Qt has display issues
# Uncomment the next line if the app window does not open correctly.
# export QT_QPA_PLATFORM=xcb

# Default prompt file included in this repo
PROMPTS_FILE="src/yoruba_voice_speech_recorder/prompts/yovo_3501.txt"

# Default output directory
SAVE_DIR="$HOME/Desktop/audio-data"

# Number of prompts to use in one session
PROMPTS_COUNT=250

# Create output directory if missing
mkdir -p "$SAVE_DIR"

echo "Starting Yoruba Voice Speech Recorder..."
echo "Prompts file: $PROMPTS_FILE"
echo "Save directory: $SAVE_DIR"
echo "Prompt count: $PROMPTS_COUNT"
echo ""

python -m yoruba_voice_speech_recorder \
  --prompts_filename "$PROMPTS_FILE" \
  --save_dir "$SAVE_DIR" \
  --prompts_count "$PROMPTS_COUNT"
