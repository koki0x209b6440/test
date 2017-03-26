import processing.video.*;
import processing.opengl.*;
import javax.media.opengl.*;

GL2 gl;
Sun sun;

void setup() {
  size(640 ,480, P3D);
  sun = new Sun();
}

void draw(){
  background(0);
  fill(0,0,0,10);
  translate(width/2,height/2);

  //加算合成をする
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  PGL pgl = pg.beginPGL();
  gl = pgl.gl.getGL().getGL2();
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glEnd();

  sun.update();
}

PGraphics makeTexture() {
  PGraphics tex = createGraphics(400, 400,JAVA2D);
  float brightness = 20;
  float dx,dy,d;
  float sd,ed,dd;
  ed = 190;
  sd = 100;
  dd = ed - sd;

  int br,bg,bb;//ベースとなる色
  br = 255;
  bg = 255;
  bb = 255;

  tex.beginDraw();
  tex.background(0);
  tex.noStroke();
  tex.endDraw();
  for (int y = 0; y < tex.height; y++) {
      for (int x = 0; x < tex.width; x++) {
        int i = x + y * tex.width;
    
        //テクスチャのピクセルの色を取り出す
        int r = tex.pixels[i] >> 16 & 0xFF;
        int g = tex.pixels[i] >> 8 & 0xFF;
        int b = tex.pixels[i] & 0xFF;

        //テクスチャの中心からの距離を計算
        dx = tex.width/2 - x;
        dy = tex.height/2 - y;
        d = sqrt(dx * dx + dy * dy);

        if(d < 1){
          d = 1;
        }
    
        //放射状に色が変化する円を描画するがテクスチャが四角形なので
        //3D空間上にテクスチャを描画すると、四角形が描画されているようになる。
        //そこで距離(d)がed以上の時は明るさを色(r,g,b)を0にする
    
        if(d > sd){
      
          r = (int)((br * brightness) / d);
          g = (int)((bg * brightness) / d);
          b = (int)((bb * brightness) / d);
      
          r = (int)(r*((float)( ed - d ) / dd));
          g = (int)(g*((float)( ed - d ) / dd));
          b = (int)(b*((float)( ed - d ) / dd));
      
          if(d > ed){
            r = 0;
            g = 0;
            b = 0;
          }
        }else{
          r = (int)((br * brightness) / d);
          g = (int)((bg * brightness) / d);
          b = (int)((bb * brightness) / d);
        }
    
        //色を設定する
    
        if(r > 255){
          r = 255;
        }
    
        if(g > 255){
          g = 255;
        }
    
        if(b > 255){
          b = 255;
        }
        tex.pixels[i] = color(r, g, b);
      }
    }
  tex.updatePixels();
  return tex;
}


class Sun {

  PGraphics tex;
  ArrayList<Elipse> Elipses;
  Particle ps;
  int n;

  Sun(){
    Elipses = new ArrayList<Elipse>();
    ps = new Particle();
    n = 500;
    tex = makeTexture();

    for(int i = 0 ; i < n; i++){
      Elipses.add(new Elipse());
    }
  }

  void update(){
    for(int i = 0 ; i < n; i++){
      Elipses.get(i).update();
    }
    ps.update();
  }
}

class Elipse { 
  float size     = 10.0f;
  float theta;
  float fai;
  float r;
  float v;
  float minSize,maxSize;
  PVector posV;
  float alpha;
    
  Elipse() {
    alpha = 0;
    minSize = 80.0;
    maxSize = 150.0;
    posV = new PVector();
    v = random(0.200,0.800);
    size  = random(minSize,maxSize);
    r = 0.5;
    theta = random(2*PI);
    fai = random(2*PI);
  
    posV.x = 0.0f;
    posV.y = 0.0f;
    posV.z = r; 
  } 
  
  void update() { 
    pushMatrix();
    size = size + v;
  
    if(r<170){
      r = r + 0.1;
    }
  
    posV.z = r;
  
    if(alpha>60){
      alpha = 60;
    } 

    float _size;
  
    _size = size*r*0.005;
    if(_size > maxSize || _size < minSize){
      v = v*(-1);
    }
        
      rotateX(theta);
      rotateY(fai);   
      translate(posV.x, posV.y, posV.z);

      if(sun.ps.size > 200.0){
        alpha = alpha + 0.07;
        noStroke();
        fill(230,30 , 30 ,alpha);
        ellipse(0, 0, _size, _size);
      }
          
      popMatrix();
    
    } 

}

class Particle {
  float size;
  float alpha = 255;
  PVector posV;
  Particle(){
    size = 10;
    posV = new PVector();
    posV.x = 0;
    posV.y = 0;
    posV.z = 0;
  }

  void update(){
      pushMatrix();
      translate(posV.x, posV.y, posV.z);
      size = size + 1.7;
    
      if(sun.Elipses.get(0).r > 15){
        alpha =  alpha  - 0.5;
        if(alpha < 0){
          alpha = 0;
        }
      }
    
      beginShape(QUADS); 
      texture(sun.tex);
      tint(255, alpha); 
      vertex(-0.5f * size, -0.5f*size, 0, 0,         0); 
      vertex(-0.5f * size,  0.5f*size, 0, 0,         sun.tex.height); 
      vertex( 0.5f * size,  0.5f*size, 0, sun.tex.width, sun.tex.height); 
      vertex( 0.5f * size, -0.5f*size, 0, sun.tex.width, 0);     
      endShape();   
      popMatrix();   
  }
}
