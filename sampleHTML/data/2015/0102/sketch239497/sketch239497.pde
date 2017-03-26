/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/239497*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
Boss boss;
String[] mystring={"弾幕もどき","360度（仮）","花（仮）"};
void setup() {
  size(320, 320);
  frameRate(30);
  rectMode(CENTER); // center mode
  boss = new Boss(width / 2, 60, 40);

}

//弾幕の設定
class Tama {

 PVector location;//位置
 PVector velocity;//速度
 float tr;//球のおおきさ
  Tama(float x, float y, float r, float ldx, float ldy) {
    location=new PVector(x,y);
    velocity=new PVector(ldx,ldy);
    tr=r;
  }
  
 //弾の位置更新
  boolean update() {
    //更新
    location.x+=velocity.x;
    location.y+=velocity.y;
    stroke(255, 255, 0);
    noFill();
    ellipse(location.x , location.y , tr , tr);
   
    // エリアチェック
    if (location.x > height || location.y < 0 || location.x > width || location.x < 0) {
        return false;
    }
   
    return true;
  }
  
  
}
//
class Boss {
  int hp, bw;
  float bx, by, bcx;
  ArrayList danmaku;
 
  Boss(float x, float y, int w) {
    bx = bcx = x;
    by = y;
    bw = w;
    hp = 256;
    danmaku = new ArrayList();
  }
 
 
  void fire_flower(float x, float y) { 
  float rad;
  
    //弾幕の模様を決める
    for (int i = 0; i < 360*9; i+= 10) {
      //花を描く
     rad=radians(i);
      final float rc = 0.085; //  値を決める
      final float rm = 0.11; //  値を決める
      float xpoint = 6*((rc - rm) * cos(rad) + rm * cos((rc - rm) / rm * rad));
      float ypoint = 6*((rc - rm) * sin(rad) - rm * sin((rc - rm) / rm * rad)); 
      
      danmaku.add(new Tama(x, y, 10, xpoint,ypoint ));
    }
  }
 
  //
  void fire_360(float x, float y) { 
  float rad;
    //弾幕の模様を決める
    for (int i = 0; i < 360; i+= 10) {
      //円を描く
      rad = radians(i);
      float xpoint=cos(rad);
      float ypoint=sin(rad);
      danmaku.add(new Tama(x, y, 10, xpoint,ypoint ));
    }
  }
  //
  void update() {
    // ボスの動きを決める
    float dx;
    //dx = 50.0 * sin(radians(frameCount * 4));
    dx=0;
    bx = bcx + dx;
    stroke(255,0,0);
    fill(256 - hp, 0, 0);
    rect(bx, by, bw, 20);
    
    fill(255);
    text(mystring[2],0,10);
  
    // 発射タイミング
    if (frameCount % 75 == 0)
      fire_flower(bx, by);//使う球の種類
  
  
  
    // 弾幕をアップデート
    for (int i = danmaku.size() -1; i >= 0; i--) {
      Tama t = (Tama)danmaku.get(i);
      if (t.update() == false)
        danmaku.remove(i);
    }
  }
}

void draw() {
   background(0); 
   boss.update();
}
  