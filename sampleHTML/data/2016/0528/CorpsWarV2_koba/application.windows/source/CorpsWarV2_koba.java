import processing.core.*; 
import processing.xml.*; 

import java.awt.*; 
import java.awt.Frame; 
import javax.swing.JFrame; 
import java.awt.Insets; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class CorpsWarV2_koba extends PApplet {


public final float WINDOW_ALPHA=0.8f;
public final boolean IS_ALWAYS_ON_TOP=true;
public int mainwinX=200,mainwinY=200;
char controlKey=' ';
public char FullscreenKey='F';
public int Menu_FPS_MIN=10;
//AppletD sapp;
Scene scene;

CorpsWarApp cwapp;
int corpNum=3, unitNum=15,bulletNum=unitNum*2;
Corp[] corps;
Bullet[]  bullets;

public void setup()
{
  //size(screen.width,screen.height,P2D);
  size(500,400,P2D);
  Key_setApplet(this);
  smooth();
  noFill();
  //sapp=new AppletD(0.8);
  cwapp=new CorpsWarApp(1.0f);
  createApp( (HanyouApplet)cwapp ,200,100);

  scene=new Scene(new NoneContentScene(this),new CoverflowGUI(this,'m') );
  scene.optionGUI.setSampleList(new SampleListTest(this) );
  scene.loadSceneList("0005");
}
public void draw()
{
  background(0,0,0,0);
  image(scene.getScene().getImage(),0,0,width,height);
  //image(sapp.outputSync(scene).getScene().getImage(),0,0,width,height);//remocon ver(when sapp=AppletD)
  work();
}
public void work()//  system-work etc
{
  /*
  fill(255);
  rect(0,0,120,50);
  fill(0);
  textSize(32);
  text("FPS:" + int(frameRate), 10, 40);
  */
  window_control_mousesystem();
  window_size_control_system();
  window_control_system();
  Key_update();
}





int pressTime[]=null;
public void Key_setApplet(PApplet applet)
{
  pressTime = new int[Character.MAX_VALUE];
  applet.addKeyListener( new java.awt.event.KeyAdapter()
                         {
                          public void keyPressed(java.awt.event.KeyEvent e)
                          {
                            if (pressTime[e.getKeyCode()] <= 0)
                              pressTime[e.getKeyCode()] = 1;
                          }
                          public void keyReleased(java.awt.event.KeyEvent e)
                          {
                            pressTime[e.getKeyCode()] = -1;
                          }
                         }
                       );
}
public int Key_get(int code){  return pressTime[code]; }
public boolean Key_pressed(int code){  return Key_get(code)==1; }
public boolean Key_released(int code){  return Key_get(code)==-1; }
public boolean Key_pushed(int code, int n, int m){  return Key_get(code)>=n&&Key_get(code)%m==0; }
public void Key_update()
{  
   for (int i=0; i<pressTime.length; i++)
     pressTime[i]+=pressTime[i]!=0?1:0; 
}


/*  0124
\u3000\u8272\u9078\u629e\u6a5f\u80fd\u5b9f\u88c5\u3002\u30de\u30a6\u30b9\u306e\u5c11\u3057\u4e0b\u306b\u30dd\u30c3\u30d7\u30a2\u30c3\u30d7\u307f\u305f\u3044\u306b\u51fa\u3059\u3088\u3046\u306b\u3057\u305f\u3044

*/
/*\u540c\u65e5\u66f4\u65b0\u3002
\u3000\u3068\u308a\u3042\u3048\u305a\u3001\u30de\u30a6\u30b9\u306e\u8fd1\u304f\u306b\u30ab\u30e9\u30fc\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u51fa\u73fe\u306f\u5b9f\u88c5\u3002
\u3000\u30e1\u30a4\u30f3\u30bf\u30d6\u304c\u3069\u3093\u3069\u3093\u5897\u3048\u3066\u884c\u304d\u305d\u3046\u3060\u3063\u305f\u306e\u3067\u3001init\u30e1\u30bd\u30c3\u30c9\u304c\u3042\u308b\u30bf\u30d6\u306b\u79fb\u3057\u305f\u3002

\u3000\u4ed6\u3001HanyouApplet\u5148\u3067\u306ekeyPressed\u3001key\u306e\u6319\u52d5\u306b\u9055\u548c\u611f\u3002
\u3000\u201c\u4e00\u56de\u3060\u3051\u767a\u52d5\u201d\u3092\u884c\u3046\u306a\u3089\u3001\u7d42\u308f\u308a\u306b\u3001\u305d\u306e\u5224\u5b9a\u306ekey\u306b\u30c0\u30df\u30fc\u6570\u5024\u3092\u66f8\u304d\u8fbc\u3080\u3079\u304d\u304b\u3082\u3002

\u3000\u3068\u308a\u3042\u3048\u305a\u30c0\u30df\u30fc\u6570\u5024\u306f\u00a5
\u3000colorcontrol\u3068\u3044\u3046\u30e1\u30bd\u30c3\u30c9\u3067\u7e8f\u3081\u305f\u3002
   colorwidget\u3067\u7ba1\u7406\u3055\u305b\u3066\u30fc\u3001\u3068\u6295\u3052\u305f\u8272\u306e\u5143\u5024\u3092\u53cd\u6620\u3059\u308b\u3088\u3046\u306b\u3057\u305f\u304b\u3063\u305f\u304c\u3001\u5341\u5b57\u30de\u30fc\u30af\u306e\u6700\u9069\u4f4d\u7f6e\u304c\u5c0e\u304d\u51fa\u305b\u3066\u3044\u306a\u3044\u3002
*/

/*



\u300c\u30b7\u30fc\u30f3\u30c1\u30a7\u30f3\u30b8\u306e\u30bd\u30fc\u30b9\u304c\u5947\u9e97\u306b\u66f8\u3051\u306a\u3044\u304b\u3089\u3001\u7814\u7a76\u629c\u304d\u3067\u3082\u4fbf\u5229\u3060\u308d\u3046\u304b\u3089\u3001\u30b9\u30c8\u30fc\u30ea\u30fc\u30dc\u30fc\u30c9\u7684\u306aGUI\u3092\u4f5c\u308b\u300d\u3092\u76ee\u6a19\u306b\u3001\u307e\u305a\u306f\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u3092\u5229\u7528\u3057\u305f\u300c\u9078\u629e\u80a2\u300d\u3092\u5b9f\u88c5\u3057\u305f\u3002
\u3000\u3053\u3053\u304b\u3089\u3010\u30b7\u30fc\u30f3\u30c1\u30a7\u30f3\u30b8\u306e\u9023\u306a\u308a\u3078\u3001\u30a4\u30f3\u30d7\u30c3\u30c8\u3011\u3010\u671d\u663c\u6669\u7684\u306b\u8a2d\u5b9a\u3057\u305f\u65b9\u306e\u30b7\u30fc\u30f3\u30ea\u30b9\u30c8\u306e\u30bb\u30fc\u30d6&\u30ed\u30fc\u30c9\u3011\u3010\u3069\u306e\u58c1\u306e\u9762\u304b\u9078\u629e\u3059\u308bGUI\u3011\u3068\u304b\u716e\u8a70\u3081\u308b\u611f\u3058\u3002

\u3000\u5c1a\u3001\u7384\u95a2\u6295\u5f71\u306e\u7814\u7a76\u306f\u300c\u5929\u6c17\u60c5\u5831\u3068\u9023\u643a\u3057\u3066\u30b7\u30fc\u30f3\u3092\u6c7a\u5b9a\u3059\u308b\u300d\u306e\u3067\u3001\u3053\u306e\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u306e\u9078\u629e\u80a2\u3068\u304b\u306f\u8131\u7dda\u3067\u3042\u308b\u3053\u3068\u306b\u7559\u610f\u3002

\u3000\u30b7\u30fc\u30f3\u30ea\u30b9\u30c8\u304c\u826f\u3044\u611f\u3058\u3002\u65b0\u30de\u30a4\u30f3\u30af\u30e9\u30d5\u30c8\u307f\u305f\u3044\u306bMap(ID\u4ee3\u308f\u308a\u306e\u540d\u524d\u3001\u5b9f\u7269)\u3067\u767b\u9332\u3057\u3066\u3044\u304f\u306e\u3060\u304c\u3001\u30af\u30e9\u30b9\u540d\u306e\u53d6\u5f97\u304c\u3067\u304d\u305f\u3002\u4f46\u3057\u300cProjectionTest_koba$Ball@14cc1\u300d\u7684\u306a\u3082\u306e\u304b\u3089\u30af\u30e9\u30b9\u540d\u90e8\u5206\u3092\u62bd\u51fa\u3057\u305f\u3002\u300ckoba\u300d\u3092\u30ad\u30fc\u3068\u3057\u3066\u3044\u308b\u306e\u3067\u3001\u9069\u6642\u5909\u66f4\u304c\u5fc5\u8981\u3002


\u3000\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u3092\u305a\u3063\u3068\u51fa\u3057\u3066\u308b\u30ea\u30e2\u30b3\u30f3\u7684\u30a6\u30a4\u30f3\u30c9\u30a6\u3068\u3001\u305d\u306e\u64cd\u4f5c\u3055\u308c\u308b\u5074\u30a6\u30a4\u30f3\u30c9\u30a6\u306b\u5206\u3051\u308b\u3053\u3068\u3082\u3067\u304d\u308b\u3002
\u3000\u4f46\u3057\u3001\u3053\u306e\u305f\u3081\u306eoverflow\u3084\u524d\u306ecolor widget\u306f\u3001\u30a4\u30f3\u30ca\u30fc\u30af\u30e9\u30b9\u306e\u5229\u70b9\u3092\u751f\u304b\u3057\u3066\u300c\u5f15\u6570\u306b\u305b\u305a\u306b\u5f15\u304d\u7d99\u3044\u3067\u3044\u308b\u300d\u3000\u5fd8\u308c\u306a\u3044\u65b9\u304c\u826f\u3044\u6c17\u304c\u3059\u308b\u3002

*/

/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u307e\u3042\u3001\u3044\u308f\u3086\u308bmain\u30e1\u30bd\u30c3\u30c9\u307f\u305f\u3044\u306a\u3082\u3093\u3067\u3001\u5b9f\u969b\u306e\u4e2d\u8eab\u306fscene\u5909\u6570\u306e\u4e2d\u8eab\u307f\u305f\u3044\u306a\u3082\u3093\u3002
\u3000scene\u5909\u6570\u3092image()\u3059\u308b\u306e\u304c\u4e3b\u306a\u4ed5\u4e8b\u3067\u3001\u5f8c\u306f\u3001\u30b0\u30ed\u30fc\u30d0\u30eb\u5909\u6570\u3092\u660e\u793a\u7684\u306b\u7f6e\u304f\u90e8\u5206(\u96a0\u308c\u3066\u7f6e\u304f\u306a\u3089init()\u304c\u3042\u308b\u30bf\u30d6\u306e\u65b9)
\u3000\u30d7\u30ed\u30b0\u30e9\u30e0\u306e\u5143\u304c\u7384\u95a2\u6295\u5f71\u3060\u3063\u305f\u306e\u3067\u3001DrawSettingData\u304c\u3042\u308b\u3002\u307e\u3042\u3001\u307e\u305f\u6295\u5f71\u3059\u308b\u304b\u3082\u3057\u308c\u306a\u3044\u3057\u3001\u6b8b\u3057\u3066\u304a\u3053\u3046\u3002
*/

/*

\u3000\u7406\u60f3\u901a\u308a\u306e\u69cb\u9020(\u30b7\u30fc\u30f3\u30c1\u30a7\u30f3\u30b8\u3084\u30bb\u30ec\u30af\u30c8\u3084\u30ed\u30fc\u30c9)\u3092\u5b9f\u88c5\u3067\u304d\u305f\u304c\u3001\u3081\u3061\u3083\u304f\u3061\u3083\u91cd\u3044\u3002
\u3000\u91cd\u3044\u539f\u56e0\u306f\u3001Hanyoubuffer\u306esize()\u306e\u30d0\u30c3\u30d5\u30a1\u7528\u610f\u304c\u3001\u5168\u90e8\u5225\u3060\u304b\u3089\u3060\u308d\u3046\u3002
\u30d0\u30c3\u30d5\u30a1\u3092\u30ea\u30b9\u30c8\u7ba1\u7406\u3057\u3066\u540c\u4e00\u30b5\u30a4\u30ba\u8981\u6c42\u306f\u30b7\u30a7\u30a2\u3055\u305b\u3088\u3046\u3002
(\u63cf\u753b\u6700\u521d\u306bbackground()\u3057\u306a\u3044\u5b50\u305f\u3061\u306f\u30a8\u30e9\u30fc\u51fa\u3057\u305d\u3046\u3060\u304c)

\u3000\u30bb\u30ec\u30af\u30c8\u753b\u9762\u306f\u3068\u3082\u304b\u304f\u3001\u30dc\u30fc\u30eb\u304c\u79fb\u52d5\u3057\u3066\u308b\u3060\u3051\u306e\u63cf\u753b\u4e2d\u306b\u91cd\u3044\u306e\u306f\u8151\u306b\u843d\u3061\u306a\u3044\u3002
\u88cf\u3067\u30d0\u30c3\u30d5\u30a1\u306b\u7121\u99c4\u306b\u66f8\u304d\u8fbc\u307f\u884c\u3063\u3066\u3044\u306a\u3044\u304b\uff1f
\u3000->\u88cf\u3067\u52d5\u3044\u3066\u3084\u304c\u308b\u2026\u2026SampleList\u306eadd\u6e1b\u3089\u3057\u305f\u3089\u5287\u7684\u306b\u8efd\u304f\u306a\u3063\u305f\u308f
\u3000\u3000\u8981\u89e3\u6c7a
*/
/*
\u3000\u901f\u5ea6\u554f\u984c\u89e3\u6c7a\u3002optionGUI\u304cisVisible=-1\u306e\u6642\u306bcoverflow\u63cf\u753b\u3060\u3051\u660e\u793a\u7684\u306b\u884c\u308f\u305b\u3066\u305f\u3002\u30d0\u30c3\u30d5\u30a1\u304c\u7121\u99c4\u306b\u66f4\u65b0\u3055\u308c\u308b\u3060\u3051\u3002\u610f\u5473\u4e0d\u660e\u3002
   \u3060\u304c\u3001\u30d0\u30c3\u30d5\u30a1\u500b\u5225\u306b\u7528\u610f\u3057\u3066\u308b\u306e\u306f\u30e1\u30e2\u30ea\u98df\u3044\u904e\u304e\u554f\u984c\u3082\u304d\u3063\u3068\u8d77\u304d\u308b\u306f\u305a\u3002\u8981\u6ce8\u610f

\u3000\u4e00\u5fdctodo(\u305d\u3053\u307e\u3067\u5fc5\u8981\u3067\u3082\u306a\u3044\u306a\u30fc\u3001\u3068\u3044\u3046\u3088\u308a\u3053\u306ekoba\u69cb\u9020\u3092\u5b9f\u969b\u904b\u7528\u3057\u3066\u307f\u305f\u3044\u306a\u30fc)

\u30fb\u30b7\u30fc\u30f3\u9023\u306a\u308a\u306e\u30bb\u30fc\u30d6\u6a5f\u80fd
\u30fb\u30c8\u30e9\u30f3\u30b8\u30b7\u30e7\u30f3\u3092\u3001optionGUI\u3067\u3082\u9078\u3079\u308b\u3088\u3046\u306b(\u3054\u3064\u3044\u6539\u4fee)

*/
/*
\u3000\u8fd1\u3057\u3044\u8ab2\u984c\u3002

\u3000\u30fbHanyouBuffer\u306e\u6709\u52b9\u5229\u7528\u3068\u3044\u3046\u3053\u3068\u3067\u3001FireCube(pixels\u5358\u4f4d\u3067\u5168\u4f53\u5f04\u3063\u3066\u308b\u3084\u3064)\u3068\u305d\u306eblend()\u3092Controller\u3067\u8a66\u3059\u3002
\u3000\u30fboptionGUI\u306e\u5229\u7528\u306b\u3064\u3044\u3066\u3002sceneWork\u3067\u8a2d\u5b9a\u305b\u305a\u306b\u3001\u306a\u305cisVisible\u3067\u30aa\u30f3\u30aa\u30d5\u3057\u3066\u3057\u307e\u3063\u305f\u3093\u3060\u308d\u3046\u3002
\u3000\u3000\u3000->\u3072\u3068\u3064\u8003\u3048\u308b\u306a\u3089\u3001optionGUI\u306f\u63cf\u753b\u9818\u57df\u3092\u3069\u3053\u306b\u3082\u4f9d\u5b58\u305b\u305a\u5c0f\u3055\u304f\u3059\u308b\u3068\u304b\u3001\u304b\u306a\u3002\u3057\u304b\u3057\u305d\u308c\u3082\u3001coverflowGUI\u3092\u5305\u3093\u3067\u5c0f\u3055\u304f\u63cf\u753b\u3059\u308b\u3088\u3046\u306b\u3059\u308c\u3070\u3044\u3044\u3002\u307e\u3042\u3001\u6a19\u6e96\u88c5\u5099\u3057\u3088\u3046\u3068\u3057\u3066\u308b\u5272\u306b\u306f\u30d0\u30c3\u30d5\u30a1\u7528\u610f\u5927\u6749\u304b\u306a\u3041\u2026\u2026
\u3000\u3000\u3000->\u66f4\u306b\u4e00\u3064\u8003\u3048\u305f\u3002\u672c\u6765\u63cf\u753b\u3068optionGUI\u63cf\u753b\u3092\u5207\u308a\u66ff\u3048\u308b\u306e\u306fScene\u30af\u30e9\u30b9\u3067\u3001\u3053\u3053\u306bsceneWork\u306f\u306a\u3044\u3002
\u3000\u3000\u3000\u3000\u5c1a\u4e14\u3064\u3001\u901a\u5e38\u30b7\u30fc\u30f3\u9077\u79fb\u306e\u3088\u3046\u306boptionGUI\u3092HanyouBuffer\u306eSceneWork\u3067\u6271\u308f\u305b\u3088\u3046\u3068\u3059\u308c\u3070\u3001\u5404\u30b7\u30fc\u30f3\u3067optionGUI\u3092\u5171\u6709\u3057\u306a\u3051\u308c\u3070\u306a\u3089\u306a\u3044\u624b\u9593\u3002
\u3000\u3000\u3000\u3000\u3060\u304b\u3089\u73fe\u72b6\u614b\u306f\u59a5\u5f53\u3002
*/
/*
\u3000\u4e0a\u8a18\u304b\u3089\u5225\u554f\u984c\u3002option\u753b\u9762\u306a\u3093\u3066\u4e00\u3064\u3058\u3083\u306a\u3044\u3060\u308d\u3046\u3057\u3001\u305d\u308c\u5168\u90e8Scene\u30af\u30e9\u30b9\u306b\u8a70\u3081\u8fbc\u3080\u308f\u3051\u306b\u306f\u3044\u304b\u306a\u3044(\u305d\u3082\u305d\u3082\u30e9\u30c3\u30d1\u30fc\u306e\u3064\u3082\u308a\u3060\u3063\u305f\u306e\u306b)
\u3000option\u753b\u9762\u3078\u306e\u9077\u79fb\u69cb\u9020\u306f\u30b7\u30fc\u30f3\u69cb\u9020\u3068\u306f\u5225\u306b\u8003\u3048\u306a\u3051\u308c\u3070\u3002\u305d\u308c\u304b\u3001\u300c\u30b7\u30fc\u30f3\u9077\u79fb\u306eoption\u753b\u9762\u3058\u3083\u306a\u3044\u300d\u306a\u3089sceneWork\u30e1\u30bd\u30c3\u30c9\u3067\u306e\u30b7\u30fc\u30f3\u9077\u79fb\u3067\u3044\u3044\u304b\uff1f\u3000\u3044\u3044\u6c17\u3082\u3059\u308b\u306a
*/

/*
\u3000\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u30e2\u30fc\u30c9\u95a2\u9023\u3068\u30c6\u30af\u30b9\u30c1\u30e3\u30de\u30c3\u30d4\u30f3\u30b0\u6a5f\u80fd\u306e\u5171\u5b58\u53ef\u80fd\u5316\u3002size\u5909\u66f4\u306e\u65b9\u306esize()\u306bP2D\u5165\u308c\u3066\u306a\u304b\u3063\u305f\u3002
\u3000\u5b9f\u7a3c\u52d5\u4e0a\u306e\u554f\u984c\u306f\u3001\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u306b\u3059\u308b\u3068\u91cd\u3044\u4e8b(\u7279\u306b\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u3002\u3053\u3044\u3064\u30b5\u30a4\u30ba\u56fa\u5b9a\u5316\u3057\u3088)
*/

/*

\u3000\u65e5\u672c\u8a9e\u4f7f\u3046\u306a\u3089
    PFont myFont=createFont("HiraginoSansGB-W6-48.vlw",32);
    pg.textFont(myFont);

\u3000\u306e\u5f8c\u306b\u3001text()\u30e1\u30bd\u30c3\u30c9
*/
/*

\u300c\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u306b\u62e1\u5927\u3059\u308b\u300d\u300c\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u300d\u304c\u91cd\u3044\u7406\u7531\u306f\u3001Image\u306e\u62e1\u5927\u7e2e\u5c0f\u51e6\u7406\u304c\u91cd\u3044\u306e\u304c\u539f\u56e0\u306e\u3088\u3046\u3060\u3002
\u3000\u4f8b\u3048\u3070\u6700\u521d\u304b\u3089\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u3067\u3001size(100,100)\u3067\u306f\u306a\u304fsize(width,height)\u3068\u3057\u3066\u3044\u308c\u3070\u3001\u3081\u3063\u3061\u3083\u8efd\u3044\u3002

\u3000\u62e1\u5927\u7e2e\u5c0f\u51e6\u7406\u3060\u3051\u3067\u3082GPU\u901a\u3057\u3066(\u30b7\u30a7\u30fc\u30c0\u30fc\u8a00\u8a9e\u3067)\u3084\u3063\u305f\u65b9\u304c\u3044\u3044\u304b\u3082\u306a\u3041\u3002

\u3000\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u306e\u30b5\u30e0\u30cd\u30a4\u30eb\u8868\u793a(\u7e2e\u5c0f\u51e6\u7406)\u306b\u5408\u308f\u305b\u3066\u3001size()\u306f\u5c0f\u3055\u304f\u8a2d\u5b9a\u3057\u305f\u3002\u3053\u308c\u3067\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u306f\u6bd4\u8f03\u7684\u8efd\u3044\u3002\u3057\u304b\u3057\u3001\u73fe\u72b6\u306e\u8a2d\u5b9a\u3067\u306f\u3001\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u304c\u91cd\u3044\u3002

\u3000\u3042\u3068\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u306e\u8efd\u91cf\u5316\u3002\u30b5\u30e0\u30cd\u30a4\u30eb\u306e\u30ec\u30f3\u30c0\u30ea\u30f3\u30b0(\u66f4\u65b0)\u306e\u9593\u9694\u3092\u5f04\u308c\u308b\u3088\u3046\u306b\u3002gif\u30a2\u30cb\u30e1\u30b5\u30e0\u30cd\u30a4\u30eb\u3063\u307d\u304f\u306a\u3063\u305f\u3002

*/

/*0716

\u3000\u30d7\u30ed\u30b8\u30a7\u30af\u30b7\u30e7\u30f3\u30de\u30c3\u30d4\u30f3\u30b0\u306e\u624b\u52d5\u4f4d\u7f6e\u5408\u308f\u305b\u306b\u5bfe\u5fdc(ProjImage)
\u3000\u5f8c\u306f\u3001\u30bb\u30fc\u30d6\u6a5f\u80fd\u304c\u6b32\u3057\u3044\u306a\u2026\u2026

*/

/*
0823
\u3000PoyoBall\u3092\u5b9f\u88c5\u3068\u3044\u3046\u304b\u79fb\u690d\u3002\u500b\u4f53\u3060\u3063\u305f\u3068\u304d\u306e\u30b0\u30ed\u30fc\u30d0\u30eb\u5909\u6570\u3092\u305d\u306e\u307e\u307e\u6271\u3063\u3066\u3044\u308b\u306e\u3067\u3001\u8907\u6570\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u3092\u4f5c\u308b\u3068\u30d0\u30b0\u308b\u3002
\u3000PoyoBall\u306e\u30e1\u30a4\u30f3\u306e\u90e8\u5206setup-draw\u304c\u30af\u30e9\u30b9\u306b\u306a\u3063\u305f\u4e8b\u3092\u8003\u616e\u3057\u3066\u30d5\u30a3\u30fc\u30eb\u30c9\u5909\u6570\u306b\u7f6e\u304d\u63db\u3048\u308b\u3079\u304d\u3002
\u3000(\u8907\u6570\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\uff1a\u3000SampleList\u3092\u4e8c\u30ab\u6240\u3067\u30ed\u30fc\u30c9\u3057\u305f\u5834\u5408)
*/

/*
0827
\u3000\u8907\u6570\u30a6\u30a4\u30f3\u30c9\u30a6\u3092\u4f5c\u308c\u308b\u304c\u3001\u3069\u3053\u307e\u3067\u6d3b\u7528\u3067\u304d\u308b\u304b(\u30b9\u30ec\u30c3\u30c9\u306e\u540c\u671f\u4e91\u3005\u554f\u984c\u306b\u3069\u308c\u307b\u3069\u885d\u7a81\u3059\u308b\u304b)\u78ba\u8a8d\u306e\u305f\u3081\u3001\u7247\u5074\u3092output\u30a6\u30a4\u30f3\u30c9\u30a6\u3001\u3082\u3046\u7247\u65b9\u3092\u30ea\u30e2\u30b3\u30f3Coverflow\u30a6\u30a4\u30f3\u30c9\u30a6\u3068\u3059\u308bAppletD\u3092\u30b5\u30f3\u30d7\u30eb\u3068\u3057\u3066\u4f5c\u308b\u3002
\u3000\u7d50\u679c\u3001\u30ab\u30e9\u30fc\u30d4\u30c3\u30ab\u30fc\u306eApplet\u306e\u3088\u3046\u306b\u3001\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092sync\u3059\u308b\u3088\u3046\u306a\u51e6\u7406\u539f\u7406\u3068\u306a\u3063\u305f\u3002(output\u30a6\u30a4\u30f3\u30c9\u30a6\u306escene\u3068\u3001\u30ea\u30e2\u30b3\u30f3\u7a93\u306escene\u306e\u30e1\u30a4\u30f3\u306e\u3084\u3064\u3092\u7b49\u3057\u304f\u3059\u308b)

\u3000\u307e\u305f\u3001\u300c\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u304b\u3089\u30c7\u30fc\u30bf\u3092\u53d7\u3051\u53d6\u308b\u300d\u3088\u3046\u306a\u51e6\u7406\u306f\u3001\u4eca\u56de\u306eAppletD\u3092\u53c2\u8003\u306b\u3001\u69cb\u9020\u4f53\u7684\u306a\u30af\u30e9\u30b9(Object)\u3092\u4f5c\u3063\u3066\u30bd\u30ec\u306e\u66f8\u304d\u63db\u3048\u66f4\u65b0\u3001\u3068\u3044\u3046\u5f62\u306b\u306a\u308b\u3060\u308d\u3046\u3002
\u3000(\u30ab\u30e9\u30fc\u30d4\u30c3\u30ab\u30fc\u306eApplet\u304c\u305d\u306e\u539f\u672c\u306b\u3042\u305f\u308b\u304c\u3001\u7c21\u5358\u5316\u306f\u51fa\u6765\u3066\u3044\u306a\u3044\u306e\u3067\u898b\u306b\u304f\u3044\u3060\u308d\u3046)
*/
/*
\u3000\u3044\u308d\u3044\u308d\u8a66\u3057\u3066\u307f\u308b\u3068\u3001\u8349\u539f\u3084PoyoBall\u306eendShape()\u3067\u30a8\u30e9\u30fc\u3092\u5410\u304f\u3088\u3046\u3060\u3002
\u3000\u306a\u306e\u3067\u3001\u305d\u308c\u3092\u691c\u8a3c\u3059\u308bDoubleWintest_koba\u3068\u3057\u3066\u8907\u88fd\u3059\u308b\u3002
*/

HanyouApplet hacw=new ColorWidget(new ColorObject(100,0,0,255) );
ColorWidget colorwidget=(ColorWidget)hacw;
boolean resizingFlag=false;//win_control


/*
\u30000217
\u3000OpenProcessing\u306eParticleWar\u3092\u53c2\u8003\u306b\u3001\u591a\u7a2e\u5c04\u6483\u3084\u30b7\u30fc\u30eb\u30c9\u3001\u6226\u95d8\u7528\u306b\u727d\u5236\u7684\u306b\u52d5\u304f\u4e8b\u3001\u81ea\u5206\u30d7\u30ec\u30a4\u30e4\u30fc\u3092\u5b9f\u88c5\u3002
\u3000(TotalWar\u8def\u7dda\u3068\u3044\u3046\u3088\u308a\u306f\u3001TiltToLive\u8def\u7dda(\u3042\u306e\u4e00\u753b\u9762\u3067\u53ce\u307e\u308a\u3001\u30b7\u30f3\u30d7\u30eb\u30c7\u30b6\u30a4\u30f3\u3067\u3001\u683c\u597d\u3044\u3044\u3068\u3044\u3046\u306e\u306f\u3001\u2026\u624b\u304c\u5c4a\u304d\u305f\u3044)  )
\u3000\u300c\u4e00\u753b\u9762\u3067\u5b8c\u7d50\u3057\u3066\u3044\u308b(\u753b\u9762\u9077\u79fb\u3082\u6975\u529b\u7121\u3057\u306b)\u300d\u300cNPC\u3068\u30ef\u30c1\u30e3\u30ef\u30c1\u30e3\u3057\u3066\u3044\u308b\u5b9f\u88c5\u306b\u3057\u305f\u3044(\u30c6\u30a4\u30eb\u30ba\u6226\u95d8\u90e8\u5206\u3084\u3001GodEater\u307f\u305f\u3044\u306b\u3001\u5f79\u306b\u7acb\u3064\u304b\u3069\u3046\u304b\u306f\u3068\u3082\u304b\u304fNPC\u3068\u5171\u95d8\u3067\u3046\u308b\u3055\u3044\u3001\u3068\u3044\u3046\u306e\u304c\u6b32\u3057\u3044)\u300d\u3068\u3044\u3046\u76ee\u8ad6\u307f\u304c\u3053\u3053\u3067\u4e00\u7aef\u306f\u5b9f\u73fe\u3067\u3001\u4eca\u307e\u3067\u306e\u5358\u7d14\u7cfb\u306e\u8a66\u4f5c\u3088\u308a\u306f\u30b2\u30fc\u30e0\u3063\u307d\u304f\u697d\u3057\u3044\u306e\u3067\u3001\u4ed6\u306e\u5b9f\u88c5\u3082\u9032\u3081\u3066\u3044\u3053\u3046\u304b\u3068\u601d\u3046\u3002
\u3000TotalWar\u306e\u300c\u6589\u5c04\u300d\u304c\u683c\u597d\u3044\u3044\u304b\u3089\u3001\u305d\u3093\u306a\u6226\u8853\u6307\u63ee\u306e\u5b9f\u88c5\u3082\u691c\u8a0e\u3059\u308b\u304b\u2026

\u3000\u306a\u306e\u3067\u3001\u5404\u7a2e\u5b9f\u88c5\u3092\u5099\u5fd8\u9332\u7684\u306b\u8a18\u9332\u3059\u308b\u3002
\u3000\u307e\u305a\u3001Simple_koba\u3092\u57fa\u306b\u3001\u30d0\u30c3\u30d5\u30a1\u7ba1\u7406\u7b49\u3092(\u81ea\u5206\u306a\u308a\u306b)\u5bb9\u6613\u306b\u3057\u3066\u8a66\u4f5c\u3057\u3066\u3044\u308b\u3002

\u3000\u672c\u4f53\u306fcorps war\u30bf\u30d6\u3001CorpsWar\u306eHanyouApplet\u3002
\u3000corps(\u99d2\u306e\u7fa4)\u306e\u914d\u5217\u306b\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u751f\u6210\u3002\u305d\u306e\u4e2d\u3067units(\u99d2)\u306e\u914d\u5217\u306b\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u751f\u6210
\u3000corps\u306b\u306fxy\u304c\u3042\u308b\u304c\u3001\u30ea\u30b9\u30dd\u30fc\u30f3\u4f4d\u7f6e\u3068\u3057\u3066\u4f7f\u3048\u308b\u3002\u307e\u305f\u3001\u3053\u306eCorp\u30af\u30e9\u30b9\u3067\u306f\u751f\u5b58\u8005\u306e\u628a\u63e1(\u8868\u793a)\u3084\u3001units\u3078\u306e\u6307\u793a(\u7bc4\u56f2\u9078\u629e->\u6307\u793a)\u3092\u5b9f\u88c5\u3057\u3066\u3044\u308b\u3002
\u3000\u306a\u304a\u3001\u6307\u793a\u306f\u4eca\u306f\u79fb\u52d5\u306e\u307f\u3002\u3053\u306e\u6307\u793a\u53ef\u80fd\u306e\u6709\u7121\u306fisPlayer\u30d5\u30e9\u30b0(\u7bc4\u56f2\u9078\u629e\u306e\u67a0\u3068units\u306e\u8272\u304c\u540c\u3058)\u3002
\u3000\u5168\u4f53\u3068\u3057\u3066\u306fCorps\u30af\u30e9\u30b9\u306fcorps.draw\u5185\u3067\u3001units[i].run();\u306e\u5b9f\u884c\u3001handle();\u306e\u5b9f\u884c\u3067\u6307\u63ee\u3001

\u3000units\u306f\u99d2\u3072\u3068\u3064\u3072\u3068\u3064\u306e\u914d\u5217\u3002Unit\u30af\u30e9\u30b9\u306f\u99d2\u3002
\u3000\u3053\u308c\u306f\u5168\u4f53\u51e6\u7406\u306fdraw();\u3067\u306f\u306a\u304frun();\u3000\u63a5\u6575\u306e\u6709\u7121\u3092isFreeMove\u30d5\u30e9\u30b0\u3067\u7ba1\u7406\u3002
\u3000\u307e\u305f\u3001\u751f\u304d\u3066\u3044\u308b\u304b\u3069\u3046\u304bisWork\u30d5\u30e9\u30b0\u3067\u7ba1\u7406\u3002false\u306a\u3089\u63cf\u753b\u7121\u3057\u3001\u5f53\u305f\u308a\u5224\u5b9a\u7121\u3057\u3001\u4ed6\u304b\u3089\u3082\u30bf\u30fc\u30b2\u30c3\u30c8\u3055\u308c\u306a\u3044\u3002
\u3000isPlayer=true\u306a\u3089keycontrol\u3000\u5c1a\u3001corp\u306eisPlayer\u30d5\u30e9\u30b0\u3068\u306f\u5225(\u81ea\u8ecd\u3092\u64cd\u4f5c\u51fa\u6765\u306a\u3044\u30d7\u30ec\u30a4\u306e\u3068\u304d\u3068\u304b)
\u3000\u79fb\u52d5\u51e6\u7406\u3092\u884c\u3046\u3002\u30d5\u30ea\u30fc\u3067\u306f\u3001\u5b9a\u671f\u7684\u306b\u65b9\u5411\u8ee2\u63db\u3057\u3064\u3064\u7d22\u6575\u7684\u79fb\u52d5\u3002
\u3000\u6b21\u306b\u3001\u5c04\u6483\u7b49\u7d71\u5408\u3057\u3066fight();\u51e6\u7406\u3002\u6575\u3092\u30bf\u30fc\u30b2\u30c3\u30c8\u3059\u308b\u3068\u6a2a\u3078\u56de\u907f\u884c\u52d5\u3092\u53d6\u308a\u306a\u304c\u3089\u3001\u6575\u306b\u5c04\u6483\u3059\u308b\u3002(\u30bf\u30fc\u30b2\u30c3\u30c8\u306f\u7dda\u3067\u3064\u306a\u3044\u3067\u3044\u308b)\u3000\u3053\u306e\u5224\u5b9a\u306fisFreeMove\u30d5\u30e9\u30b0\u3002
\u3000\u305d\u3057\u3066\u3001draw\u3002\u672c\u4f53\u4e09\u89d2\u3068\u3001\u5f53\u305f\u308a\u5224\u5b9a\u76ee\u5b89\u306e\u8584\u3044\u5186\u3001\u6307\u63ee\u5bfe\u8c61\u3092\u793a\u3059\u6fc3\u3044\u5186

\u3000bullets\u2026units
\u3000corp\u3068\u306f\u5225\u99c6\u52d5\u3002corps\u751f\u6210\u3068\u540c\u3058\u30bf\u30a4\u30df\u30f3\u30b0\u3067\u3001\u3068\u308a\u3042\u3048\u305a\u5168\u90e8normal\u306ebullet\u3067\u7528\u610f\u3002
\u3000\u305d\u306e\u5f8c\u3001\u5c04\u6483\u306e\u3068\u304d\u306b\u5f15\u304d\u7d99\u304e\u3001\u66f8\u304d\u63db\u3048\u308b\u5f62\u3067\u30ec\u30fc\u30b6\u30fc\u7b49\u3092\u6d3b\u52d5\u3055\u305b\u59cb\u3081\u308b\u3002
\u3000\u307e\u305f\u3001\u5c04\u6483\u4e3b\u3092\u4fdd\u6301\u3059\u308b\u306e\u3067\u3001\u5c04\u6483\u5f8c\u786c\u76f4\u306a\u3069\u3082\u3053\u306e\u5f3e\u4e38\u30af\u30e9\u30b9\u306e\u65b9\u3067\u5236\u5fa1\u51fa\u6765\u308b\u3002(\u305f\u3060\u3057\u30ad\u30e3\u30e9\u500b\u6027\u3092\u53cd\u6620\u3059\u308b\u306a\u3089\u3001unit\u306e\u65b9\u3067\u53cd\u52d5\u51e6\u7406\u3059\u308b\u3079\u304d\u304b\u3002\u3082\u3057\u304f\u306f\u3001\u3053\u3061\u3089\u3067\u53cd\u52d5\u3059\u308b\u304c\u3001unit\u306e\u30a6\u30a7\u30a4\u30c8\u306a\u3069\u8003\u616e\u3059\u308b\u3068\u304b\uff1f)
\u3000draw();\u306b\u5168\u4f53\u51e6\u7406\u304c\u3042\u308b\u304c\u3001\u307e\u305a\u79fb\u52d5\u51e6\u7406\u3057\u3066\u3001\u305d\u306e\u5f8ccollision();
\u3000\u5186\u3084\u9577\u65b9\u5f62\u3067\u5f53\u305f\u308a\u5224\u5b9a\u3001true\u306a\u3089\u30d2\u30c3\u30c8\u51e6\u7406(\u30c0\u30e1\u30fc\u30b8)\u3082\u884c\u3046\u3002\u305d\u3057\u3066\u3001\u8cab\u901a\u306a\u3089\u3001isCannnotPene\u30d5\u30e9\u30b0\u306e\u6307\u5b9a\u3067\u3001\u629c\u3051\u65b9\u304c\u5909\u308f\u308b\u3002
\u3000\u3060\u3044\u305f\u3044\u306f\u3001\u5f53\u305f\u308b\u3068\u3001isWork=false\u3057\u3066\u3001\u5f8c\u51e6\u7406effect();\u306b\u3002\u7206\u767a\u30a8\u30d5\u30a7\u30af\u30c8\u3068\u304b\u3002\u305d\u306e\u6642\u9593\u30ab\u30a6\u30f3\u30c8\u3092\u7d4c\u904e\u3057\u3066\u304b\u3089\u3001dead();\u3059\u308b\u3002\u3061\u3083\u3093\u3068false\u306b\u3057\u3066\u3044\u308b\u3057\u3001modeling();\u3055\u308c\u306a\u3044\u304c\u3001\u3044\u3061\u304a\u3046x=0;y=0;\u3068\u304b\u3059\u308b\u3002
\u3000\u305f\u3060\u3057\u3001\u8cab\u901a\u5f3eisCannotPene=false;\u3060\u3068\u51e6\u7406\u304c\u7570\u306a\u308b\u3002effect();\u306f\u5f8c\u51e6\u7406\u3058\u3083\u306a\u3044\u3057\u8907\u6570\u5bfe\u8c61\u304c\u8003\u3048\u3089\u308c\u308b\u3002\u306a\u306e\u3067\u3001\u30d2\u30c3\u30c8\u51e6\u7406\u306e\u3068\u3053\u308d\u3067effect\u306eemitter\u3057\u3088\u3046\u3002
\u3000\u30ac\u30fc\u30c9\u306e\u30ab\u30ad\u30f3\u306b\u3064\u3044\u3066\u306f\u3001\u307e\u3060\u691c\u8a0e\u4e2d\u3002\u5f3e\u6271\u3044\u306e\u30ac\u30fc\u30c9\u306e\u65b9\u3067\u30ac\u30fc\u30c9\u30a8\u30d5\u30a7\u30af\u30c8\u3057\u3066\u6d88\u3048\u308b(\u4e00\u767a\u30ac\u30fc\u30c9)\u3088\u3046\u306b\u3059\u308b\u304b\u3001\u30ac\u30fc\u30c9\u306f\u4e00\u5b9a\u6642\u9593\u6b8b\u308b\u304b\u3089\u3001\u5f3e\u306e\u65b9\u3067isShield\u30d5\u30e9\u30b0\u3067\u30a8\u30d5\u30a7\u30af\u30c8\u5909\u3048\u308b\u304b(unit\u304cisShield=\u30b7\u30fc\u30eb\u30c9\u306a\u3046\u3060\u304b\u3089\u3001\u5f53\u305f\u3063\u305f\u5f3e\u3082\u30b7\u30fc\u30eb\u30c9\u3055\u308c\u306a\u3046)\u3002

*/

/*
\u3000\u4eca\u5f8c\u306f\u300c\u5c04\u6483\u6642\u306b\u767a\u7159(\u5ec3\u83a2)\u300d\u300cddff\u7687\u5e1d\u306e\u3088\u3046\u306a\u30e1\u30c6\u30aa\u300d\u300c\u30ac\u30f3\u30c0\u30e0vs(\u7279\u306b\u30e6\u30cb\u30b3)\u307f\u305f\u3044\u306a\u30ac\u30fc\u30c9\u30a8\u30d5\u30a7\u30af\u30c8\u300d
\u3000\u306a\u3069\u3001\u500b\u4eba\u7684\u306a\u30ed\u30de\u30f3\u30c7\u30b6\u30a4\u30f3\u3068\u30b5\u30a6\u30f3\u30c9\u306e\u5b9f\u88c5
\u3000\u300c\u6b66\u5668\u304c\u5909\u5f62\u5c55\u958b\u300d\u300c\u6b66\u5668\u90e8\u5206\u7684\u306b\u6298\u3063\u3066\u3001\u30ea\u30ed\u30fc\u30c9\u3057\u3066\u3001\u518d\u7d50\u5408\u300d\u307f\u305f\u3044\u306a\u30ed\u30de\u30f3\u306f\u7c21\u6613\u306b\u5b9f\u88c5\u3067\u304d\u306a\u3044\u304b\u3057\u3089\u3002
\u3000(\u77e2\u5370\u306e\u7c21\u7d20\u3055\u3092\u5f15\u304d\u7d99\u3044\u3067\u3001\u30b9\u30b1\u30eb\u30c8\u30f3\u306a\u6b66\u5668\u306a\u611f\u3058\uff1f)
*/

/*
\u3000\u30ec\u30fc\u30b6\u3001\u3068\u3044\u3046\u304b\u89d2\u5ea6\u3042\u308b\u9577\u65b9\u5f62\u306e\u5f53\u305f\u308a\u5224\u5b9a\u304c\u5c11\u3005\u4e0d\u5b89\u3002\u8981\u691c\u8a3c\u3002
*/

/*
\u3000\u518d\u78ba\u8a8d\u3002\u3084\u3063\u3071\u308a\u89d2\u5ea6\u3042\u308a\u9577\u65b9\u5f62\u306e\u5f53\u305f\u308a\u5224\u5b9a\u304c\u602a\u3057\u3044\u3002\u6700\u60aa\u3001w=10;h=10;\u306a\u3089\u5947\u9e97\u306a\u5224\u5b9a\u3060\u304b\u3089\u6570\u672c\u675f\u306d\u308b\u3002
*/

/*
  key\u540c\u6642\u62bc\u3057\u306b\u5bfe\u5fdc\u3002HanyouApplet\u3082\u3002\u5f93\u6765\u306e\u3082\u4f7f\u3048\u308b\u306e\u3067\u3001\u65e2\u5b58\u7f6e\u304d\u63db\u3048\u306f\u5168\u7136\u3002
  if (Key_pushed('C', 50, 20))
    background(#aaaaff);
  if (Key_get(SHIFT)>0)
  {
    fill(255);
    rect(width/2, height/2, width/2, height/2);
  }

  if (Key_pressed('X'))
    println("X:"+frameCount);
  text(Key_get('Z'), width/2, height/2);
  
  Editor\u306e\u4ef6\u3067\u3001HanyouApplet\u306eextends JFrame\u63a1\u7528\u3092\u8a66\u904b\u8ee2\u4e2d\u3002
*/

/*0624
  unity\u3067\u8272\u3005\u3067\u304d\u308b\u3088\u3046\u306b\u306a\u3063\u3066\u3072\u3068\u6bb5\u843d\u3001\u3053\u3061\u3089\u306b\u5c11\u3057\u30b2\u30fc\u30e0\u6027\u3092\u7528\u610f\u3002
  \u62e0\u70b9CorpCore\u306e\u5927\u304d\u306a\u4e38\u3092\u5012\u3057\u305f\u3089\u90e8\u968a\u304c\u58ca\u6ec5\u3059\u308b\u304b\u3089\u3001\u5b88\u308b\u3088\u3046\u306b\u6226\u3046\u611f\u3058\u3002
  
  \u3068\u3053\u308d\u3067\u3001\u659c\u3081\u30d3\u30fc\u30e0\u3068\u81ea\u5206\u306e\u5f53\u305f\u308a\u5224\u5b9a\u3092\u3001\u89d2\u5ea6\u7121\u3057\u3067\u78ba\u8a8d\u3059\u308b\u3088\u3046\u306a\u30c7\u30d0\u30c3\u30b0\u3066\u3069\u3053\u306b\u3084\u3063\u305f\u304b\u306a\u3002if(isColisionDebug)?
*/

/*
\u3000\u3053\u306e\u30bf\u30d6\u3092\u8ffd\u52a0\u3059\u308b\u3053\u3068\u3067\u3001SUPERCLASS_APPLET_SecondBacisApplet.pde\u3092\u5229\u7528\u3057\u3066\u3001
\u3000\u30ab\u30e9\u30fc\u3092\u52d5\u7684\u30fb\u8996\u899a\u7684\u306b\u5909\u66f4\u3059\u308b\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u7ba1\u7406\u3092\u8ffd\u52a0\u3059\u308b\u3002
\u3000\u305f\u3060\u3057\u3053\u306eon/off\u306f\u3001\u30a8\u30e9\u30fc\u306e\u539f\u56e0\u3068\u306a\u308bColorWidget\u5909\u6570\u3084\u3001\u305d\u308c\u3092\u5f04\u308b\u95a2\u6570\u306a\u3069\u591a\u3044\u3002\u4e3b\u306bHanyouBuffer\u3092\u66f8\u304d\u63db\u3048\u308b\u3068\u3053\u304c\u591a\u3044\u3002\u57fa\u672c\u7684\u306b\u306f\u3001\u7f6e\u3044\u3066\u304a\u304f\u3002
\u3000\u5c1a\u3001\u3053\u308c\u3092off\u306b\u3057\u3066\u3044\u308b\u6642\u3001ColorObject\u306f\u305f\u3060\u306ergb\u69cb\u9020\u4f53\u3068\u3057\u3066\u6a5f\u80fd\u3059\u308b(\u306f\u305a)
*/
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u30ab\u30e9\u30fc\u3092\u52d5\u7684\u306b\u9078\u3076\u305f\u3081\u306eGUI\u3068\u305d\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8ColorObject\u3002
\u3000\u52d5\u4f5c\u3055\u305b\u3066\u307f\u308c\u3070\u308f\u304b\u308b\u3068\u601d\u3046\u304c\u3001HanyouApplet\u3084createApp()\u306a\u3069\u3001\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u3067\u958b\u304f\u6a5f\u80fd\u3092\u5229\u7528\u3057\u3066\u3044\u308b\u3002
\u3000\u3053\u306e\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u306f\u5e38\u99d0\u3055\u305b\u308b\u3064\u3082\u308a\u306a\u306e\u3067\u3001\u30e1\u30a4\u30f3\u306esetup\u3084draw\u306e\u3088\u3046\u306b\u81ea\u52d5\u3067\u52d5\u304finit()\u30e1\u30bd\u30c3\u30c9\u306e\u65b9\u3067\u521d\u671f\u8a2d\u5b9a\u3092\u6e08\u307e\u305b\u3001colorwidget\u30b0\u30ed\u30fc\u30d0\u30eb\u5909\u6570\u3067\u7ba1\u7406\u3057\u3066\u3044\u308b\u3002
\u3000\u5229\u7528\u6642\u306f\u3053\u306e\u8fba\u308a\u3092\u610f\u8b58\u305b\u305a\u306b\u3001HanyouBuffer\u30af\u30e9\u30b9\u5185\u306ecolorcontrol\u30e1\u30bd\u30c3\u30c9\u3068ColorObject\u3060\u3051\u6c17\u306b\u3059\u308c\u3070\u3001\u3044\u3051\u305f\u306f\u305a\u3002
*/

class ColorWidget extends HanyouApplet
{
  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/57594*@* */
  /* !do not delete the line above, required for linking your tweak if you upload again */
  int 
    ColorPickerX,
    ColorPickerY,
    LineY, //hue line vertical position
    CrossX, //saturation+brightness cross horizontal position
    CrossY; //saturation+brightness cross horizontal position
  boolean
    isDraggingCross = false,
    isDraggingLine = false;
  String
    targetname="none";
  int
    activeColor=color(123,123,123,123),
    interfaceColor = color(255); //change as you want               <------------------------------------------- CHANGE
  ColorObject
    co;
  
  public void setColorObject(String name,ColorObject co)
  {  
    targetname=name;  this.co=co;
    CrossX=ColorPickerX+PApplet.parseInt(saturation(co.getColor() ));/////
    CrossY =255-(      ColorPickerY + PApplet.parseInt(brightness(co.getColor() ))     );//
    LineY = ColorPickerY + PApplet.parseInt(hue(co.getColor() ));
  }
  public void setVisible(boolean isWork){ Point mouse = MouseInfo.getPointerInfo().getLocation(); frame.setLocation(mouse.x+10, mouse.y+10);   super.setVisible (isWork); }
  
  ColorWidget(ColorObject co)
  {
    super(1.0f);
    this.co = co;
  }
  
  public void setup()
  {
    size(325 , 255);
    smooth();
    
    colorMode(HSB);
    ColorPickerX=constrain(0,0,283); //set color picker x position to color selector + 40 and avoid it to be out of screen 
    ColorPickerY=constrain(0,0,260); //set color picker y position to color selector + 40 and avoid it to be out of screen 
    LineY=ColorPickerY+PApplet.parseInt(hue(activeColor)); //set initial Line position
    CrossX=ColorPickerX+PApplet.parseInt(saturation(activeColor)); //set initial Line position
    CrossY=ColorPickerY+PApplet.parseInt(brightness(activeColor)); //set initial Line position  
  }
  public void draw()
  { 
    background(0);
    drawColorPicker();
    drawCross();
    drawActiveColor();
    drawValues();
    checkMouse();
    drawTitle();
    
    activeColor=color(LineY-ColorPickerY , CrossX-ColorPickerX , 255-(CrossY-ColorPickerY) );
    co.setColor(activeColor);
    
    super.draw();
  }
  
  public void drawColorSelector() 
  {
    stroke(interfaceColor);
    strokeWeight(1);
    fill(0);
    rect(0,0,20,20);
    
    stroke(0);
    
    if(mouseX>0&&mouseX<20&&mouseY>0&&mouseY<20)
     fill(hue(activeColor),saturation(activeColor),brightness(activeColor)+30);
    else
     fill(activeColor);
      
    rect(1,1,18,18); //draw the color selector fill 1px inside the border
  }
  public void drawValues() 
  {
    fill(255);
    fill(0);
    textSize(10);
    
    text( "H: "+PApplet.parseInt(  (LineY-ColorPickerY )*1.417647f)+"\u00b0",                      ColorPickerX+285 , ColorPickerY+100);
    text( "S: "+PApplet.parseInt(   (CrossX-ColorPickerX )*0.39215f+0.5f)+"%",             ColorPickerX+286 , ColorPickerY+115);
    text( "B: "+PApplet.parseInt(100-(   (CrossY-ColorPickerY )*0.39215f)   ) + "%" ,     ColorPickerX+285 , ColorPickerY+130);
    
    text( "R: "+PApplet.parseInt(red(activeColor)),      ColorPickerX+285 , ColorPickerY+155);
    text( "G: "+PApplet.parseInt(green(activeColor)),   ColorPickerX+285 , ColorPickerY+170);
    text( "B: "+PApplet.parseInt(blue(activeColor)),     ColorPickerX+285 , ColorPickerY+185);
    
    text(hex(activeColor,6),ColorPickerX+285,ColorPickerY+210);
  }
  
  public void drawCross() 
  {
    if(brightness(activeColor)<90)
      stroke(255);
    else
      stroke(0);
      
    line(CrossX-5,CrossY,CrossX+5 ,CrossY);
    line(CrossX,CrossY-5,CrossX,CrossY+5);
  }
  public void drawColorPicker() 
  { 
    stroke(interfaceColor);
    //line(10,10,ColorPickerX-3,ColorPickerY-3);//\u4eee\u306b\u3001\u30ab\u30e9\u30fc\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u3092\u3069\u3053\u304b\u306e\u30aa\u30d6\u30b8\u30a7\u304b\u3089\u4f38\u3070\u3059\u306a\u3089\u3001\u3053\u306e\u7dda\u3064\u3051\u3066ColorPickerX,Y\u306e\u4f4d\u7f6e\u305d\u306e\u5206\u305a\u3089\u3057\u3066
     
    //strokeWeight(1); //where parts?
    //fill(0);
    //rect(ColorPickerX-3 ,ColorPickerY-3 ,283,260);
    
    loadPixels();
    
    for(int j=0 ; j<255 ; j++) //draw a row of pixel with the same brightness but progressive saturation
    {    
      for(int i=0 ; i<255 ; i++) set(ColorPickerX+j,ColorPickerY+i,color(LineY-ColorPickerY,j,255-i) );
    }  
    for(int j=0; j<255; j++)
    {
      for(int i=0 ; i<20 ; i++)    set(ColorPickerX+258+i,ColorPickerY+j ,color( j,255,255) );
    }
    fill(interfaceColor);
    noStroke();
    rect(ColorPickerX+280,ColorPickerY-3,45,261); 
  }
  public void drawActiveColor() 
  {
    fill(activeColor);
    stroke(0);
    strokeWeight(1);
    rect(ColorPickerX+282,ColorPickerY-1,41,80);
  }
  public void checkMouse() 
  {
    if(mousePressed)  
    {
      if(mouseX>ColorPickerX+258&&mouseX<ColorPickerX+277&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingCross) 
      {
        LineY=mouseY;
        isDraggingLine=true;
      }
      if(mouseX>ColorPickerX-1&&mouseX<ColorPickerX+255&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingLine)
      {
        CrossX=mouseX;
        CrossY=mouseY;
        isDraggingCross=true;
      }    
    }
    else
    {
      isDraggingCross=false;
      isDraggingLine=false;
    }
  }
  
  public void drawTitle()
  {
    fill(0);
    textSize(32);
    text(targetname,10,30);
    //textSize(16);
    //text("   activeColor("+red(activeColor)+","+green(activeColor)+","+blue(activeColor)+")",10,50);
    //text("   co             ("+red(co.getColor())+","+green(co.getColor())+","+blue(co.getColor() )+")",10,70);
    
  }
  
}
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u30b7\u30fc\u30f3\u9078\u629e\u753b\u9762\u5b9f\u7269\u3002\u30b7\u30fc\u30f3\u306e\u7e4b\u304c\u308a\u3067\u306f\u306a\u304f\u3001\u30b7\u30fc\u30f3\u4e00\u3064\u3092\u5207\u308a\u66ff\u3048\u308b\u60f3\u5b9a\u3002\u30b7\u30fc\u30f3\u4e00\u89a7\u3068\u306a\u308bSampleList\u306e\u8aad\u307f\u8fbc\u307f\u304c\u5fc5\u8981\u3060\u304b\u3089\u6ce8\u610f\u3057\u3066\u306d\u3002
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
  
  public void setup()
  {
    size(300,300,"P2D");
  }
  
  public void draw()
  {
    senseMenuOnOff();
    if(isVisible==-1)
    {
      pg.background(0,0,0,0); ////\u4e00\u5fdc\u7f6e\u3044\u3068\u304f
    }
    else
    {
      pg.background(255);
      HanyouBuffer buffer=coverflow.get();
      if(buffer!=null){ returnbuffer=buffer; isUpdate=true;}
      
      pg.image(coverflow.getImage(NOT_WORK),   0,0,pg.width,pg.height);
    }
  }
  public HanyouBuffer getOutputSingle()
  {
    isUpdate=false;
    return returnbuffer;
  }
}










