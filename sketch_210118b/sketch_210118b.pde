import neurosky.*;
import org.json.*;
 
ThinkGearSocket neuroSocket;
int attention = 0;
int meditation = 0;
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
  font = createFont("Serif", 50);
  textFont(font);
  frameRate(25);
  noStroke();
}
 
void draw() 
{
  background(0);
  fill(255, 255, 0);
  text("Attention: "+attention, 20, 150);
  fill(255, 255, 0, 160);
  rect(200, 130, attention*3, 40);
  fill(255, 255, 0);
  text("Meditation: "+meditation, 20, 250);
  fill(255, 255, 0, 160);
  rect(200, 230, meditation*3, 40);
 
  if (blink>0) 
  {
    fill(255, 255, 0);
    text("Blink: " + blinkSt, 20, 350);
    if (blink>15) 
    {
      blink = 0;
    } 
    else 
    {
      blink++;
    }
  }
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
  println("test");
  println("delta Level: " + delta);
  println("theta Level: " + theta);
  println("low_alpha Level: " + low_alpha);
  println("high_alpha Level: " + high_alpha);
  println("low_beta Level: " + low_beta);
  println("high_beta Level: " + high_beta);
  println("low_gamma Level: " + low_gamma);
  println("mid_gamma Level: " + mid_gamma);
}
void stop() {
  neuroSocket.stop();
   super.stop();
 }
