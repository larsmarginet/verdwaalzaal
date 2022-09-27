import processing.video.*;
import processing.sound.*;
import spout.*;

Spout spout;

// video
Movie activeVideo;
PImage img;
float duration;

// particles 
int maxParticles = 50000;
int noiseAmount = 800;
Particle[] particles = new Particle[maxParticles];

Poem[] poems = new Poem[6];
int activePoemIndex = 0;

// emotions
float input;
int input_delta = 1, input_theta = 1, input_low_alpha = 1, input_high_alpha = 1, input_low_beta = 1, input_high_beta = 1, input_low_gamma = 1, input_mid_gamma = 1;
float emotion_val;
float emotionAverage = 0.1;
float[] emotionValues;
float peek = 0;

void setup() {
  size(1920, 1080, P2D);
  frameRate(24);
  background(0);
  
  // set poems
  Amplitude[] amps1 = { 
    new Amplitude(new SoundFile(this, "data/audio/1/1.wav"), .1, .005, 0), 
    new Amplitude(new SoundFile(this, "data/audio/1/2.wav"), .5, .005, 0),
    new Amplitude(new SoundFile(this, "data/audio/1/3.wav"), .8, .005, 0),
    new Amplitude(new SoundFile(this, "data/audio/1/4.wav"), 1.1, .005, 0),
    new Amplitude(new SoundFile(this, "data/audio/1/5.wav"), 1.4, .005, 0),
    new Amplitude(new SoundFile(this, "data/audio/1/6.wav"), 1.7, .005, 0),
    new Amplitude(new SoundFile(this, "data/audio/1/7.wav"), 2.0, .005, 0),
  };
  
  Amplitude[] amps2 = { 
    new Amplitude(new SoundFile(this, "data/audio/2/1.wav"), .1, .005, 1), 
    new Amplitude(new SoundFile(this, "data/audio/2/2.wav"), .5, .005, 1),
    new Amplitude(new SoundFile(this, "data/audio/2/3.wav"), .8, .005, 1),
    new Amplitude(new SoundFile(this, "data/audio/2/4.wav"), 1.1, .005, 1),
    new Amplitude(new SoundFile(this, "data/audio/2/5.wav"), 1.4, .005, 1),
    new Amplitude(new SoundFile(this, "data/audio/2/6.wav"), 1.7, .005, 1),
    new Amplitude(new SoundFile(this, "data/audio/2/7.wav"), 2.0, .005, 1),
  };
  
  Amplitude[] amps3 = { 
    new Amplitude(new SoundFile(this, "data/audio/3/1.wav"), .1, .005, 2), 
    new Amplitude(new SoundFile(this, "data/audio/3/2.wav"), .5, .005, 2),
    new Amplitude(new SoundFile(this, "data/audio/3/3.wav"), .8, .005, 2),
    new Amplitude(new SoundFile(this, "data/audio/3/4.wav"), 1.1, .005, 2),
    new Amplitude(new SoundFile(this, "data/audio/3/5.wav"), 1.4, .005, 2),
    new Amplitude(new SoundFile(this, "data/audio/3/6.wav"), 1.7, .005, 2),
    new Amplitude(new SoundFile(this, "data/audio/3/7.wav"), 2.0, .005, 2),
  };
  
  Amplitude[] amps4 = { 
    new Amplitude(new SoundFile(this, "data/audio/4/1.wav"), .1, .005, 3), 
    new Amplitude(new SoundFile(this, "data/audio/4/2.wav"), .5, .005, 3),
    new Amplitude(new SoundFile(this, "data/audio/4/3.wav"), .8, .005, 3),
    new Amplitude(new SoundFile(this, "data/audio/4/4.wav"), 1.1, .005, 3),
    new Amplitude(new SoundFile(this, "data/audio/4/5.wav"), 1.4, .005, 3),
    new Amplitude(new SoundFile(this, "data/audio/4/6.wav"), 1.7, .005, 3),
    new Amplitude(new SoundFile(this, "data/audio/4/7.wav"), 2.0, .005, 3),
  };
  
  Amplitude[] amps5 = { 
    new Amplitude(new SoundFile(this, "data/audio/5/1.wav"), .1, .005, 4), 
    new Amplitude(new SoundFile(this, "data/audio/5/2.wav"), .5, .005, 4),
    new Amplitude(new SoundFile(this, "data/audio/5/3.wav"), .8, .005, 4),
    new Amplitude(new SoundFile(this, "data/audio/5/4.wav"), 1.1, .005, 4),
    new Amplitude(new SoundFile(this, "data/audio/5/5.wav"), 1.4, .005, 4),
    new Amplitude(new SoundFile(this, "data/audio/5/6.wav"), 1.7, .005, 4),
    new Amplitude(new SoundFile(this, "data/audio/5/7.wav"), 2.0, .005, 4),
  };
  
  Amplitude[] amps6 = { 
    new Amplitude(new SoundFile(this, "data/audio/6/1.wav"), .1, .005, 5), 
    new Amplitude(new SoundFile(this, "data/audio/6/2.wav"), .5, .005, 5),
    new Amplitude(new SoundFile(this, "data/audio/6/3.wav"), .8, .005, 5),
    new Amplitude(new SoundFile(this, "data/audio/6/4.wav"), 1.1, .005, 5),
    new Amplitude(new SoundFile(this, "data/audio/6/5.wav"), 1.4, .005, 5),
    new Amplitude(new SoundFile(this, "data/audio/6/6.wav"), 1.7, .005, 5),
    new Amplitude(new SoundFile(this, "data/audio/6/7.wav"), 2.0, .005, 5),
  };

  poems[0] = new Poem(this, "video/1.mp4", amps1);
  poems[1] = new Poem(this, "video/2.mp4", amps2);
  poems[2] = new Poem(this, "video/3.mp4", amps3);
  poems[3] = new Poem(this, "video/4.mp4", amps4);
  poems[4] = new Poem(this, "video/5.mp4", amps5);
  poems[5] = new Poem(this, "video/6.mp4", amps6);
  
  
  initActiveVideo();
  initParticles();
 
  // TODO: analyse audio input
  emotionValues = new float[10];

  // spout
  // ENABLE: spout = new Spout(this);
  // ENABLE: spout.createSender("sketch");
}

