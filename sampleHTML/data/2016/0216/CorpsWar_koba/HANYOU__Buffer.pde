class ColorObject  //三変数格納としてcolor型活用。getHSBなのに変な話だが、red(…)とかで一つずつ取り出してね
{
  color c;
  int alpha;
  ColorObject(int red,int green,int blue, int alpha)
  {
    c=color(red,green,blue);
    this.alpha=alpha;
  }
  color getColor(){ return c; }
  void setColor(int red,int green,int blue)
  {
    c=color(red,green,blue);
  }
  void setColor(color c)
  {
    this.c=c;
  }
  void setColor(int red,int green,int blue,int alpha)
  {
    c=color(red,green,blue);
    this.alpha=alpha;
  }
  void setColor(color c,int alpha)
  {
    this.c=c;
    this.alpha=alpha;
  }
  void setAlpha() {  this.alpha=alpha; }
  int getAlpha()   {  return alpha;  }
}

/*
　This program is
　このプログラムは、各クラスでもsetup-drawを持てるように(allwork()を定義しした)HanyouBufferと、それを包むSceneクラス。

・一個一個の方でsetup-drawできる、クラス用意(HanyouBuffer)
　　　メインのsetupメソッドでnewし、メインのdrawメソッドで(xxx.render();とか一手間かけず)xxx.getImage();で扱
　　　う。
　　　一回目のxxx.getImage();でコンストラクタ的挙動をとる、というようになっている。
　　　(上記仕様であるのは、シーン選択のためにオブジェクトのnewをずらーっと用意する=メモリ食い潰し問題 も意識)
　　　上記仕様の実現は、オリジナルのメソッドのsetupとdrawを内包したallwork()、drawork()によるもの。
　　　あとsizeメソッドのP2Dの引数が独特になってしまった(String)ので、これくらいが注意？
         あと描画のメソッドは全てpg.を付けて行う。

　　　あと、getImage()やgetBuffer()はDRAW_ONLY(buffer取ってくるだけ)、NO_WORK(シーン管理の仕事をカット
　　　し、CG処理だけする)のオプションを引数で使い分ける。

・HanyouBufferを格納し、遷移やらの管理がやりやすくなるように(Scene及びHanyoubuffer内のmypointer)
　　　　シーンチェンジをしたい。buff=buff.work();で　HanyouBuffer work(){ …  return new_buff; }的な切り替え
　　　構造を予定している。
　　　　しかしこれだと上記の「xxx.render();一手間要らないよ！」の仕様に反する。ので、一番表面では、
　　　HanyouBufferをくるんだScene型mypointerをnewし、各種Bufferではmypointerを(自身Bufferへポインタを向
　　　けてくる変数を)持つ。そして、xxx.getImage();などの処理内でmypointerのポインタ先を変える。
　　　(ある種、自分自身を消す行為に近い。ガベージコレクションもあるし)
　　　メインのdrawでの使い方がscene.getScene().getImage()となった。newはシーンチェンジ用のGUIも引数する。

　　　少し、処理(の所在)が不透明になっているのが傷。
　　　(尚、その後、sceneクラス内ではシーンリストのロードとかGUI切り替えとか雑務が増えた模様)
*/

final boolean NOT_OPTION=true;
class Scene// HanyouBufferをラップするクラス　(Integerの真似)
{
  HanyouBuffer scene;
  Menu optionGUI;
  Scene(HanyouBuffer scene,Menu optionGUI)
  {
    this.scene=scene;
    this.optionGUI=optionGUI;
    optionGUI.sync(this);
  }
  Scene(HanyouBuffer scene)
  {
    this.scene=scene;
    this.optionGUI=new CoverflowGUI(scene.papp,this);
  }
  
  HanyouBuffer getScene()
  {
    if(optionGUI!=null && optionGUI.isUpdate)//if(optionGUI!=null) ha nen-no-tame
    {
      if(optionGUI.getOutputSingle() !=null) setScene(optionGUI.getOutputSingle() );
      if(optionGUI.getOutputList()!=null)     setSceneList(optionGUI.getOutputList() );
    }
    if(optionGUI.isVisible==-1)
    {
      optionGUI.senseMenuOnOff();
      return scene;
    }
    else                                 return optionGUI;
  }
  HanyouBuffer getScene(boolean notoption)
  {
    if(optionGUI!=null && optionGUI.isUpdate)//if(optionGUI!=null) ha nen-no-tame
    {
      if(optionGUI.getOutputSingle() !=null) setScene(optionGUI.getOutputSingle() );
      if(optionGUI.getOutputList()!=null)     setSceneList(optionGUI.getOutputList() );
    }
    return scene;
  }
  
