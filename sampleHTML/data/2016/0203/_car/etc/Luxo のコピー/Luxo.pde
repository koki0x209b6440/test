/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/10971*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/**
 * Luxo by Jean Pierre Charalambos. 
 * 
 * This example combines InteractiveFrames, selection and constraints.
 * 
 * This example displays a famous luxo lamp (Pixar) that can be interactively
 * manipulated with the mouse. It illustrates the use of several InteractiveFrames
 * in the same scene.
 * 
 * Click on a frame visual hint to select a part of the lamp, and then move it with
 * the mouse.
 * 
 * Press 'f' to toggle the drawing of the frames' visual hints.
 * 
 * Press 'h' to toggle the mouse and keyboard navigation help.
 */

import remixlab.proscene.*;

Scene scene;
Lamp lamp;

void setup() {
  size(640, 360, P3D);
  scene = new Scene(this);
  scene.setAxisIsDrawn(false);
  scene.setGridIsDrawn(false);
  scene.setHelpIsDrawn(false);
  scene.setFrameSelectionHintIsDrawn(false);//ランプについてる[+]みたいなマーク
  lamp = new Lamp(20,0,0);
}

void draw() {
  //Proscene sets the background to black by default. If you need to change
  //it, don't call background() directly but use scene.background() instead.
  lights();
  
  //lamp.x+=1;
  lamp.draw();
  
  //  ↓draw the ground
  //  ↓床(色付き)(ランプの光の影響を加味して、色を多様に変化させている床)
  //  ↓でかい長方形床一つ描くのだと、ランプの光spotlightの影響を加味できないっぽい？
  fill(120, 120, 120);
  float nbPatches = 100;
  //normal(0.0f,0.0f,1.0f);
  for (int j=0; j<nbPatches; ++j) {
  beginShape(QUAD_STRIP );
  for (int i=0; i<=nbPatches; ++i) {
    vertex((200*(float)i/nbPatches-100), (200*j/nbPatches-100));
    vertex((200*(float)i/nbPatches-100), (200*(float)(j+1)/nbPatches-100));
  }
  endShape();
  }
}
