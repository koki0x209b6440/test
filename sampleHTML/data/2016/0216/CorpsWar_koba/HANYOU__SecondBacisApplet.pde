/*
　This program is
　このプログラムは、HanyouBufferのようにsetup-drawの構造を持てるようにして、尚且つ、メインのsetupの方でcreateApp()に引数渡しすれば、別ウインドウで開く子である。

・HanyouBufferみたいだが、更に、別ウインドウとして新規に開いて扱う(HanyouAppletとcreateApp()  )
　開く実行の中身はメインのsetupとcreateApp　開く対象はHanyouAppletを継承したもの。
　使い方はコメントアウトで残ってるのそのまま。
*/
class HanyouApplet extends SecondBasicApplet
{
  HanyouApplet()
  {
    
  }
  HanyouApplet(float window_alpha)
  {
    this.window_alpha=window_alpha;
    Key_setApplet(this);
  }
  void setup()
  {
    size(200,200);
  }
  void draw()
  { 
    //background(255);
    //fill(0, 255, 0);
    //ellipse( mouseX, mouseY, 100, 100 );
    
    Key_update();
    super.draw();
  }
  
  
  int pressTime[]=null;
  void Key_setApplet(PApplet applet)
  {
    pressTime = new int[Character.MAX_VALUE];
    applet.addKeyListener( new java.awt.event.KeyAdapter()
                           {
                            public void keyPressed(java.awt.event.KeyEvent e)
                            {
                              if (pressTime[e.getKeyCode()] <= 0)
                                pressTime[e.getKeyCode()] = 1;
                            }
                            public void keyReleased(java.awt.event.KeyEvent e)
                            {
                              pressTime[e.getKeyCode()] = -1;
                            }
                           }
                         );
  }
  int Key_get(int code){  return pressTime[code]; }
  boolean Key_pressed(int code){  return Key_get(code)==1; }
  boolean Key_released(int code){  return Key_get(code)==-1; }
  boolean Key_pushed(int code, int n, int m){  return Key_get(code)>=n&&Key_get(code)%m==0; }
  void Key_update()
  {  
     for (int i=0; i<pressTime.length; i++)
       pressTime[i]+=pressTime[i]!=0?1:0; 
  }

  
  
}










/*
   This program is
　このプログラムは、HanyouAppletの継承元、原型に当たる。実際に別ウインドウとして開く為のcreateApp()メソッドもこちらに置いている。
　どうやって別ウインドウで開いているのか？　というと、javaの仕様と戦っただけみたいな感じで、後学のためにはあまりならないので、いいや。
*/

import java.awt.Frame;
import javax.swing.JFrame;
import java.awt.Insets;

int framenum=0;

void createApp(SecondBasicApplet secondapp,int x,int y)
{
  secondapp.setLocation(x,y);
  PFrame secondf=new PFrame(secondapp);
  secondf.setTitle(  (framenum++)+"nd frame");
  secondf.setLocation(x,y);
}

public class PFrame extends JFrame
{ 
  public PFrame(PApplet app)
  {
    SecondBasicApplet _app=(SecondBasicApplet) app;
    _app.setFrame(this);
    
    app.init();
    while ( app.width<=PApplet.DEFAULT_WIDTH || app.height<=PApplet.DEFAULT_HEIGHT );
    Insets insets = frame.getInsets();
    setSize( app.width + insets.left + insets.right, app.height + insets.top + insets.bottom );
    setResizable(true);    
    add(app);
    show();
  }
}

class SecondBasicApplet extends PApplet {
  Frame frame;
  float window_alpha=1f;
  int _x,_y,_width=0,_height=0;
  char FullscreenKey='F';
  char controlKey=' ';
  boolean isWork=true;
  void setVisible(boolean isWork){ this.isWork=isWork;  frame.setVisible(isWork); }
  
  void setup() {
    size( 200, 200 );
  }
  
  void draw()
  {  //not pg.XXX
    
    
    work();
  }
  
  void work()
  {
    
    window_size_control_system();
    window_control_system();
    window_control_mousesystem();
  }
  




  
  boolean resizingFlag=false;
  void window_size_control_system()
  {
    if(dist( mouseX, mouseY, width, height)<=20)
    {
      noStroke();
      color backc=get(width-1,height-1);//abbout right-down point color
      float fill_r=255-red(backc),   fill_g=255-green(backc),   fill_b=255-blue(backc);
      int fill_c=0;
      if(fill_r<(255/2) || fill_g<(255/2) || fill_b<(255/2) )  fill_c=0;
      if(fill_r>(255/2) || fill_g>(255/2) || fill_b>(255/2) )  fill_c=255;
      fill(fill_c,255);
      rect(width-20,height-20,20,20);
      if(mousePressed==true && keyPressed && key==controlKey) resizingFlag=true;
    }
    if(mousePressed==false) resizingFlag=false;
    
    if(resizingFlag) changeWindowSize(mouseX,mouseY);
  }
  
  void changeWindowSize(int w, int h) {
    frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    //if( abs(width-w)>5 || abs(height-h)>5)println("w,h=("+w+","+h+")");
    size(w, h);
    _width=w;
    _height=h;
  }
  
  
  
  
  
  
  boolean isFullscreen=false;
  boolean _isEnter=false,isEnter=false;
  void window_control_system()
  {
    if(keyPressed && key==FullscreenKey )  isEnter=true;
    else                                                     isEnter=false;
    /////////////////////////////////////////////////
    if(isEnter==true && _isEnter==false)
    {
      if(isFullscreen)//to normal
      {
        isFullscreen=false;
        setNormalWindow(_width, _height);
      }
      else
      {
        isFullscreen=true;
        setFullScreen();
      }
    }
    ////////////////////  
    _isEnter=isEnter;
    if(!isFullscreen)
    {
      _width=width;
      _height=height;
    }
  }
  void setLocation(int x,int y)
  {
    _x=x;
    _y=y;
  }
  void setNormalWindow(int w, int h) {
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
    frame.setAlwaysOnTop(false);
    frame.setLocation(_x, _y);
    frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    this.requestFocus();
  }
  
  void setFullScreen() {
    size(screenWidth, screenHeight); 
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
    frame.setSize(width, height);
    frame.setLocation(0, 0);
    frame.setAlwaysOnTop(true);
    this.requestFocus();
  }
  
  
  
  
  
  
  
  
  int mx = 0;
  int my = 0;
  boolean _isMouse,isMouse=false;
  void setFrame(Frame frame)
  {
    this.frame=frame;
  }
  
  void init() {
    frame.removeNotify();
    frame.setUndecorated(true);
    if(IS_ALWAYS_ON_TOP)frame.setAlwaysOnTop(true);
    frame.addNotify();
    com.sun.awt.AWTUtilities.setWindowOpacity(frame, window_alpha);
    super.init();  
  }
  
  void window_control_mousesystem()
  {
    if(keyPressed && key==controlKey && !resizingFlag)
    {
      if(mousePressed)
      {
        if(isMouse==false && _isMouse==false)
        {
          mx=mouseX;
          my=mouseY;
        }
        isMouse=true;
      }
    }
    else isMouse=false;
    if(isMouse==true && _isMouse==true)  //  <- mouseDragged
    {
      Point mouse;
      mouse = MouseInfo.getPointerInfo().getLocation();
      frame.setLocation( mouse.x - mx, mouse.y - my );
      _x=mouse.x-mx;
      _y=mouse.y-my;
    }
    _isMouse=isMouse;
  }
  
  
  
  
}
