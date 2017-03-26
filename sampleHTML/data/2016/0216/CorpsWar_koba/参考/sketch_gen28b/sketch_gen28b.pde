/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/968*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
int numParticles = 6000;
float xoff = 0.0;
Tank t;

ArrayList bullets = new ArrayList();
ArrayList particles = new ArrayList();


PVector grav = new PVector(0.0, 0.02);
PVector origin;
boolean deploybullet = false;
boolean impact = false;
float centerX;
float centerY;
float explRad = 2.6f; 
float theta = 0.0f;

void setup() 
{ 
  size(800,400,P2D); 
  smooth(); 
  t = new Tank(new PVector(random(100, width-100), height-13), 12, 24);
} 


void draw() 
{ 
  background(#292929);
  t.operate();
    for (int i = bullets.size()-1; i >= 0; i--) {   
      Bullet blt = (Bullet) bullets.get(i);          
           blt.add_force(grav);
           blt.update(); 
           
           if (blt.pop()) {
             impact = true;
             origin = blt.position;
             bullets.remove(i);
                  for (int z = 0; z < numParticles; z++) {
                    
                       // circle-like initial position of explosion's Particles
                        float x = explRad * cos(theta);
                        float y = explRad * sin(theta);
                        x = noise(xoff) * x;
                        y = noise(xoff) * y;
                        x += origin.x;
                        y += origin.y;
                        
                        xoff = xoff + 0.5f;
                        theta += 0.1f;
                        
                        PVector a = new PVector();
                        PVector l = new PVector(x, y, 0);
                        PVector v = PVector.sub(l,origin);  
                        
                        particles.add(new Particle(a,v,l, random(0.1f,0.9f)));
                  }
           }  
         }
  if(impact){
    explode();
  }       
} 

 
 
void mousePressed() 
{ 
  if(mouseButton==LEFT) 
  {
   PVector a = new PVector();
   PVector l = new PVector(t.loc.x, t.loc.y, 0); // cannon startpoint
   PVector x = new PVector(t.x, t.y, 0); // cannon endpoint
   PVector v = PVector.sub(x, l);  
   bullets.add(new Bullet(a, v, l));
  }
} 


void explode(){
    for (int i = particles.size()-1; i >= 0; i--)  {
       Particle prt = (Particle) particles.get(i);   
       prt.add_force(grav);
       prt.run(); 

       if (prt.dead()) {
          particles.remove(i);
       }
    }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      t.run(0);
    } else if (keyCode == RIGHT) {
      t.run(1);
    } 
  } 
} 