/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u30b7\u30fc\u30f3\u9078\u629e\u753b\u9762\u306e\u6a5f\u80fd\u90e8\u5206\u3002\u9078\u629e\u3057\u305f\u3082\u306e\u3092\u30ea\u30b9\u30c8\u72b6\u306b\u307e\u3068\u3081\u305f\u308a\u3001\u73fe\u5728\u306e\u30b7\u30fc\u30f3\u306e\u7e4b\u304c\u308a\u3068\u540c\u671f\u3057\u305f\u308a(\u73fe\u72b6\u8868\u793a\u90e8\u5206\u306e\u305f\u3081\u306e)\u3001\u30ad\u30fc\u62bc\u3057\u3067\u30b7\u30fc\u30f3\u9078\u629e\u753b\u9762\u306b\u9077\u79fb\u3057\u305f\u308a\u3002
\u3000
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
  public void setup(){ }
  public void draw(){}

  boolean Menu_class_Mkey=false;
  public void senseMenuOnOff()
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
  public HanyouBuffer getOutputSingle()  //\u4f55\u304b\u3057\u3089\u306e\u6642\u306b\u30aa\u30fc\u30d0\u30fc\u30e9\u30a4\u30c9\u3057\u3066\u4f7f\u3063\u3066\u306d
  {
    return null;
  }
  public ArrayList<HanyouBuffer>  getOutputList()//\u4f55\u304b\u3057\u3089\u306e\u6642\u306b\u30aa\u30fc\u30d0\u30fc\u30e9\u30a4\u30c9\u3057\u3066\u4f7f\u3063\u3066\u306d
  {
    return null;
  }
  public void sync(Scene root)
  {
    returnbuffer=root.getScene(NOT_OPTION);
  }
  public void setSampleList(SampleList samplelist)
  {
    coverflow.setSampleList(samplelist);
  }
  public SampleList getSampleList()
  {
    return coverflow.samplelist;
  }
  public void setPApp(PApplet papp)
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
  public void setup(){ }
  public void draw(){}
  
  public void sync(Scene root)
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

