
/*
　本体。車とホイール。
　車の挙動(アクセル、移動)とモデル設定と描画がある。
　他はわからん(特にiterator。アクセル処理があるが)

　とりあえず本体座標はtranslate(upVb.x*scaleFactor,upVb.y*scaleFactor,upVb.z*scaleFactor);

　//視点位置は変えれるようにしたいな。
   //その位置はcam()メソッド。scaleFactor？
*/


float gravity = 0.001;
float fricLimit = 0.003;
class Wheel
{
  PVector X;
  PVector V;
  PVector F;
  Wheel(PVector xo)
  {
    X = xo;
    V = new PVector();
    F = new PVector();
  }
  void iterate(PVector forward,float speed)
  {
    float k = 0.1;
    float c = 0.15;
    float mu = 0.18;
    int b = floor(X.x);
    int a = floor(X.y);
    if(   (data[a][b]>X.z)||(data[a+1][b]>X.z)||(data[a][b+1]>X.z)||(data[a+1][b+1]>X.z)   )
    {
      PVector ref = new PVector(b+1,a,data[a][b+1]);
      PVector ref2 = new PVector(b,a+1,data[a+1][b]);
      PVector ref3;
      PVector n;
      if((X.x-b)+(X.y-a)<1)
      {
        ref3 = new PVector(b,a,data[a][b]);
        n = PVector.sub(ref2,ref3).cross(PVector.sub(ref,ref3));
      }else
      {
        ref3 = new PVector(b+1,a+1,data[a+1][b+1]);
        n = PVector.sub(ref,ref3).cross(PVector.sub(ref2,ref3));
      }
      n.normalize();
      PVector dx = PVector.sub(X,ref);
      if(n.dot(dx)>0)
      {
        PVector dxn = PVector.mult(n,n.dot(dx)*k);
        PVector dvn = PVector.mult(n,n.dot(V));
        F.sub(PVector.add(dxn,PVector.mult(dvn,c)));
        PVector forwardt = PVector.sub(forward,PVector.mult(n,n.dot(forward) ) );
        PVector dvt = PVector.sub(V,dvn);
        if(mousePressed)   dvt.sub(PVector.mult(forwardt,speed));
        else                      dvt.sub(PVector.mult(forwardt,forwardt.dot(V)*0.98));
        PVector fric = PVector.mult(dvt,mu);
        if(fric.mag()>F.mag()*0.8)   fric = PVector.mult(fric,F.mag()*0.8/fric.mag());
        F.sub(fric);
      }
    }
    F.add(bound(X));
    V.add(F);
    V.add(new PVector(0,0,-gravity));
    F = new PVector();
    X.add(V);
  }
  void iterate()
  {
    float k = 0.1;
    float c = 0.15;
    float mu = 0.18;
    int b = floor(X.x);
    int a = floor(X.y);
    PVector ref = new PVector(b+1,a,data[a][b+1]);
    PVector ref2 = new PVector(b,a+1,data[a+1][b]);
    PVector ref3;
    PVector n;
    if((X.x-b)+(X.y-a)<1)
    {
      ref3 = new PVector(b,a,data[a][b]);
      n = PVector.sub(ref2,ref3).cross(PVector.sub(ref,ref3));
    }else
    {
      ref3 = new PVector(b+1,a+1,data[a+1][b+1]);
      n = PVector.sub(ref,ref3).cross(PVector.sub(ref2,ref3));
    }
    n.normalize();
    PVector dx = PVector.sub(X,ref);
    if(n.dot(dx)>0)
    {
      PVector dxn = PVector.mult(n,n.dot(dx)*k);
      PVector dvn = PVector.mult(n,n.dot(V));
      F.sub(PVector.add(dxn,PVector.mult(dvn,c)));
      PVector dvt = PVector.sub(V,dvn);
      PVector fric = PVector.mult(dvt,mu);
      if(fric.mag()>fricLimit)   fric = PVector.mult(fric,fricLimit/fric.mag());
      F.sub(fric);
    }
    F.add(bound(X));
    V.add(PVector.mult(F,3));
    V.add(new PVector(0,0,-gravity));
    F = new PVector();
    X.add(V);
  }
  void draw()
  {
    PVector upVb = oriToWorld(new PVector(0,0,car.wheelRad*1.7),   car.ori);
    upVb.add(X);
    pushMatrix();
    translate(upVb.x*scaleFactor,upVb.y*scaleFactor,upVb.z*scaleFactor);
    draw_custom();
    popMatrix();
  }
  void draw_custom()
  {
    fill(200,200,200,150);
    sphere(car.wheelRad*2*scaleFactor);
  }
}


