/*

　This program is
　このプログラムは、HanyouAppletの利用例。pg使ってない普通のsetup-drawっぽいことに気をつけて。
　これを実際に運用するには、メインのsetupなどでcreateApp()やからね。

*/
class CorpsWarApp extends HanyouApplet
{
  Scene scene;
  CorpsWarApp(float window_alpha)
  {
    super(window_alpha);
  }
  
  void setup()
  {
    size(800,600,P2D);
    smooth();
    frameRate(30);
    scene=new Scene(new NoneContentScene(this),new CoverflowGUI(this,'m') );
    scene.optionGUI.setSampleList(new CorpsWarGameList(this) );
    scene.loadSceneList("corpswar");
  }
  void draw()
  {
    background(0);
    image(scene.getScene().getImage(),0,0,width,height);
      fill(0,0,255);
      textSize(16);
      text("FPS:"+(int)frameRate,width-60,30);
    if(Key_pressed('R') )setup();
    super.draw();
  }
}

class CorpsWarGameOpening extends HanyouBuffer
{
  CorpsWarGameOpening(PApplet papp){  super(papp);  }
  CorpsWarGameOpening(PApplet papp,Scene mypointer){  super(papp,mypointer);  }
  void setup(){  size(papp.width,papp.height,"P2D");  }
  void draw(){  pg.background(125);  }
  HanyouBuffer sceneWork()
  {
    if(papp.keyPressed && papp.key!='m'){println("test"); return next;}//  CorpsWarGame(papp);
    return this;
  }
}

class CorpsWarGame extends HanyouBuffer
{
  CorpsWarGame(PApplet papp){  super(papp);  }
  CorpsWarGame(PApplet papp,Scene mypointer){  super(papp,mypointer);  }
  void setup()
  {
    size(papp.width,papp.height,"P2D");
    pg.smooth();
    corps = new Corp[corpNum];
    for(int i=0;i<corps.length;i++)
    {
      corps[i]=new Corp(unitNum,corps,papp,pg,false,i);
      if(i==0)corps[i].isPlayer=true;
      else      corps[i].isPlayer=false;
    }
    bullets=new Bullet[bulletNum];
    for(int i=0; i<bullets.length; i++)
    {
      bullets[i]=new Bullet(i,corps,bullets,papp,pg);
    }
  }
  void draw(){
    pg.background(0);
    int i=0;
    for(i=0;i<corps.length;i++) corps[i].draw();
    for(i=0;i<bullets.length; i++) bullets[i].draw();
  }
  HanyouBuffer sceneWork()
  {
    //if(keyPressed && key!='m') return next;//  CorpsWarGame(papp);
    return this;
  }
}



//下二つはどこで使っていたっけ。CorpsWarでは使ってない？

class AppletC extends HanyouApplet
{
  HanyouBuffer scene;
  AppletC(float window_alpha)
  {
    super(window_alpha);
  }
  
  void setup()
  {
    size(200,200);
    scene=new BoundBall(this);
  }
  void draw()
  {
    background(255);
    //HanyouBuffer hb=coverflow.get();
    //if(hb!=null)scene=hb;
    image(scene.getImage(), 0,0,width,height);
    
    super.draw();
  }
}




class AppletD extends HanyouApplet
{
  Scene ball;
  AppletD(float window_alpha)
  {
    super(window_alpha);
  }
  
  void setup()
  {
    size(200,200);
    ball=new Scene(new BoundBall(this) );
    ball.optionGUI.setSampleList(new SampleListTest(this) );
    
    ball.optionGUI.isVisible=1;
    ball.getScene(NOT_OPTION).name="Ball_D";
    PImage pimg=ball.getScene(NOT_OPTION).getImage();//init
  }
  void draw()
  {
    background(255);
    image(ball.optionGUI.getImage(), 0,0,width,height);
    super.draw();
  }
  
  Scene outputSync(Scene scene)
  {
    scene.setScene(ball.getScene(NOT_OPTION)   );
    return scene;
  }
  
}
