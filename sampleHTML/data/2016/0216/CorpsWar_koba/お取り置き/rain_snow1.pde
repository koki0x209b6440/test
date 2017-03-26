


class FloorSnow extends HanyouBuffer
{
  ArrayList snowy;
  PImage output;
  
  int snowTime = 100; //snowの消え始めるまでの時間
  float snowSpeed = 0; //snowの消えるまでの時間
  int snowNumber = 200; //snowの数
  int snowThick = 2; //snowの太さ
  int snowSize = 0; //snowの大きさ
  float frameSnowSpeed = 0; // 波紋のfpsによる速さの変化
  int snowSpeedControl = 60; // 雪跡の速さを制御するための変数
  
  FloorSnow(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(papp.width/RainController.graphicsSize, papp.height/RainController.graphicsSize,"P2D");
    snowy = new ArrayList();
    RainController.raincolor=new ColorObject(255,255,255,255);
  }
  
  void draw()
  {
    
    if(RainController.stop==false)
    {
      work();
      pg.background(0);
    
      pg.scale(1.2, 1);
      for (int i = snowy.size()-1; i >= 0; i--)
      { 
        Snow snow = (Snow) snowy.get(i);
        snow.move();
        snow.display(snowThick);
        if (snow.finished()) snowy.remove(i);
      }
      pg.scale(1/1.2, 1);
      output = pg.get(0, 0, pg.width, pg.height); // オフスクリーンの画像を保持
      output.filter(BLUR, RainController.gra); // 画像をぼかす
      pg.background(0);
      /* ぼかしによる表示のさせ方の切り替え */
      if(RainController.gra_flag == true)
      {
        pg.image(output, 0, 0);
        pg.scale(1.2, 1);
        for(int i = snowy.size()-1; i >= 0; i--)
        {
          Snow snow = (Snow) snowy.get(i);
          snow.display(snowThick-1);
        }
        output = pg.get(0, 0, pg.width, pg.height);
        pg.scale(1/1.2, 1);
      }
      pg.image(output,0,0);
      /* 波紋の追加 */
      if(snowy.size() < snowNumber)
         snowy.add(new Snow(int(random(pg.width)), int(random(pg.height)), snowSpeed, RainController.raincolor.getColor(), snowSize,snowTime, pg));
      if(snowy.size() < snowNumber && snowy.size() > int(pg.width/snowSpeed)/5)
         snowy.add(new Snow(int(random(pg.width)), int(random(pg.height)), snowSpeed, RainController.raincolor.getColor(), snowSize,snowTime, pg));
  } }
  void work()
  {
    frameSnowSpeed = snowSpeedControl/round(frameRate);
    snowSpeed = frameSnowSpeed + RainController.variRippleSpeed;
    colorcontrol("SNOW(rain)",RainController.raincolor,'s');
  }
  
  
}




class Snow {
  int x, y; // 波紋の位置座標
  float w = 5; // 波紋の大きさの半径
  float colorSpeed; // 色の変化の速さ
  float lengthSpeed; // 波紋が大きくなる速さ
  float R, G, B; // 波紋の色
  int size; // 波紋の半径の最大値
  PGraphics pg; // オフスクリーンのためのオブジェクト
  
  int timeout;
  
  Snow(int snowX, int snowY, float snowSpeed, color c, int snowSize,int snowTime, PGraphics _pg)
  {
    pg = _pg;
    
    x = snowX;
    y = snowY;
    
    colorSpeed = snowSpeed;
    lengthSpeed = snowSpeed*0.05;
    
    R = red(c);
    G = green(c);
    B = blue(c);
    
    size = snowSize;
    w+=size;
    timeout=snowTime;
  }
  void move()
  {
    if(timeout < 0) {
    w = w - lengthSpeed;
    }else{
      timeout -= 1;
    }
  }
  void display(float thick)
  {
    //pg.noFill();
    //pg.fill(R,G,B);
    pg.strokeWeight(thick);
    pg.stroke(R, G, B);
    pg.ellipse(x,y,w,w);
    pg.stroke(255);
  }
  
  //* 波紋の半径が最大値に達したら、次の波紋へ *//
  boolean finished()
  {
    if(w < 1) return true;
    else return false;
  }
}
