class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float ms;
  float timer;
  float distance;

  Particle(PVector a, PVector v, PVector l, float ms_) {
    acc = a;
    vel = v;
    loc = l;
    ms = ms_;
    timer = 100.0;
  }
 
   Particle(PVector a, PVector v, PVector l, float ms_, float tmr) {
    acc = a;
    vel = v;
    loc = l;
    ms = ms_;
    timer = tmr;
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
    float col = map(timer, 0, 100, 30, 70);
    stroke(col, 100, 100, 20);
    point(loc.x,loc.y);
  }
 
 void add_force(PVector force) { 
    force.div(ms);
    vel.add(force);
  }  
 
 float getMass() { 
    return ms; 
  }  
 void setMass(float mp) { 
    ms = mp; 
  }  
  
  PVector getLocation() {
    return loc;
  }
  
  boolean dead() {
    if (timer <= 0) {
      return true;
    } else {
      return false;
    }
  }
}