/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u30b7\u30fc\u30f3\u9078\u629e\u753b\u9762\u306e\u4e00\u90e8\u63cf\u753b\u90e8\u5206(\u30b7\u30fc\u30f3\u9078\u629e\u753b\u9762\u306e\u30b7\u30fc\u30f3\u9078\u629e\u90e8\u5206)\u3002\u3069\u308c\u3092\u9078\u3093\u3067\u3044\u308b\u304b\u306e\u756a\u53f7\u3082\u3053\u3061\u3089\u3067\u7528\u610f\u3059\u308b(\u305d\u306e\u756a\u53f7\u3092\u5143\u306b\u3001\u51fa\u529bHanyouBuffer\u3092\u3059\u308b\u3068\u3044\u3046\u304b\u6c7a\u3081\u308b)
\u3000\u3042\u3068\u3001\u30ab\u30d0\u30fc\u30d5\u30ed\u30a6\u306b\u8868\u793a\u3059\u308b\u4e00\u679a\u7d75\u3092CoverflowObject\u3068\u3057\u3066\u5b9a\u7fa9\u3057\u3066\u3044\u308b\u3002\u89d2\u5ea6\u3068\u304b\u3002
*/
class CoverflowObject
{ 
  int width  = 640;
  int height = 480;
  
  double x;
  double z;
  private double angle;
  double nX;
  private double rate = 4.0f;
  HanyouBuffer img;
  int number;
  Coverflow system;
  
