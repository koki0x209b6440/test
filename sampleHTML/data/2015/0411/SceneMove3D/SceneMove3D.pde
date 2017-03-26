/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/30066*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
Scene scene;

void setup() {
  size(400, 300, P3D);
  scene = new Scene1();
}
void draw() {
  background(255, 0, 0, 10);
  scene = scene.update();
}

// =======================================================
// デモ用の状態クラス
// =======================================================
class Scene1 implements Scene {
  float h, p, b;     // ヘディング・ピッチ・バンク回転量
  float dh, dp, db;  // 角速度
  int objColor, bgColor;
  boolean isEnable;
  

  Scene1() {
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
    
    isEnable = true;
  }
  
  Scene update() {
    camera();
    lights();
    
    background(bgColor);
    
    noStroke();
    fill(objColor);
    
    pushMatrix();
    translate(width/2, height/2, -width/2);
    rotateY(radians(h));
    rotateX(radians(p));
    rotateZ(radians(b));
    box(250);
    popMatrix();
    
    h += dh;
    p += dp;
    b += db;
    
    noLights();
        
    if (mousePressed && isEnable) {
      return new StateTransitionEffect(this, new Scene1());
    } else {
      return this;
    }
  }
  
  void setEnable(boolean isEnable) {
    this.isEnable = isEnable;
  }
}
