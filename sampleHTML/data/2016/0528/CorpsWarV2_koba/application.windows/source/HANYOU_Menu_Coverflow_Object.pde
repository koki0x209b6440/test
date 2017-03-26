/*
　This program is
　このプログラムは、シーン選択画面の一部描画部分(シーン選択画面のシーン選択部分)。どれを選んでいるかの番号もこちらで用意する(その番号を元に、出力HanyouBufferをするというか決める)
　あと、カバーフロウに表示する一枚絵をCoverflowObjectとして定義している。角度とか。
*/
class CoverflowObject
{ 
  int width  = 640;
  int height = 480;
  
  double x;
  double z;
  private double angle;
  double nX;
  private double rate = 4.0;
  HanyouBuffer img;
  int number;
  Coverflow system;
  
  CoverflowObject(Coverflow system,int number,HanyouBuffer img)
  {
    this.system=system;
    this.number=number;
    this.img=img;
    PImage buff;
    for(int i=0; i<3; i++)buff=img.getImage(NOT_WORK);
  }
  void update(PGraphics pg) {
    z = 0;
    angle = system.MAX_ANGLE;
    if(nX < 0) angle = -angle;
    pg.noStroke();
    pg.fill(255);
    
    if(abs((float)x) <= system.interval + 0.1) {
      x = nX;
      angle = system.MAX_ANGLE * x / system.interval;
      z = system.offsetZ * (system.interval - abs((float)nX))/system.interval;
    } else {
      x = nX;
      double offset = system.interval;
      if(nX < 0) offset = -offset;
      x -= offset;
      x /= rate;
      x += offset;
    }
    
    pg.pushMatrix();
    pg.translate((float)x, 0, (float)z);
    pg.rotateY(-(float)angle);
    
    // =====================================================
    // テクスチャマッピング
    // P3D モードでも極力テクスチャが歪まないようにしている。
    // =====================================================
    int   n     = 20; // 分割数
    float dW    = (float)this.width / n;
    float dTexW = (float)img.getImage(DRAW_ONLY).width  / n;
    
    pg.beginShape(QUAD_STRIP);
    if(system.renderingTimer() )
    {
      if(number==system.target) pg.texture(img.getImage(NOT_WORK)   );
      else if(system.isSave)                        pg.texture(img.getImage(DRAW_ONLY)   );
      else pg.texture(img.getImage(DRAW_ONLY)   );
    }
    else pg.texture(img.getImage(DRAW_ONLY)   );
    for(int i = 0; i <= n; i++) {
      pg.vertex(-this.width / 2.0 + i*dW, -this.height / 2.0, i*dTexW, 0);
      pg.vertex(-this.width / 2.0 + i*dW,  this.height / 2.0, i*dTexW, img.getImage(DRAW_ONLY).height);
    }
    pg.endShape();
    if(count>1000)count=0;
    //renderShadow(pg,n,dW,dTexW);
    
    pg.popMatrix();
  }
  int count=0;
  
  
  
  PImage shadowImg;
  void createShadow()
  {
    shadowImg = createImage(img.getImage(DRAW_ONLY).width, img.getImage(DRAW_ONLY).height, RGB);
    
    // =====================================================
    // 影画像の作成
    // 画像の高さに応じて減衰の強さを計算する
    // =====================================================
    float a = 100;
    float dA = - (float)0xFF / img.getImage(DRAW_ONLY).height;
    for(int iy = 0; iy < shadowImg.height; iy++) {
      for(int ix = 0; ix < shadowImg.width; ix++) {
        if( a < 0 ) a = 0;
        int i = iy * shadowImg.width + ix;
        int c = img.getImage(DRAW_ONLY).pixels[(img.getImage(DRAW_ONLY).height - iy - 1)*img.getImage(DRAW_ONLY).width + ix];
        
        int fg = c;
        int fR = (0x00FF0000 & fg) >>> 16; 
        int fG = (0x0000FF00 & fg) >>> 8;
        int fB =  0x000000FF & fg;
        
        int bR = (0x00FF0000 & system.bgColor) >>> 16;
        int bG = (0x0000FF00 & system.bgColor) >>> 8;
        int bB =  0x000000FF & system.bgColor;
        
        int rR = (fR * (int)a + bR * (int)(0xFF - a)) >>> 8;
        int rG = (fG * (int)a + bG * (int)(0xFF - a)) >>> 8;
        int rB = (fB * (int)a + bB * (int)(0xFF - a)) >>> 8;
        
        shadowImg.pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      }
      a += dA;
    }
  }
  void renderShadow(PGraphics pg,int n,float dW,float dTexW)
  {
    // 影
    pg.noLights();
    pg.beginShape(QUAD_STRIP);
    pg.texture(shadowImg);
    for(int i = 0; i <= n; i++) {
      pg.vertex(-this.width / 2.0 + i*dW, this.height / 2.0, i*dTexW, 0);
      pg.vertex(-this.width / 2.0 + i*dW, this.height * 3.0 / 2.0, i*dTexW, shadowImg.height);
    }    
    pg.endShape();
  }
  
}


















