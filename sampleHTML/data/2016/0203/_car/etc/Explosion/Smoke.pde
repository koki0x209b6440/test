/*
 A 3D version of "Smoke Particle System"(look Examples->Topics->Simulate) by Daniel Shiffman.
 But this one is not so realistic. Just draws a lowDetailed spheres.
 */
class Smoke {

  ArrayList<Particle> particles;
  PVector origin;
  float partRad;
  float ints;

  Smoke(int num, PVector v, float cpartRad, float cints) {
    particles = new ArrayList<Particle>();
    origin = v.get();
    partRad = cpartRad;
    ints = cints;
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));
    }
  }

  void run(PApplet parent) {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run(parent, partRad, ints);
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void add_force(PVector dir) {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.add_force(dir);
    }
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float timer;
  private final Random generator = new Random();

  Particle(PVector l) {
    acc = new PVector(0.0f, 0.0f, 0.0f);
    float x = (float) generator.nextGaussian() * 0.2f;
    float y = (float) generator.nextGaussian() * 0.2f - 1.0f;
    float z = (float) generator.nextGaussian() * 0.2f;
    vel = new PVector(x, y, z);
    loc = l.get();
    timer = 4.0f;
  }

  void run(PApplet parent, float partRad, float ints) {
    update();
    render(parent, partRad, ints);
  }

  void add_force(PVector f) {
    acc.add(f);
  }

  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 0.05;
    acc.mult(0);
  }

  void render(PApplet parent, float partRad, float ints) {
    parent.fill(255, timer * ints);
    parent.noStroke();
    parent.sphereDetail(0);
    parent.pushMatrix();
    parent.translate(loc.x, loc.y, loc.z);
    parent.sphere(partRad);
    parent.popMatrix();
  }

  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

