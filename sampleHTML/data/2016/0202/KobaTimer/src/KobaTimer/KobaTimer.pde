/*
タイマー(途中でのチャイムにも対応)
メモ
　ドルマークとカンマをキーに、タイマーラベルを抽出。
　分秒で相対時間(何分後にタイマーを鳴らす)をget。
　Timerクラスは挙動が怪しいので、hour()等の現在時刻取得を利用。
　相対時間も適時変換する。(何時何分何秒になったらタイマーを鳴らす)

　音声連続再生の挙動も怪しいので、「二回鳴っているwav」等用意する形。

　挙動：
　起動（薄い青・小フレーム）->inputdataをドラッグアンドドロップ（画面フルサイズ）
　　　　　　　　　　　　　　->タイマー待機状態。
　　　　　　　　　　　　　　->Enterでタイマー起動 “一回目のチャイム”
　　　　　　　　　　　　　　->時間切れ、もしくはEnterで次 “発表終了まで”
　　　　　　　　　　　　　　　（チャイム数も変化）
　　　　　　　　　　　　　　->時間切れ、もしくはEnterで次 “質問タイム”
　　　　　　　　　　　　　　　（時間切れで無い場合、残り時間すべてが質問タイムになる）
　　　　　　　　　　　　　　->時間切れ、もしくはEnterでタイマー停止。
　　　　　　　　　　　　　　->Enterでタイマー待機状態に戻る

　メモ：
　※inputfileの複数回読み込みには対応していないはず。
　※ノートpcのサイズ違いによる表記ズレ
　※現在の状態が待機なのか、幾つ目のタイマーラベルなのかわかりにくい
*/

import ddf.minim.*;

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

void setup()
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

void draw()
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
  text("あと",width/6,height-height/3);
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


void setTimers()
{
  TimerLabel p=new TimerLabel("now",hour(),minute(),second() );
  start_time=p;
  for(int i=0; i<timerWorkList.size(); i++)
  {
    //println(p.getHour()+":"+p.getMinute()+":"+p.getSecond() );
    p=timerWorkList.get(i).setTimer(p);
  }
  
}

void stop()
{
  for(int i=0; i<timerWorkList.size(); i++) kane[i].close();
  minim.stop();
  super.stop();
}
