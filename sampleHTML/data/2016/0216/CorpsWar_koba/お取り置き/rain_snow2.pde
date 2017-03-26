class WallSnow extends HanyouBuffer
{
  PImage output;
  ArrayList drops;
  
  int dropSnowAngle; // dropの角度
  int angleSnowRevision = 2; // dropの角度の補正
  int dropSnowSpeed = 0; // dropの速さ
  int dropSnowNumber = 25; // dropの数
  int dropSnowThick = 4; // dropの太さ
  
  float frameDropSnowSpeed = 0; // 波紋のfpsによる速さの変化
  int dropSnowSpeedControl = 72; // 雪跡の速さを制御するための変数
  WallSnow(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(papp.width/RainController.graphicsSize, papp.height/RainController.graphicsSize,"P2D");
    pg.smooth();
    drops = new ArrayList();
    dropSnowAngle=-1;
  }
  
  void draw()
  {
    if(RainController.stop==false)
    {
      work();
      pg.background(0);
      for(int i = drops.size()-1; i >= 0; i--)
      {
        SnowDrop drop = (SnowDrop) drops.get(i);
        drop.move();
        drop.display(dropSnowThick);
        if(drop.finished())  drops.remove(i); 
      }    
      output = pg.get(0, 0, pg.width, pg.height); // オフスクリーンの画像を保持
      output.filter(BLUR, RainController.gra-1); // 画像をぼかす
      pg.background(0);
      /* ぼかしによる表示のさせ方の切り替え */
      if(RainController.gra_flag == true)
      {
        pg.image(output, 0, 0);
        for(int i = drops.size()-1; i >= 0; i--)
        {
          SnowDrop drop = (SnowDrop) drops.get(i);
          drop.display(dropSnowThick-1);
        }
        output = pg.get(0, 0, pg.width, pg.height);
      }
      pg.image(output,0,0);
      /* 雨滴の追加 */
      if(drops.size() < dropSnowNumber)
        drops.add(new SnowDrop(int(random(pg.width*2)), int(random(-50, 0)), int(random(30)),int(random(3)), dropSnowSpeed, dropSnowAngle, RainController.raincolor.getColor(), pg));
      if(drops.size() < dropSnowNumber && drops.size() > int(pg.width/dropSnowSpeed)/2)
        drops.add(new SnowDrop(int(random(pg.width*2)), int(random(-50, 0)), int(random(30)),int(random(3)), dropSnowSpeed, dropSnowAngle, RainController.raincolor.getColor(), pg));
      if(drops.size() < dropSnowNumber && drops.size() > int(pg.width/dropSnowSpeed)*3/2) 
        drops.add(new SnowDrop(int(random(pg.width*2)), int(random(-50, 0)), int(random(30)),int(random(3)), dropSnowSpeed, dropSnowAngle, RainController.raincolor.getColor(), pg));  
  } }
  void work()
  {
    frameDropSnowSpeed = dropSnowSpeedControl/round(frameRate);
    dropSnowSpeed = (int)frameDropSnowSpeed + RainController.variDropSpeed;
  }
  
  
}





class SnowDrop {
  
  
 int x1, x2; // 雨滴のx座標
 int y1, y2; // 雨滴のy座標
 int size; // 跳ね返りのサイズ
 int speed; // 雨の速さ
 int angle; // 雨の角度
 float R, G, B; // 雨滴の色
 color c1, c2; // 跳ね返りの色
 PGraphics pg; // オフスクリーンのためのオブジェクト
 
 float A;
 int ran;
 
 SnowDrop(int dropX, int dropY, int reboundSize,int rand, int dropSnowSpeed, int dropSnowAngle,color c, PGraphics _pg) {
   
   pg = _pg;
   
   /* 角度をつけた分、テクスチャをずらす(表示位置全体に雨滴を表示させるため) */
   /* この処理を施さないと、雨滴が表示されない部分が出る */
   if(dropSnowAngle >= 0) {
     x1 = dropX - int(dropSnowAngle*pg.width*0.35);
     //x2 = dropX - int(dropAngle*pg.width*0.1);
   } else if(dropSnowAngle < 0) {
     x1 = dropX;
     //x2 = dropX;
   }
   
   y1 = dropY;
   //y2 = y1;
   size = reboundSize;
   //speed = dropSpeed;
   angle = dropSnowAngle;   
   //x2 = x2 + angle;
   
   R = red(c);
   G = green(c);
   B = blue(c);
   
   
    ran = rand;
    
    if(ran == 0){
    R = R;
    G = G;
    B = B;
    
   speed = dropSnowSpeed;

    
    }else if(rand == 1){
    R = R * 2 / 3;
    G = G * 2 / 3;
    B = B * 2 / 3;
    
       speed = dropSnowSpeed * 4 / 5;
    
    }else if(rand == 2){
    R = R / 3;
    G = G / 3;
    B = B / 3;
    
       speed = dropSnowSpeed * 3 / 5;
    }
   
   
   c1 = color(R, G, B);
   c2 = color(0, 0, 0);
 }
 
  void move() {   
    //y2 = y2 + speed;
    x1 = x1 + angle;
    y1 += speed;
    //x2 += angle;
    /*
    if(y2-y1 > speed) {
      y1 = y1 + speed;
    }
    */
  }
  void display(float thick) {
    pg.stroke(R, G, B);
    pg.strokeWeight(thick);
    pg.ellipse(x1, y1, thick, thick);
   
    /* 跳ね返りの処理 
    if(y2 >= pg.height && rebound == true) {
      pg.noStroke();
      for(float i = size; i > 0; i--) {
        pg.fill(lerpColor(c1, c2, i/size));
        pg.ellipse(x2, pg.height-3, i, i);
      }
    }
    */
  }
  //* 雨滴が下まで落ちたら、次の雨滴へ *//
  boolean finished() {
    if (y1 > pg.height) {
      return true;
    } else {
      return false;
    }
  }
}


