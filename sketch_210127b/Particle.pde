class Particle {
  PVector originalPixel;
  PVector position;
  PVector velocity;
  PVector direction;
  float speed = .4;
  float life;
  
  Particle(float x, float y) {
    originalPixel = new PVector(x, y);
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    life = random(.1, 1.5); 
  }
  
  void update(int noiseAmount, float angleFactor, float iterations, float input) {
    if((life -= 0.01666) < 0) respawn(input);
    
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
  
  void respawn(float input) {
    position.x = random(0, width);
    position.y = random(0, height);
    originalPixel = new PVector(position.x, position.y);
    life = map(input, 0, 255, .1, 1);
  }
  
  void display(float radius, PImage img, PGraphics canvas, int multFactor) {
    color c = 255;
    for (int i = 1; i <= multFactor; i++) {
      if (originalPixel.x < (img.width * i)) { 
        c = img.get((int) originalPixel.x - (img.width * (i - 1)), (int) originalPixel.y);
        break;
      }
    }
    canvas.fill(c);
    canvas.rect(position.x, position.y, radius, radius); 
  }
  
  void edge() {
    if (position.x > width) position.x = 1;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 1;
    if (position.y < 0) position.y = height;
  }
}
