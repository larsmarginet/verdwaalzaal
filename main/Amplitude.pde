class Amplitude {
    float fspeed = .005;
    SoundFile instrument;
    float threshold;
    float amplitude;
    int index;
    FFT fft;

    Amplitude(SoundFile f, float t, float a, int i) {
        instrument = f;
        instrument.loop();
        instrument.amp(.005);
        threshold = t;
        amplitude = a; 
        index = i;
    }

    void update() {     
        if (index != activePoemIndex) {
            print("bingo!");
            instrument.amp(.005);

            return;
        }

        if (emotionAverage >= threshold) {
            if (amplitude < .500) amplitude += fspeed;
        } else if (emotionAverage < threshold) {
            if (amplitude > .005) amplitude -= fspeed;
        }
       
        instrument.amp(amplitude);
    }
}