PVector wheelSpan = new PVector(0.75,1.5,0.4);
void calcWheelSpan(double n){ wheelSpan.z*=n; }
PVector bodySpan = new PVector(0.6,1.2,0.2);
void calcBodySpan(double n){  bodySpan.x*=n;  bodySpan.z*=n;  }

class Car{
  PVector X,V,F,T,W;
  Orient ori;
  float wheelRad = 0.07;
  Wheel[] wheel;
  PVector[] wheelR;
  float speed,speedBlend;
  float steerAngle;
  PVector[] nodes;
  int[] hood;
  Car(PVector xo,float speedBlend,float bodySpan_n_times,float wheelSpan_n_times)
  {
    X = xo;
    this.speedBlend=speedBlend;
    calcBodySpan(bodySpan_n_times);//n倍の意
    calcWheelSpan(wheelSpan_n_times);
    V = new PVector();
    F = new PVector();
    T = new PVector();
    W = new PVector();
    ori = new Orient();
    // +x left, +y forward, +z up
    wheelR = new PVector[8];
    //[0] front right wheel
    //[1] front left wheel
    //[2] rear right wheel
    //[3] rear left wheel
    //[4567] wheels on roof
    wheelR[0] = new PVector(-wheelSpan.x/2,wheelSpan.y/2,-wheelSpan.z);
    wheelR[1] = new PVector(wheelSpan.x/2,wheelSpan.y/2,-wheelSpan.z);
    wheelR[2] = new PVector(-wheelSpan.x/2,-wheelSpan.y/2,-wheelSpan.z);
    wheelR[3] = new PVector(wheelSpan.x/2,-wheelSpan.y/2,-wheelSpan.z);
    wheelR[4] = new PVector(-bodySpan.x/3,bodySpan.y/3,bodySpan.z);
    wheelR[5] = new PVector(bodySpan.x/3,bodySpan.y/3,bodySpan.z);
    wheelR[6] = new PVector(-bodySpan.x/3,-bodySpan.y/3,bodySpan.z);
    wheelR[7] = new PVector(bodySpan.x/3,-bodySpan.y/3,bodySpan.z);
    setWheel(xo);
  }
  Car(PVector xo)
  {
    this(xo,0.02,1.0,1.0);
  }
  void setWheel(PVector xo)
  {
    wheel=new Wheel[wheelR.length];
    for(int i=0; i<wheelR.length; i++) wheel[i]=new Wheel(PVector.add(wheelR[i],xo) );
  }
  
