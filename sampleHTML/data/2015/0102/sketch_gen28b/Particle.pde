class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;

  Particle(PVector a, PVector v, PVector l, float r_) {
    acc = a;
    vel = v;
    loc = l;
    r = r_;
    timer = 100.0;
  }
  
  void run() {
    update();
    render();
  }

  void update() {
    vel.add(acc);
    loc.add(vel);
    acc = new PVector();
    timer -= 0.5f;
  }
 
  void render() {
    stroke(#ffffff, timer);
    point(loc.x,loc.y);
  }
 
 void add_force(PVector force) { 
    acc.add(force); 
  }  

  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}


