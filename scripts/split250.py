#!/usr/bin/env python3

start_line = 5001
lines_per_file = 250
smallfile = None

big_file_path = "/Users/iorife/github/yoruba-voice-speech-recorder/src/yoruba_voice_speech_recorder/prompts/yovo_5001-25000.txt"


if __name__ == '__main__':
    
    with open(big_file_path) as bigfile:
        for lineno, line in enumerate(bigfile):
            if lineno % lines_per_file == 0:
                if smallfile:
                    smallfile.close()
                    
                small_filename = 'yovo_{}_{}.txt'.format(start_line + lineno, start_line + lineno + lines_per_file - 1)
                smallfile = open(small_filename, "w")
            smallfile.write(line)
        if smallfile:
            smallfile.close()

