/*

　文字はboxの組み合わせ。なのだが……変数positionに簡単に文字パーツの座標を取得していやがる……
   っていうかimportにcollision系が全部ある。何も参考になる気がしない
   
   これなら、dragballの方が遥かに読む価値アリ、汎用性ありだろう
*/


/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/9333*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import com.bulletphysics.*;
import com.bulletphysics.collision.dispatch.*;
import com.bulletphysics.collision.shapes.*;
import com.bulletphysics.collision.broadphase.*;
import com.bulletphysics.dynamics.*;
import com.bulletphysics.dynamics.constraintsolver.*;
import com.bulletphysics.linearmath.*;

import javax.vecmath.*;

PFont ff;
String validChars = "QWERTYUIOPLKJHGFDSAZXCVBNM0987654321qwertyuioplkjhgfdsazxcvbnm";
ArrayList myChars = new ArrayList();
int cposCount = 0;
PeasyCam cam;

CollisionDispatcher myCd;
BroadphaseInterface myBi;
ConstraintSolver myCs;
CollisionConfiguration myCc;

RigidBody groundRigidBody;
ArrayList fallRigidBodies = new ArrayList();
Iterator ite, lsite;

Vector3f worldAabbMin = new Vector3f(-10000,-10000,-10000);
Vector3f worldAabbMax = new Vector3f(10000,10000,10000);
DynamicsWorld myWorld;

Transform myTransform;

//import processing.video.*; 
//MovieMaker mm;  

void setup()
{
  size(800, 600, P3D);
  cam = new PeasyCam(this, 180);
  cam.rotateY(PI/5);
  cam.rotateX(PI/5);
  ff = loadFont("imhelix2_8pt_0804_11-8.vlw");

  myCc = new DefaultCollisionConfiguration();
  myBi = new AxisSweep3(worldAabbMin, worldAabbMax);
  myCd = new CollisionDispatcher(myCc);
  myCs = new SequentialImpulseConstraintSolver();
  
  myWorld = new DiscreteDynamicsWorld(myCd, myBi, myCs, myCc);
  myWorld.setGravity(new Vector3f(0,70,0));
  
  //ADD STATIC GROUND
  CollisionShape groundShape = new StaticPlaneShape(new Vector3f(0,-1,0), 0);
  myTransform = new Transform(); 
  myTransform.origin.set(new Vector3f(0,0,0)); //ground plane position
  myTransform.setRotation(new Quat4f(0,0,0,1));
  DefaultMotionState groundMotionState = new DefaultMotionState(myTransform);
  RigidBodyConstructionInfo groundCI = new RigidBodyConstructionInfo(0, groundMotionState, groundShape, new Vector3f(0,0,0));
  RigidBody groundRigidBody = new RigidBody(groundCI);
  myWorld.addRigidBody(groundRigidBody);
  //mm = new MovieMaker(this, width, height, "drawing.mov", 30, MovieMaker.VIDEO, MovieMaker.LOSSLESS);  
}

void draw()
{
  background(255);
  setupLights();

    myWorld.stepSimulation(1.0/60.0);
    
    ite = fallRigidBodies.iterator();
    lsite = myChars.iterator();
    while( ite.hasNext() ) {
      
      LetterInstance fallRigidBody = (LetterInstance) ite.next();
      LetterShape ls = (LetterShape) lsite.next();
      
      myTransform = new Transform();
      myTransform = fallRigidBody.getMotionState().getWorldTransform(myTransform);
      
      pushMatrix();
      
      translate(myTransform.origin.x,myTransform.origin.y,myTransform.origin.z);
      
      applyMatrix(myTransform.basis.m00, myTransform.basis.m01, myTransform.basis.m02, 0,
      myTransform.basis.m10, myTransform.basis.m11, myTransform.basis.m12, 0,
      myTransform.basis.m20, myTransform.basis.m21, myTransform.basis.m22, 0,
      0,  0,  0,  1);
      
      ls.render();
      popMatrix();
    }
    

  pushMatrix();
  rotateX(HALF_PI);
  rectMode(CENTER);
  noStroke();
  fill(255);
  rect(0,0,150,150);
  popMatrix();
  //mm.addFrame(); 
}

void addBox(float pX, float pY,float pZ, float quat3, Character k)
{  
  
  String s = Character.toString(k);
  myChars.add(new LetterShape(s));
  LetterShape ls = (LetterShape) myChars.get(myChars.size()-1);
  ls.scanImage();
  
  CollisionShape fallShape = new BoxShape(new Vector3f(ls.w(),ls.h(),2.5));
  myTransform = new Transform(); 
  myTransform.origin.set(new Vector3f(pX,pY,pZ)); 
  myTransform.setRotation(new Quat4f(quat3,quat3,quat3,1));
  DefaultMotionState fallMotionState = new DefaultMotionState(myTransform);
  float myFallMass = 1; 
  Vector3f myFallInertia = new Vector3f(1,1,1);
  fallShape.calculateLocalInertia(myFallMass, myFallInertia);
  RigidBodyConstructionInfo fallRigidBodyCI = new RigidBodyConstructionInfo(myFallMass, fallMotionState, fallShape, myFallInertia);
  
  LetterInstance fallRigidBody = new LetterInstance(fallRigidBodyCI);
  
  myWorld.addRigidBody(fallRigidBody);  
  fallRigidBodies.add(fallRigidBody);


}

void keyPressed() 
{
  for(int i = 0; i < validChars.length(); i++){
    if(key == validChars.charAt(i)){
      addBox(0, -100, 0, random(-PI, PI), key);
    }
  }

}

void setupLights() 
{
  directionalLight(250, 250, 250, 0, 6, -1);
}


