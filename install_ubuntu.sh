#!/usr/bin/env bash
set -e

echo "=========================================="
echo " Ubuntu installer for Yoruba Voice Recorder"
echo "=========================================="

echo ""
echo "[1/7] Installing Ubuntu system dependencies..."
sudo apt update
sudo apt install -y \
  python3 \
  python3-venv \
  python3-dev \
  build-essential \
  portaudio19-dev \
  libportaudio2 \
  libportaudiocpp0 \
  libasound2-dev \
  libsndfile1 \
  alsa-utils \
  libxcb-xinerama0 \
  libxcb-cursor0 \
  libxkbcommon-x11-0 \
  libegl1 \
  libgl1

echo ""
echo "[2/7] Creating virtual environment if missing..."
if [ ! -d "voiceRecorderEnv" ]; then
  python3 -m venv voiceRecorderEnv
else
  echo "voiceRecorderEnv already exists. Reusing it."
fi

echo ""
echo "[3/7] Activating virtual environment..."
source ./voiceRecorderEnv/bin/activate

echo ""
echo "[4/7] Upgrading pip, wheel..."
python -m pip install --upgrade pip wheel

echo ""
echo "[5/7] Installing setuptools<81 for webrtcvad/pkg_resources compatibility..."
python -m pip install --force-reinstall "setuptools<81"

echo ""
echo "[6/7] Installing project requirements..."
python -m pip install -r requirements.txt

echo ""
echo "[7/7] Installing Yoruba Voice Recorder in editable mode..."
python -m pip install -e .

echo ""
echo "Creating default audio output directory..."
mkdir -p "$HOME/Desktop/audio-data"

echo ""
echo "Testing pkg_resources availability..."
python -c "import pkg_resources; print('pkg_resources is working')"

echo ""
echo "Testing application help command..."
python -m yoruba_voice_speech_recorder --help

echo ""
echo "=========================================="
echo " Installation complete."
echo "=========================================="
echo ""
echo "To start the app, run:"
echo ""
echo "  ./start_ubuntu.sh"
echo ""
