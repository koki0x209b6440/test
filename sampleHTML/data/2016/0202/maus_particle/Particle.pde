
// A simple Particle class
class Particle {
  int life; 
  
  float x;
  float y;
  float xspeed;
  float yspeed;
  float g1 = random (10, 50);
  
  PFont arial; 
  
  Particle(int life) {
    this.life=life;
    x = mouseX;
    y = mouseY;
    xspeed = random(-3,3);
    yspeed = random(-3,3);
  }
  
  void fallen() {
    x = x + xspeed;
    y = y + yspeed;
  }
  
  void gravity() {
    yspeed += 0.1;
  }
  
  void render() {
    stroke(0);
    fill(0,85);
    text(""+( (life--)/10 ),x,y);
  }
}

