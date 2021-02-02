import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import codeanticode.syphon.*; 
import gifAnimation.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_210127b extends PApplet {



// import processing.serial.*;   

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

public void setup() {
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
  cello_amp = new Amplitude(cello, 30, .005f);
  viool1_amp = new Amplitude(viool1, 60, .005f);
  viool2_amp = new Amplitude(viool2, 90, .005f);
  viool3_amp = new Amplitude(viool3, 120, .005f);
  viool4_amp = new Amplitude(viool4, 150, .005f);
  koor_amp = new Amplitude(koor, 180, .005f);
  harp_amp = new Amplitude(harp, 210, .005f);

  animation0 = Gif.getPImages(this, imgFileNames[0] + "." + fileType);
  animation1 = Gif.getPImages(this, imgFileNames[1] + "." + fileType);
  animation = animation0;
  img = animation[frame];

  
  
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

public void draw() {
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

public void updateGif() {
  gifIndex++;
  frame = 0;
  order = "normal";
}
class Amplitude {
    float fspeed = 0.005f;
    SoundFile instrument;
    int threshold;
    float amplitude;

    Amplitude(SoundFile i, int t, float a) {
        instrument = i;
        instrument.loop();
        threshold = t;
        amplitude = a; 
    }

    public void update() {
        // reverse input! 
        float value = map(input, 0, 255, 255, 0);
        if (value >= threshold) {
            if (amplitude < .995f) amplitude += fspeed;
        } else if (value < threshold) {
            if (amplitude > .005f) amplitude -= fspeed;
        }
        instrument.amp(amplitude);
    }
}
class Particle {
  PVector originalPixel;
  PVector position;
  PVector velocity;
  PVector direction;
  float speed = .4f;
  float life;
  
  Particle(float x, float y) {
    originalPixel = new PVector(x, y);
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    life = random(.1f, 1.5f); 
  }
  
  public void update(int noiseAmount, float angleFactor, float iterations, float input) {
    if((life -= 0.01666f) < 0) respawn(input);
    
    while(iterations > 0){ 
      float angle = noise(position.x/noiseAmount, position.y/noiseAmount) * angleFactor;
      direction.x = cos(angle);
      direction.y = sin(angle);
      velocity = direction.copy();
      velocity.mult(speed);
      position.add(velocity);
      iterations--;
    }
  }
  
  public void respawn(float input) {
    position.x = random(0, width);
    position.y = random(0, height);
    originalPixel = new PVector(position.x, position.y);
    life = map(input, 0, 255, .1f, 1);
  }
  
  public void display(float radius, PImage img, PGraphics canvas, int multFactor) {
    int c = 255;
    for (int i = 1; i <= multFactor; i++) {
      if (originalPixel.x < (img.width * i)) { 
        c = img.get((int) originalPixel.x - (img.width * (i - 1)), (int) originalPixel.y);
        break;
      }
    }
    canvas.fill(c);
    canvas.rect(position.x, position.y, radius, radius); 
  }
  
  public void edge() {
    if (position.x > width) position.x = 1;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 1;
    if (position.y < 0) position.y = height;
  }
}
  public void settings() {  size(1, 1, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_210127b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
