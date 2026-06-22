#!/usr/bin/env bash
set -e

source voiceRecorderEnv/bin/activate

mkdir -p ~/Desktop/audio-data

python -m yoruba_voice_speech_recorder \
  -p src/yoruba_voice_speech_recorder/prompts/yovo_3501.txt \
  -d ~/Desktop/audio-data
