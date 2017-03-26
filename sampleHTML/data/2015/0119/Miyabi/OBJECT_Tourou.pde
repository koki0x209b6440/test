class Tourou {
  public float angle;    // 回転角変位
  private float da;
  
  public float   x, z;   // 並進位置
  private PImage tex;    // テクスチャ
  private PImage ref;    // リフレクション
  private PImage ground; // 地面（リフレクション用）
  private float  w, h;   // レンダリングするパネルの幅と高さ

  Tourou(PImage tex) {
    this.w = 480;

    float scaleFactor = this.w / tex.width;
    this.h = tex.height * scaleFactor;
    
    this.tex = tex;
    this.tex.resize(64, 64);
    
    createRefrectionTexture(this.tex);
    
    this.da = radians(random(-1, 1));
  }
  
  void update() {
    angle += da;
  }
  
  void render() {
    pushMatrix();
    translate(x, 0, z);
    rotateY(angle);
    
    // =====================================================
    // テクスチャマッピング
    // P3D モードでも極力テクスチャが歪まないようにしている。
    // =====================================================
    int   n     = 20; // 分割数
    float dW    = (float)w / n;
    float dTexW = (float)tex.width  / n;
     
    // 4面描画
    for(int j = 0; j < 4; j++) {
      pushMatrix();
      
      rotateY(j * radians(90));
      translate(0, 0, w/2);
      
      beginShape(QUAD_STRIP);
      texture(tex);
      for(int i = 0; i <= n; i++) {
        vertex(-w / 2.0 + i*dW, -h / 2.0, i*dTexW, 0);
        vertex(-w / 2.0 + i*dW,  h / 2.0, i*dTexW, tex.height-1);
      }
      endShape();
      popMatrix();
    }
    
    popMatrix();
  }

  void renderRefrection() {
    pushMatrix();
    translate(x, 0, z);
    rotateY(angle);
    
    // =====================================================
    // テクスチャマッピング
    // P3D モードでも極力テクスチャが歪まないようにしている。
    // (ぐにゃぐにゃ感で水面反射の雰囲気を出しているのでおかしな言い方だが、要は「箱の反射なのに台形になっちゃった」みたいな不自然さをマジックナンバー的に抑制したという話。)
    // =====================================================
    int   n     = 10; // 分割数//増やすと、より詳細に歪みを施す。しかし、それがリアルさに繋がるとは限らない。
    float dW    = (float)w / n;
    float dTexW = (float)ref.width  / n;
    
    beginShape(QUADS);
    texture(ground);
    vertex(-w/2, h/2, -w/2, 0,           0);
    vertex(-w/2, h/2,  w/2, 0,           tex.height-1);
    vertex( w/2, h/2,  w/2, tex.width-1, tex.height-1);
    vertex( w/2, h/2, -w/2, tex.width-1, 0);
    endShape();
    
    for(int j = 0; j < 4; j++) {
      pushMatrix();

      rotateY(j * radians(90));
      translate(0, 0, w/2);
      
      beginShape(QUAD_STRIP);
      texture(ref);
      for(int i = 0; i <= n; i++) {
        vertex(-w / 2.0 + i*dW, h / 2.0, i*dTexW, 0);
        vertex(-w / 2.0 + i*dW, h * 3.0/ 2.0, i*dTexW, ref.height-1);
      }
      endShape();
      popMatrix();
    }
    
    popMatrix();
  }
  

  private void createRefrectionTexture(PImage tex) {
    ref    = createImage(tex.width, tex.height, RGB);
    ground = createImage(tex.width, tex.height, RGB);
    
    float a, ca;   // リフレクションの強さ
    a = ca = 150;  // 初期値
    float dA = - (float)0xFF / tex.height;
    
    for(int iy = 0; iy < ref.height; iy++) {
      for(int ix = 0; ix < ref.width; ix++) {
        if( ca < 0 ) ca = 0;
        int i = iy * ref.width + ix;
        int c = tex.pixels[(tex.height - iy - 1)*tex.width + ix];
           
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
        ground.pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
        
        rR = (fR * (int)ca + bR * (int)(0xFF - ca)) >>> 8;
        rG = (fG * (int)ca + bG * (int)(0xFF - ca)) >>> 8;
        rB = (fB * (int)ca + bB * (int)(0xFF - ca)) >>> 8;   
        ref.pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      }
      ca += dA;
    }
  }
}
