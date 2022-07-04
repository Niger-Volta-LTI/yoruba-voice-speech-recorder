import collections, wave, logging, os, datetime
import pyaudio
import webrtcvad
import queue


class Audio(object):
    """
    Streams raw audio from microphone.
    Data is received in a separate thread, and stored in a buffer, to be read from.
    """

    FORMAT = pyaudio.paInt16
    RATE = 48000
    CHANNELS = 1
    BLOCKS_PER_SECOND = 150

    def __init__(self, callback=None, buffer_s=0, flush_queue=True):
        def proxy_callback(in_data, frame_count, time_info, status):
            callback(in_data)
            return (None, pyaudio.paContinue)

        if callback is None: callback = lambda in_data: self.buffer_queue.put(in_data, block=False)
        self.sample_rate = self.RATE
        self.flush_queue = flush_queue
        self.buffer_queue = queue.Queue(maxsize=(buffer_s * 1000 // self.block_duration_ms))
        self.pa = pyaudio.PyAudio()
        self.stream = self.pa.open(format=self.FORMAT,
                                   channels=self.CHANNELS,
                                   rate=self.sample_rate,
                                   input=True,
                                   frames_per_buffer=self.block_size,
                                   stream_callback=proxy_callback)
        self.stream.start_stream()
        self.active = True

    def destroy(self):
        self.stream.stop_stream()
        self.stream.close()
        self.pa.terminate()
        self.active = False

    def read(self):
        """Return a block of audio data, blocking if necessary."""
        if self.active or (self.flush_queue and not self.buffer_queue.empty()):
            return self.buffer_queue.get()
        else:
            return None

    def read_loop(self, callback):
        """Block looping reading, repeatedly passing a block of audio data to callback."""
        for block in iter(self):
            callback(block)

    def __iter__(self):
        """Generator that yields all audio blocks from microphone."""
        while True:
            block = self.read()
            if block is None:
                break
            yield block

    block_size = property(lambda self: int(self.sample_rate / float(self.BLOCKS_PER_SECOND)))
    block_duration_ms = property(lambda self: 1000 * self.block_size // self.sample_rate)

    def write_wav(self, filename, data):
        # logging.info("write wav %s", filename)
        wf = wave.open(filename, 'wb')
        wf.setnchannels(self.CHANNELS)
        # wf.setsampwidth(self.pa.get_sample_size(FORMAT))
        assert self.FORMAT == pyaudio.paInt16
        wf.setsampwidth(2)
        wf.setframerate(self.sample_rate)
        wf.writeframes(data)
        wf.close()


class VADAudio(Audio):
    """Filter & segment audio with voice activity detection."""

    def __init__(self, aggressiveness=3):
        super(VADAudio, self).__init__()
        self.vad = webrtcvad.Vad(aggressiveness)

    def vad_collector(self, padding_ms=300, ratio=0.75, blocks=None):
        """Generator that yields series of consecutive audio blocks comprising each utterence, separated by yielding a single None.
            Determines voice activity by ratio of blocks in padding_ms. Uses a buffer to include padding_ms prior to being triggered.
            Example: (block, ..., block, None, block, ..., block, None, ...)
                      |---utterence---|        |---utterence---|
        """
        if blocks is None: blocks = iter(self)
        num_padding_blocks = padding_ms // self.block_duration_ms
        ring_buffer = collections.deque(maxlen=num_padding_blocks)
        triggered = False

        for block in blocks:
            is_speech = self.vad.is_speech(block, self.sample_rate)

            if not triggered:
                ring_buffer.append((block, is_speech))
                num_voiced = len([f for f, speech in ring_buffer if speech])
                if num_voiced > ratio * ring_buffer.maxlen:
                    triggered = True
                    for f, s in ring_buffer:
                        yield f
                    ring_buffer.clear()

            else:
                yield block
                ring_buffer.append((block, is_speech))
                num_unvoiced = len([f for f, speech in ring_buffer if not speech])
                if num_unvoiced > ratio * ring_buffer.maxlen:
                    triggered = False
                    yield None
                    ring_buffer.clear()


class AudioStore(object):
    """Stores last `maxlen` recognitions as tuples (audio, text, grammar_name, rule_name), indexed in reverse order (0 most recent)"""

    def __init__(self, audio_obj, maxlen=0, save_dir=None, auto_save_func=None):
        self.audio_obj = audio_obj
        self.maxlen = maxlen
        self.save_dir = save_dir
        # if self.save_dir and not os.path.exists(self.save_dir): os.makedirs(self.save_dir)
        self.auto_save_func = auto_save_func
        self.deque = collections.deque(maxlen=maxlen)
        self.blocks = []

    def add_block(self, block):
        if self.maxlen != 0:
            self.blocks.append(block)

    def finalize(self, text, grammar_name, rule_name):
        if self.maxlen != 0:
            audio = ''.join(self.blocks)
            self.deque.appendleft((audio, text, grammar_name, rule_name))
            self.blocks = []
            if self.auto_save_func and self.auto_save_func(*self.deque[0]): self.save(0)

    def save(self, index):
        if self.save_dir:
            filename = os.path.join(self.save_dir, "retain_" + datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S_%f") + ".wav")
            audio, text, grammar_name, rule_name = self.deque[index]
            self.audio_obj.write_wav(filename, audio)
            with open(os.path.join(self.save_dir, "retain.csv"), "a") as csvfile:
                csvfile.write(','.join([filename, '0', grammar_name, rule_name, text]) + '\n')

    def __getitem__(self, key):
        return self.deque[key]
    def __len__(self):
        return len(self.deque)
    def __bool__(self):
        return True
    def __nonzero__(self):
        return True
