
public final float WINDOW_ALPHA=1.0;
public int mainwinX=200,mainwinY=200;
char controlKey=' ';
public char FullscreenKey='F';

AppletB sapp;
Scene scene,scene2,scene3;
DrawSettingData CENTER_FLOOR,RIGHT_WALL,LEFT_WALL;

void setup()
{
  size(screen.width,screen.height,P2D);
  //size(300,300);
  textureMode(NORMALIZED);
  noFill();
  //sapp=new AppletB(0.8);
  //createApp( (HanyouApplet)sapp ,600,200);
  
  CENTER_FLOOR = new DrawSettingData("positions1.txt","CENTER_FLOOR");
  RIGHT_WALL     = new DrawSettingData("positions2.txt","RIGHT_WALL");
  LEFT_WALL        = new DrawSettingData("positions3.txt","LEFT_WALL");
  
  scene=new Scene(new Controller(this),new CoverflowGUI_ll(this,'c') );
  //scene.optionGUI.setSampleList(new SampleListTest(this) );
  scene.optionGUI.setSampleList(new CenterProjectionList(this) );
  scene.loadSceneList("0004c");
  
  scene2=new Scene(new Controller(this),new CoverflowGUI_ll(this,'l') );
  scene2.optionGUI.setSampleList(new LeftProjectionList(this) );
  scene2.loadSceneList("0004l");
  //scene2.optionGUI.setPApp(sapp);
  //scene2.optionGUI.sync(sapp.ball);
  
  scene3=new Scene(new Controller(this),new CoverflowGUI_ll(this,'r') );
  scene3.optionGUI.setSampleList(new RightProjectionList(this) );
  scene3.loadSceneList("0004r");
} 
void draw()
{
  background(0,0,0,0);
  //image(scene.getScene().getImage(),0,0,width,height);
  
  imageMapping(scene  .getScene().getImage(),CENTER_FLOOR);
  //imageMapping(scene2.getScene().getImage(),LEFT_WALL);
  //imageMapping(scene3.getScene().getImage(),RIGHT_WALL);
  
  work();
}

void imageMapping(PImage img,DrawSettingData setting)
{
  beginShape();
      texture(img);
      vertex(setting.pos[0][0], setting.pos[0][1],     setting.texpos[0][0],setting.texpos[0][1]);
      vertex(setting.pos[1][0], setting.pos[1][1],     setting.texpos[1][0],setting.texpos[1][1]);
      vertex(setting.pos[2][0], setting.pos[2][1],     setting.texpos[2][0],setting.texpos[2][1]);
      vertex(setting.pos[3][0], setting.pos[3][1],     setting.texpos[3][0],setting.texpos[3][1]);
  endShape();
}
  
void work()//  system-work etc
{
  fill(255);
  rect(0,0,120,50);
  fill(0);
  textSize(32);
  text("FPS:" + int(frameRate), 10, 40);
  
  window_size_control_system();
  window_control_system();
  window_control_mousesystem();
}


/*  0124
　色選択機能実装。マウスの少し下にポップアップみたいに出すようにしたい

*/
/*同日更新。
　とりあえず、マウスの近くにカラーウィジェット出現は実装。
　メインタブがどんどん増えて行きそうだったので、initメソッドがあるタブに移した。

　他、HanyouApplet先でのkeyPressed、keyの挙動に違和感。
　“一回だけ発動”を行うなら、終わりに、その判定のkeyにダミー数値を書き込むべきかも。

　とりあえずダミー数値は¥
　colorcontrolというメソッドで纏めた。
   colorwidgetで管理させてー、と投げた色の元値を反映するようにしたかったが、十字マークの最適位置が導き出せていない。
*/

/*



「シーンチェンジのソースが奇麗に書けないから、研究抜きでも便利だろうから、ストーリーボード的なGUIを作る」を目標に、まずはカバーフロウを利用した「選択肢」を実装した。
　ここから【シーンチェンジの連なりへ、インプット】【朝昼晩的に設定した方のシーンリストのセーブ&ロード】【どの壁の面か選択するGUI】とか煮詰める感じ。

　尚、玄関投影の研究は「天気情報と連携してシーンを決定する」ので、このカバーフロウの選択肢とかは脱線であることに留意。

　シーンリストが良い感じ。新マインクラフトみたいにMap(ID代わりの名前、実物)で登録していくのだが、クラス名の取得ができた。但し「ProjectionTest_koba$Ball@14cc1」的なものからクラス名部分を抽出した。「koba」をキーとしているので、適時変更が必要。


　カバーフロウをずっと出してるリモコン的ウインドウと、その操作される側ウインドウに分けることもできる。
　但し、このためのoverflowや前のcolor widgetは、インナークラスの利点を生かして「引数にせずに引き継いでいる」　忘れない方が良い気がする。

*/


