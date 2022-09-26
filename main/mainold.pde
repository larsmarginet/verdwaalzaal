// import processing.video.*;
// import processing.sound.*;
// import spout.*;

// Spout spout;

// // video
// Movie myVideo;
// PImage img;
// float duration;

// Int 

// // particles 
// int maxParticles = 50000;
// int noiseAmount = 800;
// Particle[] particles = new Particle[maxParticles];

// // music
// SoundFile one, two, three, four, five, six, seven, eight, nine, ten;
// Amplitude one_amp, two_amp, three_amp, four_amp, five_amp, six_amp, seven_amp, eight_amp, nine_amp, ten_amp;

// // emotions
// float input;
// int input_delta = 1, input_theta = 1, input_low_alpha = 1, input_high_alpha = 1, input_low_beta = 1, input_high_beta = 1, input_low_gamma = 1, input_mid_gamma = 1;
// float emotion_val;
// float emotionAverage = 2;
// float[] emotionValues;
// float peek = 0;

// void setup() {
//   size(5760, 1080, P2D);
//   frameRate(24);
//   background(0);

//   // video
//   myVideo = new Movie(this, "final.mp4");
//   myVideo.play();
//   duration = myVideo.duration();

//   // particles
//   for (int i = 0; i < maxParticles; i++) {
//     particles[i] = new Particle(random(0, width), random(0, height));
//   }

//   // music
//   one = new SoundFile(this, "data/01.wav");
//   two = new SoundFile(this, "data/02.wav");
//   three = new SoundFile(this, "data/03.wav");
//   four = new SoundFile(this, "data/04.wav");
//   five = new SoundFile(this, "data/05.wav");
//   six = new SoundFile(this, "data/06.wav");
//   seven = new SoundFile(this, "data/07.wav");
//   eight = new SoundFile(this, "data/08.wav");
//   nine = new SoundFile(this, "data/10.wav");

//   one_amp = new Amplitude(one, .1, .005);
//   two_amp = new Amplitude(two, .5, .005);
//   three_amp = new Amplitude(three, .8, .005);
//   four_amp = new Amplitude(four, 1.1, .005);
//   five_amp = new Amplitude(five, 1.4, .005);
//   six_amp = new Amplitude(six, 1.7, .005);
//   seven_amp = new Amplitude(seven, 2, .005);
//   eight_amp = new Amplitude(eight, 2.3, .005);
//   nine_amp = new Amplitude(nine, 2.6, .005);

//   emotionValues = new float[10];

//   // spout
//   // ENABLE: spout = new Spout(this);
//   // ENABLE: spout.createSender("sketch");
// }

// void mousePressed() {
//   myVideo.jump(0);
// }

// void draw() {
//   if (myVideo.time() > duration - 10 && emotionAverage > .1) {
//     emotionAverage -= .1;
//   }
  
//   one_amp.update();
//   two_amp.update();
//   three_amp.update();
//   four_amp.update();
//   five_amp.update();
//   six_amp.update();
//   seven_amp.update();
//   eight_amp.update();
//   nine_amp.update();
  
//   if (myVideo.available()) {
//     myVideo.read();
//     myVideo.loadPixels();
   
//     tint(255, 0);
   
//     image(myVideo, 0, 0);
//     img = myVideo.get();
   
//     if (img != null) {
//       noStroke();
//       smooth();
     
//       for (int i = 0; i < maxParticles; i++) {
//         float radius = map(emotionAverage, 0, 5, 3, 2);
//         float angleFactor = map(emotionAverage, 0, 5, TWO_PI, PI);
//         float iterations = map(i, 0, maxParticles, 5, 1);
//         particles[i].update(noiseAmount, angleFactor, iterations, emotionAverage);
//         particles[i].display(radius, img, 1);
//         particles[i].edge();
//       }
//     }
//   }

//   // ENABLE: spout.sendTexture();

//   if (peek >= .05) {
//     peek -= .05;
//   }
// }

// int count = 0;
// float sum = 0;

// void AddNewValue(float val) {
//   if(count < emotionValues.length) {
//     emotionValues[count++] = val;
//     sum += val; 
//   } else {
//     sum += val; 
//     sum -= emotionValues[0];
    
//     for (int i = 0; i < emotionValues.length-1; i++) {
//       emotionValues[i] = emotionValues[i+1] ;
//     }
    
//     emotionValues[emotionValues.length-1] = val;
//   }
// }

// public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
//   input_delta = delta;
//   input_theta = theta;
//   input_low_alpha = low_alpha;
//   input_high_alpha = high_alpha;
//   input_low_beta = low_beta;
//   input_high_beta = high_beta;
//   input_low_gamma = low_gamma;
//   input_mid_gamma = mid_gamma;
  
//   if (myVideo.time() < duration - 5) {
//     emotion_val = 0.574 - (1.951 * norm(log(float(input_high_beta)), 6, 15)) - (1.092 *  norm(log(float(input_high_beta)), 6, 15)) + (1.944 * norm(log(float(input_high_alpha)), 6, 15)) + (2.511 * norm(log(float(input_low_beta)), 6, 15)) + (1.513 * norm(log(float(input_theta)), 6, 15));
//     AddNewValue(emotion_val);
//     emotionAverage = sum / count;
   
//     if (emotion_val > emotionAverage + .5) {
//       peek = emotion_val - emotionAverage;
//     } 
//   }
// }

// void stop() {
//   super.stop();
// }
