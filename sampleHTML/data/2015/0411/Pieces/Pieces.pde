/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/60348*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
State state;

PImage textureImage;
float  angle;        // カメラの回転角

void setup() {
  size(400, 300, P3D);
  frameRate(30);
  noStroke();
  
  textureImage = loadImage("texture.jpg");

  state = new Prepare();
}

void draw() {
  background(0);
  
  camera();
  lights();

  // カメラを適当に回転
  pushMatrix();
  translate(width / 2, 0, -width / 2);
  rotateY(radians(angle += 0.5f));
  translate(-width / 2, 0, 0);

  // 状態の更新
  state = state.update();
  
  popMatrix();
}


// 長方形の破片クラス
class RectFraction {
  private PVector size;           // 大きさ
  private PVector position;       // （最終的な）位置
  
  private PVector velocity;       // 速度

  private PVector angleVelocity;  // 角速度
  
  private int ttl;   // 寿命 (ttl: time to live)

  private int counter;
  
  private PVector currentPosition;
  private PVector currentRotation;
  
  private int delay;
  
  public RectFraction(int x, int y, int w, int h, int delay) {
    this.position      = new PVector(x, y);
    this.size          = new PVector(w, h);
    this.delay         = delay < 0 ? 0 : delay;
    
    this.velocity      = new PVector(random(-3, 3), 
                                     random(-3, 3), 
                                     random(-5, 5));
    this.angleVelocity = new PVector(radians(random(-3, 3)), 
                                     radians(random(-3, 3)), 
                                     radians(random(-3, 3)));
    this.counter       = 0;
    
    this.ttl           = 500;
    this.currentPosition = new PVector();
    this.currentRotation = new PVector();
  }
  
  // 描画
  public boolean render() {
    boolean retValue = false;
    
    ++counter;
    
    if(counter < delay) return retValue;
    
    if(counter > ttl + delay) {
      counter = ttl + delay;
      retValue = true;
    }
    
    int coef = ttl - (counter - delay);
    // 現在位置の計算
    currentPosition.x = position.x + coef * velocity.x;
    currentPosition.y = position.y + coef * velocity.y;
    currentPosition.z = position.z + coef * velocity.z;   

    // 角変位の計算
    currentRotation.x = coef * angleVelocity.x;
    currentRotation.y = coef * angleVelocity.y;
    currentRotation.z = coef * angleVelocity.z;
    
    pushMatrix();

    // 座標変換
    translate(currentPosition.x, currentPosition.y, currentPosition.z);

    rotateY(currentRotation.y);
    rotateX(currentRotation.x);
    rotateZ(currentRotation.z);
    
    // 描画
    beginShape();
    texture(textureImage);
    vertex(-0.5f * size.x, -0.5f * size.y, 0.5f * size.z, position.x - size.x / 2, position.y - size.y / 2);
    vertex(-0.5f * size.x,  0.5f * size.y, 0.5f * size.z, position.x - size.x / 2, position.y + size.y / 2);
    vertex( 0.5f * size.x,  0.5f * size.y, 0.5f * size.z, position.x + size.x / 2, position.y + size.y / 2);
    vertex( 0.5f * size.x, -0.5f * size.y, 0.5f * size.z, position.x + size.x / 2, position.y - size.y / 2);
    endShape();
    
    popMatrix();
    
    return retValue;
  }
}