class Coverflow extends HanyouBuffer
{
  SampleList samplelist;
  CoverflowObject[] cfo;
  
  final float MAX_ANGLE = radians(70);  // ジャケットの最大傾斜角
  final float interval = 500;           // 間隔
  final int   offsetZ  = 400;           // Z方向の移動分
  final int   bgColor  = color(255, 255, 255);
  int target=0;
  boolean isSave=false;
  
  Coverflow(PApplet papp,SampleList samplelist)
  {
    super(papp);
    this.samplelist=samplelist;
  }
  void setSampleList(SampleList samplelist)
  {
    this.samplelist=samplelist;
    first();
  }
  void setPApp(PApplet papp)
  {
    this.papp=papp;
    samplelist.setPApp(papp);
  }
  
  void setup()
  {
    size(400,250,"P3D");
    first();
  }
  void first()
  {
    cfo=new CoverflowObject[samplelist.size()];
    target=cfo.length/2;
    int i=0;
    Iterator it=samplelist.scenelist.keySet().iterator();
    while(it.hasNext() )
    {
      Object o=it.next();
      cfo[i] = new CoverflowObject(this,i,samplelist.scenelist.get(o) );
      cfo[i].nX = (i - cfo.length / 2) * interval;
      i++;
    }
  }
  
  int count=0;
  void draw()
  {
    if(int(frameRate)<Menu_FPS_MIN) isSave=true;
    
    pg.background(0,0,0,0);
    pg.camera(0, 0, 1200, 0, 0, 0, 0, 1, 0);
    if(!isSave)pg.background(bgColor);
    else pg.background(red(bgColor)-100,green(bgColor)-100,blue(bgColor)-100);
    pg.hint(ENABLE_DEPTH_SORT);
    for(int i = 0; i < cfo.length; i++) cfo[i].update(pg);
    if(!papp.mousePressed)keycontrol();
    else mousecontrol();
  }
  
  boolean Ekey=false;
  HanyouBuffer get()
  {
    timercount++;
    if(papp.keyPressed)
    {
      if(papp.key==ENTER && Ekey==false)
      {
        Ekey=true;
        return cfo[target].img;
      }
    }
    else Ekey=false;
    return null;
  }


  boolean Nkey=false,Pkey=false;
  void keycontrol()
  {
    if(papp.keyPressed)
    {
      if(papp.keyCode==RIGHT && Nkey==false)
      {
        Nkey=true;
        if(target<cfo.length-1)target++;
        isSave=false;
      }
      if(papp.keyCode==LEFT && Pkey==false)
      {
        Pkey=true;
        if(target>0)target--;
        isSave=false;
      }
    }
    else
    {
      Nkey=false;
      Pkey=false;
    }
    double offsetX=-cfo[target].nX * 0.1;
    for(int i = 0; i < cfo.length; i++) cfo[i].nX += offsetX;
  }
  
  void mousecontrol()
  {
    double minX = 9999;
    for(int i = 0; i < cfo.length; i++)
    { 
      if(abs((float)cfo[i].nX) < abs((float)minX))
      {
        minX = cfo[i].nX;
        target=i;
      }
    }
    double offsetX;
    if(papp.mousePressed) offsetX = 6*(papp.mouseX - papp.pmouseX);
    else offsetX = -minX * 0.1;
    for(int i = 0; i < cfo.length; i++) cfo[i].nX += offsetX;
  }
  
  int timercount=0;
  boolean renderingTimer()   //rendering kankaku
  {
    int a=10;
    if(timercount%a==0) return true;
    if(timercount>1000)timercount=0;
    return false;
  }
  
  
}












