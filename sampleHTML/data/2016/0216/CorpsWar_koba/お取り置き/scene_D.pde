class SceneD extends HanyouBuffer
{
  HanyouBuffer snow;
  SceneD(PApplet papp)
  {
    super(papp);
  }
  SceneD(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  void setup()
  {
    size(300,300,"P2D");
    snow=new FloorSnow(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.blend(snow.getBuffer(),0,0,snow.pg.width,snow.pg.height,     0,0,pg.width,pg.height,ADD);
  }
  
  HanyouBuffer sceneWork()
  {
    //if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    return this;
  }
  
}
