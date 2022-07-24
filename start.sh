#!/bin/bash

# setup dirs
mkdir -p ~/Desktop/audio-data

python3 -m yoruba_voice_speech_recorder -p src/yoruba_voice_speech_recorder/prompts/timit.txt -d ~/Desktop/audio-data
