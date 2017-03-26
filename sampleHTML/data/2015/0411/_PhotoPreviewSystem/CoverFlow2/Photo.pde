class Photo {
  int width  = 640;
  int height = 480;
  
  double x;
  double z;
  private double angle;
  double nX;
  private double rate = 4.0;
  
  PImage img;
  
  Photo(String fileName) {
    img  = loadImage(fileName);
    if(img == null) {
      img = createImage(128, 128, RGB);
      for(int i = 0; i < img.pixels.length; i++) {
        img.pixels[i] = 0xFFFFFFFF;
      }
    }
    //createShadow();
  }
  
  void update() {
    z = 0;
    angle = MAX_ANGLE;
    if(nX < 0) angle = -angle;
    noStroke();
    fill(255);
    
    if(abs((float)x) <= interval + 0.1) {
      x = nX;
      angle = MAX_ANGLE * x / interval;
      z = offsetZ * (interval - abs((float)nX))/interval;
    } else {
      x = nX;
      double offset = interval;
      if(nX < 0) offset = -offset;
      x -= offset;
      x /= rate;
      x += offset;
    }
    
    pushMatrix();
    translate((float)x, 0, (float)z);
    rotateY(-(float)angle);
    
    // =====================================================
    // テクスチャマッピング
    // P3D モードでも極力テクスチャが歪まないようにしている。
    // =====================================================
    int   n     = 20; // 分割数
    float dW    = (float)this.width / n;
    float dTexW = (float)img.width  / n;
    
    beginShape(QUAD_STRIP);
    texture(img);
    for(int i = 0; i <= n; i++) {
      vertex(-this.width / 2.0 + i*dW, -this.height / 2.0, i*dTexW, 0);
      vertex(-this.width / 2.0 + i*dW,  this.height / 2.0, i*dTexW, img.height);
    }
    endShape();
    
    //renderShadow(n,dW,dTexW);
    
    popMatrix();
  }
  
  
  
  
  PImage shadowImg;
  void createShadow()
  {
    shadowImg = createImage(img.width, img.height, RGB);
    
    // =====================================================
    // 影画像の作成
    // 画像の高さに応じて減衰の強さを計算する
    // =====================================================
    float a = 100;
    float dA = - (float)0xFF / img.height;
    for(int iy = 0; iy < shadowImg.height; iy++) {
      for(int ix = 0; ix < shadowImg.width; ix++) {
        if( a < 0 ) a = 0;
        int i = iy * shadowImg.width + ix;
        int c = img.pixels[(img.height - iy - 1)*img.width + ix];
        
        int fg = c;
        int fR = (0x00FF0000 & fg) >>> 16; 
        int fG = (0x0000FF00 & fg) >>> 8;
        int fB =  0x000000FF & fg;
        
        int bR = (0x00FF0000 & bgColor) >>> 16;
        int bG = (0x0000FF00 & bgColor) >>> 8;
        int bB =  0x000000FF & bgColor;
        
        int rR = (fR * (int)a + bR * (int)(0xFF - a)) >>> 8;
        int rG = (fG * (int)a + bG * (int)(0xFF - a)) >>> 8;
        int rB = (fB * (int)a + bB * (int)(0xFF - a)) >>> 8;
        
        shadowImg.pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      }
      a += dA;
    }
  }
  void renderShadow(int n,float dW,float dTexW)
  {
    // 影
    noLights();
    beginShape(QUAD_STRIP);
    texture(shadowImg);
    for(int i = 0; i <= n; i++) {
      vertex(-this.width / 2.0 + i*dW, this.height / 2.0, i*dTexW, 0);
      vertex(-this.width / 2.0 + i*dW, this.height * 3.0 / 2.0, i*dTexW, shadowImg.height);
    }    
    endShape();
  }
}
