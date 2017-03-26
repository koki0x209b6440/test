
class FlareRain extends FlareImageObject
{
  final int RAIN_NUM=3;
  int[] x;
  int[] y;
  FlareRain(PApplet papp)                        {  super(papp);                 }
  FlareRain(PApplet papp,String imgname) {  super(papp,imgname);  }
  FlareRain(PApplet papp,PImage img)      {  super(papp,img);          }
  void setup()
  {
    size(300,300,"P2D");
    effect_setup();
    
    x=new int[RAIN_NUM];
    y=new int[RAIN_NUM];
    for(int i=0; i<RAIN_NUM; i++)
    {
      x[i]=(int)random(0,pg.width);
      y[i]=0;
    }
  }
  void draw()
  {
    pg.background(0,0,0,0);
    
    for(int i=0; i<RAIN_NUM; i++)
    {
      x[i]+=1;
      y[i]+=2;
      if(x[i]<0 || pg.width<x[i]    ||     y[i]<0 || pg.height<y[i])
      {
        x[i]=(int)random(0,pg.width);
        y[i]=0;
      }
      pg.image(img,x[i],y[i]);
    }
    
    calcEffect();
  }
  
}



////////////////////////////////////////////////////////////////////////////////////////////////////
class FlareImageObject extends HanyouBuffer
{
  PImage img;
  String imgname;
  
  PGraphics buff;
  FlareImageObject(PApplet papp)
  {
    super(papp);
    imgname="data/sample.jpg";
    img=loadImage(imgname);
  }
  FlareImageObject(PApplet papp,String imgname)
  {
    super(papp);
    this.imgname=imgname;
    img=loadImage(imgname);
  }
  FlareImageObject(PApplet papp,PImage img)
  {
    super(papp);
    this.img=img;
  }
  
  
  void setup()
  {
    size(img.width,img.height,"P2D");
    effect_setup();
  }
  void effect_setup()
  {
    buff=createGraphics(pg.width,pg.height,P2D);
    buff.beginDraw();
    buff.fill(0,165);
    buff.background(0,0,0,0);
    buff.noStroke();
    buff.endDraw();
    pg.imageMode(CENTER);
    pg.ellipseMode(CENTER);
  }
  
  void draw()
  {
    pg.background(0,0,0,0);
    
    pg.pushMatrix();
    pg.translate(pg.width/2,pg.height/2);
    pg.scale(map(sin(frameCount/20.),-1,1,0.5,0.7));
    pg.rotate(frameCount/40.);
    pg.image(img,0,0);
    pg.popMatrix();
    
    calcEffect();
  }
  
  void calcEffect()
  {
    pg.noStroke();
    pg.fill(255);
    
    //blend(buff,3,3,pg.width-5,pg.height-5,0,0,pg.width,pg.height,SCREEN);
    pg.blend(buff,0,4,pg.width,pg.height,0,0,pg.width,pg.height,SCREEN);
    pg.blend(buff,4,0,pg.width,pg.height,0,0,pg.width,pg.height,SCREEN);
    pg.blend(buff,3,3,pg.width,pg.height,0,0,pg.width,pg.height,SCREEN);
    
    buff.beginDraw();
    buff.image(pg.get(),0,0);
    /*
    // [buff.image(...) no other-version]
    buff.background(0,0,0,0);
    buff.blend(pg.get(),0,0,pg.width,pg.height,  0,0,pg.width,pg.height,ADD);
    */
    buff.rect(0,0,pg.width,pg.height);
    buff.endDraw();
  }
}