  void iterate()
  {
    for(int i=0;i<4;i++)   wheelReactor(wheel[i],wheelR[i]);
    for(int i=4;i<8;i++)   wheelReactor(wheel[i],wheelR[i]);
    if(mousePressed==true && keyPressed==true)
    {
      steerAngle = ((float) mouseX / width - 0.5) * PI/2;
      speed += (  (    (   (float) mouseY / height - 0.67) *-0.2)-speed)*speedBlend;
    }else
    {
      steerAngle *= 0.99;
      speed += (0.0-speed)*speedBlend;
    }
    PVector steerV = new PVector(-sin(steerAngle),cos(steerAngle),0);
    for(int i=0;i<2;i++)   wheel[i].iterate(oriToWorld(steerV,car.ori),speed);
    for(int i=2;i<4;i++)   wheel[i].iterate(oriToWorld(new PVector(0,1,0),car.ori),speed);
    for(int i=4;i<8;i++)   wheel[i].iterate();
    if(keyPressed&&key==' ')
    {
      // flip car
      PVector upV = new PVector(0,0,1);
      PVector upVb = oriToWorld(upV,ori);
      if (PVector.angleBetween(upV,upVb) > PI/4)
      {
        float Tpull = 0.01 * (PVector.angleBetween(upV,upVb) - PI/4);
        if(str(Tpull).equals("NaN") )   Tpull=0;
        PVector dir = upVb.cross(upV);
        dir.normalize();
        T.add(PVector.mult(dir,Tpull) );
      }
    }
    F.add(bound(X));
    V.add(PVector.mult(F,0.2));
    V.add(F);
    V.add(new PVector(0,0,-gravity));
    F = new PVector();
    X.add(V);
    W.add(PVector.mult(T,1.0));
    T = new PVector();
    W.mult(0.99);
    ori.spin(W);
  }
  void draw()
  {
    custom_body();

    for(int i=0;i<nodes.length;i++)
    {
      nodes[i] = oriToWorld(nodes[i],ori);
      nodes[i].add(X);
      nodes[i].mult(scaleFactor);
    }
    draw_body_custom();
    for(int i=0;i<4;i++)   wheel[i].draw();
  }
  void custom_body()
  {
    nodes= new PVector[16];
    hood= new int[16];
    fill(255);
        //タイヤではなく車本体部分
    nodes[0] = new PVector(bodySpan.x/2,bodySpan.y/2,bodySpan.z/2);
    nodes[1] = new PVector(bodySpan.x/2,bodySpan.y/2,-bodySpan.z/2);
    nodes[2] = new PVector(-bodySpan.x/2,bodySpan.y/2,bodySpan.z/2);
    nodes[3] = new PVector(-bodySpan.x/2,bodySpan.y/2,-bodySpan.z/2);
    nodes[4] = new PVector(-bodySpan.x/2,-bodySpan.y/2,bodySpan.z/2);
    nodes[5] = new PVector(-bodySpan.x/2,-bodySpan.y/2,-bodySpan.z/2);
    nodes[6] = new PVector(bodySpan.x/2,-bodySpan.y/2,bodySpan.z/2);
    nodes[7] = new PVector(bodySpan.x/2,-bodySpan.y/2,-bodySpan.z/2);
    /*
    nodes[0] = new PVector(0.24,-0.18,0.225);
    nodes[1] = new PVector(-0.24,-0.18,0.225);
    nodes[2] = new PVector(0.36,-0.18,0.045);
    nodes[3] = new PVector(-0.36,-0.18,0.045);
    nodes[4] = new PVector(0.36,-0.9,0.045);
    nodes[5] = new PVector(-0.36,-0.9,0.045);
    nodes[6] = new PVector(0.36,-0.9,-0.225);
    nodes[7] = new PVector(-0.36,-0.9,-0.225);
    */
    nodes[8] = new PVector(0.36,0.9,-0.225);
    nodes[9] = new PVector(-0.36,0.9,-0.225);
    nodes[10] = new PVector(0.36,0.9,-0.045);
    nodes[11] = new PVector(-0.36,0.9,-0.045);
    nodes[12] = new PVector(0.36,0.42,0.045);
    nodes[13] = new PVector(-0.36,0.42,0.045);
    nodes[14] = new PVector(0.24,0.18,0.225);
    nodes[15] = new PVector(-0.24,0.18,0.225);
    hood[0] = 7;
    hood[1] = 9;
    hood[2] = 5;
    hood[3] = 11;
    hood[4] = 3;
    hood[5] = 13;
    hood[6] = 1;
    hood[7] = 15;
    hood[8] = 0;
    hood[9] = 14;
    hood[10] = 2;
    hood[11] = 12;
    hood[12] = 4;
    hood[13] = 10;
    hood[14] = 6;
    hood[15] = 8;
  }
  void draw_body_custom()
  {
    fill(200,200,200,150);
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<nodes.length;i++)   vertex(nodes[i].x,nodes[i].y,nodes[i].z);
    endShape();
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<nodes.length;i++)   vertex(nodes[hood[i]].x,nodes[hood[i]].y,nodes[hood[i]].z);
    endShape();
  }
  
  void cam()
  {
    PVector camV = PVector.add(oriToWorld(new PVector(0,-5,2),car.ori),   car.X);
    camV.z = car.X.z + 2;
    int b = floor(camV.x);
    int a = floor(camV.y);
    //println("data["+a+"]["+b+"]");
    float aa = data[a][b];
    float ca = data[a][b+1];
    float ba = aa + (ca - aa) * (camV.x - (float)b);
    float ac = data[a+1][b];
    float cc = data[a+1][b+1];
    float bc = ac + (cc - ac) * (camV.x - (float)b);
    float bb = ba + (bc - ba) * (camV.y - (float)a);
    if(camV.z<bb+1){   camV.z=bb+1;   }
    camX = PVector.add( PVector.add(camX,PVector.mult(PVector.sub(camV,camX),0.05) ),   V);
    camera(camX.x*scaleFactor, 
                camX.y*scaleFactor, 
                camX.z*scaleFactor, // eyeX, eyeY, eyeZ
                car.X.x*scaleFactor,
                car.X.y*scaleFactor, 
                car.X.z*scaleFactor, // centerX, centerY, centerZ
                0.0, 0.0, -1.0); // upX, upY, upZ
  }
}
PVector camX;//↑の、主にカメラの処理で使う

