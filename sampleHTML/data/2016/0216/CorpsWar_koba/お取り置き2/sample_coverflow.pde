/*
　This program is
　このプログラムは、シーン選択画面の実装例。現在見えているシーンだけを選んで切り替える。キーは、メインのsetupで引数渡しで設定しているはず。
*/

class CoverflowGUI_l extends CoverflowGUI
{
  HanyouBuffer buffer;
  CoverflowGUI_l(PApplet papp)
  {
    super(papp);
  }
  CoverflowGUI_l(PApplet papp,Scene root)
  {
    super(papp,root);
  }
  CoverflowGUI_l(PApplet papp,char mkey)
  {
    super(papp,mkey);
  }
  CoverflowGUI_l(PApplet papp,char mkey,Scene root)
  {
    super(papp,mkey,root);
  }
  
  void setup()
  {
    size(300,300,"P2D");
  }
  
  void draw()
  {
    senseMenuOnOff();
    if(isVisible==-1)
    {
      pg.background(0,0,0,0);//一応置いとく
    }
    else
    {
      pg.background(255);
      buffer=coverflow.get();
      if(buffer!=null){ returnbuffer=buffer; isUpdate=true;}
      
      if(returnbuffer!=null)
      {
         if(coverflow.isSave || !coverflow.renderingTimer() )pg.image(returnbuffer.getImage(DRAW_ONLY),pg.width/3,50,100,100);
         else                      pg.image(returnbuffer.getImage(NOT_WORK),pg.width/3,50,100,100);
      }
      pg.image(coverflow.getImage(NOT_WORK),   0,pg.height/2,pg.width,pg.height/2);
      
      pg.fill(0);
      pg.textSize(18);
      pg.text(""+coverflow.cfo[coverflow.target].img.name,pg.width/3,pg.height/2+20); 
    }
  }
  
  HanyouBuffer getOutputSingle()
  {
    isUpdate=false;
    return returnbuffer;
  }
  
}
