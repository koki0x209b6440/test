
class RefrectionTest extends HanyouBuffer
{
  final int BACKGROUND_COLOR = 0xFFF0F0F0; // 背景色
  HanyouBuffer obj;
  
  RefrectionTest(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(papp.width,papp.height,"P2D","Controller");
    obj=new Ball(papp);
  }
  
  void draw()
  {
    int x=mouseX-obj.getImage().width,   y=mouseY-obj.getImage(DRAW_ONLY).height;
    pg.background(BACKGROUND_COLOR);
    //pg.background(0,0,0,0);
    
    //main-draw
    pg.blend(obj.getBuffer(DRAW_ONLY),0,0,obj.getImage(DRAW_ONLY).width,   obj.getImage(DRAW_ONLY).height,
                                               x,y, obj.getImage(DRAW_ONLY).width,   obj.getImage(DRAW_ONLY).height,
                  DARKEST);
                  
                  
    //refrection
    pg.blend(obj.getBuffer(DRAW_ONLY),0,0,obj.getImage(DRAW_ONLY).width,   obj.getImage(DRAW_ONLY).height,
                                               x,y+obj.getImage(DRAW_ONLY).height, obj.getImage(DRAW_ONLY).width,   obj.getImage(DRAW_ONLY).height,
                  DARKEST);
    pg.fill(0xDD << 24 | 0xFFFFFF & BACKGROUND_COLOR);
    pg.noStroke();
    pg.rect(x,y+obj.getImage(DRAW_ONLY).height, obj.getImage(DRAW_ONLY).width,   obj.getImage(DRAW_ONLY).height);
    //pg.image(obj.getBuffer(false),x,y);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    return this;
  }
  
}
