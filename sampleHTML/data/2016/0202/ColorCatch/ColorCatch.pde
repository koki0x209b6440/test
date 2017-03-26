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
ArrayList selecters;  // Select Rect Class
boolean selecting = false;
boolean showingHelp = false;

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
  noStroke();
  selecters = new ArrayList();
  return buffimg;
}
void draw()
{
  while(img==null);//init stunby;
  background(0);
  image(img, 0, 0);
  int size = selecters.size();
  if (0<size)
  {
    for (int i=0; i<size-1; i++) ((CRect)selecters.get(i)).update();
    if (selecting)((CRect)selecters.get(size-1)).update(mouseX, mouseY);
    else ((CRect)selecters.get(size-1)).update();
  }
  if (showingHelp)
  {
    stroke(80, 180, 0);
    fill(0, 120, 20, 150);
    rect(0, 0, 240, height);
    fill(255);
    int str_x = 10;
    int str_y = 30;
    text("--- Help ---", str_x, str_y);
    text("Ctrl + MouseLeftPress :", str_x, str_y+=25);
    text("Select Color Analyzing Area", str_x+10, str_y+=16);
    text("key \'h\' :", str_x, str_y+=30);
    text("Show/Hide Help", str_x+10, str_y+=16);
    text("key \'r\' :", str_x, str_y+=20);
    text("Clear All Select Area", str_x+10, str_y+=16);
    text("key \'d\' :", str_x, str_y+=20);
    text("Remove Lateset Select Area", str_x+10, str_y+=16);  
  }
}
void mousePressed()
{
  selecters.add( new CRect(mouseX, mouseY) );
  selecting = true;
}
void mouseReleased()
{
  selecting = false;
}
void keyPressed()
{
  switch (key)
  {
    case 'd':
      if (0 < selecters.size()) selecters.remove( selecters.size()-1 );
      break;
    case 'r':
      selecters.clear();
      break;
    case 'h':	
      showingHelp = (false == showingHelp) ? true : false;
      break;
    default:
      break;
  }
}
void keyReleased()
{
  selecting = false;
}
