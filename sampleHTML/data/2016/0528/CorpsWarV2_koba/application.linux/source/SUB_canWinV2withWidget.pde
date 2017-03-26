/*

setupやdrawのように自動で働くinitメソッドを利用している。例えばカラーウィジェットを自動で定義・初期設定を済ませるような挙動とか。
後はウインドウサイズ変更や、ウインドウ透過率もここで弄っているか。
*/
/*
このタブ追加で、透過度、カラーウィジェット、枠無しウインドウ
以下をwork();に追加する必要がある。(絶対では無いが)
window_control_mousesystem()

そもそも、カラーウィジェットをinit();で生成する都合、というかinit();の書き換えの都合、
*/
 
int mx = 0;
int my = 0; 
boolean _isMouse,isMouse=false;
 
void init() {
  frame.removeNotify();
  frame.setUndecorated(true);  
  if(IS_ALWAYS_ON_TOP)frame.setAlwaysOnTop(true);
  frame.addNotify();
  frame.setLocation(mainwinX,mainwinY);
  com.sun.awt.AWTUtilities.setWindowOpacity(frame, WINDOW_ALPHA);
  
  createApp(hacw ,600,200);
  hacw.setVisible(false);
  
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
    mainwinX=mouse.x-mx;
    mainwinY=mouse.y-my;
  }
  _isMouse=isMouse;
}