  CoverflowObject(Coverflow system,int number,HanyouBuffer img)
  {
    this.system=system;
    this.number=number;
    this.img=img;
    PImage buff;
    for(int i=0; i<3; i++)buff=img.getImage(NOT_WORK);
  }
  public void update(PGraphics pg) {
    z = 0;
    angle = system.MAX_ANGLE;
    if(nX < 0) angle = -angle;
    pg.noStroke();
    pg.fill(255);
    
    if(abs((float)x) <= system.interval + 0.1f) {
      x = nX;
      angle = system.MAX_ANGLE * x / system.interval;
      z = system.offsetZ * (system.interval - abs((float)nX))/system.interval;
    } else {
      x = nX;
      double offset = system.interval;
      if(nX < 0) offset = -offset;
      x -= offset;
      x /= rate;
      x += offset;
    }
    
    pg.pushMatrix();
    pg.translate((float)x, 0, (float)z);
    pg.rotateY(-(float)angle);
    
    // =====================================================
    // \u30c6\u30af\u30b9\u30c1\u30e3\u30de\u30c3\u30d4\u30f3\u30b0
    // P3D \u30e2\u30fc\u30c9\u3067\u3082\u6975\u529b\u30c6\u30af\u30b9\u30c1\u30e3\u304c\u6b6a\u307e\u306a\u3044\u3088\u3046\u306b\u3057\u3066\u3044\u308b\u3002
    // =====================================================
    int   n     = 20; // \u5206\u5272\u6570
    float dW    = (float)this.width / n;
    float dTexW = (float)img.getImage(DRAW_ONLY).width  / n;
    
    pg.beginShape(QUAD_STRIP);
    if(system.renderingTimer() )
    {
      if(number==system.target) pg.texture(img.getImage(NOT_WORK)   );
      else if(system.isSave)                        pg.texture(img.getImage(DRAW_ONLY)   );
      else pg.texture(img.getImage(DRAW_ONLY)   );
    }
    else pg.texture(img.getImage(DRAW_ONLY)   );
    for(int i = 0; i <= n; i++) {
      pg.vertex(-this.width / 2.0f + i*dW, -this.height / 2.0f, i*dTexW, 0);
      pg.vertex(-this.width / 2.0f + i*dW,  this.height / 2.0f, i*dTexW, img.getImage(DRAW_ONLY).height);
    }
    pg.endShape();
    if(count>1000)count=0;
    //renderShadow(pg,n,dW,dTexW);
    
    pg.popMatrix();
  }
  int count=0;
  
  
  
  PImage shadowImg;
  public void createShadow()
  {
    shadowImg = createImage(img.getImage(DRAW_ONLY).width, img.getImage(DRAW_ONLY).height, RGB);
    
    // =====================================================
    // \u5f71\u753b\u50cf\u306e\u4f5c\u6210
    // \u753b\u50cf\u306e\u9ad8\u3055\u306b\u5fdc\u3058\u3066\u6e1b\u8870\u306e\u5f37\u3055\u3092\u8a08\u7b97\u3059\u308b
    // =====================================================
    float a = 100;
    float dA = - (float)0xFF / img.getImage(DRAW_ONLY).height;
    for(int iy = 0; iy < shadowImg.height; iy++) {
      for(int ix = 0; ix < shadowImg.width; ix++) {
        if( a < 0 ) a = 0;
        int i = iy * shadowImg.width + ix;
        int c = img.getImage(DRAW_ONLY).pixels[(img.getImage(DRAW_ONLY).height - iy - 1)*img.getImage(DRAW_ONLY).width + ix];
        
        int fg = c;
        int fR = (0x00FF0000 & fg) >>> 16; 
        int fG = (0x0000FF00 & fg) >>> 8;
        int fB =  0x000000FF & fg;
        
        int bR = (0x00FF0000 & system.bgColor) >>> 16;
        int bG = (0x0000FF00 & system.bgColor) >>> 8;
        int bB =  0x000000FF & system.bgColor;
        
        int rR = (fR * (int)a + bR * (int)(0xFF - a)) >>> 8;
        int rG = (fG * (int)a + bG * (int)(0xFF - a)) >>> 8;
        int rB = (fB * (int)a + bB * (int)(0xFF - a)) >>> 8;
        
        shadowImg.pixels[i] = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
      }
      a += dA;
    }
  }
  public void renderShadow(PGraphics pg,int n,float dW,float dTexW)
  {
    // \u5f71
    pg.noLights();
    pg.beginShape(QUAD_STRIP);
    pg.texture(shadowImg);
    for(int i = 0; i <= n; i++) {
      pg.vertex(-this.width / 2.0f + i*dW, this.height / 2.0f, i*dTexW, 0);
      pg.vertex(-this.width / 2.0f + i*dW, this.height * 3.0f / 2.0f, i*dTexW, shadowImg.height);
    }    
    pg.endShape();
  }
  
}


















class Coverflow extends HanyouBuffer
{
  SampleList samplelist;
  CoverflowObject[] cfo;
  
  final float MAX_ANGLE = radians(70);  // \u30b8\u30e3\u30b1\u30c3\u30c8\u306e\u6700\u5927\u50be\u659c\u89d2
  final float interval = 500;           // \u9593\u9694
  final int   offsetZ  = 400;           // Z\u65b9\u5411\u306e\u79fb\u52d5\u5206
  final int   bgColor  = color(255, 255, 255);
  int target=0;
  boolean isSave=false;
  
  Coverflow(PApplet papp,SampleList samplelist)
  {
    super(papp);
    this.samplelist=samplelist;
  }
  public void setSampleList(SampleList samplelist)
  {
    this.samplelist=samplelist;
    first();
  }
  public void setPApp(PApplet papp)
  {
    this.papp=papp;
    samplelist.setPApp(papp);
  }
  
  public void setup()
  {
    size(400,250,"P3D");
    first();
  }
  public void first()
  {
    cfo=new CoverflowObject[samplelist.size()];
    target=cfo.length/2;
    int i=0;
    Iterator it=samplelist.scenelist.keySet().iterator();
    while(it.hasNext() )
    {
      Object o=it.next();
      cfo[i] = new CoverflowObject(this,i,samplelist.scenelist.get(o) );
      cfo[i].nX = (i - cfo.length / 2) * interval;
      i++;
    }
  }
  
  int count=0;
  public void draw()
  {
    if(PApplet.parseInt(frameRate)<Menu_FPS_MIN) isSave=true;
    
    pg.background(0,0,0,0);
    pg.camera(0, 0, 1200, 0, 0, 0, 0, 1, 0);
    if(!isSave)pg.background(bgColor);
    else pg.background(red(bgColor)-100,green(bgColor)-100,blue(bgColor)-100);
    pg.hint(ENABLE_DEPTH_SORT);
    for(int i = 0; i < cfo.length; i++) cfo[i].update(pg);
    if(!papp.mousePressed)keycontrol();
    else mousecontrol();
  }
  
  boolean Ekey=false;
  public HanyouBuffer get()
  {
    timercount++;
    if(papp.keyPressed)
    {
      if(papp.key==ENTER && Ekey==false)
      {
        Ekey=true;
        return cfo[target].img;
      }
    }
    else Ekey=false;
    return null;
  }


  boolean Nkey=false,Pkey=false;
  public void keycontrol()
  {
    if(papp.keyPressed)
    {
      if(papp.keyCode==RIGHT && Nkey==false)
      {
        Nkey=true;
        if(target<cfo.length-1)target++;
        isSave=false;
      }
      if(papp.keyCode==LEFT && Pkey==false)
      {
        Pkey=true;
        if(target>0)target--;
        isSave=false;
      }
    }
    else
    {
      Nkey=false;
      Pkey=false;
    }
    double offsetX=-cfo[target].nX * 0.1f;
    for(int i = 0; i < cfo.length; i++) cfo[i].nX += offsetX;
  }
  
  public void mousecontrol()
  {
    double minX = 9999;
    for(int i = 0; i < cfo.length; i++)
    { 
      if(abs((float)cfo[i].nX) < abs((float)minX))
      {
        minX = cfo[i].nX;
        target=i;
      }
    }
    double offsetX;
    if(papp.mousePressed) offsetX = 6*(papp.mouseX - papp.pmouseX);
    else offsetX = -minX * 0.1f;
    for(int i = 0; i < cfo.length; i++) cfo[i].nX += offsetX;
  }
  
