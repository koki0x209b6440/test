import processing.opengl.*; 
import javax.media.opengl.*; 

PGraphics pg;
final int EDGE_LENGTH = 400;  //  四角形の長さ
final int OBJECT_SIZE = 50;     //  画面内に描画する物体のサイズ
float positionX = 0;  //  テクスチャ内の物体のX座標

ArrayList<Circle> Circles; 

Sphere s;
PImage img;

GL2 gl;

void setup() { 

  size(640 ,480, OPENGL);

  pg = createGraphics(100, 100, JAVA2D);

  Circles = new ArrayList<Circle>(); 
  for(int i = 0; i < 20; ++i) { 
    Circles.add(new Circle(pg)); 
  } 

  smooth();
  textureMode(NORMAL);

  background(0);

  s = new Sphere(300.0,30);


}

void draw(){
  background(0);
   // テクスチャの加算合成を有効にする 
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  PGL pgl = pg.beginPGL(); 
  gl = pgl.gl.getGL().getGL2();
  gl.glDisable(GL.GL_DEPTH_TEST); 
  gl.glEnable(GL.GL_BLEND); 
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE); 
  gl.glEnd();   
  s.makeSphere();
}

class Sphere {
  PVector v1,v2,v3,v4;
  float a,b,rad,ph,th,_ph,ry;
  int num;


  Sphere(float r,int n){
    ry = 0.0;
    a = 180.0/n;
    b = 360.0/n;
    num = n;
    rad = r;
  
    v1 = new PVector();
    v2 = new PVector();
    v3 = new PVector();
    v4 = new PVector();
  
    makeSphere();
  
  }

  void makeSphere(){
  
    noStroke();
    th = 0.0;
    ph = 0.0;
    _ph = 0.0;
    v1.x = 0.0;
    v1.y = 0.0;
    v1.z = 0.0;
    v2.x = 0.0;
    v2.y = 0.0;
    v2.z = 0.0;
    v3.x = 0.0;
    v3.y = 0.0;
    v3.z = 0.0;
    v4.x = 0.0;
    v4.y = 0.0;
    v4.z = 0.0;
  
    drawTexture(pg);
      
    translate(width/2,height/2);
  
    ry = ry + 0.002;
    if(ry > 2*PI){
      ry = ry - 2*PI;
    }
  
    rotateY(ry);
  
    for(int i = 0; i < num; i++){
      
      ph = _ph;
    
      for(int j = 0; j < num; j++){
        if(i  == 0){
        
          v1.z=rad*sin(radians(th + a))*cos(radians(ph));
          v1.x=rad*sin(radians(th + a))*sin(radians(ph));
          v1.y=rad*cos(radians(th + a));
        
        
          v2.z=rad*sin(radians(th + a))*cos(radians(ph-b));
          v2.x=rad*sin(radians(th + a))*sin(radians(ph-b));
          v2.y=rad*cos(radians(th + a));
        
          v3.z=rad*sin(radians(th))*cos(radians(ph-b/2.0));
          v3.x=rad*sin(radians(th))*sin(radians(ph-b/2.0));
          v3.y=rad*cos(radians(th));
          
          beginShape(TRIANGLE);
          texture(pg);
          vertex(v1.x, v1.y, v1.z, 0, 0);
          vertex(v2.x, v2.y, v2.z, 1, 0);
          vertex(v3.x, v3.y, v3.z, 0.5, 1);
          endShape();
        
          ph = ph + b;
        
        }else if( i < num -1 ){
        
            v1.z=rad*sin(radians(th + a))*cos(radians(ph));
            v1.x=rad*sin(radians(th + a))*sin(radians(ph));
            v1.y=rad*cos(radians(th + a));
        
            v2.z=rad*sin(radians(th + a))*cos(radians(ph-b));
            v2.x=rad*sin(radians(th + a))*sin(radians(ph-b));
            v2.y=rad*cos(radians(th + a));
        
            v3.z=rad*sin(radians(th))*cos(radians(ph- b - b/2.0));
            v3.x=rad*sin(radians(th))*sin(radians(ph- b - b/2.0));
            v3.y=rad*cos(radians(th));
          
            v4.z=rad*sin(radians(th))*cos(radians(ph-b/2.0));
            v4.x=rad*sin(radians(th))*sin(radians(ph-b/2.0));
            v4.y=rad*cos(radians(th));
                
            if(j%3 == 0){
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v1.x, v1.y, v1.z, 0, 0);
              vertex(v2.x, v2.y, v2.z, 1, 0);
              vertex(v4.x, v4.y, v4.z, 0.5,1);
              endShape();
            
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v2.x, v2.y, v2.z, 1, 0);
              vertex(v3.x, v3.y, v3.z, 0, 0);
              vertex(v4.x, v4.y, v4.z, 0.5, 1);
              endShape();
            }else if(j%3 == 1){
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v1.x, v1.y, v1.z, 0.5, 1);
              vertex(v2.x, v2.y, v2.z, 0, 0);
              vertex(v4.x, v4.y, v4.z, 1,0);
              endShape();
            
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v2.x, v2.y, v2.z, 0, 0);
              vertex(v3.x, v3.y, v3.z, 0.5, 1);
              vertex(v4.x, v4.y, v4.z, 1, 0);
              endShape();
            }else if(j%3 == 2){
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v1.x, v1.y, v1.z, 1, 0);
              vertex(v2.x, v2.y, v2.z, 0.5, 1);
              vertex(v4.x, v4.y, v4.z, 0,0);
              endShape();
            
