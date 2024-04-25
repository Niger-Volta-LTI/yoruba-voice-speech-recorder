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
$ python3 ./setup.py py2app -A    # py2app uses setup to build an app bundle (.app)
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
This repo is based on a fork of https://github.com/daanzu/speech-training-recorder. 

We have implemented updates, bugfixes, enhancements and new features. The additional development efforts include &rarr;
* Updates and fixes to support latest version of Python3
* Updates and fixes to run on the latest MacOS ARM-based CPUs (Homebrew & `portaudio` entanglements)
* Improvements to the audio playback engine and the fidelity of the audio recording format (eg. 48kHz samplerate)
* New feature, support for per-prompt-file speaker labels
* New feature, support for loading prompt files directly with an open-file dialog window
* New feature, support for scanning prompt files and creating automatic layouts based on the available lines
* Cosmetic updates to the User Interface
* Updates to the latest version of PySide (QT), for building modern GUI applications
* Updates to installation and start scripts, to facilitate easier deployment for non-developers
* Initial scripts for py2app or PyInstaller packaging for distribution on the Mac App Store


## Cite this work

If you found this tool useful, please consider citing
```bibtex
@software{yvspeechrecorder,
  author = {Iroro Orife and Aremu Anuoluwapo and K\d{\'{o}}l\'{a} T\'{u}b\d{\`{o}}s\'{u}n and and David Ifeoluwa Adelani and Tol\'{u}l\d{o}p\d{\'{e}} \'{O}g\'{u}nr\d{\`{e}}m\'{i}},
  title = {Yorùbá Voice Speech Recorder},
  url = {https://github.com/Niger-Volta-LTI/yoruba-voice-speech-recorder},
  version = {v0.1-alpha},
  date = {2022-08-31},
  year = {2022},
}
```
