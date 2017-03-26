import processing.opengl.*; 
import javax.media.opengl.*; 

/*
[http://enjoyproessing.blogspot.jp/2015/02/blog-post_15.html]
・面の集まりとして波を表現　ｓ×s(n個の面)
・実際に表示する面は(s-1)×(s-1)個
・（ｓ×s個だと外周にある面の座標を計算する際に配列（ArrayList)のインデックスがアウトするため）
・t秒後の面の位置のｚ座標は震央からの距離をもとに計算(高校のときの物理の教科書の公式を参考にしました・・・)
*/

Surfaces wave;

void setup() { 
 
  wave = new Surfaces();

  size(500 ,500, OPENGL);
 
  background(0);
 
  camera(220.0, 220.0, 220.0, // カメラの位置(x,y,z)
  wave.s*wave.space/2, wave.s*wave.space/2, 0.0, // 視点(x,y,z)
  0.0, 1.0, 0.0);
}

void draw() {
 
  background(0);
  wave.update();
}

class Surfaces{
  float space;//面の辺の長さ
  float lamda,f,t,a;//波長,周波数,時間,振幅
  int n,s;
  //Surface[][] surfaces;
  ArrayList<Surface> surfaces;
  PVector point,ev;//震央の座標
  boolean outerflag;//外周の面かどうかの判定用
 
  Surfaces(){
    point = new PVector();
    s = 50;
    n = s*s;
    //surfaces = new Surface[n][n];
    surfaces = new ArrayList<Surface>(); 
   
    lamda = 50.0f;
    f = 1.0f;
    a = 15.0f;
   
    ev = new PVector(10.0f,100.0f,50.0f);
    space = 5.0f;
    int x;
    int y;
    for(int i = 0; i < n; i++){
      x = i%s;
      y = i/s;
      point.x = x*space;
      point.y = y*space;
      point.z = 0;
       
      if(i < s || i % s == 0 || (i+1)% s == 0    || i > n - s){
        outerflag = true;
      }else{
        outerflag = false;
      }
     
      surfaces.add(new Surface(point,ev,space,outerflag));
      surfaces.get(i).calcDistance();
    }
  }
   
  void update(){  
    float time = millis()/1000.0;
    for(int i = 0; i < n; i++){
       surfaces.get(i).calcCV_Z(f,time,lamda,a);
    }
   
    for(int i = 0; i < n; i++){
      surfaces.get(i).calcV_Z(surfaces,i,s);
    }
   
    for(int i = 0; i < n; i++){
       surfaces.get(i).makeSurface();
    }
  }
}

class Surface {
  private PVector v1,v2,v3,v4,cv,ev;//面の４点,cv:面の中心点
  float cvz;//面の中心点のz座標
  private float r,f,a,t,lam;
  boolean outerflag;
  float space;
 
 Surface(PVector p1,PVector p2,float s,boolean of){
   v1 = new PVector();
   v2 = new PVector();
   v3 = new PVector();
   v4 = new PVector();
   cv = new PVector();
   ev = new PVector();
  
   space = s;
   outerflag = of;
  
   float x1,x2,y1,y2;
   x1 = p1.x - space/2.0f;
   x2 = p1.x + space/2.0f;
   y1 = p1.y - space/2.0f;
   y2 = p1.y + space/2.0f;
  
   v1.x = x1;
   v1.y = y1;
   v1.z = 0;
   v2.x = x2;
   v2.y = y1;
   v2.z = 0;
   v3.x = x2;
   v3.y = y2;
   v3.z = 0;
   v4.x = x1;
   v4.y = y2;
   v4.z = 0;
  
   cv = p1;
   ev = p2;
 
 }

 //面の中心点と震央の距離の計算
 void calcDistance(){
   r = sqrt((cv.x - ev.x)*(cv.x - ev.x) + (cv.y - ev.y)*(cv.y - ev.y));
 }
 
  //面のz座標の計算
  void calcV_Z(ArrayList<Surface> surfaces,int i,int s){
    if(outerflag == false){   
      v1.z = (cvz + surfaces.get(i - 1).cvz + surfaces.get(i - 1 - s).cvz + surfaces.get(i - s).cvz)/4.0f;
      v2.z = (cvz + surfaces.get(i - s).cvz + surfaces.get(i + 1 - s ).cvz + surfaces.get(i+1).cvz)/4.0f;
      v3.z = (cvz + surfaces.get(i + 1).cvz + surfaces.get(i + 1 + s ).cvz+ surfaces.get(i + s).cvz)/4.0f;
      v4.z = (cvz + surfaces.get(i + s).cvz + surfaces.get(i - 1 + s ).cvz + surfaces.get(i-1).cvz)/4.0f;
    }
  }
 
  //t秒後の面のz座標の計算
  void calcCV_Z(float f,float t,float lamda,float a){
    cvz = a*sin(2*PI*(t*f-r/lamda ));
  }
 
  //4点から面を張る
  void makeSurface(){
    if(outerflag == false){
      beginShape();
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
      vertex(v3.x, v3.y, v3.z);
      vertex(v4.x, v4.y, v4.z);
      endShape(CLOSE);
    }
  }
} 
