# Yorùbá Voice Speech Recorder

App for recording speech utterances dictated from text prompts. Speaker name, audio-recording path & prompt text are saved to a metadata file. Use it for building speech recognition and speech synthesis corpora for training and evaluation.


##  Developer setup using setup.py (pip) workflow
 * `git clon` repo and `cd` into repo directory
 * run installation script `./scripts/install.sh`
 * start app with `./scripts/start.sh`

### Caveats
`pyAudio`, the audio library used for recording audio, requires [portaudio](http://www.portaudio.com/) to be installed on the system.
The easiest way is with [brew](https://brew.sh/)
```
brew install portaudio
```
Because `portaudio` library may be installed in a custom location (manually, via `macports` or on Apple `arm64` systems), we 
must specify the location of headers and libraries, with `CPPFLAGS` & `LDFLAGS`. This is done within the `./install.sh` script. 

For reference brew installs `portaudio` in the following locations:
```
brew on ARM64 (Apple M1): CPPFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" pip3 install -e .
brew on Intel x86 (Older Macs): CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" pip3 install -e .
macports: CPPFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" pip3 install -e .
```


## py2app workflow
```
$ python3 ./scripts/setup.py py2app -A    # py2app uses setup to build an app bundle (.app)
$ ./dist/Yorùbá\ Voice\ Speech\ Recorder.app/Contents/MacOS/Yorùbá\ Voice\ Speech\ Recorder  
     -p ~/github/yoruba-voice-speech-recorder/src/yoruba_voice_speech_recorder/prompts/timit.txt 
     -d ~/Desktop/audio-data
```

## Other packaging solutions
 * [PyOxidizer](https://pyoxidizer.readthedocs.io/en/stable/index.html)
 * [Nuitka](https://doc.qt.io/qtforpython/deployment-nuitka.html)
 * others like [Typer](https://typer.tiangolo.com), [cx_freeze](https://cx-freeze.readthedocs.io/en/latest/) & [shiv](https://shiv.readthedocs.io/en/latest). 