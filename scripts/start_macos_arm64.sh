#!/bin/bash

# setup dirs
mkdir -p ~/Desktop/audio-data

# launch app with specific homebrew environment
env DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH" python3 -m yoruba_voice_speech_recorder
