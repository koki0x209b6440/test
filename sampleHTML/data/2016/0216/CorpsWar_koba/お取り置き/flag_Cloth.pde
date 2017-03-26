
class Cloth extends HanyouBuffer
{
  String imgname;
  PImage img;
  float elementSize;
  int w,h,kakudo;
  int hanten_x,hanten_y;
  ClothObject obj;
  Cloth(PApplet papp,PImage img,int hanten_x,int hanten_y,int w,int h,int kakudo,float elementSize)
  {
    super(papp);
    this.img=img;
    
    this.hanten_x=hanten_x;
    this.hanten_y=hanten_y;
    this.w=w;
    this.h=h;
    this.kakudo=kakudo;
    this.elementSize=elementSize;
  }
  Cloth(PApplet papp,int hanten_x,int hanten_y,int w,int h,int kakudo,float elementSize)
  {
    super(papp);
    this.img=loadImage("basiccloth.jpg");
    
    this.hanten_x=hanten_x;
    this.hanten_y=hanten_y;
    this.w=w;
    this.h=h;
    this.kakudo=kakudo;
    this.elementSize=elementSize;
  }
  void setup()
  {
    size(w+50,h+50,"P3D");
    obj=new ClothObject(this,img.get(), 1,1,w,h,      0.000,0.01);
  }
  void draw()
  {
    obj.effect(pg);
    pg.background(0,0,0,0);
    pg.lights();
    drawSheet(obj);
  }
  void drawSheet(ClothObject co){
    pg.noStroke();
    for (int j=0; j<co.numh-1; j++){
      pg.beginShape(TRIANGLE_STRIP);
      pg.texture(co.img);
      float xtweek = 1.02;
      float ytweek = 1.05;
      for (int i=0; i<co.numw; i++){
        pg.vertex(co.X[i][j].x, co.X[i][j].y, co.X[i][j].z,
                       elementSize*i*xtweek, elementSize*j*ytweek);
        pg.vertex(co.X[i][j+1].x, co.X[i][j+1].y, co.X[i][j+1].z,
                       elementSize*i*xtweek, elementSize*(j+1)*ytweek);      
      }
      pg.endShape();
    }
    //  pg.fill(255,0,0,255);//DEBUG
    //  pg.ellipse(0,0,10,10);
  }
  
  void setImage(PImage newimg)
  {
    img=newimg;
    obj.setImage(img);
  }
  void setImage(String imgname)
  {
    setImage(loadImage(imgname) );
  }
  
  
}
