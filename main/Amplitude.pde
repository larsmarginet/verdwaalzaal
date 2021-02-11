class Amplitude {
    float fspeed = 0.005;
    SoundFile instrument;
    float threshold;
    float amplitude;

    Amplitude(SoundFile i, float t, float a) {
        instrument = i;
        instrument.loop();
        threshold = t;
        amplitude = a; 
    }

    void update() {
        if (emotionAverage >= threshold) {
            if (amplitude < .400) amplitude += fspeed;
        } else if (emotionAverage < threshold) {
            if (amplitude > .005) amplitude -= fspeed;
        }
        instrument.amp(amplitude);
    }
}