              beginShape(TRIANGLE);
              texture(pg);
              vertex(v2.x, v2.y, v2.z, 0.5, 1);
              vertex(v3.x, v3.y, v3.z, 1, 0);
              vertex(v4.x, v4.y, v4.z, 0, 0);
              endShape();
            }
        
            ph = ph + b;
        }else{
        
          v1.z=rad*sin(radians(th))*cos(radians(ph));
          v1.x=rad*sin(radians(th))*sin(radians(ph));
          v1.y=rad*cos(radians(th));
        
          v2.z=rad*sin(radians(th))*cos(radians(ph-b));
          v2.x=rad*sin(radians(th))*sin(radians(ph-b));
          v2.y=rad*cos(radians(th));
        
          v3.z=rad*sin(radians(th+a))*cos(radians(ph));
          v3.x=rad*sin(radians(th+a))*sin(radians(ph));
          v3.y=rad*cos(radians(th+a));
        
          beginShape(TRIANGLE);
          texture(pg);
          vertex(v1.x, v1.y, v1.z, 0, 0);
          vertex(v2.x, v2.y, v2.z, 1, 0);
          vertex(v3.x, v3.y, v3.z, 0.5, 1);
          endShape();
        
          ph = ph + b;
        
        }
      
      }
      _ph = _ph + b*3.0/2.0;
      th = th + a ;
    }
  }
}

//  テクスチャ用画像の描画
void drawTexture(PGraphics pg){
  pg.beginDraw();
  pg.background(0, 0,0);
  pg.smooth();
  for(int i = 0; i < 20; ++i) { 
    Circles.get(i).update(pg);
    pg.fill(Circles.get(i).r,Circles.get(i).g,Circles.get(i).b);
    pg.ellipse(Circles.get(i).px, Circles.get(i).py, 30, 30); 
  } 
  pg.filter(BLUR,8.0);
  pg.endDraw();
}

class Circle{
  int r;
  int g;
  int b;
  float rad;
  float px,py,vx,vy;

  Circle(PGraphics pg){
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
  
    px = random(0,pg.width);
    py = random(0,pg.height);
  
    vx = random(0,pg.width*0.01);
    vy = random(0,pg.height*0.01);
  }
  
  void changeDire(PGraphics pg){
    if(px < 0 || px > pg.width){
      vx = vx*(-1);
    }
  
    if(py < 0 ||  px > pg.height){
      vy = vy*(-1);
    } 
  }

  void update(PGraphics pg){
    px = px + vx;
    py = py + vy;
    changeDire(pg);
  }
}
