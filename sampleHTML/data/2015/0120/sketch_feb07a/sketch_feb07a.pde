/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/1005*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import processing.video.*;

MovieMaker mm;  // Declare MovieMaker object


int numParticles = 25000;
ArrayList particles = new ArrayList();
Orbital_Att oa;
float theta, atheta = 0.0f;
float xoff = 0.0f;
int w = 640;
int h = 480;
PVector origin = new PVector(w/2, h/2, 0);
PVector ml;
float explRad = 1.0f;
float attRad = 30.0f;

void setup()
{
  size(w, h, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  oa = new Orbital_Att(new PVector(), 2.0f, 50.0f);
    for(int i = 0; i < numParticles; i++)
  {
    PVector a = new PVector();
    PVector l = new PVector(width/2, height/2, 0);
    PVector v = new PVector(); 
    particles.add(new Particle(a,v,l, 1.0f, random(0.0f, 100.0f)));
   }
  //mm = new MovieMaker(this, width, height, "drawing.mov", 30, MovieMaker.VIDEO, MovieMaker.LOSSLESS);
}

void draw()
{
  background(1, 0, 0, 100);

  ml = new PVector(w/2, h/2, 0);
  float ax = attRad * cos(atheta);
  float ay = attRad * sin(atheta);
  ax += ml.x;
  ay += ml.y;
  atheta += 10.0f;
  
  float np = map(mouseX, 0, width, 0.000001f, 0.1f);  
  float der = map(mouseY, 0, height, 0.5f, 3.0f);  
  for (int i = 0; i < numParticles; i++)  {
       Particle prt = (Particle) particles.get(i);   
       prt.run();
       
       
       if(mousePressed == true){
          oa.setLocation(new PVector(ax, ay, 0));
          PVector force = oa.warp(prt);
          prt.add_force(force);          
        }
        
        
        
       if (prt.dead()) {
        particles.remove(i);

        float x = der * cos(theta);
        float y = der * sin(theta);
        x *= noise(xoff);
        y *= noise(xoff);
        x += origin.x;
        y += origin.y;

        xoff += np;
        theta += 1.0f;

        PVector a = new PVector();
        PVector l = new PVector(x, y, 0);
        PVector v = PVector.sub(l,origin); 
        particles.add(new Particle(a,v,l, 1.0f));
       }
    }
  //mm.addFrame();
}



void keyPressed() {
  if (key == ' ') {
    mm.finish();
  }
}