void wheelReactor(Wheel weel, PVector offset)
{
  float k1 = 0.2;
  float k2 = 0.03;
  float c1 = 0.05;
  float c2 = 0.03;
  PVector dx1o = PVector.sub(weel.X,car.X);
  PVector dx1 = worldToOri(dx1o,car.ori);
  PVector comp1 = PVector.sub(dx1,offset);
  comp1.x *= -k1;
  comp1.y *= -k1;
  comp1.z *= -k2;
  comp1.x -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),  worldToOri(car.V,car.ori)),   worldToOri(car.W,car.ori).cross(dx1)),c1).x;
  comp1.y -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),  worldToOri(car.V,car.ori)),   worldToOri(car.W,car.ori).cross(dx1)),c1).y;
  comp1.z -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),  worldToOri(car.V,car.ori)),   worldToOri(car.W,car.ori).cross(dx1)),c2).z;
  PVector comp1o = oriToWorld(comp1,car.ori);
  weel.F.add(comp1o);
  car.F.sub(comp1o);
  car.T.sub(dx1o.cross(comp1o));
}
void wheelReactor2(Wheel weel, PVector offset)
{
  float k1 = 0.03;
  float k2 = k1;
  float c1 = 0.03;
  float c2 = c1;
  PVector dx1o = PVector.sub(weel.X,car.X);
  PVector dx1 = worldToOri(dx1o,car.ori); 
  PVector comp1 = PVector.sub(dx1,offset);
  comp1.x *= -k1;
  comp1.y *= -k1;
  comp1.z *= -k2;
  comp1.x -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),worldToOri(car.V,car.ori)),worldToOri(car.W,car.ori).cross(dx1)),c1).x;
  comp1.y -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),worldToOri(car.V,car.ori)),worldToOri(car.W,car.ori).cross(dx1)),c1).y;
  comp1.z -= PVector.mult(PVector.sub(PVector.sub(worldToOri(weel.V,car.ori),worldToOri(car.V,car.ori)),worldToOri(car.W,car.ori).cross(dx1)),c2).z;
  PVector comp1o = oriToWorld(comp1,car.ori);
  weel.F.add(comp1o);
  car.F.sub(comp1o);
  car.T.sub(dx1o.cross(comp1o));
}
PVector worldToOri(PVector w, Orient Ori)
{
  PVector o = new PVector();
  o.x = w.x * Ori.ui.x + w.y * Ori.ui.y + w.z * Ori.ui.z;
  o.y = w.x * Ori.uj.x + w.y * Ori.uj.y + w.z * Ori.uj.z;
  o.z = w.x * Ori.uk.x + w.y * Ori.uk.y + w.z * Ori.uk.z;
  return o;
}
PVector oriToWorld(PVector o, Orient Ori)
{
  PVector w = new PVector();
  w.x = Ori.ui.x * o.x + Ori.uj.x * o.y + Ori.uk.x * o.z;
  w.y = Ori.ui.y * o.x + Ori.uj.y * o.y + Ori.uk.y * o.z;
  w.z = Ori.ui.z * o.x + Ori.uj.z * o.y + Ori.uk.z * o.z;
  return w;
}
