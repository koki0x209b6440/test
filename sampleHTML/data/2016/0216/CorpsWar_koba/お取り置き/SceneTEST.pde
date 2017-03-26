class SceneTest extends HanyouBuffer
{
  float h, p, b;     // ヘディング・ピッチ・バンク回転量
  float dh, dp, db;  // 角速度
  int objColor, bgColor;
  
  SceneTest(PApplet papp)
  {
    super(papp);
  }
  SceneTest(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  void setup()
  {
    size(width,height,"P3D");
    
    // 色の付け方はてきとうです。
    objColor = color(random(100, 200), 
                             random(100, 200), 
                             random(100, 200));
    bgColor = color( red(objColor) + 55, green(objColor) + 55, blue(objColor) + 55);
    
    // 回転量・並進量を設定
    h = random(0, 360);
    p = random(-90, 90);
    b = random(0, 360);
    dh = random(-1, 1);
    db = random(-1, 1);
    dp = random(-1, 1);
  }
  
  void draw()
  {
    pg.camera();
    pg.lights();
    
    pg.background(bgColor);
    
    pg.noStroke();
    pg.fill(objColor);
    
    pg.pushMatrix();
    pg.translate(width/2, height/2, -width/2);
    pg.rotateY(radians(h));
    pg.rotateX(radians(p));
    pg.rotateZ(radians(b));
    pg.box(250);
    pg.popMatrix();
    
    h += dh;
    p += dp;
    b += db;
    
    pg.noLights();
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new ExplosionEffect(this,new SceneTest(papp,mypointer) );
    
    return this;
  }
}
