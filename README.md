# Yorùbá Voice Speech Recorder

App for recording speech utterances dictated from text prompts. Speaker name, audio-recording path & prompt text are saved to a metadata file. Use it for building speech recognition and speech synthesis corpora for training and evaluation.


##  setup.py (pip) workflow
 * Install with `pip3`
 * Invoke `yoruba_voice_speech_recorder` with `python3`
 * Optionally, uninstall with `pip3`

```
$ CPPFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" pip3 install -e .
$ python3 -m yoruba_voice_speech_recorder -p src/yoruba_voice_speech_recorder/prompts/timit.txt -d ~/Desktop/audio-data
$ pip3 uninstall yoruba-voice-speech-recorder
```

### Caveats and context
Since `pyAudio` has `portAudio` as a dependency, one must first install `portaudio`. The easiest way is with
```
brew install portaudio
```
however if the `portaudio` library is installed in a custom location (manually or via `macports`) then to specify the 
location of headers and libraries, this is why we use `CPPFLAGS` & `LDFLAGS` above with `pip` to point to `/opt/local`

Similarly, either of these should work for `setup.py` based development
```
CPPFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" python3 ./setup.py
python3 setup.py build_ext --include-dirs=/opt/local/include --library-dirs=/opt/local/lib --libraries=mylib
```


## py2app workflow

```
$ cp setup.py2app setup.py      # switch to a py2app setup
$ python3 setup.py py2app -A    # py2app uses setup to build an app bundle (.app)
$ ./dist/Yorùbá\ Voice\ Speech\ Recorder.app/Contents/MacOS/Yorùbá\ Voice\ Speech\ Recorder  
     -p ~/github/yoruba-voice-speech-recorder/src/yoruba_voice_speech_recorder/prompts/timit.txt 
     -d ~/Desktop/audio-data
```

## Other packaging solutions
 * [PyOxidizer](https://pyoxidizer.readthedocs.io/en/stable/index.html)
 * [Nuitka](https://doc.qt.io/qtforpython/deployment-nuitka.html)
 * others like [Typer](https://typer.tiangolo.com), [cx_freeze](https://cx-freeze.readthedocs.io/en/latest/) & [shiv](https://shiv.readthedocs.io/en/latest). 