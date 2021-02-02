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


int max_delta = 1;
int max_theta = 1;
int max_low_alpha = 1;
int max_high_alpha = 1;
int max_low_beta = 1;
int max_high_beta = 1;
int max_low_gamma = 1;
int max_mid_gamma = 1;

float emotion_val;


int blinkSt = 0;
PFont font;
int blink = 0;
 
void setup() 
{
  size(640, 480);
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
 
void draw() 
{
  background(0);
  fill(44, 234, 208);
  rect(20, 460 - map(input_delta, 0, max_delta, 0, 460), 50, map(input_delta, 0, max_delta, 0, 460));
  fill(255);
  text("delta", 35, 475);
  
  fill(210, 54, 118);
  rect(80, 460 - map(input_theta, 0, max_theta, 0, 460), 50, map(input_theta, 0, max_theta, 0, 460));
  fill(255);
  text("theta", 95, 475);
  
  fill(59, 55, 227);
  rect(140, 460 - map(input_low_alpha, 0, max_low_alpha, 0, 460), 50, map(input_low_alpha, 0, max_low_alpha, 0, 460));
  fill(255);
  text("low_alpha", 145, 475);
  
  fill(25, 253, 46);
  rect(200, 460 - map(input_high_alpha, 0, max_high_alpha, 0, 460), 50, map(input_high_alpha, 0, max_high_alpha, 0, 460));
  fill(255);
  text("high_alpha", 205, 475);
   
  fill(121, 56, 236);
  rect(260, 460 - map(input_low_beta, 0, max_low_beta, 0, 460), 50, map(input_low_beta, 0, max_low_beta, 0, 460));
  fill(255);
  text("low_beta", 265, 475);
  
  fill(118, 89, 212);
  rect(320, 460 - map(input_high_beta, 0, max_high_beta, 0, 460), 50, map(input_high_beta, 0, max_high_beta, 0, 460));
  fill(255);
  text("high_beta", 325, 475);
  
  fill(174, 25, 92);
  rect(380, 460 - map(input_low_gamma, 0, max_low_gamma, 0, 460), 50, map(input_low_gamma, 0, max_low_gamma, 0, 460));
  fill(255);
  text("low_gamma", 380, 475);
  
  fill(10, 229, 78);
  rect(440, 460 - map(input_mid_gamma, 0, max_mid_gamma, 0, 460), 50, map(input_mid_gamma, 0, max_mid_gamma, 0, 460));
  fill(255);
  text("mid_gamma", 440, 475);
  
  fill(255);
  text("emotion: " + emotion_val, 500, height/2);
  
  fill(255);
  text("max_delta: " + max_delta, 500, (height/2) + 30);
  
  fill(255);
  text("max_theta: " + max_theta, 500, (height/2) + 50);
  
  fill(255);
  text("max_low_alpha: " + max_low_alpha, 500, (height/2) + 70);
  
  fill(255);
  text("max_high_alpha: " + max_high_alpha, 500, (height/2) + 90);
  
  fill(255);
  text("max_low_beta: " + max_low_beta, 500, (height/2) + 110);
    
  fill(255);
  text("max_high_beta: " + max_high_beta, 500, (height/2) + 130);
    
  fill(255);
  text("max_low_gamma: " + max_low_gamma, 500, (height/2) + 150);
    
  fill(255);
  text("max_mid_gamma: " + max_mid_gamma, 500, (height/2) + 170);
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
  if (input_delta > max_delta) max_delta = input_delta;
  // println("theta Level: " + theta);
  input_theta = theta;
  if (input_theta > max_theta) max_theta = input_theta;
  // println("low_alpha Level: " + low_alpha);
  input_low_alpha = low_alpha;
  if (input_low_alpha > max_low_alpha) max_low_alpha = input_low_alpha;
  // println("high_alpha Level: " + high_alpha);
  input_high_alpha = high_alpha;
  if (input_high_alpha > max_high_alpha) max_high_alpha = input_high_alpha;
  // println("low_beta Level: " + low_beta);
  input_low_beta = low_beta;
  if (input_low_beta > max_low_beta) max_low_beta = input_low_beta;
  // println("high_beta Level: " + high_beta);
  input_high_beta = high_beta;
  if (input_high_beta > max_high_beta) max_high_beta = input_high_beta;
  // println("low_gamma Level: " + low_gamma);
  input_low_gamma = low_gamma;
  if (input_low_gamma > max_low_gamma) max_low_gamma = input_low_gamma;
  // println("mid_gamma Level: " + mid_gamma);
  input_mid_gamma = mid_gamma;
  if (input_mid_gamma > max_mid_gamma) max_mid_gamma = input_mid_gamma;
  
  println(log(float(delta)));
  println(log(float(mid_gamma)));
  println(" ");
  emotion_val = 0.574 - (1.951 * map(input_high_beta, 0, max_high_beta, 0, 1)) - (1.092 * map(input_high_beta, 0, max_high_beta, 0, 1)) + (1.944 * map(input_high_alpha, 0, max_high_alpha, 0, 1)) + (2.511 * map(input_low_beta, 0, max_low_beta, 0, 1)) + (1.513 * map(input_theta, 0, max_theta, 0, 1));
  // emotion_val = 0.574 - (1.951 * log(float(input_high_beta))) - (1.092 * log(float(input_high_beta))) + (1.944 * log(float(input_high_alpha))) + (2.511 * log(float(input_low_beta))) + (1.513 * log(float(input_theta)));
  

}
void stop() {
  neuroSocket.stop();
   super.stop();
 }
