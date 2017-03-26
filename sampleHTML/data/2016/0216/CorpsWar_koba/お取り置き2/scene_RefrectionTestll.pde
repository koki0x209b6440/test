
class RefrectionTestll extends HanyouBuffer
{
  final int BACKGROUND_COLOR = 0xFFF0F0F0; // 背景色
  HanyouBuffer obj;
  
  RefrectionTestll(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(papp.width,papp.height,"P2D");
    obj=new Ball(papp);
  }
  
  void draw()
  {
    int x=mouseX-obj.getImage().width,   y=mouseY-obj.getImage(false).height;
    pg.background(BACKGROUND_COLOR);
    //pg.background(0,0,0,0);
    
    //main-draw
    pg.blend(obj.getBuffer(false),0,0,obj.getImage(false).width,   obj.getImage(false).height,
                                               x,y, obj.getImage(false).width,   obj.getImage(false).height,
                  DARKEST);
                  

    //refrection
    
    
    pg.blend(obj.getBuffer(false),0,0,obj.getImage(false).width,   obj.getImage(false).height,
                                               x,y+obj.getImage(false).height, obj.getImage(false).width,   obj.getImage(false).height,
                  DARKEST);
    //pg.image(obj.getBuffer(false),x,y);
  }
}