  int timercount=0;
  public boolean renderingTimer()   //rendering kankaku
  {
    int a=10;
    if(timercount%a==0) return true;
    if(timercount>1000)timercount=0;
    return false;
  }
  
  
}













/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u30b7\u30fc\u30f3\u9078\u629e\u3084\u30bb\u30fc\u30d6\u30d5\u30a1\u30a4\u30eb\u30ed\u30fc\u30c9\u306b\u4f7f\u308f\u308c\u308b\u30b7\u30fc\u30f3\u30ea\u30b9\u30c8\u306e\u539f\u578b\u3002\u7279\u306bTestSampleList\u306f\u30b7\u30fc\u30f3\u30ea\u30b9\u30c8\u306e\u5b9a\u7fa9\u306e\u4ed5\u65b9\u3068\u3057\u3066\u898b\u3068\u3044\u3066\u3002
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
  public void setup(){  size(100,100,"P2D");  pg.background(100,100,100,255);  pg.textSize(60); pg.text("no image",10,height/2); }
  public void draw(){ }
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
  public void setPApp(PApplet papp)
  {
    Iterator it=scenelist.keySet().iterator();
    while(it.hasNext() ) scenelist.get(it.next() ).papp=papp;
  }
  public void addScene(HanyouBuffer scene)
  {
    scenelist.put(scene.name,scene);
  }
  public HanyouBuffer get(String name)
  {
    return scenelist.get(name);
  }
  public void debugmessage()
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
  
 public String getClassName()
 {
   String str=""+this;//ProjectionTest_koba$SceneList@1931579
   String[] strArray1=str.split("koba");
   String[] strArray2=strArray1[1].split("@");
   return strArray2[0];
 }
 public int size(){   return scenelist.size();}
 
 
}
class ColorObject  //\u4e09\u5909\u6570\u683c\u7d0d\u3068\u3057\u3066color\u578b\u6d3b\u7528\u3002getHSB\u306a\u306e\u306b\u5909\u306a\u8a71\u3060\u304c\u3001red(\u2026)\u3068\u304b\u3067\u4e00\u3064\u305a\u3064\u53d6\u308a\u51fa\u3057\u3066\u306d
{
  int c;
  int alpha;
  ColorObject(int red,int green,int blue, int alpha)
  {
    c=color(red,green,blue);
    this.alpha=alpha;
  }
  public int getColor(){ return c; }
  public void setColor(int red,int green,int blue)
  {
    c=color(red,green,blue);
  }
  public void setColor(int c)
  {
    this.c=c;
  }
  public void setColor(int red,int green,int blue,int alpha)
  {
    c=color(red,green,blue);
    this.alpha=alpha;
  }
  public void setColor(int c,int alpha)
  {
    this.c=c;
    this.alpha=alpha;
  }
  public void setAlpha() {  this.alpha=alpha; }
  public int getAlpha()   {  return alpha;  }
}

/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001\u5404\u30af\u30e9\u30b9\u3067\u3082setup-draw\u3092\u6301\u3066\u308b\u3088\u3046\u306b(allwork()\u3092\u5b9a\u7fa9\u3057\u3057\u305f)HanyouBuffer\u3068\u3001\u305d\u308c\u3092\u5305\u3080Scene\u30af\u30e9\u30b9\u3002

\u30fb\u4e00\u500b\u4e00\u500b\u306e\u65b9\u3067setup-draw\u3067\u304d\u308b\u3001\u30af\u30e9\u30b9\u7528\u610f(HanyouBuffer)
\u3000\u3000\u3000\u30e1\u30a4\u30f3\u306esetup\u30e1\u30bd\u30c3\u30c9\u3067new\u3057\u3001\u30e1\u30a4\u30f3\u306edraw\u30e1\u30bd\u30c3\u30c9\u3067(xxx.render();\u3068\u304b\u4e00\u624b\u9593\u304b\u3051\u305a)xxx.getImage();\u3067\u6271
\u3000\u3000\u3000\u3046\u3002
\u3000\u3000\u3000\u4e00\u56de\u76ee\u306exxx.getImage();\u3067\u30b3\u30f3\u30b9\u30c8\u30e9\u30af\u30bf\u7684\u6319\u52d5\u3092\u3068\u308b\u3001\u3068\u3044\u3046\u3088\u3046\u306b\u306a\u3063\u3066\u3044\u308b\u3002
\u3000\u3000\u3000(\u4e0a\u8a18\u4ed5\u69d8\u3067\u3042\u308b\u306e\u306f\u3001\u30b7\u30fc\u30f3\u9078\u629e\u306e\u305f\u3081\u306b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306enew\u3092\u305a\u3089\u30fc\u3063\u3068\u7528\u610f\u3059\u308b=\u30e1\u30e2\u30ea\u98df\u3044\u6f70\u3057\u554f\u984c \u3082\u610f\u8b58)
\u3000\u3000\u3000\u4e0a\u8a18\u4ed5\u69d8\u306e\u5b9f\u73fe\u306f\u3001\u30aa\u30ea\u30b8\u30ca\u30eb\u306e\u30e1\u30bd\u30c3\u30c9\u306esetup\u3068draw\u3092\u5185\u5305\u3057\u305fallwork()\u3001drawork()\u306b\u3088\u308b\u3082\u306e\u3002
\u3000\u3000\u3000\u3042\u3068size\u30e1\u30bd\u30c3\u30c9\u306eP2D\u306e\u5f15\u6570\u304c\u72ec\u7279\u306b\u306a\u3063\u3066\u3057\u307e\u3063\u305f(String)\u306e\u3067\u3001\u3053\u308c\u304f\u3089\u3044\u304c\u6ce8\u610f\uff1f
         \u3042\u3068\u63cf\u753b\u306e\u30e1\u30bd\u30c3\u30c9\u306f\u5168\u3066pg.\u3092\u4ed8\u3051\u3066\u884c\u3046\u3002

\u3000\u3000\u3000\u3042\u3068\u3001getImage()\u3084getBuffer()\u306fDRAW_ONLY(buffer\u53d6\u3063\u3066\u304f\u308b\u3060\u3051)\u3001NO_WORK(\u30b7\u30fc\u30f3\u7ba1\u7406\u306e\u4ed5\u4e8b\u3092\u30ab\u30c3\u30c8
\u3000\u3000\u3000\u3057\u3001CG\u51e6\u7406\u3060\u3051\u3059\u308b)\u306e\u30aa\u30d7\u30b7\u30e7\u30f3\u3092\u5f15\u6570\u3067\u4f7f\u3044\u5206\u3051\u308b\u3002

\u30fbHanyouBuffer\u3092\u683c\u7d0d\u3057\u3001\u9077\u79fb\u3084\u3089\u306e\u7ba1\u7406\u304c\u3084\u308a\u3084\u3059\u304f\u306a\u308b\u3088\u3046\u306b(Scene\u53ca\u3073Hanyoubuffer\u5185\u306emypointer)
\u3000\u3000\u3000\u3000\u30b7\u30fc\u30f3\u30c1\u30a7\u30f3\u30b8\u3092\u3057\u305f\u3044\u3002buff=buff.work();\u3067\u3000HanyouBuffer work(){ \u2026  return new_buff; }\u7684\u306a\u5207\u308a\u66ff\u3048
\u3000\u3000\u3000\u69cb\u9020\u3092\u4e88\u5b9a\u3057\u3066\u3044\u308b\u3002
\u3000\u3000\u3000\u3000\u3057\u304b\u3057\u3053\u308c\u3060\u3068\u4e0a\u8a18\u306e\u300cxxx.render();\u4e00\u624b\u9593\u8981\u3089\u306a\u3044\u3088\uff01\u300d\u306e\u4ed5\u69d8\u306b\u53cd\u3059\u308b\u3002\u306e\u3067\u3001\u4e00\u756a\u8868\u9762\u3067\u306f\u3001
\u3000\u3000\u3000HanyouBuffer\u3092\u304f\u308b\u3093\u3060Scene\u578bmypointer\u3092new\u3057\u3001\u5404\u7a2eBuffer\u3067\u306fmypointer\u3092(\u81ea\u8eabBuffer\u3078\u30dd\u30a4\u30f3\u30bf\u3092\u5411
\u3000\u3000\u3000\u3051\u3066\u304f\u308b\u5909\u6570\u3092)\u6301\u3064\u3002\u305d\u3057\u3066\u3001xxx.getImage();\u306a\u3069\u306e\u51e6\u7406\u5185\u3067mypointer\u306e\u30dd\u30a4\u30f3\u30bf\u5148\u3092\u5909\u3048\u308b\u3002
\u3000\u3000\u3000(\u3042\u308b\u7a2e\u3001\u81ea\u5206\u81ea\u8eab\u3092\u6d88\u3059\u884c\u70ba\u306b\u8fd1\u3044\u3002\u30ac\u30d9\u30fc\u30b8\u30b3\u30ec\u30af\u30b7\u30e7\u30f3\u3082\u3042\u308b\u3057)
\u3000\u3000\u3000\u30e1\u30a4\u30f3\u306edraw\u3067\u306e\u4f7f\u3044\u65b9\u304cscene.getScene().getImage()\u3068\u306a\u3063\u305f\u3002new\u306f\u30b7\u30fc\u30f3\u30c1\u30a7\u30f3\u30b8\u7528\u306eGUI\u3082\u5f15\u6570\u3059\u308b\u3002

\u3000\u3000\u3000\u5c11\u3057\u3001\u51e6\u7406(\u306e\u6240\u5728)\u304c\u4e0d\u900f\u660e\u306b\u306a\u3063\u3066\u3044\u308b\u306e\u304c\u50b7\u3002
\u3000\u3000\u3000(\u5c1a\u3001\u305d\u306e\u5f8c\u3001scene\u30af\u30e9\u30b9\u5185\u3067\u306f\u30b7\u30fc\u30f3\u30ea\u30b9\u30c8\u306e\u30ed\u30fc\u30c9\u3068\u304bGUI\u5207\u308a\u66ff\u3048\u3068\u304b\u96d1\u52d9\u304c\u5897\u3048\u305f\u6a21\u69d8)
*/

final boolean NOT_OPTION=true;
class Scene// HanyouBuffer\u3092\u30e9\u30c3\u30d7\u3059\u308b\u30af\u30e9\u30b9\u3000(Integer\u306e\u771f\u4f3c)
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
  
  public HanyouBuffer getScene()
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
  public HanyouBuffer getScene(boolean notoption)
  {
    if(optionGUI!=null && optionGUI.isUpdate)//if(optionGUI!=null) ha nen-no-tame
    {
      if(optionGUI.getOutputSingle() !=null) setScene(optionGUI.getOutputSingle() );
      if(optionGUI.getOutputList()!=null)     setSceneList(optionGUI.getOutputList() );
    }
    return scene;
  }
  
  public void setScene(HanyouBuffer scene)
  {
    this.scene=scene;
  }
  public void setSceneList(ArrayList<HanyouBuffer> list)
  {
    if(list.size()==0) return;
    setScene(list.get(0).setMyPointer(this)   );
    HanyouBuffer scene=getScene(NOT_OPTION);
    for(int i=1; i<list.size(); i++)  scene=scene.setNext(list.get(i).setMyPointer(this)  ).next;  
  }
  public void loadSceneList(String filename)
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
 public abstract void setup();
 public abstract void draw();
 public HanyouBuffer sceneWork(){ return this; }
 
 
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
 public void drawork()
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
 public void size(int w,int h, String pmode)
 {
   if(pmode.equals("P2D") ) pg=createGraphics(w,h,P2D);
   if(pmode.equals("P3D") ) pg=createGraphics(w,h,P3D);
   pg.smooth();
   pg.beginDraw();
   pg.background(0);
   pg.updatePixels();
   pg.endDraw();
 }
 
 public PImage getImage()
  {
    return getBuffer().get();
  }
 public PGraphics getBuffer()
 {
   allwork();
   return pg;
 }
 public PImage getImage(int nonework)        //use-example getImage(DRAW_ONLY),  for(int i=50; i>=DRAW_ONLY; i--)getImage(i);
 {
   return getBuffer(nonework).get();
 }
 public PGraphics getBuffer(int nonework)
 {
   if(nonework==DRAW_ONLY)
   {
     //allwork();
     return pg;
   }
   else return getBuffer();
 }
 public PImage getImage(boolean nonework)//use-example:  getImage(NOT_WORK)
 {
   return getBuffer(NOT_WORK).get();
 }
 public PGraphics getBuffer(boolean nonework)
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
 
 public HanyouBuffer setMyPointer(Scene mypointer)
 {
   this.mypointer=mypointer;
   return this;
 }
 public HanyouBuffer setNext(HanyouBuffer next)
 {
   this.next=next;
   return this;
 }
 
 
 public String getClassName()
 {
   String str=""+this;//ProjectionTest_koba$SceneList@1931579
   String[] strArray1=str.split("koba");
   String[] strArray2=strArray1[1].split("@");
   return strArray2[0];
 }
 
 public void colorcontrol(String targetname,ColorObject target,char presskey)
  {
    if(papp.keyPressed&& papp.key==presskey)
    {
      if(!colorwidget.isWork)
      {
        colorwidget.setColorObject(targetname,target);
        colorwidget.setVisible(true);
      }
      else colorwidget.setVisible(false);
      papp.key='\u00a5';
    }
  }
  
 
}
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouBuffer\u306e\u3088\u3046\u306bsetup-draw\u306e\u69cb\u9020\u3092\u6301\u3066\u308b\u3088\u3046\u306b\u3057\u3066\u3001\u5c1a\u4e14\u3064\u3001\u30e1\u30a4\u30f3\u306esetup\u306e\u65b9\u3067createApp()\u306b\u5f15\u6570\u6e21\u3057\u3059\u308c\u3070\u3001\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u3067\u958b\u304f\u5b50\u3067\u3042\u308b\u3002

\u30fbHanyouBuffer\u307f\u305f\u3044\u3060\u304c\u3001\u66f4\u306b\u3001\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u3068\u3057\u3066\u65b0\u898f\u306b\u958b\u3044\u3066\u6271\u3046(HanyouApplet\u3068createApp()  )
\u3000\u958b\u304f\u5b9f\u884c\u306e\u4e2d\u8eab\u306f\u30e1\u30a4\u30f3\u306esetup\u3068createApp\u3000\u958b\u304f\u5bfe\u8c61\u306fHanyouApplet\u3092\u7d99\u627f\u3057\u305f\u3082\u306e\u3002
\u3000\u4f7f\u3044\u65b9\u306f\u30b3\u30e1\u30f3\u30c8\u30a2\u30a6\u30c8\u3067\u6b8b\u3063\u3066\u308b\u306e\u305d\u306e\u307e\u307e\u3002
*/
class HanyouApplet extends SecondBasicApplet
{
  HanyouApplet()
  {
    
  }
  HanyouApplet(float window_alpha)
  {
    this.window_alpha=window_alpha;
    Key_setApplet(this);
  }
  public void setup()
  {
    size(200,200);
  }
  public void draw()
  { 
    //background(255);
    //fill(0, 255, 0);
    //ellipse( mouseX, mouseY, 100, 100 );
    
    Key_update();
    super.draw();
  }
  
  
  int pressTime[]=null;
  public void Key_setApplet(PApplet applet)
  {
    pressTime = new int[Character.MAX_VALUE];
    applet.addKeyListener( new java.awt.event.KeyAdapter()
                           {
                            public void keyPressed(java.awt.event.KeyEvent e)
                            {
                              if (pressTime[e.getKeyCode()] <= 0)
                                pressTime[e.getKeyCode()] = 1;
                            }
                            public void keyReleased(java.awt.event.KeyEvent e)
                            {
                              pressTime[e.getKeyCode()] = -1;
                            }
                           }
                         );
  }
  public int Key_get(int code){  return pressTime[code]; }
  public boolean Key_pressed(int code){  return Key_get(code)==1; }
  public boolean Key_released(int code){  return Key_get(code)==-1; }
  public boolean Key_pushed(int code, int n, int m){  return Key_get(code)>=n&&Key_get(code)%m==0; }
  public void Key_update()
  {  
     for (int i=0; i<pressTime.length; i++)
       pressTime[i]+=pressTime[i]!=0?1:0; 
  }

  
  
}










/*
   This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouApplet\u306e\u7d99\u627f\u5143\u3001\u539f\u578b\u306b\u5f53\u305f\u308b\u3002\u5b9f\u969b\u306b\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u3068\u3057\u3066\u958b\u304f\u70ba\u306ecreateApp()\u30e1\u30bd\u30c3\u30c9\u3082\u3053\u3061\u3089\u306b\u7f6e\u3044\u3066\u3044\u308b\u3002
\u3000\u3069\u3046\u3084\u3063\u3066\u5225\u30a6\u30a4\u30f3\u30c9\u30a6\u3067\u958b\u3044\u3066\u3044\u308b\u306e\u304b\uff1f\u3000\u3068\u3044\u3046\u3068\u3001java\u306e\u4ed5\u69d8\u3068\u6226\u3063\u305f\u3060\u3051\u307f\u305f\u3044\u306a\u611f\u3058\u3067\u3001\u5f8c\u5b66\u306e\u305f\u3081\u306b\u306f\u3042\u307e\u308a\u306a\u3089\u306a\u3044\u306e\u3067\u3001\u3044\u3044\u3084\u3002
*/





int framenum=0;

