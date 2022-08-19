#!/bin/bash

# setup dirs
mkdir -p ~/Desktop/audio-data


# uninstall previous version
echo "Uninstalling old YoVo Speech Recorder ..."
yes | pip3 uninstall yoruba-voice-speech-recorder 2>/dev/null


for i in {1..3}
do
   sleep 1
   echo "."
done

echo "Installing fresh YoVo Speech Recorder ..."
CPPFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" pip3 install -e . 2>/dev/null

