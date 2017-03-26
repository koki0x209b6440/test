class SceneB extends HanyouBuffer
{
  HanyouBuffer grass;
  SceneB(PApplet papp)
  {
    super(papp);
  }
  SceneB(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  void setup()
  {
    size(300,300,"P2D");
    grass=new Grass(papp);
  }
  
  void draw()
  {
    pg.background(255);
    pg.blend(grass.getBuffer(),0,0,grass.pg.width,grass.pg.height,     0,0,pg.width,pg.height,DARKEST);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    
    return this;
  }
  
}


class SceneBl extends HanyouBuffer
{
  HanyouBuffer rain;
  SceneBl(PApplet papp)
  {
    super(papp);
  }
  SceneBl(PApplet papp,Scene mypointer)
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
    //pg.image(rain.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}

class SceneBr extends HanyouBuffer
{
  HanyouBuffer rain;
  SceneBr(PApplet papp)
  {
    super(papp);
  }
  SceneBr(PApplet papp,Scene mypointer)
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
    //pg.image(rain.getBuffer(),0,0,pg.width,pg.height);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    //if(keyPressed && key=='p') return new ZoomSlideEffect(this,next);
    
    return this;
  }
}
