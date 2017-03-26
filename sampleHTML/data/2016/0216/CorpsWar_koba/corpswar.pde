/*

　This program is
　このプログラムは、HanyouAppletの利用例。pg使ってない普通のsetup-drawっぽいことに気をつけて。
　これを実際に運用するには、メインのsetupなどでcreateApp()やからね。

*/
class CorpsWar extends HanyouApplet
{
  CorpsWar(float window_alpha)
  {
    super(window_alpha);
  }
  
  void setup()
  {
    size(800,600,P2D);
    smooth();
    frameRate(20);
    corps = new Corp[corpNum];
    for(int i=0;i<corps.length;i++)
    {
      corps[i]=new Corp(unitNum,corps, this,false,i);
      if(i==0)corps[i].isPlayer=true;
      else      corps[i].isPlayer=false;
    }
    bullets=new Bullet[bulletNum];
    for(int i=0; i<bullets.length; i++)
    {
      bullets[i]=new Bullet(i,corps,bullets,this);
    }
  }
  void draw()
  {
    background(0);
    //if(frameCount==100){frameCount=0;setup();}
    int i=0;
    for(i=0;i<corps.length;i++) corps[i].draw();
    for(i=0;i<bullets.length; i++) bullets[i].draw();
    if(Key_pressed('R') )setup();
    
    super.draw();
  }
}







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
