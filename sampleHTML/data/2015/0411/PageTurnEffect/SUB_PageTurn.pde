
/*
参考　[   ]
天気投影の方に上手く移植できなかったが、こちらには「ページ捲ってる途中で、
次のページがもう描画され始めている」の機能があって、更にページ捲りっぽい。
*/

interface Scene {
  Scene sceneWork();
}

class PageFlipEffect implements Scene
{
  private int time;
  private Scene next;
  
  private float pageturnTakeTime;
  private PImage front, back, nextImg;
  private PVector p1, p2, p3, p4;
  private PVector rightTop, rightBottom;
  private float rate;
  private int range_w,range_h,translate_x,translate_y;
  PageFlipEffect(Scene next,float pageturnTakeTime,     int translate_x,int translate_y,int range_w,int range_h)
  {
    this.pageturnTakeTime=pageturnTakeTime;
    this.translate_x=translate_x;
    this.translate_y=translate_y;
    this.range_w=range_w;
    this.range_h=range_h;
    this.next = next;
    time = 0;
    front  = createImage(width, height, RGB);/////現在表示中の
    back   = createImage(width, height, RGB);
    nextImg = createImage(width, height, RGB);
    p1 = new PVector();
    p2 = new PVector();
    p3 = new PVector();
    p4 = new PVector();
    rightTop = new PVector(range_w, 0);
    rightBottom = new PVector(range_w, range_h);
    loadPixels();//////////////////////////////////////////////ページ捲り中の捲られるページ、を作っておく
    for(int i = 0; i < pixels.length; i++) front.pixels[i] = pixels[i];
    updatePixels();
  }
  Scene sceneWork()
  {
    pageturn_setup();//////////////////////////////////////ページ捲り設定(動的な値設定)
    
    if(time==0)
    {
    next.sceneWork();/////////////////////////////////////////ページ捲り中の次のページ、を作っておく
    loadPixels();
    for(int i = 0; i < pixels.length; i++) nextImg.pixels[i] = pixels[i];
    updatePixels();
    }
    
    updateBack();     //ページ捲り中の捲られるページ、を描画(今表示しているもののコピー。)
    background(front); //
    noStroke();/////////////////////////////////////////////ページ捲り描画(紙的な部分)
    beginShape();
    texture(back);
    vertex(p1.x+translate_x, p1.y+translate_y, rightBottom.x, rightBottom.y);
    vertex(p2.x+translate_x, p2.y+translate_y, p2.x, p2.y);
    vertex(p3.x+translate_x, p3.y+translate_y, p3.x, p3.y);        
    if(p4 != null) vertex(p4.x+translate_x, p4.y+translate_y, rightTop.x, rightTop.y);
    endShape();
    
    beginShape();//////////////////////////////////////////ページ捲り中の次ページ、を描画(捲られてるページと同時描画)
    texture(nextImg);
    vertex(p2.x+translate_x, p2.y+translate_y, p2.x+translate_x, p2.y+translate_y);
    vertex(rightBottom.x+translate_x, rightBottom.y+translate_y, rightBottom.x+translate_x, rightBottom.y+translate_y);
    if(p4 != null) vertex(rightTop.x+translate_x, rightTop.y+translate_y, rightTop.x+translate_x, rightTop.y+translate_y);
    vertex(p3.x+translate_x, p3.y+translate_y, p3.x+translate_x, p3.y+translate_y);        
    endShape();
    
    time++; 
    if (time == pageturnTakeTime) {//ページ捲りが終わったタイミングで、画面遷移の実際の処理(時間で指定)
      return next;
    }
    return this;
  }
  
  

  private void pageturn_setup()
  {
    rate = (float)time / pageturnTakeTime;
    p2.x = range_w * (1.0 - rate);
    p2.y = range_h;
    if (rate * (range_w + range_h) < range_h) {////////////////ページ捲り、最初らへんの動き(必要設定)(ベクトル設定？)
      p3.x = range_w;
      p3.y = range_h - rate * (range_w + range_h);
      p4 = null;
    } else {////////////////////////////////////////////ページ捲り。後半の動き(必要設定)
      p3.x = range_w - (rate * (range_w + range_h) - range_h);
      p3.y = 0;
      p4 = getPointSymmetricAboutRay(p2, p3, rightTop);
    }
    p1 = getPointSymmetricAboutRay(p2, p3, rightBottom);
  }
  
  // 与えられた2点を通る光線に対して対称な点を得る
  private PVector getPointSymmetricAboutRay (PVector startPoint, PVector endPoint, PVector q) 
  {
    PVector p = startPoint;
    PVector d = PVector.sub(endPoint, startPoint);
    d.normalize();
    float   t = PVector.dot(d, PVector.sub(q, p));
    
    // 点に最接近する直線上の座標
    PVector _q = PVector.add(p, PVector.mult(d, t));
    return PVector.sub(_q, PVector.sub(q, _q));
  }  
  
  private final int SHADOW_WIDTH  = 20;   // 影の幅（あてにならない）
  private void updateBack()
  {
    // 影を作る
    int shadowBias = 150;
    background(0xFF);
    for(int i = SHADOW_WIDTH; i >= 0; i--) {
      float sRate = (float)i / SHADOW_WIDTH;
      int c = (int)(sRate * (0xFF - shadowBias) + shadowBias + 0.5);

      if(c > 0xFF) continue;
      stroke(c);
      strokeWeight(1 + i * 8);
      line(p2.x, p2.y, p3.x, p3.y);
      
    }
    //noStroke();
    loadPixels();
    for(int i = 0; i < front.pixels.length; i++) {
      int shadow = 0x000000FF & pixels[i];
      int c = front.pixels[i];
      int r = (0x00FF0000 & c) >>> 16;
      int g = (0x0000FF00 & c) >>> 8;
      int b =  0x000000FF & c;
      // 裏面を白に
      r = 255;
      g = 255;
      b = 255;
      // 影のグラデーション
      if(shadow < r) r = shadow;
      if(shadow < g) g = shadow;
      if(shadow < b) b = shadow;
      back.pixels[i] = 0xFF000000 | r << 16 | g << 8 | b;
    }
    updatePixels();
  }
}
