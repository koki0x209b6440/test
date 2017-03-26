class SceneC extends HanyouBuffer
{
  HanyouBuffer snow;
  SceneC(PApplet papp)
  {
    super(papp);
  }
  SceneC(PApplet papp,Scene mypointer)
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
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    return this;
  }
  
}



class SceneCl extends HanyouBuffer
{
  HanyouBuffer snow;
  SceneCl(PApplet papp)
  {
    super(papp);
  }
  SceneCl(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  
  void setup()
  {
    size(300,300,"P2D");
    snow=new WallSnow(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.image(snow.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}
class SceneCr extends HanyouBuffer
{
  HanyouBuffer snow;
  SceneCr(PApplet papp)
  {
    super(papp);
  }
  SceneCr(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  
  void setup()
  {
    size(300,300,"P2D");
    snow=new WallSnow_ll(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.image(snow.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}
