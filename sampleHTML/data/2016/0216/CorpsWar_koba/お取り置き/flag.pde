
// まだ棒とか温度表示とかの装飾ない(あと、玄関投影の歪み対策の意図的歪みも)
// とりあえず布シミュの移植だけ。

class Flag extends HanyouBuffer
{
  HanyouBuffer cloth;
  Flag(PApplet papp)
  {
    super(papp);
  }
  
  
  void setup()
  {
    size(500,500,"P2D");
    cloth=new Cloth(papp,1,1,300,300,0,50);
  }
  
  void draw()
  {
    pg.background(0);
    pg.image(cloth.getImage(), 100,100,300,300);
  }
  
}
