/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/26538*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
boolean SECONDARY_DRAW = false;

float GRAVITY = 0.04;
int ITERATIONS = 3;
int COLLISION_ITERATIONS = 1;
float TIGHTNESS = 2.1;
float INTERACT_DIST = 15;
float INTERACTON_FORCE = 0.0;

int BALL_COUNT = 80;

Ball[] balls;
int count = 0;

void setup(){
  size(500,500);
  smooth();
  stroke(0,90);
  //noFill();
  balls = new Ball[BALL_COUNT];

  //for(int i = 0; i < BALL_COUNT; i++) 
    //balls[i] = new Ball(random(50, 450),random(30,450),random(5,25), 10, .75);


}


void draw(){
  background(0);

  for(int i = 0; i < count; i++)
  {
    Ball b = balls[i];

    b.update();
    if(!SECONDARY_DRAW)
      b.draw();

    if(mousePressed && b.inPolygon(mouseX, mouseY)){
      if(mouseButton == LEFT)    
        b.airPressure += 0.0005;
      else
        b.airPressure -= 0.0005;

    }

    for(int j = 0; j < count*COLLISION_ITERATIONS; j++)
    {
      if(i!=j%count){
        balls[i].testBall(balls[j%count]); 
      }
    }
  }
  
//  loadPixels();
//  
//  for(int i = 0; i < pixels.length; i++){ 
//    pixels[i] = red(pixels[i]) < 150 ? pixels[i] : color(255);
//  }
//  
//  updatePixels();


}


void mousePressed(){
 balls[count] = new Ball(mouseX, mouseY, random(10,20),30, .05); 
 count++;
}
