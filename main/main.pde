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

Poem[] poems = new Poem[5];
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
    new Amplitude(new SoundFile(this, "data/01.wav"), .1, .005), 
    new Amplitude(new SoundFile(this, "data/02.wav"), .5, .005),
    new Amplitude(new SoundFile(this, "data/03.wav"), .8, .005),
    new Amplitude(new SoundFile(this, "data/04.wav"), 1.1, .005),
    new Amplitude(new SoundFile(this, "data/05.wav"), 1.4, .005),
    new Amplitude(new SoundFile(this, "data/06.wav"), 1.7, .005),
  };
  
  Amplitude[] amps2 = { 
    new Amplitude(new SoundFile(this, "data/01.wav"), .1, .005), 
    new Amplitude(new SoundFile(this, "data/02.wav"), .5, .005),
    new Amplitude(new SoundFile(this, "data/03.wav"), .8, .005),
    new Amplitude(new SoundFile(this, "data/04.wav"), 1.1, .005),
    new Amplitude(new SoundFile(this, "data/05.wav"), 1.4, .005),
    new Amplitude(new SoundFile(this, "data/06.wav"), 1.7, .005),
  };
  
  Amplitude[] amps3 = { 
    new Amplitude(new SoundFile(this, "data/01.wav"), .1, .005), 
    new Amplitude(new SoundFile(this, "data/02.wav"), .5, .005),
    new Amplitude(new SoundFile(this, "data/03.wav"), .8, .005),
    new Amplitude(new SoundFile(this, "data/04.wav"), 1.1, .005),
    new Amplitude(new SoundFile(this, "data/05.wav"), 1.4, .005),
    new Amplitude(new SoundFile(this, "data/06.wav"), 1.7, .005),
  };
  
  Amplitude[] amps4 = { 
    new Amplitude(new SoundFile(this, "data/01.wav"), .1, .005), 
    new Amplitude(new SoundFile(this, "data/02.wav"), .5, .005),
    new Amplitude(new SoundFile(this, "data/03.wav"), .8, .005),
    new Amplitude(new SoundFile(this, "data/04.wav"), 1.1, .005),
    new Amplitude(new SoundFile(this, "data/05.wav"), 1.4, .005),
    new Amplitude(new SoundFile(this, "data/06.wav"), 1.7, .005),
  };
  
  Amplitude[] amps5 = { 
    new Amplitude(new SoundFile(this, "data/01.wav"), .1, .005), 
    new Amplitude(new SoundFile(this, "data/02.wav"), .5, .005),
    new Amplitude(new SoundFile(this, "data/03.wav"), .8, .005),
    new Amplitude(new SoundFile(this, "data/04.wav"), 1.1, .005),
    new Amplitude(new SoundFile(this, "data/05.wav"), 1.4, .005),
    new Amplitude(new SoundFile(this, "data/06.wav"), 1.7, .005),
  };

  poems[0] = new Poem(this, "video.mp4", amps1);
  poems[1] = new Poem(this, "video-s.mp4", amps2);
  poems[2] = new Poem(this, "final.mp4", amps3);
  poems[3] = new Poem(this, "video.mp4", amps4);
  poems[4] = new Poem(this, "final.mp4", amps5);
  
  
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

void incrementActivePoem() {
  if (activePoemIndex < poems.length - 1) {
    activePoemIndex++;
  } else {
    activePoemIndex = 0;
  }
  
  initActiveVideo();
}

void decrementActivePoem() {
  if (activePoemIndex <= 0) {
    activePoemIndex = poems.length -1;
  } else {
    activePoemIndex--;
  }
  
  initActiveVideo();
}

void resetSequence() {
  activePoemIndex = 0;
  initActiveVideo();
}

void mousePressed() {
  incrementActivePoem();
}

void keyPressed() {
  print(keyCode);
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
  for (int i = 0; i < poems[activePoemIndex].tracks.length; i++) {
    poems[activePoemIndex].tracks[i].update();
  }
  
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