void initActiveVideo() {
  if (activeVideo != null) {
    activeVideo.stop();
  }

  activeVideo = poems[activePoemIndex].video;
  activeVideo.jump(0);
  activeVideo.play();
  duration = activeVideo.duration();
} 

void initParticles() {
  for (int i = 0; i < maxParticles; i++) {
    particles[i] = new Particle(random(0, width), random(0, height));
  }
}

int prevIndex = 0;

void incrementActivePoem() {
  if (activePoemIndex < poems.length - 1) {
    activePoemIndex++;
  } else {
    activePoemIndex = 0;
  }

  updateAudioAtIndex(prevIndex);

  initActiveVideo();

  prevIndex = activePoemIndex;
}

void decrementActivePoem() {
  if (activePoemIndex <= 0) {
    activePoemIndex = poems.length -1;
  } else {
    activePoemIndex--;
  }
  
  updateAudioAtIndex(prevIndex);

  initActiveVideo();

  prevIndex = activePoemIndex;
}

void resetSequence() {
  activePoemIndex = 0;
  initActiveVideo();
}

void mousePressed() {
  incrementActivePoem();
}

void keyPressed() {
  switch (keyCode) {
    // R
    case 82:
      resetSequence();
      break;
    // Left
    case 37:
      decrementActivePoem();
      break;
    // Right
    case 39:
      incrementActivePoem();
      break;
  } 
}

void updateAudioAtIndex(int index) {
  for (int i = 0; i < poems[index].tracks.length; i++) {
    poems[index].tracks[i].update();
  }
}

void draw() {
  // video is finished
  if (activeVideo.time() >= duration) {
    incrementActivePoem();
  }

  // fade out audio
  if (activeVideo.time() > duration - 10 && emotionAverage > .1) {
    emotionAverage -= .1;
  } else {
    emotionAverage += .01;
  }

  // update audio amplitude
  updateAudioAtIndex(activePoemIndex);
  
  if (activeVideo.available()) {
    activeVideo.read();
    activeVideo.loadPixels();
   
    tint(255, 0);
   
    image(activeVideo, 0, 0);
    img = activeVideo.get();
   
    if (img != null) {
      noStroke();
      smooth();
     
      for (int i = 0; i < maxParticles; i++) {
        float radius = map(emotionAverage, 0, 5, 3, 2);
        float angleFactor = map(emotionAverage, 0, 5, TWO_PI, PI);
        float iterations = map(i, 0, maxParticles, 5, 1);
        particles[i].update(noiseAmount, angleFactor, iterations, emotionAverage);
        particles[i].display(radius, img, 1);
        particles[i].edge();
      }
    }
  }

  // ENABLE: spout.sendTexture();
}

void stop() {
  super.stop();
}
