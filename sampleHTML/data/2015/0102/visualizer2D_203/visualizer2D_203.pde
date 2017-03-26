
import processing.opengl.*;  
import javax.media.opengl.*;  
import ddf.minim.*;//minimライブラリをインポート
import ddf.minim.analysis.*;//analysisライブラリをインポート
Minim minim;
AudioPlayer player;  
FFT fft;

GL2 gl;

ArrayList<Particle> particles;
PGraphics  tex; 

float rotateYf;
float d_rotateY;

float a;
final float I = 60;

void setup()
{
  rotateYf = 0;
  d_rotateY = 0.001;
  a = 0;
  size(640,480, OPENGL); 
  
  particles = new ArrayList<Particle>();  
  for(int i = 0; i < 1000; ++i) {    
    particles.add(new Particle());  
  } 

  minim = new Minim(this);
  player = minim.loadFile("01.mp3", 512);//音源ファイルのロード
  //バッファサイズ(512)とサンプリング周期の設定
  fft = new FFT(player.bufferSize(), player.sampleRate());
  player.play();//音源ファイルの再生
  
  
}

void draw()
{
  background(0);
  translate(width/2,height/2);
  rotateYf = rotateYf + d_rotateY;
  rotateY(rotateYf);
  a = 0;
  
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  PGL pgl = pg.beginPGL();  
  gl = pgl.gl.getGL().getGL2(); 
  gl.glDisable(GL.GL_DEPTH_TEST);  
  gl.glEnable(GL.GL_BLEND);  
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);  
  gl.glEnd(); 

  fft.forward(player.mix);//高速フーリエ変換の実行

  for(int i = 0; i < I; i++)
  {
    //60以下にしているのは高周波成分をカットするため
    a  = a + fft.getBand(i);
  }
  
  //0.2を掛けているのは明るさの調節のため
  a = (a / I)*0.2;
  //aの値を0から255にマッピング
  //2は適当な値
  tex =  makeTexture( map(a, 0, 2, 0, 255));
  
  for(int i = 0; i < particles.size(); i++) {  
    particles.get(i).update();  
  } 
}

//プログラム終了時に呼び出されます
void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

PGraphics makeTexture(float f) {  
  PGraphics tex = createGraphics(100, 100,JAVA2D);  
  float r = tex.width * 2 / 3;  
    
  tex.beginDraw();  
  tex.background(0);  
  tex.noStroke();
  
  tex.fill(f*0.4, f*0.2, f);  
  tex.ellipse(tex.width/2, tex.height/2, r, r);  
  tex.filter(BLUR,8.0);  
  tex.endDraw();  
  return tex;  
}

class Particle {      

  private float theta;
  private float fai;
  
  private PVector pos;//位置
  private float r;//半径
  
  private float SIZE;
  
  Particle() {
    theta = random(2*PI);
    fai = random(2*PI);
    pos = new PVector(); 
    r = random(1000);
    SIZE = random(1.0,50.0);
    
    //半径r上に表示
    pos.x = r*sin(theta)*cos(fai);
    pos.y = r*sin(theta)*sin(fai);
    pos.z = r*cos(theta);
  }  
    
  void update() {  
    pos.x = r*sin(theta)*cos(fai);
    pos.y = r*sin(theta)*sin(fai);
    pos.z = r*cos(theta);    
       
    pushMatrix(); 
     
    translate(pos.x, pos.y, pos.z); 
   
     //常にテクスチャを正面に向ける
    PMatrix3D pm = (PMatrix3D)g.getMatrix();    
    pm.m00 = 1;
    pm.m11 = 1;
    pm.m22 = 1;
    pm.m01 = 0;
    pm.m02 = 0;   
    pm.m10 = 0;
    pm.m12 = 0;   
    pm.m20 = 0;
    pm.m21 = 0;  
    resetMatrix(); 
    applyMatrix(pm);
    
    //4つの頂点をもつ正方形にテクスチャを貼り付け表示      
    beginShape(QUADS);  
    texture(tex);  
    vertex(-0.5f * SIZE, -0.5f*SIZE, 0, 0,         0);  
    vertex(-0.5f * SIZE,  0.5f*SIZE, 0, 0,         tex.height);  
    vertex( 0.5f * SIZE,  0.5f*SIZE, 0, tex.width, tex.height);  
    vertex( 0.5f * SIZE, -0.5f*SIZE, 0, tex.width, 0);      
    endShape();  
          
    popMatrix();  
  }  
}  
