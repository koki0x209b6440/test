/*
　This program is
　このプログラムは、シーン選択画面の実装例。シーンの連なりを設定変更できる。
　ただしトランジションは変更できない。要再構築。
　キーは、メインのsetupで引数渡しで設定しているはず。
*/
class CoverflowGUI_ll extends ListTypeMenu
{
  HanyouBuffer buffer;
  CoverflowGUI_ll(PApplet papp) 
  {
    super(papp);
  }
  CoverflowGUI_ll(PApplet papp,Scene root) 
  {
    super(papp,root);
  }
  CoverflowGUI_ll(PApplet papp,char mkey)
  {
    super(papp,mkey);
  }
  CoverflowGUI_ll(PApplet papp,char mkey,Scene root)
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
      if(buffer!=null)
      {
         if(target_list_index==list.size() && list.size()<BUFFER_LONG)
         {
           target_list_index++;
           list.add(buffer);
           isUpdate=true;
         }
         if(target_list_index<list.size() )
         {
           list.set(target_list_index,buffer);
           isUpdate=true;
         }
      }
      if(papp.keyPressed)
      {
        if(papp.key=='1') target_list_index=0;
        if(papp.key=='2') target_list_index=1;
        if(papp.key=='3') target_list_index=2;
      }
      for(int i=0; i<BUFFER_LONG; i++)
      {
        if(i==target_list_index) pg.fill(255,0,0,255);
        else                            pg.fill(0,0,255,255);
        
        
        pg.rect(   (pg.width/BUFFER_LONG)*i-3+20,47,55,55);
        if(i<list.size() && list.get(i)!=null)
        {
           if(coverflow.isSave || !coverflow.renderingTimer() )pg.image(list.get(i).getImage(DRAW_ONLY),(pg.width/BUFFER_LONG)*i+20,50,50,50);
           else                     pg.image(list.get(i).getImage(NOT_WORK),(pg.width/BUFFER_LONG)*i+20,50,50,50);
        }
      }
      //println("test");
      pg.image(coverflow.getImage(NOT_WORK),   0,pg.height/2,pg.width,pg.height/2);
      
      pg.fill(0);
      pg.textSize(18);
      pg.text(""+coverflow.cfo[coverflow.target].img.name,pg.width/3,pg.height/2+20);
    }
  }
  HanyouBuffer getOutputSingle()
  {
    return null;
  }
  ArrayList<HanyouBuffer> getOutputList()
  {
    isUpdate=false;
    return list;
  }
  
}
