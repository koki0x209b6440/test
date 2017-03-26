
/*
　px[i]とpy[i]の色平面の数値をやりくり。1マスは変数Dの値。DがNマスある感じ。
　マウスによって生じる水流などをシミュレートしている。変数Skipの値によって「ミルク(白)の移動は、いくつD飛ばしで」とできる。
　size(W*D,H*D,P2D);は、単にコーヒー領域よりも広い範囲を用意したってことか

　水流的な挙動のシミュレートをu、vで行う。(<=px,pyの色データの影響を受ける)
　px,pyはu,vの演算を受けて、色が決まる、色配列。
　(物理のu,vと色のpx,pyは互いに影響し合う)

　あと、マウスの挙動が勉強になる。
　マウスのクリック位置を「カップの内側の領域だけ」のものへ変換している。
　HanyouTestの方に活用できるかしら……
*/

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/15090*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
final int W=100;
final int H=100;
final int D=3;
final int Skip = 4;
final int N=100000;

final float dt = 0.001;
final float dx = 0.01;
final float dy = 0.01;
final float nu = 0.01;//nuって何の英略語だ？

PImage cup;

float[] px = new float[N];
float[] py = new float[N];
float[][][] u = new float[W][H][2];
float[][][] v = new float[W][H][2];

void setup()
{
  size(W*D,H*D,P2D);
  cup = loadImage("coffee.png");
  frameRate(60);
  for(int i=0; i<W; i++){
    for(int j=0; j<H; j++){
      for(int h=0; h<2; h++){
        u[i][j][h] = v[i][j][h] =0;
  } } }
  for(int i=0; i<N; i++)    px[i] = py[i] = 0;
}

void draw()
{
  background(0);
  
  if(keyPressed) mouseMoved(); 
  drawParticles();  
  image(cup,0,0);
  
  for(int i=0; i<Skip; i++)   calc();
  
  fill(255);
  text("drag is Spoon, space key is milk !", 20, 20);
  text("fps: " + int(frameRate), 20, H*D-20); 
}

void drawParticles()
{
  for(int i=0; i<N; i++)
  {
    //水流的な挙動のシミュレートをu、vで行う。px,pyはu,vの演算を受けて、色が決まる、色配列。
    //     (↑px,pyの色データの影響を受ける)
    if(px[i]>2 && px[i]<W-2 && py[i]>2 && py[i]<H-2)
    {
      px[i] += u[int(px[i])][int(py[i])][0]*100;
      if(px[i]>2 && px[i]<W-2 && py[i]>2 && py[i]<H-2)
      {
        py[i] += v[int(px[i])][int(py[i])][0]*100;
      }
    }
    noStroke();
    fill(220,30);
    rect(px[i]*D,py[i]*D,2,2);
  }
}

void calc(){
  for(int i=0; i<W; i++){
    for(int j=0; j<H; j++){
      if(i==0 || i==W-1){
        u[i][j][1] = u[i][j][0]/2;
        v[i][j][1] = v[i][j][0]/2;
      }
      else if(j==0 || j==H-1){
        u[i][j][1] = u[i][j][0]/2;
        v[i][j][1] = v[i][j][0]/2;
      }
      else{
        u[i][j][1] = u[i][j][0];
        u[i][j][1] += u[i][j][0]*-dt/(2*dx)*(u[i+1][j][0] - u[i-1][j][0]);
        u[i][j][1] += v[i][j][0]*-dt/(2*dy)*(u[i][j+1][0] - u[i][j-1][0]);
        u[i][j][1] += nu*dt/(dx*dx)*(u[i+1][j][0] - 2*u[i][j][0] + u[i-1][j][0]);
        u[i][j][1] += nu*dt/(dy*dy)*(u[i][j+1][0] - 2*u[i][j][0] + u[i][j-1][0]);

        v[i][j][1] = v[i][j][0];
        v[i][j][1] += u[i][j][0]*-dt/(2*dx)*(v[i+1][j][0] - v[i-1][j][0]);
        v[i][j][1] += v[i][j][0]*-dt/(2*dy)*(v[i][j+1][0] - v[i][j-1][0]);
        v[i][j][1] += nu*dt/(dx*dx)*(v[i+1][j][0] - 2*v[i][j][0] + v[i-1][j][0]);
        v[i][j][1] += nu*dt/(dy*dy)*(v[i][j+1][0] - 2*v[i][j][0] + v[i][j-1][0]);
      }
    }
  }

  for(int i=0; i<W; i++){
    for(int j=0; j<H; j++){
      if(abs(u[i][j][1])>dx/dt) u[i][j][1]=(u[i-1][j][1]+u[i+1][j][1] + u[i][j-1][1]+u[i][j+1][1])/4;

      u[i][j][0] = u[i][j][1];

      if(abs(v[i][j][1])>dy/dt) v[i][j][1]=(v[i-1][j][1]+v[i+1][j][1] + v[i][j-1][1]+v[i][j+1][1])/4;

      v[i][j][0] = v[i][j][1];
    }
  }
}

void mouseDragged(){
  mouseMoved();
}

void mouseMoved(){
  //マウスのクリック位置を「カップの内側の領域だけ」のものへ変換している。
  int x = constrain(mouseX/D,0,W-1);
  int y = constrain(mouseY/D,0,H-1);
  int px = constrain(pmouseX/D,0,W-1);
  int py = constrain(pmouseY/D,0,H-1);
  text("x"+x+",y"+y, 20, H*D-40); 
  text("mouseX"+mouseX+"mouseY"+mouseY, 20, H*D-60); 
  if(mousePressed){
    u[x][y][0] =+ (x - px)*0.1;
    v[x][y][0] =+ (y - py)*0.1;
  }
  
  if(keyPressed){
    for(int i=0; i<200; i++){
      int r = int(random(N));
      this.px[r] = x+random(4)-2;
      this.py[r] =  y+random(4)-2;
    }  
  }
}

