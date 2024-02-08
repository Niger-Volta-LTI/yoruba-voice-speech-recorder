# Yorùbá Voice Speech Recorder

App for recording speech utterances dictated from text prompts. Speaker name, audio-recording path & prompt text are saved to a metadata file. Use it for building speech recognition and speech synthesis corpora for training and evaluation.


##  Developer setup
 *  **Prerequisites**: `git`, `python3` & `brew`
 * `git clone` this repo, `cd` into the repo directory
 * run installation script: `$ ./scripts/install.sh`
 * start app: `$ ./scripts/start.sh`

### Caveats
`pyAudio`, the audio library used for recording audio, requires [portaudio](http://www.portaudio.com/) to be installed on the system.
The easiest way is with [brew](https://brew.sh/)
```
brew install portaudio
```
`portaudio` library may be installed in a custom location depending on your package manager `brew` or `macports`, or depending on your computer's hardware
`arm64` vs Intel `x86`. In all cases, we must specify the location of headers and libraries, with `CPPFLAGS` & `LDFLAGS`. 
This is already done within the `./install.sh` script, but may need to be modified based on the above :point_up:

For reference on
 - **[M1 Macs](https://en.wikipedia.org/wiki/Apple_M1)**: `CPPFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" pip3 install -e .`
 - **Older Intel Macs**: `CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" pip3 install -e .`
 - **Macports**: `CPPFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" pip3 install -e .`


## Developer py2app setup
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

## License
Distributed under the AGPL-3.0 license. See the LICENSE text file for more information.

## Acknowledgements
This repo is based on a fork of https://github.com/daanzu/speech-training-recorder. Our bugfixes, enhancements and additional development efforts include &rarr;
* Improvements to the audio playback engine and the fidelity of the audio recording format
* New support for per-prompt-file speaker labels
* New support for loading prompt files directly with an open-file dialog window
* New support for scanning prompt files and creating an automatic layouts based on the available lines
* Cosmetic updates to the User Interface
* Updates to the latest version of PySide (QT)
* Updates to installation and start scripts, to ensure the app can also run on Apple M1 (ARM) computers
* Scripts for packaging with py2app or PyInstaller
