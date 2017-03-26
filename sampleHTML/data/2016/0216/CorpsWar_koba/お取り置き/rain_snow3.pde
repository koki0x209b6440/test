class WallSnow_ll extends HanyouBuffer
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
  WallSnow_ll(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(papp.width/RainController.graphicsSize, papp.height/RainController.graphicsSize,"P2D");
    pg.smooth();
    drops = new ArrayList();
    dropSnowAngle=1;
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
