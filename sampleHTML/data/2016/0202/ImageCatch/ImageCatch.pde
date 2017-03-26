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

PImage img=null;
int x=0,y=0,w=300,h=300;
int getX=200,getY=100,getW=200,getH=200;

DropTarget dropTarget; 
List<File> fileNameList = null;

void setup()
{
  size(640,480);
  /*
  //GUI input-mode.
  img = loadImage( selectInput() );
  */
  
  //drag&drop input-mode.
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
            /* 例外処理 */  
          }catch (IOException ex)
          {  
            /* 例外処理 */  
          }  
        }  
        if(fileNameList == null) return;  
        // ドラッグ&ドロップされたファイルの一覧は一時リストに格納される  
        // 以下のように書くと、ファイルのフルパスを表示  
        for(File f : fileNameList) img=loadandinitImage(f.getAbsolutePath());
      }
    }
  );
  
}
PImage loadandinitImage(String path)
{
  PImage buffimg=loadImage(path);
  if (width < buffimg.width)  buffimg.resize(width, 0);
  if (height < buffimg.height) buffimg.resize(0, height);
  return buffimg;
}
void draw()
{
  while(img==null);//init stunby;
  background(0);
  image(img, x, y,w,h);
  if(keyPressed==true  && key==' ')
  {
    PImage saveimg=get(getX,getY,getW,getH);
    saveimg.save("data/icon/hoge.jpg");
    println("save!");
  }
  
  noStroke();
  fill(0,0,0,200);
  rect(0,0,getX,height);
  rect(getX+getW,0,width-(getX+getW), height);
  rect(getX,0, getW,getY);
  rect(getX,getY+getH,getW,height-(getY+getH) );
  stroke(255,0,0);
  noFill();
  rect(getX,getY,getW,getH);
}
void mouseDragged()
{
  x+=mouseX-pmouseX;
  y+=mouseY-pmouseY;
}
void keyPressed()
{
  if(key=='+')
  {
    w*=1.5;
    h*=1.5;
  }
  if(key=='-')
  {
    w*=0.5;
    h*=0.5;
  }
}
