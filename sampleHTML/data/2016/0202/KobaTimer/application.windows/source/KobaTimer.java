import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 
import java.awt.datatransfer.DataFlavor; 
import java.awt.datatransfer.Transferable; 
import java.awt.datatransfer.UnsupportedFlavorException; 
import java.awt.dnd.DnDConstants; 
import java.awt.dnd.DropTarget; 
import java.awt.dnd.DropTargetDragEvent; 
import java.awt.dnd.DropTargetDropEvent; 
import java.awt.dnd.DropTargetEvent; 
import java.awt.dnd.DropTargetListener; 
import java.io.File; 
import java.io.IOException; 
import java.awt.Point; 
import java.awt.MouseInfo; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class KobaTimer extends PApplet {

/*
\u30bf\u30a4\u30de\u30fc(\u9014\u4e2d\u3067\u306e\u30c1\u30e3\u30a4\u30e0\u306b\u3082\u5bfe\u5fdc)
\u30e1\u30e2
\u3000\u30c9\u30eb\u30de\u30fc\u30af\u3068\u30ab\u30f3\u30de\u3092\u30ad\u30fc\u306b\u3001\u30bf\u30a4\u30de\u30fc\u30e9\u30d9\u30eb\u3092\u62bd\u51fa\u3002
\u3000\u5206\u79d2\u3067\u76f8\u5bfe\u6642\u9593(\u4f55\u5206\u5f8c\u306b\u30bf\u30a4\u30de\u30fc\u3092\u9cf4\u3089\u3059)\u3092get\u3002
\u3000Timer\u30af\u30e9\u30b9\u306f\u6319\u52d5\u304c\u602a\u3057\u3044\u306e\u3067\u3001hour()\u7b49\u306e\u73fe\u5728\u6642\u523b\u53d6\u5f97\u3092\u5229\u7528\u3002
\u3000\u76f8\u5bfe\u6642\u9593\u3082\u9069\u6642\u5909\u63db\u3059\u308b\u3002(\u4f55\u6642\u4f55\u5206\u4f55\u79d2\u306b\u306a\u3063\u305f\u3089\u30bf\u30a4\u30de\u30fc\u3092\u9cf4\u3089\u3059)

\u3000\u97f3\u58f0\u9023\u7d9a\u518d\u751f\u306e\u6319\u52d5\u3082\u602a\u3057\u3044\u306e\u3067\u3001\u300c\u4e8c\u56de\u9cf4\u3063\u3066\u3044\u308bwav\u300d\u7b49\u7528\u610f\u3059\u308b\u5f62\u3002

\u3000\u6319\u52d5\uff1a
\u3000\u8d77\u52d5\uff08\u8584\u3044\u9752\u30fb\u5c0f\u30d5\u30ec\u30fc\u30e0\uff09->inputdata\u3092\u30c9\u30e9\u30c3\u30b0\u30a2\u30f3\u30c9\u30c9\u30ed\u30c3\u30d7\uff08\u753b\u9762\u30d5\u30eb\u30b5\u30a4\u30ba\uff09
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->\u30bf\u30a4\u30de\u30fc\u5f85\u6a5f\u72b6\u614b\u3002
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->Enter\u3067\u30bf\u30a4\u30de\u30fc\u8d77\u52d5 \u201c\u4e00\u56de\u76ee\u306e\u30c1\u30e3\u30a4\u30e0\u201d
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->\u6642\u9593\u5207\u308c\u3001\u3082\u3057\u304f\u306fEnter\u3067\u6b21 \u201c\u767a\u8868\u7d42\u4e86\u307e\u3067\u201d
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\uff08\u30c1\u30e3\u30a4\u30e0\u6570\u3082\u5909\u5316\uff09
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->\u6642\u9593\u5207\u308c\u3001\u3082\u3057\u304f\u306fEnter\u3067\u6b21 \u201c\u8cea\u554f\u30bf\u30a4\u30e0\u201d
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\uff08\u6642\u9593\u5207\u308c\u3067\u7121\u3044\u5834\u5408\u3001\u6b8b\u308a\u6642\u9593\u3059\u3079\u3066\u304c\u8cea\u554f\u30bf\u30a4\u30e0\u306b\u306a\u308b\uff09
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->\u6642\u9593\u5207\u308c\u3001\u3082\u3057\u304f\u306fEnter\u3067\u30bf\u30a4\u30de\u30fc\u505c\u6b62\u3002
\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000\u3000->Enter\u3067\u30bf\u30a4\u30de\u30fc\u5f85\u6a5f\u72b6\u614b\u306b\u623b\u308b

\u3000\u30e1\u30e2\uff1a
\u3000\u203binputfile\u306e\u8907\u6570\u56de\u8aad\u307f\u8fbc\u307f\u306b\u306f\u5bfe\u5fdc\u3057\u3066\u3044\u306a\u3044\u306f\u305a\u3002
\u3000\u203b\u30ce\u30fc\u30c8pc\u306e\u30b5\u30a4\u30ba\u9055\u3044\u306b\u3088\u308b\u8868\u8a18\u30ba\u30ec
\u3000\u203b\u73fe\u5728\u306e\u72b6\u614b\u304c\u5f85\u6a5f\u306a\u306e\u304b\u3001\u5e7e\u3064\u76ee\u306e\u30bf\u30a4\u30de\u30fc\u30e9\u30d9\u30eb\u306a\u306e\u304b\u308f\u304b\u308a\u306b\u304f\u3044
*/



DropTarget dropTarget; 
List<File> fileNameList = null;

PFont font_normal,font_empha;

ArrayList<TimerLabel> timerWorkList=new ArrayList<TimerLabel>();
int isWork=0; //0=input  1=win-full  2=stand-by  3=work
boolean isKeyPressed=false;
TimerLabel start_time;
int t_labelnum=0,t=-1;
TimerLabel t_label;

Minim minim;
AudioSample[] kane;

public void setup()
{
  size(200,200,P2D);
  frame.setLocation(screenWidth/2, screenHeight/3);
  font_normal = createFont("MS Gothic", 120);//createFont(name,fontSize);
  font_empha = createFont("MS Gothic", 300);
  fill(0);
  textAlign(CENTER);
  dropTarget = new DropTarget
  ( this, 
    new DropTargetListener()
    {
      public void dragEnter(DropTargetDragEvent dtde) {}  
      public void dragOver(DropTargetDragEvent dtde) {}  
      public void dropActionChanged(DropTargetDragEvent dtde) {}  
      public void dragExit(DropTargetEvent dte) {}  
      public void drop(DropTargetDropEvent dtde)
      {  
        dtde.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);  
        Transferable trans = dtde.getTransferable();  
        if(trans.isDataFlavorSupported(DataFlavor.javaFileListFlavor))
        {  
          try 
          {  
            fileNameList = (List<File>)  
              trans.getTransferData(DataFlavor.javaFileListFlavor);  
          }catch (UnsupportedFlavorException ex)
          {
          }catch (IOException ex)
          {
          }  
        }  
        if(fileNameList == null) return;
        for(File f : fileNameList) initTimer(f.getAbsolutePath());
        isWork++;
      }
    }
  ); 
}

