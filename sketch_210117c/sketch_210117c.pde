import neurosky.*;
import org.json.*;
 
ThinkGearSocket neuroSocket;

int input_delta = 1;
int input_theta = 1;
int input_low_alpha = 1;
int input_high_alpha = 1;
int input_low_beta = 1;
int input_high_beta = 1;
int input_low_gamma = 1;
int input_mid_gamma = 1;

float emotion_val;

int maxParticles = 1000;
int noiseAmount = 800;

Particle[] particles_a = new Particle[maxParticles];
Particle[] particles_b = new Particle[maxParticles];
Particle[] particles_c = new Particle[maxParticles];

void setup () {
  //fullScreen(); 
  size(1920, 1000);
  background(0);
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  try {
    neuroSocket.start();
  } catch (Exception e) {
    println(e);
  }
  for(int i = 0; i < maxParticles; i++){
    particles_a[i] = new Particle(random(0, width),random(0,height));
    particles_b[i] = new Particle(random(0, width),random(0,height));
    particles_c[i] = new Particle(random(0, width),random(0,height));
  }
} 

void draw() {
  fill(0, 5);
  rect(0, 0, width, height);
  
  noStroke();
  smooth();
  
  for(int i = 0; i < maxParticles; i++){
    float radius = map(i, 0, maxParticles, 4, 6);
    float alpha = map(i, 0, maxParticles, 0, 250);
    // float angleFactor = map(input, 0, 255, PI, TWO_PI);
    float angleFactor = TWO_PI;
    // float colorFactor = 1;
    float colorFactor = map(emotion_val, -1, 5, 0.4, 1.4);
    float iterations = map(i, 0, maxParticles, 5, 1);

    fill(214 * colorFactor, 132 * colorFactor, 102 * colorFactor,alpha);
    particles_a[i].update(noiseAmount, angleFactor, iterations);
    particles_a[i].display(radius);
    particles_a[i].edge();

    fill(226 * colorFactor,186 * colorFactor,143 * colorFactor, alpha);
    particles_b[i].update(noiseAmount, angleFactor, iterations);
    particles_b[i].display(radius);
    particles_b[i].edge();

    fill(113 * colorFactor,142 * colorFactor,134 * colorFactor, alpha);
    particles_c[i].update(noiseAmount, angleFactor, iterations);
    particles_c[i].display(radius);
    particles_c[i].edge();
  }  
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
