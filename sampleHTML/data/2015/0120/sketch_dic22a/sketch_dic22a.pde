/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/765*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
int PMAX = 35000;
ArrayList p = new ArrayList(PMAX);
//Part[] p = new Part[20000];
float speed = 0;
float yCoord = 0;
float myr;
float c = 0.0; 
boolean drawbg = true;
void setup() 
{ 
  size(800,600, P2D); 
  //smooth(); 
  colorMode(HSB, 360, 100, 100, 100);
  for(int i=0; i<PMAX; i++){ 
    PVector a = new PVector();  
    PVector v = new PVector();   
    PVector l = new PVector(random(10, width-10),random(10, height-10)); 
    float m = random(1, 10);
  
  
  
//    float r = noise(off)*60; // estrae un numero che vale 1/2 di di r
//    off += 0.01;
//    print("  " + r);


   p.add(new Part (l, v, a, m));
  } 
  
} 

void draw()
{
  //background(1, 0, 100, 100);
  noStroke();
  fill(1, 100, 0, 75);
  rect(0, 0, width, height);

  yCoord += speed;
  speed += 0.01;
  stroke(1, 0, 100, 50);
  line(1,yCoord, 4, yCoord);
  line(width-4,yCoord, width-2, yCoord);
  
  
  float progAttrito = map(yCoord, 0, height-10, -0.10, -0.80);
  c = progAttrito;
  //print(" "+c);
  if (yCoord > height-10) {
    speed = speed * -0.995;  
  }
  
  for(int i = p.size()-1; i >= 0; i--){
    Part particle = (Part) p.get(i);
    //print(" " +i);
    particle.live();
    
    // forza grav
    PVector grav = new PVector(0.0,0.40);
    particle.add_force(grav);
    
    // attrito
    PVector actualVel = particle.getVel(); 
    PVector attrito = PVector.mult(actualVel,c); 
    particle.add_force(attrito);     

    

    
    if(mousePressed == true){
    // il mouse attrae
    PVector mouseLoc = new PVector(mouseX,mouseY);
    PVector diff = PVector.sub(mouseLoc,particle.getLoc());
    diff.normalize();
      
    float factor = 0.90; 
    diff.mult(factor);
    particle.setAcc(diff);
    }
      
      if (particle.pop()) {
          p.remove(i); // rimuove
          PVector a = new PVector();  
          PVector v = new PVector();   
          PVector l = new PVector(random(10, width-10),random(100)+yCoord); 
          myr = map(yCoord, 0, height-10, 1, 10);
          p.add(new Part (l, v, a, myr)); // aggiunge
      }
  }
  //if(p.isEmpty())
   //print(" end ");
}

 	

void keyPressed() { 
  //saveFrame();
}