public void createApp(SecondBasicApplet secondapp,int x,int y)
{
  secondapp.setLocation(x,y);
  PFrame secondf=new PFrame(secondapp);
  secondf.setTitle(  (framenum++)+"nd frame");
  secondf.setLocation(x,y);
}

public class PFrame extends JFrame
{ 
  public PFrame(PApplet app)
  {
    SecondBasicApplet _app=(SecondBasicApplet) app;
    _app.setFrame(this);
    
    app.init();
    while ( app.width<=PApplet.DEFAULT_WIDTH || app.height<=PApplet.DEFAULT_HEIGHT );
    Insets insets = frame.getInsets();
    setSize( app.width + insets.left + insets.right, app.height + insets.top + insets.bottom );
    setResizable(true);    
    add(app);
    show();
  }
}

class SecondBasicApplet extends PApplet {
  Frame frame;
  float window_alpha=1f;
  int _x,_y,_width=0,_height=0;
  char FullscreenKey='F';
  char controlKey=' ';
  boolean isWork=true;
  public void setVisible(boolean isWork){ this.isWork=isWork;  frame.setVisible(isWork); }
  
  public void setup() {
    size( 200, 200 );
  }
  
  public void draw()
  {  //not pg.XXX
    
    
    work();
  }
  
  public void work()
  {
    
    window_size_control_system();
    window_control_system();
    window_control_mousesystem();
  }
  




  
  boolean resizingFlag=false;
  public void window_size_control_system()
  {
    if(dist( mouseX, mouseY, width, height)<=20)
    {
      noStroke();
      int backc=get(width-1,height-1);//abbout right-down point color
      float fill_r=255-red(backc),   fill_g=255-green(backc),   fill_b=255-blue(backc);
      int fill_c=0;
      if(fill_r<(255/2) || fill_g<(255/2) || fill_b<(255/2) )  fill_c=0;
      if(fill_r>(255/2) || fill_g>(255/2) || fill_b>(255/2) )  fill_c=255;
      fill(fill_c,255);
      rect(width-20,height-20,20,20);
      if(mousePressed==true && keyPressed && key==controlKey) resizingFlag=true;
    }
    if(mousePressed==false) resizingFlag=false;
    
    if(resizingFlag) changeWindowSize(mouseX,mouseY);
  }
  
  public void changeWindowSize(int w, int h) {
    frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    //if( abs(width-w)>5 || abs(height-h)>5)println("w,h=("+w+","+h+")");
    size(w, h);
    _width=w;
    _height=h;
  }
  
  
  
  
  
  
  boolean isFullscreen=false;
  boolean _isEnter=false,isEnter=false;
  public void window_control_system()
  {
    if(keyPressed && key==FullscreenKey )  isEnter=true;
    else                                                     isEnter=false;
    /////////////////////////////////////////////////
    if(isEnter==true && _isEnter==false)
    {
      if(isFullscreen)//to normal
      {
        isFullscreen=false;
        setNormalWindow(_width, _height);
      }
      else
      {
        isFullscreen=true;
        setFullScreen();
      }
    }
    ////////////////////  
    _isEnter=isEnter;
    if(!isFullscreen)
    {
      _width=width;
      _height=height;
    }
  }
  public void setLocation(int x,int y)
  {
    _x=x;
    _y=y;
  }
  public void setNormalWindow(int w, int h) {
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
    frame.setAlwaysOnTop(false);
    frame.setLocation(_x, _y);
    frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    this.requestFocus();
  }
  
  public void setFullScreen() {
    size(screenWidth, screenHeight); 
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
    frame.setSize(width, height);
    frame.setLocation(0, 0);
    frame.setAlwaysOnTop(true);
    this.requestFocus();
  }
  
  
  
  
  
  
  
  
  int mx = 0;
  int my = 0;
  boolean _isMouse,isMouse=false;
  public void setFrame(Frame frame)
  {
    this.frame=frame;
  }
  
  public void init() {
    frame.removeNotify();
    frame.setUndecorated(true);
    if(IS_ALWAYS_ON_TOP)frame.setAlwaysOnTop(true);
    frame.addNotify();
    com.sun.awt.AWTUtilities.setWindowOpacity(frame, window_alpha);
    super.init();  
  }
  
  public void window_control_mousesystem()
  {
    if(keyPressed && key==controlKey && !resizingFlag)
    {
      if(mousePressed)
      {
        if(isMouse==false && _isMouse==false)
        {
          mx=mouseX;
          my=mouseY;
        }
        isMouse=true;
      }
    }
    else isMouse=false;
    if(isMouse==true && _isMouse==true)  //  <- mouseDragged
    {
      Point mouse;
      mouse = MouseInfo.getPointerInfo().getLocation();
      frame.setLocation( mouse.x - mx, mouse.y - my );
      _x=mouse.x-mx;
      _y=mouse.y-my;
    }
    _isMouse=isMouse;
  }
  
  
  
  
}
/*
\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba\u5909\u66f4\u3002\u7279\u306b\u30e1\u30a4\u30f3\u306e\u30a6\u30a4\u30f3\u30c9\u30a6\u3002
\u3053\u306e\u30bf\u30d6\u306e\u8ffd\u52a0\u3067\u3001\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba\u3092\u52d5\u7684\u306b\u5909\u66f4\u3067\u304d\u308b\u3088\u3046\u306b\u306a\u308b\u3002\u30d5\u30eb\u30b9\u30af\u30ea\u30fc\u30f3\u5316\u3082\u542b\u3081\u3066\u3002
\u5c1a\u3001draw();(\u306e\u4e2d\u3067\u5b9f\u884c\u3057\u3066\u3044\u308bwork();  )\u306b\u4ee5\u4e0b\u306e\u4e8c\u3064\u3092\u8ffd\u52a0\u3059\u308b\u3002

  window_size_control_system();
  window_control_system();

*/
int mainwinW=0,mainwinH=0;

public void window_size_control_system()
{
  if(dist( mouseX, mouseY, width, height)<=20)
  {
    noStroke();
    int backc=get(width-1,height-1);//abbout right-down point color
    float fill_r=255-red(backc),   fill_g=255-green(backc),   fill_b=255-blue(backc);
    int fill_c=0;
    if(fill_r<(255/2) || fill_g<(255/2) || fill_b<(255/2) )  fill_c=0;
    if(fill_r>(255/2) || fill_g>(255/2) || fill_b>(255/2) )  fill_c=255;
    fill(fill_c,255);
    rect(width-20,height-20,20,20);
    if(mousePressed==true && keyPressed &&key==controlKey) resizingFlag=true;
  }
  if(mousePressed==false) resizingFlag=false;  
  if(resizingFlag) changeWindowSize(mouseX,mouseY);
  }
public void changeWindowSize(int w, int h) {
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  size(w, h,P2D);
  mainwinW=w;
  mainwinH=h;
}



/*
\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba\u5909\u66f4\u3002\u7279\u306b\u30e1\u30a4\u30f3\u306e\u30a6\u30a4\u30f3\u30c9\u30a6\u3002
*/
boolean isFullscreen=false;
boolean _isEnter=false,isEnter=false;
public void window_control_system()
{
  if(keyPressed && key==FullscreenKey )  isEnter=true;
  else                                                     isEnter=false;
  /////////////////////////////////////////////////
  if(isEnter==true && _isEnter==false)
  {
    if(isFullscreen)//to normal
    {
      isFullscreen=false;
      setNormalWindow(mainwinW,mainwinH);
    }
    else
    {
      isFullscreen=true;
      setFullScreen();
    }
  }
  ////////////////////  
  _isEnter=isEnter;
  if(!isFullscreen)
  {
    mainwinW=width;
    mainwinH=height;
  }
}
public void setLocation(int x,int y)
{
  mainwinX=x;
  mainwinY=y;
}
public void setNormalWindow(int w, int h) {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  frame.setAlwaysOnTop(false);
  frame.setLocation(mainwinX, mainwinY);
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  size(w, h,P2D);
  this.requestFocus();
}
public void setFullScreen() {
  size(screenWidth, screenHeight,P2D); 
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  frame.setSize(width, height);
  frame.setLocation(0, 0);
  frame.setAlwaysOnTop(true);
  this.requestFocus();
}
/*

setup\u3084draw\u306e\u3088\u3046\u306b\u81ea\u52d5\u3067\u50cd\u304finit\u30e1\u30bd\u30c3\u30c9\u3092\u5229\u7528\u3057\u3066\u3044\u308b\u3002\u4f8b\u3048\u3070\u30ab\u30e9\u30fc\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u3092\u81ea\u52d5\u3067\u5b9a\u7fa9\u30fb\u521d\u671f\u8a2d\u5b9a\u3092\u6e08\u307e\u305b\u308b\u3088\u3046\u306a\u6319\u52d5\u3068\u304b\u3002
\u5f8c\u306f\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba\u5909\u66f4\u3084\u3001\u30a6\u30a4\u30f3\u30c9\u30a6\u900f\u904e\u7387\u3082\u3053\u3053\u3067\u5f04\u3063\u3066\u3044\u308b\u304b\u3002
*/
/*
\u3053\u306e\u30bf\u30d6\u8ffd\u52a0\u3067\u3001\u900f\u904e\u5ea6\u3001\u30ab\u30e9\u30fc\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u3001\u67a0\u7121\u3057\u30a6\u30a4\u30f3\u30c9\u30a6
\u4ee5\u4e0b\u3092work();\u306b\u8ffd\u52a0\u3059\u308b\u5fc5\u8981\u304c\u3042\u308b\u3002(\u7d76\u5bfe\u3067\u306f\u7121\u3044\u304c)
window_control_mousesystem()

\u305d\u3082\u305d\u3082\u3001\u30ab\u30e9\u30fc\u30a6\u30a3\u30b8\u30a7\u30c3\u30c8\u3092init();\u3067\u751f\u6210\u3059\u308b\u90fd\u5408\u3001\u3068\u3044\u3046\u304binit();\u306e\u66f8\u304d\u63db\u3048\u306e\u90fd\u5408\u3001
*/
 
int mx = 0;
int my = 0; 
boolean _isMouse,isMouse=false;
 
public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);  
  if(IS_ALWAYS_ON_TOP)frame.setAlwaysOnTop(true);
  frame.addNotify();
  frame.setLocation(mainwinX,mainwinY);
  com.sun.awt.AWTUtilities.setWindowOpacity(frame, WINDOW_ALPHA);
  
  createApp(hacw ,600,200);
  hacw.setVisible(false);
  
  super.init();
}

public void window_control_mousesystem()
{
  if(keyPressed && key==controlKey && !resizingFlag)
  {
    if(mousePressed)
    {
      if(isMouse==false && _isMouse==false)
      {
        mx=mouseX;
        my=mouseY;
      }
      isMouse=true;
    }
  }
  else isMouse=false;
  if(isMouse==true && _isMouse==true)  //  <- mouseDragged
  {
    Point mouse;
    mouse = MouseInfo.getPointerInfo().getLocation();
    frame.setLocation( mouse.x - mx, mouse.y - my );
    mainwinX=mouse.x-mx;
    mainwinY=mouse.y-my;
  }
  _isMouse=isMouse;
}


class SampleListTest extends TestSampleList
{
  SampleListTest(PApplet papp)
  {
    super(papp);
    addScene(new Controller(papp) );
    addScene(new SceneTest(papp) );
  }
  
}

class ListTestB extends TestSampleList
{
  ListTestB(PApplet papp)
  {
    super(papp);
    addScene(new Controller(papp) );
    addScene(new SceneTest(papp) );
    //addScene(new PoyoBall(papp) );
  }
  
}

class CorpsWarGameList extends TestSampleList
{
  CorpsWarGameList(PApplet papp)
  {
    super(papp);
    addScene(new CorpsWarGameOpening(papp) );
    addScene(new CorpsWarGame(papp) );
    //addScene(new PoyoBall(papp) );
  }
  
}
/*

\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouApplet\u306e\u5229\u7528\u4f8b\u3002pg\u4f7f\u3063\u3066\u306a\u3044\u666e\u901a\u306esetup-draw\u3063\u307d\u3044\u3053\u3068\u306b\u6c17\u3092\u3064\u3051\u3066\u3002
\u3000\u3053\u308c\u3092\u5b9f\u969b\u306b\u904b\u7528\u3059\u308b\u306b\u306f\u3001\u30e1\u30a4\u30f3\u306esetup\u306a\u3069\u3067createApp()\u3084\u304b\u3089\u306d\u3002

*/
class CorpsWarApp extends HanyouApplet
{
  Scene scene;
  CorpsWarApp(float window_alpha)
  {
    super(window_alpha);
  }
  
  public void setup()
  {
    size(800,600,P2D);
    smooth();
    frameRate(30);
    scene=new Scene(new NoneContentScene(this),new CoverflowGUI(this,'m') );
    scene.optionGUI.setSampleList(new CorpsWarGameList(this) );
    scene.loadSceneList("corpswar");
  }
  public void draw()
  {
    background(0);
    image(scene.getScene().getImage(),0,0,width,height);
      fill(0,0,255);
      textSize(16);
      text("FPS:"+(int)frameRate,width-60,30);
    if(Key_pressed('R') )setup();
    super.draw();
  }
}

class CorpsWarGameOpening extends HanyouBuffer
{
  CorpsWarGameOpening(PApplet papp){  super(papp);  }
  CorpsWarGameOpening(PApplet papp,Scene mypointer){  super(papp,mypointer);  }
  public void setup(){  size(papp.width,papp.height,"P2D");  }
  public void draw(){  pg.background(125);  }
  public HanyouBuffer sceneWork()
  {
    if(papp.keyPressed && papp.key!='m'){println("test"); return next;}//  CorpsWarGame(papp);
    return this;
  }
}

class CorpsWarGame extends HanyouBuffer
{
  CorpsWarGame(PApplet papp){  super(papp);  }
  CorpsWarGame(PApplet papp,Scene mypointer){  super(papp,mypointer);  }
  public void setup()
  {
    size(papp.width,papp.height,"P2D");
    pg.smooth();
    corps = new Corp[corpNum];
    for(int i=0;i<corps.length;i++)
    {
      corps[i]=new Corp(unitNum,corps,papp,pg,false,i);
      if(i==0)corps[i].isPlayer=true;
      else      corps[i].isPlayer=false;
    }
    bullets=new Bullet[bulletNum];
    for(int i=0; i<bullets.length; i++)
    {
      bullets[i]=new Bullet(i,corps,bullets,papp,pg);
    }
  }
  public void draw(){
    pg.background(0);
    int i=0;
    for(i=0;i<corps.length;i++) corps[i].draw();
    for(i=0;i<bullets.length; i++) bullets[i].draw();
  }
  public HanyouBuffer sceneWork()
  {
    //if(keyPressed && key!='m') return next;//  CorpsWarGame(papp);
    return this;
  }
}



//\u4e0b\u4e8c\u3064\u306f\u3069\u3053\u3067\u4f7f\u3063\u3066\u3044\u305f\u3063\u3051\u3002CorpsWar\u3067\u306f\u4f7f\u3063\u3066\u306a\u3044\uff1f

class AppletC extends HanyouApplet
{
  HanyouBuffer scene;
  AppletC(float window_alpha)
  {
    super(window_alpha);
  }
  
  public void setup()
  {
    size(200,200);
    scene=new BoundBall(this);
  }
  public void draw()
  {
    background(255);
    //HanyouBuffer hb=coverflow.get();
    //if(hb!=null)scene=hb;
    image(scene.getImage(), 0,0,width,height);
    
    super.draw();
  }
}




class AppletD extends HanyouApplet
{
  Scene ball;
  AppletD(float window_alpha)
  {
    super(window_alpha);
  }
  
  public void setup()
  {
    size(200,200);
    ball=new Scene(new BoundBall(this) );
    ball.optionGUI.setSampleList(new SampleListTest(this) );
    
    ball.optionGUI.isVisible=1;
    ball.getScene(NOT_OPTION).name="Ball_D";
    PImage pimg=ball.getScene(NOT_OPTION).getImage();//init
  }
  public void draw()
  {
    background(255);
    image(ball.optionGUI.getImage(), 0,0,width,height);
    super.draw();
  }
  
  public Scene outputSync(Scene scene)
  {
    scene.setScene(ball.getScene(NOT_OPTION)   );
    return scene;
  }
  
}


class Bullet
{
  PApplet papp;
  PGraphics pg;
  Unit fromUnit=null;
  Corp[] corps;
  Bullet[] bullets;
  
  boolean isWork=false;//\u5f53\u305f\u308a\u5224\u5b9aON\u306a\u3069\u3002false\u6642\u70b9\u3067\u306feffect\u884c\u3046
  boolean isShield=false;//\u9632\u304c\u308c\u305f\u307b\u3046
  boolean isCannotPene=true;
  int ID;
  int x=0,y=0,w=10,h=10;
  float direction=0,speed=0;
  int life=-1;
  int damage=-1;
  Bullet(int ID,Corp[] corps,Bullet[] bullets,PApplet papp,PGraphics pg)
  {
    this.ID=ID;
    this.corps=corps;
    this.bullets=bullets;
    this.papp=papp;
    this.pg=pg;
    x=0;
    y=0;
    w=10;
    h=10;
    speed=0;
    life=-1;
    damage=-1;
    isWork=false;
  }
  Bullet(Bullet befBullet,Unit fromUnit,int x,int y,float direction)//shoot
  {
    this.fromUnit=fromUnit;
    corps=befBullet.corps;
    bullets=befBullet.bullets;
    papp=befBullet.papp;
    pg=befBullet.pg;
    this.x=x;
    this.y=y;
    this.direction=direction;
    speed=2;
    w=10;
    h=10;
    life=100;
    damage=30;
    isWork=true;
  }
  public void draw()
  {
    if(isWork)
    {
      move();
      if(!collision() )modeling();
      else             isWork=false;
      if(life--<0)     isWork=false;
    }
    else effect();
  }
  
