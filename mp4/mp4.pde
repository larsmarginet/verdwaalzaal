import processing.video.*;
import processing.sound.*;
//import spout.*;
//import neurosky.*;
//import org.json.*;

//Spout spout;
//ThinkGearSocket neuroSocket;

// video
Movie myVideo;
PImage img;
// PImage[] animation;
int nFrames = 1000; // change this to video.length --> #frames
int frame = 0;

// particles 
int maxParticles = 10000;
int noiseAmount = 800;
Particle[] particles = new Particle[maxParticles];

// music
//SoundFile bas, cello, viool1, viool2, viool3, viool4, koor, harp;
//Amplitude cello_amp, viool1_amp, viool2_amp, viool3_amp, viool4_amp, koor_amp, harp_amp;

// emotions
float input;
int input_delta = 1, input_theta = 1, input_low_alpha = 1, input_high_alpha = 1, input_low_beta = 1, input_high_beta = 1, input_low_gamma = 1, input_mid_gamma = 1;
float emotion_val;
float emotionAverage = 1;
float[] emotionValues;

void setup(){
  size(640, 360, P2D);
  frameRate(24);
  background(0);
  
  // video
  myVideo = new Movie(this, "video.mp4");
  myVideo.play();
  myVideo.volume(0);
  println("created video" + millis());
  // animation = new PImage[nFrames];
  
  // particles
  for(int i = 0; i < maxParticles; i++){
    particles[i] = new Particle(random(0, width), random(0,height));
  }
   println("created particles" + millis());
  
  // music
  //bas = new SoundFile(this, "data/bass2.wav");
  //println("created bas " + millis());
  //cello = new SoundFile(this, "data/cello2.wav");
  //println("created cello " + millis());
  //viool1 = new SoundFile(this, "data/violin.wav");
  //println("created viool1" + millis());
  //viool2 = new SoundFile(this, "data/sensation.wav");
  //println("created viool2" + millis());
  //viool3 = new SoundFile(this, "data/sentient.wav");
  //println("created viool3" + millis());
  //viool4 = new SoundFile(this, "data/viool4.wav");
  //println("created viool4" + millis());
  //koor = new SoundFile(this, "data/koor.wav");
  //println("created koor" + millis());
  //harp = new SoundFile(this, "data/harp.wav");
  //println("created harp" + millis());
 
  //bas.loop();
  //println("bass loop " + millis());
  //cello_amp = new Amplitude(cello, .5, .005);
  //println("cello_amp loop " + millis());
  //viool1_amp = new Amplitude(viool1, 1, .005);
  //viool2_amp = new Amplitude(viool2, 1.5, .005);
  //viool3_amp = new Amplitude(viool3, 2, .005);
  //viool4_amp = new Amplitude(viool4, 2.5, .005);
  //koor_amp = new Amplitude(koor, 3, .005);
  //harp_amp = new Amplitude(harp, 3.5, .005);
  
  // emotions
  //ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  //try {
  //  neuroSocket.start();
  //} catch (Exception e) {
  //  println(e);
  //}
  // println("nerosku " + millis());
  //emotionValues = new float[10];
  
  //spout = new Spout(this);
  //spout.createSender("sketch");
}

void mousePressed() {
  myVideo.jump(0);
}

void draw() {
  println(frameRate);
  //cello_amp.update();
  //viool1_amp.update();
  //viool2_amp.update();
  //viool3_amp.update();
  //viool4_amp.update();
  // koor_amp.update();
  // harp_amp.update();
  if(myVideo.available()) {
    myVideo.read();
    myVideo.loadPixels();
    // animation[frame] = myVideo.get();
    tint(255, 0);
    image(myVideo, 0, 0);
    img = myVideo.get();
    if(img != null) {
      noStroke();
      smooth();
      for (int i = 0; i < maxParticles; i++) {
        float radius = map(emotionAverage, 0, 5, 2, 1);
        float angleFactor = map(emotionAverage, 0, 5, PI, TWO_PI);
        float iterations = map(i, 0, maxParticles, 5, 1);
        particles[i].update(noiseAmount, angleFactor, iterations, emotionAverage);
        particles[i].display(radius, img, 1);
        particles[i].edge();
      } 
    }
    frame++;
    if(frame >= nFrames-1){
      frame = 0;
    }
  }
  //spout.sendTexture();
}

int count = 0;
float sum = 0;

//void AddNewValue(float val) {
//  if(count < emotionValues.length) {
//    emotionValues[count++] = val;
//    sum += val; 
//  } else {
//    sum += val; 
//    sum -= emotionValues[0];
//    for (int i = 0; i < emotionValues.length-1; i++) {
//      emotionValues[i] = emotionValues[i+1] ;
//    }
//    emotionValues[emotionValues.length-1] = val;
//  }
//}

//public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
//  input_delta = delta;
//  input_theta = theta;
//  input_low_alpha = low_alpha;
//  input_high_alpha = high_alpha;
//  input_low_beta = low_beta;
//  input_high_beta = high_beta;
//  input_low_gamma = low_gamma;
//  input_mid_gamma = mid_gamma;
 
//  emotion_val = 0.574 - (1.951 * norm(log(float(input_high_beta)), 6, 15)) - (1.092 *  norm(log(float(input_high_beta)), 6, 15)) + (1.944 * norm(log(float(input_high_alpha)), 6, 15)) + (2.511 * norm(log(float(input_low_beta)), 6, 15)) + (1.513 * norm(log(float(input_theta)), 6, 15));
//  AddNewValue(emotion_val);
//  emotionAverage = sum / count;
//  //if (emotion_val > emotionAverage + .5) {
//  //  println("piek!!");
//  //  println("value: " + emotion_val + " - average: " + emotionAverage);
//  //} 
//}

//void stop() {
//  neuroSocket.stop();
//  super.stop();
//}
