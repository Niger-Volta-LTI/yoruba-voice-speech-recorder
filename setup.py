#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup
from setuptools import find_packages


setup(
    name="yoruba_voice_speech_recorder",
    setup_requires="setupmeta",
    license="GNU AGPL",
    author="ruoho.ruotsi@gmail.com",
    description="App for recording speech utterances dictated from text prompts. "
                "Speaker name, audio-recording path & prompt text are saved to a metadata file. "
                "Use it for building speech recognition and speech synthesis corpora for training and evaluation."
                "Improvements & adaptations from https://github.com/daanzu/speech-training-recorder made for "
                "the Yorùbá Voice project",
    packages=find_packages('src'),
    package_dir={'': 'src'},
    include_package_data=True,
    versioning="distance"  # Optional, would activate tag-based versioning
)