  public boolean collision()
  {
    for(int i=0; i<corps.length; i++)
    { 
      if(i==fromUnit.CorpID)continue;
      for(int j=0; j<corps[i].units.length; j++)
      { if( ( sq(corps[i].units[j].x-x)+sq(corps[i].units[j].y-y) )<=sq(w+corps[i].units[j].r)*0.4f )
        { if(corps[i].units[j].isWork==false)continue;
          if(corps[i].units[j].isShield==false)
          {
            corps[i].units[j].life-=damage;
            if (corps[i].units[j].life < 1)
            {   
              corps[i].units = corps[i].remove(j, corps[i].units);
              //mSketch.mParticleSystem.emitter(tx, ty, 0, 0,100, 10);
            }
          }
          else isShield=true;
          return isCannotPene;
    } } }
    return false;
  }
  public void move()
  {
    float radians = (float) ((Math.PI * (direction)) / 180);
    x += speed * Math.cos(radians);
    y += speed * Math.sin(radians);
  }
  public void modeling()
  {
    pg.pushMatrix();
    pg.translate(x,y);
    if(fromUnit!=null)pg.fill(fromUnit.uColor,255,255-fromUnit.uColor, 150);
    else              pg.fill(255,0,0,150);
    pg.ellipse(0,0,w,w);
    pg.popMatrix();
  }
  
  int effectCount=0;
  public void effect()//isWork=false\u3067\u3082\u7a3c\u52d5\u3057\u3066\u3044\u308b\u304c\u3001\u4e00\u5b9a\u6642\u9593\u5f8c\u6d88\u3048\u308b\u30a8\u30d5\u30a7\u30af\u30c8\u3067\u3042\u308b\u4e8b\u306b\u671f\u5f85
  {
    if(isShield);
    else ;
    if(effectCount++>10)dead();
  }
  public void dead()
  {
    x=0;
    y=0;
    isWork=false;
    if(life>0)isWork=!isCannotPene;
  }
  
}

class Corp
{
        PApplet papp;
	PGraphics pg;
        Unit[] units;
        Corp[] corps;

        int CorpID;
	int uColor;	//UnitColor
	float x, y;
        boolean isPlayer;
        Corp(int startunits,Corp[] corps,PApplet papp,PGraphics pg,boolean isPlayer,int CorpID)
        {
          this.papp=papp;
	  this.pg=pg;
          this.corps=corps;
	  this.isPlayer=isPlayer;
          this.CorpID=CorpID;
          x=papp.random(pg.width*.9f);
          y=papp.random(pg.height*.9f);
          if(CorpID==0)uColor=1;
          else if(CorpID==1)uColor=120;
          else if(CorpID==2)uColor=255;
          else uColor=corps[CorpID-1].uColor+60;
          units=new Unit[startunits];
          for(int i=0;i<units.length;i++)
          {
            if(i==0) units[i]=new CorpCore(papp,pg,corps,x,y,CorpID,i,uColor);
            else     units[i]=new Unit(papp,pg,corps,x,y,CorpID,i,uColor);
            if(CorpID==0 && i==1)units[i].isPlayerON(UP,LEFT,DOWN,RIGHT);//UP,LEFT,DOWN,RIGHT  //'W','A','S','D'
          }
        }
        public void draw()
        {
          pg.fill(uColor,255,255-uColor,255);
          pg.textSize(16);
          pg.text(""+unitsLifeLength(),15,15*(CorpID+1));
          for(int i=0;i<units.length;i++) units[i].run();
          if(isPlayer)
          {
            pg.fill(uColor,255-uColor,255,100);
            handle();
          }
        }
        public Unit[] remove (int valueToRemove,Unit in[])
        {
          /*
          if(in.length<1||in[valueToRemove]==null)return in;
          
          Unit[] temp=new Unit[in.length-1];
          for (int i=0;i<valueToRemove;i++)                temp[i]=in[i];
          for (int i=valueToRemove;i<temp.length;i++) temp[i]=in[i+1];
          return temp;
          */
          in[valueToRemove].isWork=false;//die
          if(in[valueToRemove].r==R_CORPCORE_SIZE)
          {
            for(int i=0; i<in.length; i++)in[i].isWork=false;//\u62e0\u70b9\u7834\u58ca->\u90e8\u968a\u58ca\u6ec5
          }
          return in;
        }
        public int unitsLifeLength()
        {
          int result=0;
          for(int i=0; i<units.length; i++)
          {
            if(units[i].isWork==true)result++;
          }
          return result;
        }

        
        
        
        
        int mnx=0,mny=0;
        int px=0,py=0;
        PVector[] mnpoints = new PVector[4];
        boolean pmousePressed=false;
        boolean mousePressed=false;
        boolean pFlg=false;
        public void handle()
        {
          pg.ellipse(papp.mouseX,papp.mouseY,5,5);
          pg.ellipse(px,py,5,5);
          mousePressed=papp.mousePressed;
          if (papp.mousePressed&&papp.mouseButton==papp.LEFT&&!pmousePressed)
          {	
            pFlg=false;
            px=0;
            py=0;
            mnx=(int)papp.mouseX;
            mny=(int)papp.mouseY;
            mnpoints[0] = new PVector(papp.mouseX,papp.mouseY);
          }
	  if (papp.mousePressed&&papp.mouseButton==papp.LEFT&&pmousePressed) 
          {	
	    mnpoints[0] = new PVector(mnx,mny);	
            mnpoints[1] = new PVector(papp.mouseX,mny);
	    mnpoints[2] = new PVector(papp.mouseX,papp.mouseY);	
            mnpoints[3] = new PVector(mnx,papp.mouseY);
	    tsVertex(mnpoints);
          }
	  if (!papp.mousePressed&&papp.mouseButton==papp.LEFT&&pmousePressed)
          {	
            mnpoints[0] = new PVector(mnx,mny);	
            mnpoints[1] = new PVector(papp.mouseX,mny);
            mnpoints[2] = new PVector(papp.mouseX,papp.mouseY);	
            mnpoints[3] = new PVector(mnx,papp.mouseY);
            for(int i=0;i<units.length;i++)
            {
              units[i].isSelected=false;
              if(mnpoints[0].x<mnpoints[1].x&&mnpoints[0].y<mnpoints[2].y)
              {
                if(units[i].x>mnpoints[0].x&&units[i].x<mnpoints[1].x&&
		   units[i].y>mnpoints[0].y&&units[i].y<mnpoints[2].y){    units[i].isSelected=true;}
              }
	      else if(	mnpoints[1].x<mnpoints[0].x&&mnpoints[0].y<mnpoints[2].y)
              {
	        if(units[i].x>mnpoints[1].x&&units[i].x<mnpoints[0].x&&
                   units[i].y>mnpoints[0].y&&units[i].y<mnpoints[2].y){	units[i].isSelected=true;}	
              }
	      else if(	mnpoints[1].x<mnpoints[0].x&&mnpoints[2].y<mnpoints[0].y)
              {
	        if(units[i].x>mnpoints[1].x&&units[i].x<mnpoints[0].x&&
		   units[i].y>mnpoints[2].y&&units[i].y<mnpoints[0].y){	units[i].isSelected=true;}	
              }
	      else if(mnpoints[0].x<mnpoints[1].x&&mnpoints[2].y<mnpoints[0].y)
              {
	        if(units[i].x>mnpoints[0].x&&units[i].x<mnpoints[1].x&&
		   units[i].y>mnpoints[2].y&&units[i].y<mnpoints[0].y){	units[i].isSelected=true;}	
              }
	  } }


          if (papp.mousePressed&&papp.mouseButton==papp.RIGHT) 
          {
              px=papp.mouseX;
              py=papp.mouseY;
	  }
	  pmousePressed=papp.mousePressed;

          if(pFlg=true && px!=0 && py!=0)
          {
	      for(int i=0;i<units.length;i++)
              {
                if (units[i].isSelected)
                {	
                  float angle = papp.atan2(py-units[i].y,px-units[i].x)*180/papp.PI;
                  units[i].direction=angle;
                }
              }
          }
          
        }	
        public void tsVertex(PVector[] a)
        {  
            pg.beginShape(); 
                pg.vertex(a[0].x, a[0].y);
                pg.vertex(a[1].x, a[1].y);
                pg.vertex(a[2].x, a[2].y);
            pg.endShape();
            pg.beginShape();
                pg.vertex(a[2].x, a[2].y);
                pg.vertex(a[3].x, a[3].y);
                pg.vertex(a[0].x, a[0].y);
            pg.endShape(); 
        }
}

class RectBullet extends Bullet
{
  /*
  RectBullet(int ID,Corp[] corps,Bullet[] bullets,PApplet papp)
  {
    super(ID,corps,bullets,papp);
  }
  */
  RectBullet(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=2;
    w=20;
    h=20;
    life=100;
    damage=30;
    isCannotPene=true;
  }
  public boolean collision()
  {
    for(int i=0; i<corps.length; i++)
    { 
      if(i==fromUnit.CorpID)continue;
      for(int j=0; j<corps[i].units.length; j++)
      { if( x<=corps[i].units[j].x && corps[i].units[j].x <=(x+w) )
        { if(y<=corps[i].units[j].y && corps[i].units[j].y <=(y+h) )
          { if(corps[i].units[j].isWork==false)continue;
            if(corps[i].units[j].isShield==false)
            {
              corps[i].units[j].life-=damage;
              if (corps[i].units[j].life < 1)
              {   
                corps[i].units = corps[i].remove(j, corps[i].units);
                //mSketch.mParticleSystem.emitter(tx, ty, 0, 0,100, 10);
              }
            }
            else isShield=true;
            return isCannotPene;
    } } } }
    return false;
  }

  public void modeling()
  {
    pg.pushMatrix();
    pg.translate(x,y);
    if(fromUnit!=null)pg.fill(fromUnit.uColor,255,255-fromUnit.uColor, 150);
    else              pg.fill(255,0,0,150);
    pg.rect(0,0,w,h);
    pg.popMatrix();
  }
  
  int effectCount=0;
  public void effect()//isWork=false\u3067\u3082\u7a3c\u52d5\u3057\u3066\u3044\u308b\u304c\u3001\u4e00\u5b9a\u6642\u9593\u5f8c\u6d88\u3048\u308b\u30a8\u30d5\u30a7\u30af\u30c8\u3067\u3042\u308b\u4e8b\u306b\u671f\u5f85
  {                //(\u8907\u6570\u30d2\u30c3\u30c8\u3060\u304b\u3089)\u30d2\u30c3\u30c8\u6642\u306e\u30a8\u30d5\u30a7\u30af\u30c8\u3067\u3082\u7121\u3044\u3057\u3001\u56fa\u5b9a\u30ec\u30fc\u30b6\u306a\u3089\u3053\u3053\u306e\u5f79\u5272\u306a\u3093\u3060\u308d\u3046
                   //\u30ec\u30fc\u30b6\u7d42\u308f\u308a\u969b\u306e\u6319\u52d5(\u706b\u7dda)\uff1f\u3000\u3067\u3082\u305d\u308c\u306f\u63cf\u753b\u306edraw\u306e\u65b9\u3067life\u3068\u540c\u671f\u3057\u3066...
    if(isShield);
    else ;
    if(life<=0)dead();
  }
}

public final int R_UNIT_SIZE=22;
public final int R_CORPCORE_SIZE=40;

class Unit
{
  PApplet papp;
  PGraphics pg;
  Corp[] corps;

  boolean isWork=true,isFreeMove=true,isShield=false;
  boolean isPlayer=false;
  boolean isSelected;

  float direction;
  int uColor;//unit Color
  int life;
  float x, y, speed,defaultspeed;
  int CorpID, unitID;
  int r=R_UNIT_SIZE;
  int chargeCount=0;
  Unit(PApplet papp,PGraphics pg,Corp[] corps, float x2, float y2,int groupIDi, int unitIDi, int uColori)
  {
    this.pg=pg;
    this.papp = papp;
    this.corps=corps;
    direction = papp.random(-180, 180);
    CorpID = groupIDi;
    uColor = uColori;
    life = 100;
    unitID = unitIDi;
    defaultspeed=0.7f;
    speed = defaultspeed;
    x = papp.random(x2 - papp.width * .1f, x2+ papp.width * .1f);
    y = papp.random(y2 - papp.height * .1f, y2 + papp.height * .1f);
    isSelected = false;
    isPlayer=false;
    
    keyUp=-1;
    keyLeft=-1;
    keyDown=-1;
    keyRight=-1;
  }
  public void run()
  {
    isFreeMove=true;
    if(isWork==false)return;
    if(isPlayer) keycontrol();
    move();
    fight();
    draw();
  }
  public void draw()
  {
    pg.fill(uColor,255,255-uColor, 255);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.stroke(255 - life * 2.5f, life * 2.5f, 0, 255);
    pg.line(-life / 4, -10, life / 4, -10);
    pg.stroke(255);
    if(isFreeMove)pg.rotate(papp.radians(direction));
    else          pg.rotate(papp.radians(direction-90));
    if (isSelected)
    {
      pg.ellipse(0, 0, r, r);
    }
    if(isPlayer)
    {
      pg.fill(255,0,0, 55);
      pg.ellipse(0, 0, r, r);
      pg.fill(uColor, 255 - uColor, 255, 255);
    }
    pg.beginShape();
      pg.vertex(-5,-5);
      pg.vertex(10,0);
      pg.vertex(-5,5);
    pg.endShape(CLOSE);
    pg.noStroke();
    pg.fill(255, 255, 255, 55);
    pg.ellipse(0, 0, r, r);
    pg.popMatrix();
  }
  
  public void fight()
  {
    boolean canShoot = true;
    speed = defaultspeed;
    for (int i = 0; i < corps.length; i++)
    {
      for (int j = 0; j < corps[i].units.length; j++)
      {
        if(corps[i].units[j].isWork==false) continue;
        if (!(i == CorpID && j == unitID))
        {
          float tx = corps[i].units[j].x, ty = corps[i].units[j].y, vx, vy;
          float radius = papp.dist(x, y, tx, ty);
          if (radius < 135)
          {
            float angle = papp.atan2(y - ty, x- tx)* 180 / papp.PI + 180;
            if (i != CorpID && canShoot)
            {
              pg.stroke(uColor,255,255-uColor, 255);
              speed = defaultspeed;
              canShoot = false;
              
              if(chargeCount++==0)
              { for(int k=0; k<bullets.length; k++)
                { if(bullets[k].isWork==false)
                  {
                    int rp=(int)(random(0,5) );//rp=random-pattern//random(0,3)
                    if       (rp==0) bullets[k]=new Bullet(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==1) bullets[k]=new Shield(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==2) bullets[k]=new RectBullet(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==3){ if( (int)(random(0,5) ) ==2 )bullets[k]=new Lazer(bullets[k],this,(int)x,(int)y,angle); }
                    else if(rp==4) bullets[k]=new Beam(bullets[k],this,(int)x,(int)y,angle);
                    break;
              } } }
              else if(chargeCount>100){chargeCount=0;}
              
              pg.fill(uColor, 255 - uColor, 255, 55);
              pg.line(x, y, tx, ty);
              direction = angle+90;
              isFreeMove=false;
              if(!isPlayer) { if(life<=50)direction+=90;}
            }
        } }
        pg.stroke(255);
        pg.strokeWeight(1);
      }
    }
  }
  
  int dm=0;
  public void move()
  {
    float radians= (float) ((Math.PI * (direction)) / 180);
    if(!isPlayer)
    {
      x += speed * Math.cos(radians);
      y += speed * Math.sin(radians);
      if(dm++==100){direction += papp.random(-50, 50); }
    }
    if (x < 10)
    {
      x = 10;
      direction += papp.random(-100, 100);
    }
    if (x > papp.width - 10)
    {
      x = papp.width - 10;
      direction += papp.random(-100, 100);
    }
    if (y < 10)
    {
      y = 10;
      direction += papp.random(-100, 100);
    }
    if (y > papp.height - 10)
    {
      y = papp.height - 10;
      direction += papp.random(-100, 100);
    }
  }  
  
  public void isPlayerON(int upkey,int leftkey,int downkey,int rightkey)
  {
    isPlayer=true;
    keyUp=upkey;
    keyLeft=leftkey;
    keyDown=downkey;
    keyRight=rightkey;
  }
  int keyUp,keyLeft,keyDown,keyRight;
  public void keycontrol()
  {
    HanyouApplet happ=(HanyouApplet)papp;
      if(happ.Key_get(keyUp)>0 )    y-=2;
      if(happ.Key_get(keyLeft)>0 )  x-=2;
      if(happ.Key_get(keyDown)>0 )  y+=2;
      if(happ.Key_get(keyRight)>0 ) x+=2;
  }
}


