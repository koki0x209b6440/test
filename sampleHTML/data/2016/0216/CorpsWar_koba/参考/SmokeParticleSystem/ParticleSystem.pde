// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed
  PImage img;
  
  ParticleSystem(int num, PVector v)
  {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    PImage msk = loadImage("texturebasic.gif");
    img = new PImage(msk.width,msk.height);
    for (int i = 0; i < img.pixels.length; i++) img.pixels[i] = color(255,50,50);//ここが煙の色指定
    img.mask(msk);
    for (int i = 0; i < num; i++)
    {
      particles.add(new Particle(origin, img));    // Add "num" amount of particles to the arraylist
    }
  }

  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead())
      {
        particles.remove(i);
      }
    }
    for (int i = 0; i < 2; i++)
    {
    addParticle();
    }
  }
  
  // Method to add a force vector to all particles currently in the system
  void add_force(PVector dir)
  {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.add_force(dir);
    }
  }  

  void addParticle(){   particles.add(new Particle(origin,img));   }
  void addParticle(Particle p){   particles.add(p);   }

  // A method to test if the particle system still has particles
  boolean dead()
  {
    if (particles.isEmpty())
    {
      return true;
    }
    else 
    {
      return false;
    }
  }
  
  void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}

