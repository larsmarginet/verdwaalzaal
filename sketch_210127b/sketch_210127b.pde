import processing.sound.*;
import codeanticode.syphon.*;
// import processing.serial.*;   
import gifAnimation.*;
// Serial myPort;  

SoundFile bas, cello, viool1, viool2, viool3, viool4, koor, harp;
Amplitude cello_amp, viool1_amp, viool2_amp, viool3_amp, viool4_amp, koor_amp, harp_amp;

PGraphics canvas;
SyphonServer server;

float input = 100;

int maxParticles = 10000;
int noiseAmount = 800;

int multFactor = 1; // how many times does the gif show

Particle[] particles = new Particle[maxParticles];

PImage[] animation;
PImage[] animation0;
PImage[] animation1;
PImage img;

String[] imgFileNames = new String[]{ "bandw_2", "original" }; 
int gifIndex = 0;
String fileType = "gif";
String order = "normal";
int frame = 0;

void setup() {
  frameRate(24);
  background(0);

  bas = new SoundFile(this, "bas.wav");
  cello = new SoundFile(this, "cello.wav");
  viool1 = new SoundFile(this, "viool1.wav");
  viool2 = new SoundFile(this, "viool2.wav");
  viool3 = new SoundFile(this, "viool3.wav");
  viool4 = new SoundFile(this, "viool4.wav");
  koor = new SoundFile(this, "koor.wav");
  harp = new SoundFile(this, "harp.wav");

  bas.loop();
  cello_amp = new Amplitude(cello, 30, .005);
  viool1_amp = new Amplitude(viool1, 60, .005);
  viool2_amp = new Amplitude(viool2, 90, .005);
  viool3_amp = new Amplitude(viool3, 120, .005);
  viool4_amp = new Amplitude(viool4, 150, .005);
  koor_amp = new Amplitude(koor, 180, .005);
  harp_amp = new Amplitude(harp, 210, .005);

  animation0 = Gif.getPImages(this, imgFileNames[0] + "." + fileType);
  animation1 = Gif.getPImages(this, imgFileNames[1] + "." + fileType);
  animation = animation0;
  img = animation[frame];

  size(1, 1, P3D);
  
  // myPort  =  new Serial (this, "/dev/tty.usbmodem142101",  9600); // Set the com port and the baud rate according to the Arduino IDE
  // myPort.bufferUntil ('\n');   // Receiving the data from the Arduino IDE
  
  for(int i = 0; i < maxParticles; i++){
    particles[i] = new Particle(random(0, width),random(0,height));
  }
  
  surface.setResizable(true);
  surface.setSize(img.width * multFactor, img.height);

  canvas = createGraphics(width, height, P3D); // create a new canvas to send to MadMapper
  server = new SyphonServer(this, "Processing Syphon");
}

// void serialEvent (Serial myPort) {
//   input = float (myPort.readStringUntil( '\n' ));
// } 

void draw() {
  cello_amp.update();
  viool1_amp.update();
  viool2_amp.update();
  viool3_amp.update();
  viool4_amp.update();
  koor_amp.update();
  harp_amp.update();

  canvas.beginDraw();
  canvas.noStroke();
  canvas.smooth();
  for (int i = 0; i < maxParticles; i++) {
    float radius = map(input, 0, 255, 1, 2);
    // float radius = 15;
    float alpha = map(i, 0, maxParticles, 0, 250);
    float angleFactor = map(input, 0, 255, PI, TWO_PI);
    //float angleFactor = TWO_PI;
    float colorFactor = 1;
    float iterations = map(i, 0, maxParticles, 5, 1);
    particles[i].update(noiseAmount, angleFactor, iterations, input);
    particles[i].display(radius, img, canvas, multFactor);
    particles[i].edge();
  }
  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas); // send rendered frame to MadMapper

  // if (millis()/1000 > 7 && gifIndex == 0) {
  //   updateGif();
  //   animation = animation1;
  //   println("new index");
  // }

  if (order == "normal" && frame >= animation.length - 1) {
    order = "reverse";
  } else if (order == "reverse" && frame == 0) {
    order = "normal";
  }

  if (order == "normal") {
    frame++;
  } else if (order == "reverse") {
    frame--;
  }
  img = animation[frame];
}

void updateGif() {
  gifIndex++;
  frame = 0;
  order = "normal";
}