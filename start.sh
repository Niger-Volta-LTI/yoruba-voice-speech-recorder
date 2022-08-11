#!/bin/bash

# setup dirs
mkdir -p ~/Desktop/audio-data

env DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH" python3 -m yoruba_voice_speech_recorder -p src/yoruba_voice_speech_recorder/prompts/yovo_3001.txt -d ~/Desktop/audio-data --ordered --prompts_count 500
