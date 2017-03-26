
class SceneA extends HanyouBuffer
{
  HanyouBuffer grass,rain;
  SceneA(PApplet papp)
  {
    super(papp);
  }
  SceneA(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  
  void setup()
  {
    size(300,300,"P2D");
    grass=new Grass(papp);
    rain=new FloorRain(papp);
  }
  
  void draw()
  {
    pg.background(0);
    //pg.blend(grass.getBuffer(),0,0,grass.pg.width,grass.pg.height,     0,0,pg.width,pg.height,ADD);
    pg.blend(rain.getBuffer(),0,0,rain.pg.width,rain.pg.height,        0,0,pg.width,pg.height,ADD);
    //pg.image(rain.getBuffer(),0,0);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}

class SceneAl extends HanyouBuffer
{
  HanyouBuffer rain;
  SceneAl(PApplet papp)
  {
    super(papp);
  }
  SceneAl(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  
  void setup()
  {
    size(300,300,"P2D");
    rain=new WallRain(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.image(rain.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}

class SceneAr extends HanyouBuffer
{
  HanyouBuffer rain;
  SceneAr(PApplet papp)
  {
    super(papp);
  }
  SceneAr(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  
  void setup()
  {
    size(300,300,"P2D");
    rain=new WallRain_ll(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.image(rain.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}
