import processing.opengl.*; 
import javax.media.opengl.*; 
import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer player; 
FFT fft;
GL2 gl;

Vertexs v;
PVector cp,vp;

void setup()
{
  vp = new PVector(0.0,200.0,0.0);
  cp = new PVector(-100, -200.0, -1500.0);
  v = new Vertexs(100,25,50);
  size(640,480, OPENGL);
  minim = new Minim(this);
  player = minim.loadFile("01.mp3", 512);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  player.play();

}

void draw()
{
  background(0);

  camera(cp.x, cp.y, cp.z, vp.x, vp.y, vp.z, 0.0, 1.0, 0.0);
  rotateY(radians(320));
  translate(-900,0,-500);
  scale(0.7);

  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  PGL pgl = pg.beginPGL(); 
  gl = pgl.gl.getGL().getGL2();
  gl.glDisable(GL.GL_DEPTH_TEST); 
  gl.glEnable(GL.GL_BLEND); 
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE); 
  gl.glEnd();

  fft.forward(player.mix);

   v.update(fft);
   v.makeSurface();

}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}


class Vertexs{
  PVector pos;
  int n,p;
  ArrayList<Vertex> vertexs;
  //r：面の線分の長さ
  //n：バッファの保持件数
  //p：FFTのバッファの取得数(バッファを512としているが,p番目までを取得)
  //ArrayListの長さはn×p
  Vertexs(float r ,int n,int p){
    this.n = n;
    this.p = p;
    vertexs = new ArrayList<Vertex>();
    for(int i = 0;i < n*p; i++){
      vertexs.add(new Vertex( (i%p)*r,0,(i/p)*r));
    }
  }

 //配列のシフトを行う
 //古いデータは後ろにシフトされる
 void update(FFT f){
    for(int i = p*n;i>0;i--){
      if(i>p){
        vertexs.get(i-1).pos.y = vertexs.get(i-1 - p).pos.y;
      }else{//0～からp-1番目のArrayListにバッファf(FFT)の0からp-1番目を入れる
        vertexs.get(i-1).pos.y = height - f.getBand(i) * 8;
      }
    }
  }

  //面の表示
  //三角形を描画
  void makeSurface(){
    for(int i = 0;i<n -1 ;i++){
      for(int j = 0;j<p -1 ;j++){
        fill(100 ,255*((float)i/n ), 255*((float)j/p ) );

        beginShape();
            vertex(vertexs.get(j + p*i).pos.x,  vertexs.get(j+ p*i).pos.y,   vertexs.get(j+ p*i).pos.z );
            vertex(vertexs.get(j+ 1+ p*(i+1)).pos.x,  vertexs.get(j+1+ p*(i+1)).pos.y,   vertexs.get(j+1+ p*(i+1)).pos.z );
            vertex(vertexs.get(j+ p*(i+1)).pos.x,  vertexs.get(j+ p*(i+1)).pos.y,   vertexs.get(j+ p*(i+1)).pos.z );
        endShape(CLOSE);
        beginShape();
           vertex(vertexs.get(j + p*i).pos.x,  vertexs.get(j+ p*i).pos.y,   vertexs.get(j+ p*i).pos.z );
            vertex(vertexs.get(j+1+ p*i).pos.x,  vertexs.get(j+1+ p*i).pos.y,   vertexs.get(j+1+ p*i).pos.z );
            vertex(vertexs.get(j+ 1+ p*(i+1)).pos.x,  vertexs.get(j+1+ p*(i+1)).pos.y,   vertexs.get(j+1+ p*(i+1)).pos.z );
        endShape(CLOSE);
      }
    }
  }
}
//座標情報を持つクラス
class Vertex{
  PVector pos;
  Vertex(float x,float y,float z){
    pos = new PVector();
    pos.x = x;
    pos.y = y;
    pos.z = z;
  }
}
