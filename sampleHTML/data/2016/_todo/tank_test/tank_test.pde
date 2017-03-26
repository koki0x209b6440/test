/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/52553*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import saito.objloader.*;
import java.util.HashMap;

Tank t;

float ptime;  // previous time
float ctime;  // current time
float dtime;  // delta time

void setup() {
  size(600, 600, P3D);

  // create the tank. "tank.model" does nothing, just a place holder for now
  t = new Tank(this, "tank.model");
  ptime = millis();
  
  noCursor();
}
void draw() 
{
  if(frameCount % 25 == 0 && frameRate < 55.0)
    println("#################################");
  // do some timing stuff
  ctime = millis();
  dtime = ctime - ptime;
  ptime = ctime;
  
  // Update the tank
  t.update(dtime);
  
  // Do the drawing fun
  //lights();
  //ambientLight(51, 102, 126);
  directionalLight(255, 255, 255, 0, 0, -1);
  background(180);
  fill(210, 180, 140);
  
  // Draw the tank
  t.draw();
  
  // Draw some extra stuff 
  drawAxis();
  drawPlane();
}

// For debugging and reference purposes
void drawAxis()
{
  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, 0, 0, 50, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 50, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 50);
  noStroke();
}

// Place holder to draw the terrain
void drawPlane()
{  
  int s = 1000;
  int ss = 100;
  fill(0, 200, 20);
  //stroke(200);
  noStroke();
  for(int i = 0; i < s; i += ss)
  {
    beginShape(TRIANGLE_STRIP);
    for(int j = 0; j <= s; j += ss)
    {
      vertex(j, i, 0);
      vertex(j, i + ss, 0);
    }
    endShape();
  }
  noStroke();
}

// Mouse and keyboard input
void mousePressed()
{
  t.mouseInput(false);
}
void mouseDragged()
{
  t.mouseInput(true);
}

void keyPressed()
{
  t.keyInput(key, true);
}

void keyReleased()
{
  t.keyInput(key, false);
}