public void draw()
{
  window_control_mousesystem();



  if(isWork==0){ background(211,222,255); return;}
  if(isWork==1)
  {
    isWork++;
    
    minim=new Minim(this);
    kane=new AudioSample[timerWorkList.size()];
    for(int i=0; i<3; i++) kane[i]=minim.loadSample("kane"+(i+1)+".wav");
    
    size(screenWidth, screenHeight,P2D); 
    frame.removeNotify();
    frame.addNotify();
    frame.setSize(screenWidth, screenHeight);
    frame.setLocation(0, 0);
    this.requestFocus();
    return;
  }  
  if(t_labelnum>t)
  {
    if(t_labelnum==timerWorkList.size() ) isWork=4;
    else 
    {
      t=t_labelnum;
      t_label=timerWorkList.get(t_labelnum);
    }
  }
  if(isWork==4)
  {
    if(keyPressed && !isKeyPressed && key==ENTER)
    {
      isKeyPressed=true;
      isWork=2;
      t_labelnum=0;
      t=-1;
      setTimers();
    }
    if(!keyPressed) isKeyPressed=false;
    return ;
  }
  
  
  
  background(255);
  textFont(font_normal);
  fill(0);
  text(t_label.getLabel() ,width/2,height/4);
  text("\u3042\u3068",width/6,height-height/3);
  int h,m,s;
  if(isWork==2)
  {
    h=t_label.getHour()-start_time.getHour();
    m=t_label.getMinute()-start_time.getMinute();
  }
  else
  {
    h=t_label.getHour()-hour();
    m=t_label.getMinute()-minute();
  }
  if(m<0)
  {
    h--;
    m+=60;
  }
  if(isWork==2)  s=t_label.getSecond()-start_time.getSecond();
  else                s=t_label.getSecond()-second();
  if(s<0)
  {
    m--;
    s+=60;
  }
  textFont(font_empha);
  fill(0,0,255);
  text(String.format("%02d",m)+":"+String.format("%02d",s),width-width/3,height-height/3);
  int now_m,now_s;
  if(isWork==2)
  {
    now_m=0;
    now_s=0;
  }
  else
  {
    now_m=minute()-start_time.getMinute();
    now_s=second()-start_time.getSecond();
  }
  if(now_s<0)
  {
    now_m--;
    now_s+=60;
  }
  if(now_m<0)
  {
    //now_h--;
    now_m+=60;
  }
  textFont(font_normal);
  fill(0);
  text("total"+String.format("%02d",now_m)+":"+String.format("%02d",now_s),width/2,height-height/8);
    
  

  if(isWork==2)
  {
    if(keyPressed && !isKeyPressed && key==ENTER)
    {
      isKeyPressed=true;
      setTimers();
      isWork++;
  } }
  if(isWork==3)
  {
    if(keyPressed && !isKeyPressed && key==ENTER)
    {
      isKeyPressed=true;
      h=0; m=0; s=0;
  } }
  if(h==0 && m==0 && s==0)
  {
    kane[(t_labelnum++)%3].trigger();
  }
  if(!keyPressed) isKeyPressed=false;
}


