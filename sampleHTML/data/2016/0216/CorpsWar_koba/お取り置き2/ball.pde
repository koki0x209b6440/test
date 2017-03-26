
class Ball extends HanyouBuffer
{
  ColorObject ballc=new ColorObject(255,0,0,255);
  Ball(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(100,100,"P2D");
  }
  
  void draw()
  {
    pg.background(0,0,0,0);
    
    pg.fill(ballc.getColor() );
    pg.rect(0,0,pg.width-1,pg.height-1);
    
    colorcontrol(name,ballc,'b');
  }
}
