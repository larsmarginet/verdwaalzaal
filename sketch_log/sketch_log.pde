import neurosky.*;
import org.json.*;
 
ThinkGearSocket neuroSocket;
int attention = 0;
int meditation = 0;

int input_delta = 1;
int input_theta = 1;
int input_low_alpha = 1;
int input_high_alpha = 1;
int input_low_beta = 1;
int input_high_beta = 1;
int input_low_gamma = 1;
int input_mid_gamma = 1;


float emotion_val;


int blinkSt = 0;
PFont font;
int blink = 0;
 
void setup() 
{
  size(640, 480);
   background(0);
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  try 
  {
    neuroSocket.start();
  } 
  catch (Exception e) {
    println(e);
  }
  smooth();
  font = createFont("Sans-Serif", 10);
  textFont(font);
  frameRate(25);
  noStroke();
}
 
int mult_factor = 40; 
 
void draw() 
{
 
  fill(44, 234, 208, 1);
  ellipse(20, log(float(input_delta)) * mult_factor, 5, 5);
  //rect(20, 460 - log(float(input_delta)) * mult_factor, 50, log(float(input_delta)) * mult_factor);
  fill(255);
  text("delta", 35, 475);
  
  fill(210, 54, 118, 1);
  ellipse(80, log(float(input_theta)) * mult_factor, 5, 5);
  //rect(80, 460 - log(float(input_theta)) * mult_factor, 50, log(float(input_theta)) * mult_factor);
  fill(255);
  text("theta", 95, 475);
  
  fill(59, 55, 227, 1);
  ellipse(140, log(float(input_low_alpha)) * mult_factor, 5, 5);
  //rect(140, 460 - log(float(input_low_alpha)) * mult_factor, 50, log(float(input_low_alpha)) * mult_factor);
  fill(255);
  text("low_alpha", 145, 475);
  
  fill(25, 253, 46, 1);
  ellipse(200, log(float(input_high_alpha)) * mult_factor, 5, 5);
  //rect(200, 460 - log(float(input_high_alpha)) * mult_factor, 50,log(float(input_high_alpha)) * mult_factor);
  fill(255);
  text("high_alpha", 205, 475);
   
  fill(121, 56, 236, 1);
  ellipse(260, log(float(input_low_beta)) * mult_factor, 5, 5);
  //rect(260, 460 - log(float(input_low_beta)) * mult_factor, 50, log(float(input_low_beta)) * mult_factor);
  fill(255);
  text("low_beta", 265, 475);
  
  fill(118, 89, 212, 1);
  ellipse(320, log(float(input_high_beta)) * mult_factor, 5, 5);
  //rect(320, 460 - log(float(input_high_beta)) * mult_factor, 50, log(float(input_high_beta)) * mult_factor);
  fill(255);
  text("high_beta", 325, 475);
  
  fill(174, 25, 92, 1);
  ellipse(380, log(float(input_low_gamma)) * mult_factor, 5, 5);
  //rect(380, 460 - log(float(input_low_gamma)) * mult_factor, 50, log(float(input_low_gamma)) * mult_factor);
  fill(255);
  text("low_gamma", 380, 475);
  
  fill(10, 229, 78, 1);
  ellipse(440, log(float(input_mid_gamma)) * mult_factor, 5, 5);
  //rect(440, 460 - log(float(input_mid_gamma)) * mult_factor, 50, log(float(input_mid_gamma)) * mult_factor);
  fill(255);
  text("mid_gamma", 440, 475);
  
  //fill(255);
  //text("emotion: " + emotion_val, 500, height/2);
}
 
 
 void keypressed () {
   println("test");
   if (key=='r') saveFrame("result.png");
 }
 
void attentionEvent(int attentionLevel) 
{
  attention = attentionLevel;
}
 
void meditationEvent(int meditationLevel) 
{
  meditation = meditationLevel;
}
 
void blinkEvent(int blinkStrength) 
{
  blinkSt = blinkStrength;
  blink = 1;
}


public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  // println("delta Level: " + delta);
  input_delta = delta;
  // println("theta Level: " + theta);
  input_theta = theta;
  // println("low_alpha Level: " + low_alpha);
  input_low_alpha = low_alpha;
  // println("high_alpha Level: " + high_alpha);
  input_high_alpha = high_alpha;
  // println("low_beta Level: " + low_beta);
  input_low_beta = low_beta;
  // println("high_beta Level: " + high_beta);
  input_high_beta = high_beta;
  // println("low_gamma Level: " + low_gamma);
  input_low_gamma = low_gamma;
  // println("mid_gamma Level: " + mid_gamma);
  input_mid_gamma = mid_gamma;
 
  emotion_val = 0.574 - (1.951 * norm(log(float(input_high_beta)), 6, 15)) - (1.092 *  norm(log(float(input_high_beta)), 6, 15)) + (1.944 * norm(log(float(input_high_alpha)), 6, 15)) + (2.511 * norm(log(float(input_low_beta)), 6, 15)) + (1.513 * norm(log(float(input_theta)), 6, 15));
  println(emotion_val);
}


void stop() {
  neuroSocket.stop();
   super.stop();
 }