public void setTimers()
{
  TimerLabel p=new TimerLabel("now",hour(),minute(),second() );
  start_time=p;
  for(int i=0; i<timerWorkList.size(); i++)
  {
    //println(p.getHour()+":"+p.getMinute()+":"+p.getSecond() );
    p=timerWorkList.get(i).setTimer(p);
  }
  
}

public void stop()
{
  for(int i=0; i<timerWorkList.size(); i++) kane[i].close();
  minim.stop();
  super.stop();
}
  
  
  
  
  
  
  
  
  
  
  
/*
a	a
[	]
*/

/*
sample[http://tercel-sakuragaoka.blogspot.jp/2011/10/processing.html]
          [http://d.hatena.ne.jp/ryochack/20110808/1312819516]
*/

class TimerLabel
{

  String labelname="test"; public String getLabel(){return labelname;}
  int dm,ds;
  int h=0;     public int getHour(){ return h; }
  int m=0;    public int getMinute(){ return m; }
  int s=0;     public int getSecond(){ return s; }
  TimerLabel(String name,int dm,int ds)
  {
    labelname=name;
    this.dm=dm;  this.ds=ds;
  }
  TimerLabel(String name,int h,int m,int s)//debug
  {
    labelname=name;
    this.h=h;  this.m=m; this.s=s;
  }
  public TimerLabel setTimer(TimerLabel t)
  {
    h=0; m=0; s=0;
    s=ds+t.getSecond();
    if(s>=60)
    {
      s=s%60;
      m++;
    }
    m=dm+t.getMinute();
    if(m>=60)
    {
      m=m%60;
      h++;
    }
    h+=t.getHour();
    //if(h>=60) ;
    
    return this;
  }
}




public void initTimer(String path)
{
  BufferedReader reader=createReader(path);
  String line;
  boolean isRead=true;
  
  boolean isHit=false;
  TimerLabel now=null,p=null;
  try
  {
    while(isRead)
    {
       line=reader.readLine();
       //println("readLine:"+line);
       if(line.length()>=3)
       {
         if(line.charAt(0)=='e' && line.charAt(1)=='n' && line.charAt(2)=='d') isRead=false;
       }
       int from=-2,to=-1;
       for(int i=0; i<line.length(); i++)
       {
         if( line.charAt(i)=='$' || line.charAt(i)==':')
         {
           if(from<to && i>to)from=i;
           if(i!=from && from>to) to=i;
           if(from<to)
           {
             int m_pos=to,s_pos=to;
             for(i=to; i<line.length(); i++)
             {
               if(line.charAt(i)=='\u5206') m_pos=i;
               if(line.charAt(i)=='\u79d2') s_pos=i;
             }
             int m = Integer.parseInt( line.substring(to+1,m_pos) );
             int s = Integer.parseInt( line.substring(m_pos+1,s_pos) );
             
             //println("     "+line.substring(from,to) );
             //println("          "+line.substring(to+1,m_pos) );
             //println("          "+line.substring(m_pos+1,s_pos) );
             if(!isHit)
             {
               isHit=true;
               now=new TimerLabel("now",hour(),minute(),second() );
               start_time=now;
               p=now;
             }
             timerWorkList.add(new TimerLabel(line.substring(from+1,to), m,s).setTimer(p)  );
             p=timerWorkList.get(timerWorkList.size()-1);
             
             //from=to;//\u4e00\u884c\u306e\u4e2d\u306b\u8907\u6570\u306e$\u3084:\u304c\u3042\u308b\u5834\u5408
             //to--;
    } } } }
  }catch(IOException e)
  {
    line=null;
    println("[reader.readLine()] error.");
    return;
  }
  
}

//import java.awt.*;
 



public final float WINDOW_ALPHA=1.0f;
char controlKey=' ';
 
int mx = 0;
int my = 0;
boolean _isMouse,isMouse=false;
public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);  
  frame.addNotify();
  frame.setLocation(screenWidth/2,screenHeight/2);
  com.sun.awt.AWTUtilities.setWindowOpacity(frame, WINDOW_ALPHA);
  super.init();
}
public void window_control_mousesystem()
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "KobaTimer" });
  }
}
