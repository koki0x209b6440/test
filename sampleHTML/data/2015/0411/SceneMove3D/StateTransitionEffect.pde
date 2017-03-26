// **************************************
//
// 画面遷移用クラス
//
// **************************************
class StateTransitionEffect implements Scene {
  private final int MAX_TIME   = 90;
  private final int FADE_DELAY = 80;

  private PImage nextSceneImage;
  private Fragments fragments;
  private int time;
  private Scene cur, next;//cur  :前状態      next : 次状態 
  
  StateTransitionEffect(Scene cur, Scene next) {
    this.cur = cur;
    this.next = next;
    
    nextSceneImage = createImage(width, height, RGB);

    cur.setEnable(false);
    next.setEnable(false);
    
    fragments = new Fragments(50);
    time = 0;
  }
  
  Scene update(){
    camera();
    noStroke();
    next.update();
    
    int a;  // アルファ値（フェード効果で使用）
    
    loadPixels();
    for(int i = 0; i < pixels.length; i++)  nextSceneImage.pixels[i] = pixels[i];
    background(nextSceneImage);
    
    // 次状態のフェードイン効果
    /* --------------------------------------------------
    a = (int)(255 * (float)(MAX_TIME - time) / MAX_TIME);
    fill(0, a);
    rect(0, 0, width, height);
    -------------------------------------------------- */
    
    // 破片の描画
    fragments.update();
    /*
    // 破片のフェードアウト効果
    if (FADE_DELAY <= time) {
      a = (int)(255*(float)(time-FADE_DELAY)/(MAX_TIME-FADE_DELAY));

      loadPixels();
      // アルファ合成
      for(int i = 0; i < pixels.length; i++) {
        int fg = nextSceneImage.pixels[i];
        int bg = pixels[i];
        
        int fR = (0x00FF0000 & fg) >>> 16;
        int fG = (0x0000FF00 & fg) >>> 8;
        int fB =  0x000000FF & fg;
      
        int bR = (0x00FF0000 & bg) >>> 16;
        int bG = (0x0000FF00 & bg) >>> 8;
        int bB =  0x000000FF & bg;
      
        int rR = (((fR - bR) * a) >>> 8 ) + bR;
        int rG = (((fG - bG) * a) >>> 8 ) + bG;
        int rB = (((fB - bB) * a) >>> 8 ) + bB;
        
        pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      }
      updatePixels();
    }
    */
    if(time++ < MAX_TIME) return this;
    
    next.setEnable(true);
    return next;
  }
  
  void setEnable(boolean isEnable) { 
    /* なにもしない */
  }
}
