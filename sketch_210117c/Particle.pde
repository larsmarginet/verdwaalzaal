class Particle {
  PVector position;
  PVector velocity;
  PVector direction;
  float speed = .4;
  float life;
  
  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    life = random(0, 5); 
  }
  
  void update(int noiseAmount, float angleFactor, float iterations) {
    if((life -= 0.01666) < 0) respawn();
    
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
  
  void respawn() {
     position.x = random(-50, width+50);
     position.y = random(-50, height+50);
     life = 5;
  }
  
  void display(float radius) {
    ellipse(position.x, position.y, radius, radius); 
  }
  
  void edge() {
    if (position.x > width) position.x = 1;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 1;
    if (position.y < 0) position.y = height;
  }
}
