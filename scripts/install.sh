#!/bin/bash

# setup dirs
mkdir -p ~/Desktop/audio-data


# uninstall previous version
echo "Uninstalling old YoVo Speech Recorder ..."
pip3 uninstall yoruba-voice-speech-recorder


for i in {1..15}
do
   echo " "
done

echo "Installing fresh YoVo Speech Recorder ..."
CPPFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" pip3 install -e .