  void setScene(HanyouBuffer scene)
  {
    this.scene=scene;
  }
  void setSceneList(ArrayList<HanyouBuffer> list)
  {
    if(list.size()==0) return;
    setScene(list.get(0).setMyPointer(this)   );
    HanyouBuffer scene=getScene(NOT_OPTION);
    for(int i=1; i<list.size(); i++)  scene=scene.setNext(list.get(i).setMyPointer(this)  ).next;  
  }
  void loadSceneList(String filename)
  {
    filename="save/"+filename+".txt";
    BufferedReader reader=createReader(filename);
    String line;
    ArrayList<HanyouBuffer> loadlist=new ArrayList<HanyouBuffer>();
    
    int from=-2,to=-1;
    try
    {
      line=reader.readLine();
    }catch(IOException e)
    {
      line=null;
      println("loadSceneList error.");
      return;
    }
    for(int i=0; i<line.length(); i++)
    {
      if( line.charAt(i)=='$' || line.charAt(i)=='.' || line.charAt(i)==',')
      {
        if(from<to && i>to)from=i;
        if(i!=from && from>to) to=i;
        if(from<to)
        {
          HanyouBuffer buff=optionGUI.getSampleList().get(line.substring(from,to) );
          if(buff!=null) loadlist.add(buff);
          else
          {
            println("loadSceneList load-error:     ["+line.substring(from,to)+"] <-not find.");
            loadlist.add(optionGUI.getSampleList().get("$NoneContentScene") );
          }
          from=to;
          to--;
    } } }
    setSceneList(loadlist);
    optionGUI.sync(this);
  }
  
}









final int DRAW_ONLY=0;
final boolean NOT_WORK=true;
abstract class HanyouBuffer
{
 PGraphics pg;
 Boolean isFirst=true,isError=false;
 String name;
 PApplet papp;
 HanyouBuffer next;
 Scene mypointer=null;
 HanyouBuffer(PApplet papp)
 {
   name=getClassName();
   this.papp=papp;
 }
 HanyouBuffer(PApplet papp,Scene mypointer)
 {
   name=getClassName();
   this.papp=papp;
   this.mypointer=mypointer;
 }
 HanyouBuffer(HanyouBuffer now,HanyouBuffer next)
 {
   name=getClassName();
   this.papp=now.papp;
   this.mypointer=now.mypointer;
 }
 abstract void setup();
 abstract void draw();
 HanyouBuffer sceneWork(){ return this; }
 
 
 public void allwork(){ allwork(false);  }
 public void allwork(boolean isIamElement)
 {
   if(!isError)
   {
     if(!isIamElement && mypointer!=null) mypointer.setScene(sceneWork() );
     if(isFirst)
     {
       setup();
       isFirst=false;
     }
     drawork();
   }
 }
 void drawork()
 {
   if(pg==null)
   {
     println(name+" is not put size(width,height,pmode,name);");
     isError=true;
     return;
   }
   pg.beginDraw();
   pg.loadPixels();
   draw();
   pg.updatePixels();
   pg.endDraw();
 }
 void size(int w,int h, String pmode)
 {
   if(pmode.equals("P2D") ) pg=createGraphics(w,h,P2D);
   if(pmode.equals("P3D") ) pg=createGraphics(w,h,P3D);
   pg.smooth();
   pg.beginDraw();
   pg.background(0);
   pg.updatePixels();
   pg.endDraw();
 }
 
 PImage getImage()
  {
    return getBuffer().get();
  }
 PGraphics getBuffer()
 {
   allwork();
   return pg;
 }
 PImage getImage(int nonework)        //use-example getImage(DRAW_ONLY),  for(int i=50; i>=DRAW_ONLY; i--)getImage(i);
 {
   return getBuffer(nonework).get();
 }
 PGraphics getBuffer(int nonework)
 {
   if(nonework==DRAW_ONLY)
   {
     //allwork();
     return pg;
   }
   else return getBuffer();
 }
 PImage getImage(boolean nonework)//use-example:  getImage(NOT_WORK)
 {
   return getBuffer(NOT_WORK).get();
 }
 PGraphics getBuffer(boolean nonework)
 {
   allwork(NOT_WORK);
   /*
   if(pg==null)
   {
     println(name+" is not size(width,height,pmode,name);");
     isError=true;
     return null;
   }
   */
   return pg;
 }
 
 HanyouBuffer setMyPointer(Scene mypointer)
 {
   this.mypointer=mypointer;
   return this;
 }
 HanyouBuffer setNext(HanyouBuffer next)
 {
   this.next=next;
   return this;
 }
 
 
 String getClassName()
 {
   String str=""+this;//ProjectionTest_koba$SceneList@1931579
   String[] strArray1=str.split("koba");
   String[] strArray2=strArray1[1].split("@");
   return strArray2[0];
 }
 
 void colorcontrol(String targetname,ColorObject target,char presskey)
  {
    if(papp.keyPressed&& papp.key==presskey)
    {
      if(!colorwidget.isWork)
      {
        colorwidget.setColorObject(targetname,target);
        colorwidget.setVisible(true);
      }
      else colorwidget.setVisible(false);
      papp.key='¥';
    }
  }
  
 
}
