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

  String labelname="test"; String getLabel(){return labelname;}
  int dm,ds;
  int h=0;     int getHour(){ return h; }
  int m=0;    int getMinute(){ return m; }
  int s=0;     int getSecond(){ return s; }
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
  TimerLabel setTimer(TimerLabel t)
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




void initTimer(String path)
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
               if(line.charAt(i)=='分') m_pos=i;
               if(line.charAt(i)=='秒') s_pos=i;
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
             
             //from=to;//一行の中に複数の$や:がある場合
             //to--;
    } } } }
  }catch(IOException e)
  {
    line=null;
    println("[reader.readLine()] error.");
    return;
  }
  
}
