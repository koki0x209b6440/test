
//import java.awt.*;
 
import java.awt.Point;
import java.awt.MouseInfo;

public final float WINDOW_ALPHA=1.0;
char controlKey=' ';
 
int mx = 0;
int my = 0;
boolean _isMouse,isMouse=false;
void init() {
  frame.removeNotify();
  frame.setUndecorated(true);  
  frame.addNotify();
  frame.setLocation(screenWidth/2,screenHeight/2);
  com.sun.awt.AWTUtilities.setWindowOpacity(frame, WINDOW_ALPHA);
  super.init();
}
void window_control_mousesystem()
{
  if(keyPressed && key==controlKey)
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
  }
  _isMouse=isMouse;
}
