/*
　This program is
　このプログラムは、シーン選択画面実物。シーンの繋がりではなく、シーン一つを切り替える想定。シーン一覧となるSampleListの読み込みが必要だから注意してね。
*/


class CoverflowGUI extends Menu
{
  CoverflowGUI(PApplet papp)
  {
    super(papp);
  }
  CoverflowGUI(PApplet papp,Scene root)
  {
    super(papp,root);
  }
  CoverflowGUI(PApplet papp,char mkey)
  {
    super(papp,mkey);
  }
  CoverflowGUI(PApplet papp,char mkey,Scene root)
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
      pg.background(0,0,0,0); ////一応置いとく
    }
    else
    {
      pg.background(255);
      HanyouBuffer buffer=coverflow.get();
      if(buffer!=null){ returnbuffer=buffer; isUpdate=true;}
      
      pg.image(coverflow.getImage(NOT_WORK),   0,0,pg.width,pg.height);
    }
  }
  HanyouBuffer getOutputSingle()
  {
    isUpdate=false;
    return returnbuffer;
  }
}










/*
　This program is
　このプログラムは、シーン選択画面の機能部分。選択したものをリスト状にまとめたり、現在のシーンの繋がりと同期したり(現状表示部分のための)、キー押しでシーン選択画面に遷移したり。
　
*/
class Menu extends HanyouBuffer
{
  boolean isUpdate=false;
  int isVisible=-1; //1=true  -1=false
  Scene root;
  HanyouBuffer returnbuffer=null;
  Coverflow coverflow;
  char menu_open_key='m';
  
  ArrayList<HanyouBuffer> list=null;
  final int BUFFER_LONG=3;
  int target_list_index=0;
  Menu(PApplet papp){ super(papp); coverflow=new Coverflow(papp,new TestSampleList(papp)   ); }
  Menu(PApplet papp,Scene root)
  {
    super(papp);
    coverflow=new Coverflow(papp,new TestSampleList(papp)   );
    sync(root);
  }
  Menu(PApplet papp,char mkey){ super(papp); menu_open_key=mkey; coverflow=new Coverflow(papp,new TestSampleList(papp)   ); }
  Menu(PApplet papp,char mkey,Scene root)
  {
    super(papp);
    menu_open_key=mkey;
    coverflow=new Coverflow(papp,new TestSampleList(papp)   );
    sync(root);
  }
  void setup(){ }
  void draw(){}

  boolean Menu_class_Mkey=false;
  void senseMenuOnOff()
  {
    if(papp.keyPressed)
    {
      if(papp.key==menu_open_key && Menu_class_Mkey==false)
      {
        Menu_class_Mkey=true;
        isVisible*=-1;
      }
    }
    else Menu_class_Mkey=false;
  }
  HanyouBuffer getOutputSingle()  //何かしらの時にオーバーライドして使ってね
  {
    return null;
  }
  ArrayList<HanyouBuffer>  getOutputList()//何かしらの時にオーバーライドして使ってね
  {
    return null;
  }
  void sync(Scene root)
  {
    returnbuffer=root.getScene(NOT_OPTION);
  }
  void setSampleList(SampleList samplelist)
  {
    coverflow.setSampleList(samplelist);
  }
  SampleList getSampleList()
  {
    return coverflow.samplelist;
  }
  void setPApp(PApplet papp)
  {
    coverflow.setPApp(papp);
  }
}

class ListTypeMenu extends Menu
{
  ListTypeMenu(PApplet papp)                                { super(papp); }
  ListTypeMenu(PApplet papp,Scene root)                { super(papp); sync(root);}
  ListTypeMenu(PApplet papp,char mkey)                { super(papp,mkey); }
  ListTypeMenu(PApplet papp,char mkey,Scene root){  super(papp,mkey,root); }
  void setup(){ }
  void draw(){}
  
  void sync(Scene root)
  {
    HanyouBuffer scene=root.getScene(NOT_OPTION);
    list=new ArrayList<HanyouBuffer>();// (not main)list reset.
    while(scene!=null)
    {
      if(target_list_index==BUFFER_LONG)return;
      list.add(scene);
      target_list_index++;
      scene=scene.next;
    }
  }
}

