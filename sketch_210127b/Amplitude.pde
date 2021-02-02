class Amplitude {
    float fspeed = 0.005;
    SoundFile instrument;
    int threshold;
    float amplitude;

    Amplitude(SoundFile i, int t, float a) {
        instrument = i;
        instrument.loop();
        threshold = t;
        amplitude = a; 
    }

    void update() {
        // reverse input! 
        float value = map(input, 0, 255, 255, 0);
        if (value >= threshold) {
            if (amplitude < .995) amplitude += fspeed;
        } else if (value < threshold) {
            if (amplitude > .005) amplitude -= fspeed;
        }
        instrument.amp(amplitude);
    }
}