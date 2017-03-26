/*
ウインドウサイズ変更。特にメインのウインドウ。
このタブの追加で、ウインドウサイズを動的に変更できるようになる。フルスクリーン化も含めて。
尚、draw();(の中で実行しているwork();  )に以下の二つを追加する。

  window_size_control_system();
  window_control_system();

*/
int mainwinW=0,mainwinH=0;

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
    if(mousePressed==true && keyPressed &&key==controlKey) resizingFlag=true;
  }
  if(mousePressed==false) resizingFlag=false;  
  if(resizingFlag) changeWindowSize(mouseX,mouseY);
  }
void changeWindowSize(int w, int h) {
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  size(w, h,P2D);
  mainwinW=w;
  mainwinH=h;
}



/*
ウインドウサイズ変更。特にメインのウインドウ。
*/
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
      setNormalWindow(mainwinW,mainwinH);
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
    mainwinW=width;
    mainwinH=height;
  }
}
void setLocation(int x,int y)
{
  mainwinX=x;
  mainwinY=y;
}
void setNormalWindow(int w, int h) {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  frame.setAlwaysOnTop(false);
  frame.setLocation(mainwinX, mainwinY);
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  size(w, h,P2D);
  this.requestFocus();
}
void setFullScreen() {
  size(screenWidth, screenHeight,P2D); 
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  frame.setSize(width, height);
  frame.setLocation(0, 0);
  frame.setAlwaysOnTop(true);
  this.requestFocus();
}
