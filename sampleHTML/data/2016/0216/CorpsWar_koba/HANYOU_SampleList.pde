
/*
　This program is
　このプログラムは、シーン選択やセーブファイルロードに使われるシーンリストの原型。特にTestSampleListはシーンリストの定義の仕方として見といて。
*/
class TestSampleList extends SampleList
{
  TestSampleList(PApplet papp)
  {
    super(papp);
    addScene(new NoneContentScene(papp) );
  }
  
}
class NoneContentScene extends HanyouBuffer
{
  NoneContentScene(PApplet papp){  super(papp);}
  void setup(){  size(100,100,"P2D");  pg.background(100,100,100,255);  pg.textSize(60); pg.text("no image",10,height/2); }
  void draw(){ }
}



class SampleList
{
  PApplet papp;
  HashMap<String,HanyouBuffer> scenelist;
  SampleList(PApplet papp)
  {
    scenelist=new HashMap<String,HanyouBuffer>();
    this.papp=papp;
  }
  void setPApp(PApplet papp)
  {
    Iterator it=scenelist.keySet().iterator();
    while(it.hasNext() ) scenelist.get(it.next() ).papp=papp;
  }
  void addScene(HanyouBuffer scene)
  {
    scenelist.put(scene.name,scene);
  }
  HanyouBuffer get(String name)
  {
    return scenelist.get(name);
  }
  void debugmessage()
  {
    Iterator it=scenelist.keySet().iterator();
    int i=0;
    println("");
    println("");
    println("<"+getClassName()+">all content");
    while(it.hasNext() )
    {
      Object o=it.next();
      println( "          "+(i++)+"   :   "+o   );//scenelist.get(o)
    }
    println("-------------------------------------------------------end");
  }
  
 String getClassName()
 {
   String str=""+this;//ProjectionTest_koba$SceneList@1931579
   String[] strArray1=str.split("koba");
   String[] strArray2=strArray1[1].split("@");
   return strArray2[0];
 }
 int size(){   return scenelist.size();}
 
 
}
