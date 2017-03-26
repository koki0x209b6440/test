/*
0116

　画面上に陰影があり、奇麗だったので、それを勉強したかった。
　しかし中身を見てみれば、走るAI車を照らすようにspotlight();の一行のみ。
　processing既存のメソッドは案外便利なんだなぁ。

*/

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/47949*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//import processing.opengl.*;

Robot r2d2;
float rotacionT = .3;
float rotacion  = 0;
float px, py;

void setup() {
  size (650, 650, P3D);
  frameRate(200);
  rectMode(CENTER);
  noStroke();
  lights();
  r2d2 = new Robot();
}


void draw() {
  
  /*
  //px,pyに注目してスクロールなカメラ。ズーム率どこだろう(=>height/2.0)。
  camera(width/2.0 + px/2, height/2.0 + py/2, (height/2.0) / tan(PI*60.0 / 360.0),
         width/2.0 + px  , height/2.0 + py,
         0, 0, 1, 0);//auto
  */
  
  camera(width/2.0, height/2.0 , (height/1.5) / tan(PI*60.0 / 360.0),
         width/2.0 , height/2.0 ,
         0, 0, 1, 0);
  
  px += (r2d2.px - px)*.02;
  py += (r2d2.py - py)*.02;
  if (rotacion<rotacionT-.01) {
    rotacion += (rotacionT-rotacion)*.006;
  }

  background(0);
  translate(width/2, height/2, 210);
  //rotateX(rotacion);//auto
  //pointLight(255, 255, 255, px, py, 30);
  rotateX(mY*0.01);
  rotateY(mX*0.01);
  if(mousePressed){  mY-=mouseY-pmouseY;  mX-=mouseX-pmouseX;  }
  r2d2.m1.draw();
  r2d2.draw();
  r2d2.pensar();
}
int mX=0,mY=0;