class CorpCore extends Unit
{
   CorpCore(PApplet papp,PGraphics pg,Corp[] corps, float x2, float y2,int groupIDi, int unitIDi, int uColori)
   {
      super(papp,pg,corps,x2,y2,groupIDi,unitIDi,uColori);
      speed=0;//\u62e0\u70b9\u306f\u52d5\u304b\u306a\u3044\u3002\u3068\u308a\u3042\u3048\u305a\u5ff5\u306e\u305f\u30810\u306b\u3002
     defaultspeed=0;//\u62e0\u70b9\u306f\u52d5\u304b\u306a\u3044\u3002\u3068\u308a\u3042\u3048\u305a\u5ff5\u306e\u305f\u30810\u306b\u3002
     r=R_CORPCORE_SIZE;
     life*=2;
   }
  public void draw()
  {
    pg.fill(uColor,255,255-uColor, 255);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.stroke(255);
    //if(isFreeMove)papp.rotate(papp.radians(direction));
    //else              papp.rotate(papp.radians(direction-90));
    if (isSelected)
    {
      pg.ellipse(0, 0, r, r);
    }
    pg.ellipse(0, 0, r, r);
    pg.stroke(255 - life * 2.5f, life * 2.5f, 0, 255);
    pg.line(-life / 4, -10, life / 4, -10);
    pg.popMatrix();
  }
}

/*
[http://nameniku.blog71.fc2.com/blog-entry-635.html]
*/

class Beam extends Lazer
{
  Beam(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=2;
    w=30;
    h=10;
    life=100;
    isColisionDebug=false;
    isCannotPene=true;
    damage=30;
  }
  public void move()
  {
    super.move();
    w-=10;
  }
}

class Lazer extends RectBullet
{
  boolean isColisionDebug=false;//\u659c\u3081\u30ec\u30fc\u30b6\u3068unit\u70b9xy\u306e\u5f53\u305f\u308a\u5224\u5b9a//0,0\u3092\u57fa\u6e96\u306b\u3057\u3066\u30ec\u30fc\u30b6\u771f\u6a2a\u5909\u63db\u3001unit\u70b9\u5909\u63db\u3057\u305f\u3082\u306e\u3092\u8868\u793a
  Lazer(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=0;
    w=10;
    h=10;
    life=100;
    isColisionDebug=false;
    isCannotPene=false;
    damage=1;
  }
  public boolean collision()
  {
    float radians = (float) ((Math.PI * (direction)) / 180);
    float x2,y2,rx,ry;//rx=result-x
    for(int i=0; i<corps.length; i++)
    { 
      if(i==fromUnit.CorpID)continue;
      for(int j=0; j<corps[i].units.length; j++)
      { if(corps[i].units[j].isWork==false)continue;
        x2=corps[i].units[j].x-x;
        y2=corps[i].units[j].y-y;
        rx=x2*cos(radians)+y2*sin(radians);
        ry=x2*sin(radians)-y2*cos(radians);
        //if(rx<0)rx*=-1;
        //if(ry<0)ry*=-1;
        if(isColisionDebug){ papp.fill(corps[i].units[j].uColor, 255 - corps[i].units[j].uColor, 255, 150); papp.ellipse(rx,ry,10,10);  }                                             
        if(0<=rx&&rx<=w*0.8f)
        { if(0<=ry&&ry<=h*0.8f)
          {
            if(corps[i].units[j].isShield==false)
            {
              corps[i].units[j].life-=damage;
              if (corps[i].units[j].life < 1)
              {
                corps[i].units = corps[i].remove(j, corps[i].units);
                //mSketch.mParticleSystem.emitter(tx, ty, 0, 0,100, 10);
              }
            }
            else isShield=true;
            return isCannotPene;//\u3053\u3053false\u3067\u8cab\u901a
    } } } }
    return false;
  }
  public void move()
  {
    super.move();
    w+=10;
  }
    public void modeling()
  {
    float radians = (float) ((Math.PI * (direction)) / 180);
    pg.pushMatrix();
      pg.translate(x,y);
      pg.rotate(radians);
      if(fromUnit!=null)pg.fill(fromUnit.uColor,255,255-fromUnit.uColor, 150);
      else              pg.fill(255,0,0,150);
      pg.rect(0,0,w,h);
    pg.popMatrix();
    if(isColisionDebug){ pg.fill(fromUnit.uColor, 255 - fromUnit.uColor, 255, 150); pg.rect(0,0,w,h); }
  }
  
}
class Shield extends Bullet
{
  float fromUnitx,fromUnity;
  Shield(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=0;
    w=(int)(fromUnit.r*1.2f);
    h=(int)(fromUnit.r*1.2f);
    life=100;
    fromUnit.isShield=true;
    fromUnitx=fromUnit.x;
    fromUnity=fromUnit.y;
    isCannotPene=false;
    damage=0;
  }
  public void move()
  {
    fromUnit.x=fromUnitx;
    fromUnit.y=fromUnity;
  }
  
  public boolean collision()
  {
    for(int i=0; i<bullets.length; i++)
    {
        if( ( sq(bullets[i].x-x)+sq(bullets[i].y-y) )<=sq(w+bullets[i].w)*0.4f )
        {
          if(i==ID)continue;
          bullets[i].effect();
          return isCannotPene;//effect//\u306f\u5404\u7a2ebullet\u7cfb\u306eif\u5206\u5c90\u306b\u4efb\u305b\u308b
    }   }
    return false;
  }
  public void modeling()
  {
    pg.pushMatrix();
    pg.translate(x,y);
    pg.fill(255,255,255,150);
    pg.ellipse(0,0,w,h);
    pg.popMatrix();
  }
  public void effect()//isWork=false\u3067\u3082\u7a3c\u52d5\u3057\u3066\u3044\u308b\u304c\u3001\u4e00\u5b9a\u6642\u9593\u5f8c\u6d88\u3048\u308b\u30a8\u30d5\u30a7\u30af\u30c8\u3067\u3042\u308b\u4e8b\u306b\u671f\u5f85
  {                //(\u8907\u6570\u30d2\u30c3\u30c8\u3060\u304b\u3089)\u30d2\u30c3\u30c8\u6642\u306e\u30a8\u30d5\u30a7\u30af\u30c8\u3067\u3082\u7121\u3044\u3057\u3001\u56fa\u5b9a\u30ec\u30fc\u30b6\u306a\u3089\u3053\u3053\u306e\u5f79\u5272\u306a\u3093\u3060\u308d\u3046
                   //\u30ec\u30fc\u30b6\u7d42\u308f\u308a\u969b\u306e\u6319\u52d5(\u706b\u7dda)\uff1f\u3000\u3067\u3082\u305d\u308c\u306f\u63cf\u753b\u306edraw\u306e\u65b9\u3067life\u3068\u540c\u671f\u3057\u3066...
    if(isShield);
    else ;
    if(life<=0)dead();
  }
  public void dead()
  {
    super.dead();
    fromUnit.isShield=false;
  }
  
}
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouBuffer\u5229\u7528\u4f8b\u305d\u306e2\u3002\u30dc\u30fc\u30eb\u3088\u308a\u5c11\u3057\u96e3\u3057\u3081\u3002\u3053\u3061\u3089\u3082\u3001CG\u6df7\u305c\u5408\u308f\u305b\u305f\u3044\u306a\u3089\u3001blend()\u30e1\u30bd\u30c3\u30c9\u3068\u304bpixels\u52a0\u7b97\u3088\u308a\u3082\u3001draw\u306e\u4e2d\u306e\u30bd\u30fc\u30b9\u3092\u7d44\u307f\u5408\u308f\u305b\u3066\u6df7\u305c\u308b\u65b9\u304c\u697d\u304b\u3064\u5947\u9e97\u3002\u60b2\u3057\u3044\u3002

   
*/

class SceneTest extends HanyouBuffer
{
  float h, p, b;     // \u30d8\u30c7\u30a3\u30f3\u30b0\u30fb\u30d4\u30c3\u30c1\u30fb\u30d0\u30f3\u30af\u56de\u8ee2\u91cf
  float dh, dp, db;  // \u89d2\u901f\u5ea6
  int objColor, bgColor;
  
  SceneTest(PApplet papp)
  {
    super(papp);
  }
  SceneTest(PApplet papp,Scene mypointer)//   <---point   (as Scene)
  {
    super(papp,mypointer);
  }
  
  public void setup()
  {
    size(300,300,"P3D");//high-graphic : main-window(w,h= 500,400)
    //size(100,100,"P3D");//low-graphic //but work-cost cannot low. (smalling or bigging image is high work-cost?)
    
    // \u8272\u306e\u4ed8\u3051\u65b9\u306f\u3066\u304d\u3068\u3046\u3067\u3059\u3002
    objColor = color(random(100, 200), 
                             random(100, 200), 
                             random(100, 200));
    bgColor = color( red(objColor) + 55, green(objColor) + 55, blue(objColor) + 55);
    
    // \u56de\u8ee2\u91cf\u30fb\u4e26\u9032\u91cf\u3092\u8a2d\u5b9a
    h = random(0, 360);
    p = random(-90, 90);
    b = random(0, 360);
    dh = random(-1, 1);
    db = random(-1, 1);
    dp = random(-1, 1);
  }
  
  public void draw()
  {
    pg.camera();
    pg.lights();
    
    pg.background(bgColor);
    
    pg.noStroke();
    pg.fill(objColor);
    
    pg.pushMatrix();
    pg.translate(pg.width/2, pg.height/2, -pg.width/2);
    pg.rotateY(radians(h));
    pg.rotateX(radians(p));
    pg.rotateZ(radians(b));
    pg.box(pg.width*0.8f   );
    pg.popMatrix();
    
    h += dh;
    p += dp;
    b += db;
    
    pg.noLights();
  }
  public HanyouBuffer sceneWork()
  {
    //if(keyPressed && key=='p') return new ExplosionEffect(this,new SceneTest(papp,mypointer) );
    return this;
  }
}
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouBuffer\u5229\u7528\u4f8b\u305d\u306e1\u3002\u305f\u3060\u306e\u30d0\u30a6\u30f3\u30c9\u30dc\u30fc\u30eb\u3002
\u3000CG\u6df7\u305c\u5408\u308f\u305b\u305f\u3044(\u3053\u306e\u30dc\u30fc\u30eb\u3068\u5225\u306eCG\u3092\u540c\u6642\u63cf\u753b\u3057\u305f\u3044)\u306a\u3089\u3001\u3053\u306e\u30dc\u30fc\u30eb\u7a0b\u5ea6\u306a\u3089\u3001blend()\u30e1\u30bd\u30c3\u30c9\u3068\u304bpixels\u52a0\u7b97\u3088\u308a\u3082\u3001draw\u306e\u4e2d\u306e\u30bd\u30fc\u30b9\u3092\u7d44\u307f\u5408\u308f\u305b\u3066\u6df7\u305c\u308b\u65b9\u304c\u697d\u304b\u3064\u5947\u9e97\u3002\u60b2\u3057\u3044\u3002
\u3000x,y\u5ea7\u6a19\u6301\u3063\u3066work()\u306e\u3042\u308b\u30dc\u30fc\u30eb\u3092\u4f5c\u308b\u304c\u5b9a\u77f3\u3060\u3068\u306f\u3001\u982d\u306e\u7247\u9685\u306b\u7f6e\u3044\u3066\u304a\u304f\u3079\u304d\u3002HanyouBuffer\u7cfb\u306f\u7d76\u5bfe\u306b\u5229\u7528\u3059\u308b\u3079\u304d\u3068\u3044\u3046\u3082\u306e\u3067\u3082\u306a\u3044(\u3082\u3057\u304f\u306fHanyouBuffer\u7cfb\u306e\u3082\u306e\u3092\u4e00\u3064\u3060\u3051\u565b\u307e\u305b\u308b)

*/
class BoundBall extends HanyouBuffer
{
  ColorObject ballcolor=new ColorObject(255,0,0,255);
  int x,y,dx=1,dy=(int)(random(1,5) );
  BoundBall(PApplet papp)
  {
    super(papp);
  }
  public void setup()
  {
    size(papp.width,papp.height,"P2D");//controller-width,height copy
    x=pg.width/3;
    y=pg.height/2;
  }
  public void draw()
  {
    pg.background(0);
    pg.fill(ballcolor.getColor() );
    pg.ellipse(x,y,50,50);
    x+=dx;
    y+=dy;
    if( x<0 || pg.width<x) dx*=-1;
    if( y<0 || pg.height<y) dy*=-1;
    colorcontrol(name,ballcolor,'b');
  } 
}


/*
//normal (bound-ball only ) mode
      ColorObject ballcolor=new ColorObject(255,0,0,255);
      int x,y,dx=1,dy=(int)(random(1,5) );
      void setup()
      {
        size(300,300,P2D);//controller-width,height copy
        x=width/3;
        y=height/2;
      }
      void draw()
      {
        background(0);
        fill(ballcolor.getColor() );
        ellipse(x,y,50,50);
        x+=dx;
        y+=dy;
        if( x<0 || width<x) dx*=-1;
        if( y<0 || height<y) dy*=-1;
      }
*/



/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouBuffer\u201d\u201d\u201d\u6d3b\u7528\u201d\u201d\u201d\u4f8b\u305d\u306e1\u3002\u30aa\u30d5\u30b9\u30af\u30ea\u30fc\u30f3\u30d0\u30c3\u30d5\u30a1\u30ea\u30f3\u30b0\u3068\u3044\u3046\u3084\u3064\u3002
\u3000CG\u3092blend\u3067\u6df7\u305c\u5408\u308f\u305b\u305f\u308a\u3001\u5358\u306b\u8907\u6570\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u30ec\u30f3\u30c0\u30ea\u30f3\u30b0\u3092\u7ba1\u7406\u3057\u305f\u308a\u3002

\u3000\u30dc\u30fc\u30eb\u7a0b\u5ea6\u306a\u3089\u3001blend()\u30e1\u30bd\u30c3\u30c9\u3068\u304bpixels\u52a0\u7b97\u3088\u308a\u3082\u3001draw\u306e\u4e2d\u306e\u30bd\u30fc\u30b9\u3092\u7d44\u307f\u5408\u308f\u305b\u3066\u6df7\u305c\u308b\u65b9\u304c\u697d\u304b\u3064\u5947\u9e97\u3002\u60b2\u3057\u3044\u3002
\u3000x,y\u5ea7\u6a19\u6301\u3063\u3066work()\u306e\u3042\u308b\u30dc\u30fc\u30eb\u3092\u4f5c\u308b\u304c\u5b9a\u77f3\u3060\u3068\u306f\u3001\u982d\u306e\u7247\u9685\u306b\u7f6e\u3044\u3066\u304a\u304f\u3079\u304d\u3002HanyouBuffer\u7cfb\u306f\u7d76\u5bfe\u306b\u5229\u7528\u3059\u308b\u3079\u304d\u3068\u3044\u3046\u3082\u306e\u3067\u3082\u306a\u3044(\u3082\u3057\u304f\u306fHanyouBuffer\u7cfb\u306e\u3082\u306e\u3092\u3001\u3053\u3053Controller\u306e\u3088\u3046\u306a\u3082\u306e\u3092\u4e00\u3064\u3060\u3051\u565b\u307e\u305b\u308b)

*/
class Controller extends HanyouBuffer
{
  HanyouBuffer ball;
  Controller(PApplet papp)
  {
    super(papp);
  }
  Controller(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  public void setup()
  {
    size(300,300,"P2D");//high-graphic : main-window(w,h= 500,400)
    //size(100,100,"P2D");//low-graphic //but work-cost cannot low. (smalling or bigging image is high work-cost?)
    ball=new BoundBall(papp);
  }
  
  public void draw()
  {
    pg.background(0);
    pg.blend(ball.getBuffer(NOT_WORK),0,0,ball.pg.width,ball.pg.height,        0,0,pg.width,pg.height,ADD);
  }
  
  public HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    return this;
  }
}
/*
\u3000This program is
\u3000\u3053\u306e\u30d7\u30ed\u30b0\u30e9\u30e0\u306f\u3001HanyouBuffer\u9593\u3092\u9077\u79fb\u3055\u305b\u308b\u30c8\u30e9\u30f3\u30b8\u30b7\u30e7\u30f3\u306e\u5b9f\u88c5\u4f8b\u3002
\u3000\u5404\u7a2eHanyouBuffer\u7cfb\u306f\u3001sceneWork(\u3053\u306e\u30c8\u30e9\u30f3\u30b8\u30b7\u30e7\u30f3\u3092\u8d77\u3053\u3059\u305f\u3081\u306e\u30e1\u30bd\u30c3\u30c9)\u3068\u3001\u9077\u79fb\u524d\u5f8c(\u81ea\u5206\u81ea\u8eab\u3068next)\u3092\u6301\u3064\u306e\u3067\u3001\u3084\u308a\u3084\u3059\u3044\u306f\u305a\u3002
*/
class CrossFadeEffect extends HanyouBuffer
{
  HanyouBuffer now;//next
  private final int FADE_EFFECT_TIME=70;
  private int count=0,alpha=255;
  CrossFadeEffect(HanyouBuffer now,HanyouBuffer next)
  {
    super(now,next);
    this.now=now;
    this.next=next;
  }
  public void setup()
  {
    size(300,300,"P2D");
    
    PImage buff=next.getImage(NOT_WORK);
  }
  
  public void draw()
  {
    pg.background(0);
    pg.tint(255,255,255,alpha);
    pg.image(now.getImage(NOT_WORK),0,0,pg.width,pg.height);
    pg.tint(255,255,255,255-alpha);
    pg.image(next.getImage(NOT_WORK),0,0,pg.width,pg.height);

    
    alpha-=(255/FADE_EFFECT_TIME);
  }
  
  public HanyouBuffer sceneWork()
  {
    if(alpha<120) return next;
    return this;
  }
  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "CorpsWarV2_koba" });
  }
}
