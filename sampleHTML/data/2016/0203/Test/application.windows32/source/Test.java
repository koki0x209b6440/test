import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.awt.AWTException; 
import java.awt.Robot; 
import java.awt.MouseInfo; 
import java.awt.Point; 
import java.awt.PointerInfo; 
import java.lang.Math; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Test extends PApplet {


  Player player;
  WorldData world=new NormalWorld(Config.WORLD_LENGTH_X,
                                  Config.WORLD_LENGTH_Y,
                                  Config.WORLD_LENGTH_Z);
  public void setup(){
    
    size(Config.WIN_WIDE, Config.WIN_HIGH, P3D);//\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba
    
    smooth();
    frameRate(20);
    ObjectBlock.init(this);
    
    player=new Player( Config.FIRST_X,      Config.FIRST_Y,     Config.FIRST_Z, 
                       Config.PLAYER_WIDTH, Config.PLAYER_HEIGHT, Config.PLAYER_DEPTH,   world); 
    world.setObj(player);

  }
  
  public void draw(){//width\u3068height\u306fsetup\u3067\u6307\u5b9a\u3057\u305f\u30a6\u30a4\u30f3\u30c9\u30a6\u30b5\u30a4\u30ba\u3092\u683c\u7d0d\u3057\u305f\u3082\u306e\uff1f
    background(0,102,204);
    
    player.control();
    world.draw3D(player);
    world.infoDraw(player);
  }
  
  ////////////////////////
  
  public void keyPressed(){
    KeyControl.listenKey(key,keyCode,true);
  }
  
  public void keyReleased(){
    KeyControl.listenKey(key,keyCode,false);
  }

  public void mousePressed(){
    MouseControl.listenMouseClick(mouseButton,true);
  }
  
  public void mouseReleased(){
    MouseControl.listenMouseClick(mouseButton,false);
  }
  
  public void mouseMoved(){
    MouseControl.listenMousePoint();
  }



public class ObjectBlocksDictionary{
//\u3000\u308f\u3056\u308f\u3056\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u3092\u30de\u30c3\u30d7\u306b\u5165\u308c\u308b\u7406\u7531(\u91cd\u304f\u306d\uff1f\u3068\u304b\u4ed6\u306b\u624b\u6bb5\u3042\u308b\u3060\u308d\u3001\u3068\u304b\u5bfe\u7b56):
//\u3079\u3064\u306b\u30d6\u30ed\u30c3\u30af\u30bf\u30a4\u30d7\u5165\u529b\u53d7\u3051\u53d6\u3063\u3066\u3000if(type==hoge) return new HogeObject();\u3092\u9023\u306d\u3066\u3082\u826f\u3044\u304c\u3001
//\u30af\u30ea\u30a8\u30a4\u30c6\u30a3\u30d6\u30e2\u30fc\u30c9\u6642\u306e\u30a2\u30a4\u30c6\u30e0\u4e00\u89a7\u3092\u5b9f\u73fe\u3059\u308b\u306e\u306b\u3001\u3053\u306e\u8f9e\u66f8\u304c\u3042\u308c\u3070get(n).drawAsItem\u3092for\u6587\u3067\u56de\u305b\u3070
//\u3044\u3044\u3002(\u305d\u3053\u307e\u3067\u8003\u3048\u305f\u306f\u3044\u3044\u304cdrawAsItem\u30e1\u30bd\u30c3\u30c9\u3001\u305d\u3082\u305d\u3082\u30a2\u30a4\u30c6\u30e0\u306e\u6982\u5ff5\u3059\u3089\u307e\u3060\u7121\u3044\u304c)
//\u3000\u3067\u3001\u8f9e\u66f8\u3067\u30d6\u30ed\u30c3\u30af\u30bf\u30a4\u30d7\u3092\u7d22\u5f15\u3057\u3066\u3001\u898b\u3064\u3051\u305f\u30d6\u30ed\u30c3\u30af\u306e\u30b3\u30d4\u30fc\u3092\u51fa\u529b\u3059\u308b(\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u751f\u6210\u306e\u4ee3\u7528)
//"\u306a\u3093\u3068\u306a\u304f\u4e00\u89a7\u304b\u3089\u30d6\u30ed\u30c3\u30af\u3092\u53d6\u308a\u51fa\u3059\u65b9\u304c\u305d\u308c\u3063\u307d\u3044"\u3068\u601d\u3063\u305f\u304b\u3089\u3001\u3060\u304c\u3001\u30b7\u30ea\u30a2\u30e9\u30a4\u30ba\u307e\u3067\u3084\u3063\u305f\u306e\u306f\u3084\u308a\u3059\u304e\u304b\u3002
//\u305b\u3063\u304b\u304f\u306a\u306e\u3067\u30bb\u30fc\u30d6\u30c7\u30fc\u30bf\u5165\u51fa\u529b\u3001\u7279\u306b\u5165\u529b\u306b\u5f79\u7acb\u3066\u3088\u3046\u3068\u3082\u601d\u3046\u3002
//(\u30bb\u30fc\u30d6\u30c7\u30fc\u30bf\u5165\u51fa\u529b\u3053\u305d\u30b7\u30ea\u30a2\u30e9\u30a4\u30ba\u3067\u306a\u3093\u3068\u304b\u3067\u304d\u308b\u304b\u3082\u3060\u304b\u3089\u3001\u3053\u306e\u8f9e\u66f8\u306f\u30b7\u30ea\u30a2\u30e9\u30a4\u30ba\u306e\u7df4\u7fd2\u53f0\u306b\u306a\u3063\u305f\u3068
//\u7d50\u679c\u8ad6\u3067\u8a00\u3048\u308b\u304b\u3082\uff1f)

//\u8ffd\u8a18:\u30a2\u30a4\u30c6\u30e0\u4e00\u89a7\u3060\u3051\u3067\u306a\u304f\u3001\u6240\u6301\u30a2\u30a4\u30c6\u30e0\u306e\u63cf\u753b\u3001\u3064\u307e\u308a\u30a2\u30a4\u30c6\u30e0\u3068\u3057\u3066\u306e\u5404\u30d6\u30ed\u30c3\u30af\u306e\u63cf\u753b(\u30ef\u30fc\u30eb\u30c9\u306e\u5ea7\u6a19\u306b\u5bfe\u5fdc\u3057\u306a\u3044)
//\u306f\u3053\u3053\u306e\u3092get\u3067\u4f7f\u304a\u3046\u3068\u601d\u3046\u3002(\u30a2\u30a4\u30c6\u30e0\u6b04\u672a\u5b9f\u88c5\u3060\u304c)(\u30e1\u30e2:\u6240\u6301\u54c1\u306e\u4f4d\u7f6e\u3084\u500b\u6570\u3084\u30bf\u30a4\u30d7\u306f\u3069\u3046\u51e6\u7406\u3059\u308b\u304b\u8ff7\u3046)
 private HashMap<Integer,ObjectBlock> obDic=new HashMap<Integer,ObjectBlock>();
 private ObjectBlock obj;

 ObjectBlocksDictionary(WorldData world){
   obDic.put(0,new NoObject(0,0,0) );
   obDic.put(1,new PlayerBlock(0,0,0));
   obDic.put(2,new ColorfulBox(0,0,0,255,255,255));
   obDic.put(3,new ColorfulBox(0,0,0,255,0,0));
   obDic.put(4,new ColorfulBox(0,0,0,100,100,100));
 }

 public ObjectBlock export(int x,int y,int z,   int newType){
   return obDic.get(newType).getCopy(x,y,z);
 }
 public ObjectBlock export(ObjectBlock obj,   int newType){
   return obDic.get(newType).getCopy(obj.x, obj.y, obj.z);
 }

}

/*
  Config\u30af\u30e9\u30b9
  KeyControl\u30af\u30e9\u30b9
  MouseControl\u30af\u30e9\u30b9
*/



public static class Config{
  
  ////////////3D\u7a7a\u9593\u306e\u60c5\u5831

  public static final int WIN_WIDE=1000;
  public static final int WIN_HIGH=600;

  public static final int WORLD_LENGTH_X=50;//\u30aa\u30d6\u30b8\u30a7\u304c\u3044\u304f\u3064\u4e26\u3076\u4e16\u754c\u304b
  public static final int WORLD_LENGTH_Y=20;
  public static final int WORLD_LENGTH_Z=50;
  
  public static final float OBJ_SIZE = 100; //\u8a2d\u7f6e\u30aa\u30d6\u30b8\u30a7\u4e00\u3064\u306e\u30b5\u30a4\u30ba(\u51f9\u51f8\u306e\u3042\u308b\u30c6\u30af\u30b9\u30c1\u30e3\u3067\u3082\u3001
                                           //\u5f53\u305f\u308a\u5224\u5b9a\u3068\u5b58\u5728\u4f4d\u7f6e\u306f\u9577\u65b9\u4f53\u6271\u3044)

  public static final int SEARCH_RENGE=10;
  ////////////\u30d7\u30ec\u30a4\u30e4\u30fc\u95a2\u9023(\u307b\u307c\u3001\u30d6\u30ed\u30c3\u30af\u306e\u500b\u6570\u63db\u7b97(\uff1f) )

  public static final int FIRST_X=3;//\u5ea7\u6a19\u63db\u7b97(WorldData\u306e\u5c3a\u5ea6\u306b\u304a\u3051\u308b\u5347\u76ee\u3067)
  public static final int FIRST_Y=5;
  public static final int FIRST_Z=3;
  
  public static final int PLAYER_HEIGHT=2;//\u5927\u304d\u3055\u3092\u5347\u76ee\u63db\u7b97\u3067\u3002
  public static final int PLAYER_WIDTH=1;
  public static final int PLAYER_DEPTH=1;

  public static final float PLAYER_SPEED_X=0.3f;
  public static final float GRAVITY=0.3f;
  public static final float PLAYER_SPEED_Y=0.3f+GRAVITY;
  public static final float PLAYER_SPEED_Z=0.3f;
  
  public static final int PLAYER_PLACE_RENGE=5;//\u624b\u306e\u5c4a\u304f\u7bc4\u56f2//\u307e\u3060\u4f7f\u3063\u3066\u306a\u3044\u3002
  public static final int PLAYER_VIEW_X=10;//<-\u5de6\u53f3\u7247\u5074\u3060\u3051\u306a\u306e\u3067\u3001\u5b9f\u8cea\u4e8c\u500d\u30d6\u30ed\u30c3\u30af\u5206\u8aad\u307f\u8fbc\u307f
  public static final int PLAYER_VIEW_Y=10;
  public static final int PLAYER_VIEW_Z=10;
  
  
  public static final int MOUSE_POSITION_X=500;
  public static final int MOUSE_POSITION_Y=500;
  
  public static final float CAMERA_ROTATE_SPEED_W=0.03f;
  public static final float CAMERA_ROTATE_SPEED_H=0.03f;
  public static final float CAMERA_ROTATE_DEAD_ZONE=5;//<-\u30de\u30a6\u30b9\u306e\u79fb\u52d5\u91cf\u3067\u6307\u5b9a\u3002
}



public static class KeyControl{//1\u30b2\u30fc\u30e0\u3067\u5171\u901a\u306a\u306e\u3067static\u3002//\u4e00\u30b2\u30fc\u30e0\u3067\u5171\u901a\u306a\u306e\u3067static\u3002
  public static boolean FOWARD_Pressed=false;
  public static boolean BACK_Pressed=false;
  public static boolean RIGHT_Pressed=false;
  public static boolean LEFT_Pressed=false;
  public static boolean LAND_Pressed=false;
  public static boolean FLY_Pressed=false;
  
  //\u51e6\u7406\u672c\u4f53\u306fTest\u306b\u3042\u308bkeyPressed\u30e1\u30bd\u30c3\u30c9\u7cfb
  public static void listenKey(char keyData,int keyCodeData,boolean flag){
    if(keyData=='w' || keyCodeData==UP){
      FOWARD_Pressed=flag;
    }
    if(keyData=='x' || keyCodeData==DOWN){
      BACK_Pressed=flag;
    }
    if(keyData=='a' || keyCodeData==LEFT){
      LEFT_Pressed=flag;
    }
    if(keyData=='d' || keyCodeData==RIGHT){
      RIGHT_Pressed=flag;
    }
    if(keyData=='_'){
      LAND_Pressed=flag;
    }
    if(keyCodeData==SHIFT){
      FLY_Pressed=flag;
    }
  }
}













public static class MouseControl{//1\u30b2\u30fc\u30e0\u3067\u5171\u901a\u306a\u306e\u3067static\u3002
  
  private static Robot robot;//\u30de\u30a6\u30b9\u30dd\u30a4\u30f3\u30bf\u30fc\u5236\u5fa1\u306e\u307f\u3092\u62c5\u5f53\u3002
  private static PointerInfo pi=MouseInfo.getPointerInfo();
  private static Point nowMousePoint=new Point(Config.MOUSE_POSITION_X, Config.MOUSE_POSITION_Y);
  private static int mouseMoveDir_w=0,mouseMoveDir_h=0;
  public static boolean PUT_Pressed  =false;
  public static boolean BREAK_Pressed=false;
  
  private static void init(){
    if(robot!=null)robot.mouseMove(Config.MOUSE_POSITION_X, Config.MOUSE_POSITION_Y);
  }
  
  public static void listenMousePoint(){//Test\u306eMouseMove\u30e1\u30bd\u30c3\u30c9(\u30b9\u30ec\u30c3\u30c9)\u3067\u5e38\u306b\u767a\u52d5\u3057\u305f\u306f\u308b\u3002
                                        //\u2191\u3067\u306e\u5b9f\u884c\u304c\u306a\u3044\u9650\u308a\u3001\u3053\u306e\u30af\u30e9\u30b9\u306b\u6c42\u3081\u3066\u308b\u6a5f\u80fd\u306f\u767a\u73fe\u3057\u306a\u3044\u3002
    if(robot==null){
      try {
        robot = new Robot();
      }
      catch (AWTException e) {
        e.printStackTrace();
      }
    }
    else{
      pi=MouseInfo.getPointerInfo();
      nowMousePoint=pi.getLocation();
    }
  }
  
  public static void listenMouseMoveDir(){
    float left =Config.MOUSE_POSITION_X-Config.CAMERA_ROTATE_DEAD_ZONE,
          right=Config.MOUSE_POSITION_X+Config.CAMERA_ROTATE_DEAD_ZONE,
          up   =Config.MOUSE_POSITION_Y-Config.CAMERA_ROTATE_DEAD_ZONE,
          down =Config.MOUSE_POSITION_Y+Config.CAMERA_ROTATE_DEAD_ZONE;
    
    if(left<= nowMousePoint.getX()&&nowMousePoint.getX() <=right)
      mouseMoveDir_w=  0;
    else if(nowMousePoint.getX()<left) 
      mouseMoveDir_w= -1;
    else if(right<nowMousePoint.getX())
      mouseMoveDir_w=  1;
    if(up<= nowMousePoint.getY()&&nowMousePoint.getY() <=down)
      mouseMoveDir_h=  0;
    else if(nowMousePoint.getY()<up)
      mouseMoveDir_h= 1;
    else if(down<nowMousePoint.getY()) 
      mouseMoveDir_h=  -1;
      
    init();//\u30de\u30a6\u30b9\u3092\u521d\u671f\u4f4d\u7f6e\u306b\u623b\u3059\u3002(\u3058\u3083\u306a\u3044\u3068\u30a6\u30a4\u30f3\u30c9\u30a6\u5916\u306b\u3067\u305f\u3089\u65b9\u5411\u53d6\u5f97\u304c\u52b9\u304b\u306a\u304f\u306a\u3063\u3066\u3057\u307e\u3046)

  }
  
  public static void listenMouseClick(int mouseButtonData, boolean flag){
    if(mouseButtonData==RIGHT){
      PUT_Pressed=flag;
    }else if(mouseButtonData==LEFT){
      BREAK_Pressed=flag;
    }
  }
  
  /*
  public static int getMouseX(){
    return (int)(nowMousePoint.getX() );
  }
  public static int getMouseY(){
    return (int)(nowMousePoint.getY() );
  }
  */
  public static int getMouseMoveDirW(){
    return mouseMoveDir_w;
  }
  public static int getMouseMoveDirH(){
    return mouseMoveDir_h;
  }
  
  
}

public class MoveBlock extends ObjectBlock{
  //\u5f53\u305f\u308a\u5224\u5b9a\u306e\u3042\u308b\u80f4\u4f53\u306e\u30d7\u30ec\u30a4\u30e4\u30fc\u30d6\u30ed\u30c3\u30af\u3068\u9055\u3063\u3066\u3001\u30ab\u30e1\u30e9\u3068\u79fb\u52d5\u51e6\u7406\u3001\u30a2\u30af\u30b7\u30e7\u30f3\u51e6\u7406\u306e\u584a\u3002
  //\u5185\u90e8\u30af\u30e9\u30b9\u3092\u8131\u3059\u308b\u305f\u3081\u306e\u30a8\u30e9\u30fc\u6f70\u3057\u304c\u5b8c\u4e86\u3067\u304d\u3066\u304a\u3089\u305a.java\u3092\u4ed8\u3051\u3089\u308c\u306a\u3044\u306e\u3067\u3001
  //\u8f9e\u66f8\u306b\u3001\u3053\u306e\u6d3e\u751f\u3092\u767b\u9332\u3067\u304d\u306a\u3044(\u3068\u3044\u3046\u304b\u3001\u6575\u306e\u5b9f\u88c5\u3001\u52d5\u304f\u7269\u4f53\u306e\u5b9f\u88c5\u306f\u4f55\u3082\u30a4\u30e1\u30fc\u30b8\u3092\u3064\u3051\u3066\u304a\u3089\u305a\u3001
  //\u30d7\u30ec\u30a4\u30e4\u30fc\u30af\u30e9\u30b9\u304b\u3089\u305d\u308c\u3089\u3057\u3044\u3082\u306e\u3092\u5206\u96e2\u3057\u3066\u89aa\u30af\u30e9\u30b9\u306b\u3057\u305f\u306e\u304c\u3053\u308c\u3002\u884c\u304d\u5f53\u305f\u308a\u3070\u3063\u305f\u308a)
  public float float_x,float_y,float_z;//x,y,z\u306f\u6240\u5c5e\u3059\u308b\u30de\u30b9\u3002\u3053\u3061\u3089\u306f\u66f4\u306b\u7d30\u304b\u3044\u4f4d\u7f6e\u3002
  public ObjectBlock[] prevPositionBlock;
  public int prevPositionBlockNum=0;
  public int wide,high,depth;
  Test.WorldData world;
  
  MoveBlock(int x,int y,int z,  int w,int h,int d,  Test.WorldData world){
    super(x,y,z,false);
    float_x=x;
    float_y=y;
    float_z=z;
    wide=w;
    high=h;
    depth=d;
    this.world=world;

    prevPositionBlockNum=wide*high*depth;
    prevPositionBlock=new ObjectBlock[prevPositionBlockNum];

    setBody(x,y,z);  
  }
  

  public void move_afterSimulated(float new_x,float new_y,float new_z){
    if(searchColisionAtPoint_And_BodySize(new_x,new_y,new_z)==false){
      world.translateUsedPoint(new_x,new_y,new_z);
      restoreBlockAtMyPosition();
      setBody( (int)new_x, (int)new_y, (int)new_z);
      float_x=new_x;
      float_y=new_y;
      float_z=new_z;
    }
  }
  public boolean searchColisionAtPoint_And_BodySize(float x,float y,float z){
    for(int w=0; w<wide; w++){
      for(int h=0; h<high; h++){
        for(int d=0; d<depth; d++){
          if(world.getObj( (int)(x+0.5f)+w, (int)(y+0.5f)-h, (int)(z+0.5f)+d ).isCollisionBlock==true ||
             world.getObj( (int)(x)+w, (int)(y)-h,(int)(z)+d ).isCollisionBlock==true){
            //\u4e00\u884c\u76ee\u306e\u6761\u4ef6:2\u306b\u7269\u304c\u3042\u308b\u3068\u3059\u308b\u30021\u304b\u30891.5\u306b\u79fb\u52d5\u3059\u308b\u6642\u3001\u305d\u306e\u56db\u6368\u4e94\u5165\u304c2\u306a\u306e\u3067\u305d\u308c\u4ee5\u4e0a\u8fd1\u3065\u3051\u306a\u3044\u611f\u3058\u3002
            //\u2191\u5ea7\u6a19\u5897\u52a0\u578b\u306e\u79fb\u52d5\u306e\u5834\u5408\u3002
            //\u5ea7\u6a19\u73fe\u8c61\u578b\u306e\u79fb\u52d5\u306e\u5834\u5408\u30013.5\u304b\u30892.9\u306b\u79fb\u52d5\u3057\u305f\u6642\u30012\u306e\u30b0\u30ea\u30c3\u30c9\u5185\u3060\u304c\u3001\u305d\u306e\u56db\u6368\u4e94\u5165\u304c3\u306a\u306e\u3067\u307e\u3060\u885d\u7a81\u5224\u5b9a\u306f\u8d77\u304d\u306a\u3044\u3002
            //\u2191\u305f\u3060\u3057\u30ab\u30e1\u30e9\u30ef\u30fc\u30af\u306b\u554f\u984c\u304c\u751f\u3058\u308b\u304b\u3069\u3046\u304b\u3067\u3001\u5bfe\u7b56\u3059\u308b\u304b\u6c7a\u3081\u308b(\u885d\u7a81\u3059\u308b\u30d6\u30ed\u30c3\u30af\u306b)
            return true;
          }
        }
      }
    }
    return false;
  }

  public void restoreBlockAtMyPosition(){
    for(int i=0; i<prevPositionBlockNum; i++){
      world.setObj(prevPositionBlock[i]);
    }
  }
  
  public void setBody(int x,int y,int z){
    int i=0;
    for(int w=0; w<wide; w++){
      for(int h=0; h<high; h++){
        for(int d=0; d<depth; d++){
          prevPositionBlock[i++]=world.getObj(x+w,y-h,z+d);
          world.setObj(world.obDic.export(x+w,y-h,z+d,   type) );
          //Player\u81ea\u8eab\u306e\u4f4d\u7f6e\u306e\u30ef\u30fc\u30eb\u30c9\u60c5\u5831\u3082\u3001PlayerBlock\u3067\u66f8\u304d\u63db\u3048\u308b\u3002(player\u306f\u30ab\u30e1\u30e9\u4f4d\u7f6e\u3002Test\u3067\u4fdd\u6301\u3057\u305f\u307e\u307e)
        }
      }
    }
    this.x=x;
    this.y=y;
    this.z=z;    
  }


}



/*
  Player\u30af\u30e9\u30b9
 */



public class Player extends MoveBlock {
  //\u30d6\u30ed\u30c3\u30af\u306e\u3088\u3046\u306b\u914d\u7f6e\u3059\u308b\u305f\u3081ObjectBlock\u3092\u7d99\u627f\u3001\u3057\u304b\u3057\u3059\u3050\u306b\u305d\u306e\u5730\u70b9\u306f
  //\u30d7\u30ec\u30a4\u30e4\u30fc\u30d6\u30ed\u30c3\u30af\u306b\u7f6e\u304d\u63db\u3048\u3089\u308c\u308b\u306e\u3067\u3001\u30c7\u30a3\u30fc\u30d7\u30af\u30ed\u30fc\u30f3\u5bfe\u5fdc\u306e\u610f\u5473\u3067\u306e\u7d99\u627f\u306f\u4e0d\u5fc5\u8981\u3002
  //(\u3088\u3063\u3066\u3001\u6271\u3044\u3084\u3059\u3044\u3001processing\u5185\u90e8\u30af\u30e9\u30b9\u306e\u307e\u307e\u306b\u3057\u3066\u3042\u308b)
  //(.java\u306b\u5206\u96e2\u3067\u304d\u306a\u304b\u3063\u305f\u8a00\u3044\u8a33\u3002\u3051\u3063\u3053\u3046\u3001\u305d\u306e\u540d\u6b8b\u304c\u6b8b\u3063\u3066\u3044\u308b\u3002\u30c7\u30d5\u30a9\u306esin\u3092\u4f7f\u3063\u3066\u306a\u3044\u7b49)
  private float dir_w=0, dir_h=0;//\u771f\u6b63\u9762\u3092\u5411\u3044\u3066\u3044\u308b\u306e\u3092\u57fa\u6e96\u306b\u30020~2\u3002(\u8a08\u7b97\u6642\u306fPI\u3092\u304b\u3051\u308b)
  private boolean prevPUT_Pressed=false;
  private boolean prevBREAK_Pressed=false;
  //private float center_x=0,center_y=0,center_z=0;

  public Player(int x, int y, int z, int w, int h, int d, Test.WorldData world) {
    super(x, y, z, w, h, d, world);
    pApplet.camera(0, 0, 0, 0, 0, 3*Test.Config.OBJ_SIZE, 0, -1, 0);//y\u30920\u3092\u4e0b\u5074\u306b\u3057\u3066"\u7a4d\u307f\u4e0a\u3052"\u65b9\u5f0f\u306b\u5909\u3048\u308b\u3053\u3068\u304c\u30e1\u30a4\u30f3\u76ee\u7684\u3002
    pApplet.noCursor();
    type=1;

    //world.setObj(world.obDic.export(10,1,10,  3));//\u8a66\u3057
  }

  public void control() {//\u8996\u70b9\u3092\u8003\u616e\u3057\u305f\u753b\u50cf\u51e6\u7406(\u30a6\u30a4\u30f3\u30c9\u30a6\u5185\u3067\u306e\u898b\u3048\u65b9\u306b\u5927\u304d\u304f\u5f71\u97ff)
    Test.MouseControl.listenMouseMoveDir();//getMouseMoveDir\u306eW\u3068H\u304c\u6700\u65b0\u60c5\u5831\u306b\u66f4\u65b0\u3055\u308c\u308b\u3002

    dir_h+=Test.MouseControl.getMouseMoveDirH()*Test.Config.CAMERA_ROTATE_SPEED_H;
    if (dir_h>=0.5f)dir_h=0.5f;
    if (dir_h<=-0.5f)dir_h=-0.5f;

    pApplet.camera(0, 0, 0, 
    0, 
    Test.Config.OBJ_SIZE*(float)(Math.sin(dir_h*PI) ), 
    Test.Config.OBJ_SIZE*(float)(Math.cos(dir_h*PI) ), 
    0, -1, 0);
    //y\u30920\u3092\u4e0b\u5074\u306b\u3057\u3066"\u7a4d\u307f\u4e0a\u3052"\u65b9\u5f0f\u306b\u5909\u3048\u308b\u3053\u3068\u304c\u30e1\u30a4\u30f3\u76ee\u76841\u3002
    //\u4e0a\u4e0b\u8996\u70b9\u79fb\u52d5\u306b\u3082\u5f71\u97ff\u3002\u30e1\u30a4\u30f3\u76ee\u76842\u3002

    dir_w+=Test.MouseControl.getMouseMoveDirW()*Test.Config.CAMERA_ROTATE_SPEED_W;
    if (dir_w>2)dir_w=0;
    if (dir_w<0)dir_w=2; 
    pApplet.rotateY(-dir_w*PI);
    float new_x=float_x, new_y=float_y, new_z=float_z;
    if (Test.KeyControl.FOWARD_Pressed==true) {
      new_x+=Test.Config.PLAYER_SPEED_X*(float)(Math.sin(dir_w*PI) );
      new_z+=Test.Config.PLAYER_SPEED_Z*(float)(Math.cos(dir_w*PI) );
    }
    if (Test.KeyControl.BACK_Pressed==true) {
      new_x-=Test.Config.PLAYER_SPEED_X*(float)(Math.sin(dir_w*PI) );
      new_z-=Test.Config.PLAYER_SPEED_Z*cos(dir_w*PI);
    }
    if (Test.KeyControl.RIGHT_Pressed==true) {//\u304a\u304b\u3057\u3044\u6319\u52d5
      new_x+=Test.Config.PLAYER_SPEED_X*(float)(Math.cos(dir_w*PI) );
      new_z-=Test.Config.PLAYER_SPEED_Z*(float)(Math.sin(dir_w*PI) );
    }
    if (Test.KeyControl.LEFT_Pressed==true) {//\u304a\u304b\u3057\u3044\u6319\u52d5
      new_x-=Test.Config.PLAYER_SPEED_X*(float)(Math.cos(dir_w*PI) );
      new_z+=Test.Config.PLAYER_SPEED_Z*(float)(Math.sin(dir_w*PI) );
    }
    if (Test.KeyControl.FLY_Pressed==true) {
      new_y+=Test.Config.PLAYER_SPEED_Y;
    }
    if (Test.KeyControl.LAND_Pressed==true) {
      new_y-=Test.Config.PLAYER_SPEED_Y;
    }
    move_afterSimulated(new_x, new_y, new_z);

    new_x=float_x;
    new_y=float_y;
    new_z=float_z;
    new_y-=Test.Config.GRAVITY;
    move_afterSimulated(new_x, new_y, new_z);

    blockPlace(-1);

    if (Test.MouseControl.PUT_Pressed  ==true &&
      prevPUT_Pressed!=Test.MouseControl.PUT_Pressed)     blockPlace(3);
    if (Test.MouseControl.BREAK_Pressed==true &&
      prevBREAK_Pressed!=Test.MouseControl.BREAK_Pressed) blockPlace(0);
    prevPUT_Pressed=Test.MouseControl.PUT_Pressed;
    prevBREAK_Pressed=Test.MouseControl.BREAK_Pressed;
  }

  public void move_afterSimulated(float new_x, float new_y, float new_z) {
    if (searchColisionAtPoint_And_BodySize(new_x, new_y, new_z)==false) {
      world.translateUsedPoint(new_x, new_y, new_z);//<-\u8ffd\u52a0\u3002\u3053\u308c\u7121\u3057\u3067\u3044\u3051\u308b(\u30ab\u30e1\u30e9\u30ef\u30fc\u30af\u306e\u307f)\u306a\u3089\u3001\u89aa\u30af\u30e9\u30b9\u306e\u3067\u3044\u3051\u308b\u3002
      restoreBlockAtMyPosition();
      setBody( (int)new_x, (int)new_y, (int)new_z);
      float_x=new_x;
      float_y=new_y;
      float_z=new_z;
    }
  }

  private void blockPlace(int type) {
    float ballet_x=float_x, ballet_y=float_y, ballet_z=float_z;
    float new_x=ballet_x, new_y=ballet_y, new_z=ballet_z;
    float dspeed=Config.PLAYER_PLACE_RENGE*0.1f;//\u30ec\u30f3\u30b8\u305d\u306e\u307e\u307e\u3060\u30685\u30de\u30b9\u5148\u306b\u3057\u304b\u8a2d\u7f6e\u3067\u304d\u306a\u3044\u3002
    //\u3088\u308a\u624b\u524d\u306b\u7269\u304c\u3042\u3063\u305f\u3089\u305d\u306e\u624b\u524d\u306b\u8a2d\u7f6e\u3002\u5f3e\u306e\u7740\u5f3e\u3068\u540c\u3058\u30a4\u30e1\u30fc\u30b8\u3002
    int count=0;
    while (count<10) {
      new_x+=dspeed*(float)(Math.sin(dir_w*PI) );
      new_z+=dspeed*(float)(Math.cos(dir_w*PI) );
      new_y+=dspeed*(float)(Math.sin(dir_h*PI) );


      if (world.getObj( (int)(new_x), (int)(new_y), (int)(new_z) ).isCollisionBlock==true) {
        count=0;
        if (type==-1) {
          noFill();
          stroke(0, 255, 0);
          pushMatrix();
          translate( ( (int)(ballet_x)-world.translate_x)*Config.OBJ_SIZE, 
                     ( (int)(ballet_y)-world.translate_y)*Config.OBJ_SIZE, 
                     ( (int)(ballet_z)-world.translate_z)*Config.OBJ_SIZE);
          box(Config.OBJ_SIZE);
          popMatrix();
          stroke(0, 0, 255);
          pushMatrix();
          translate( ( (int)(new_x)-world.translate_x)*Config.OBJ_SIZE, 
                     ( (int)(new_y)-world.translate_y)*Config.OBJ_SIZE, 
                     ( (int)(new_z)-world.translate_z)*Config.OBJ_SIZE);
          box(Config.OBJ_SIZE*1.1f);
          popMatrix();
          
          return;
        }
        if (type!=0)
          world.setObj(world.obDic.export((int)ballet_x, (int)ballet_y, (int)ballet_z, type) );
        else
          world.setObj(world.obDic.export( (int)new_x, (int)new_y, (int)new_z, type) );
        return;
      }

      count++;
      ballet_x=new_x;
      ballet_y=new_y;
      ballet_z=new_z;
    }
  }
}

/*
  NormalWorld\u30af\u30e9\u30b9
     WorldData\u30af\u30e9\u30b9
*/


class NormalWorld extends WorldData{
  NormalWorld(int wide,int high,int depth){
    super(wide,high,depth);

    for(int z=0; z<Config.WORLD_LENGTH_Z; z++){//\u4eee\u8a2d\u7f6e(\u5730\u9762)
      for(int x=0; x<Config.WORLD_LENGTH_X; x++){
        int a=Config.WORLD_LENGTH_Y-1;
        setObj(obDic.export(x,0,z,  2) );//\u5929\u4e95
        //setObj(x,a,z,   new ColorfulBox(x,a,z,255,255,255) );//\u5730\u9762
      }
    }
    for(int z=(int)(Config.WORLD_LENGTH_Z*0.3f); z<(int)(Config.WORLD_LENGTH_Z*0.7f); z++){
      for(int x=(int)(Config.WORLD_LENGTH_X*0.3f); x<(int)(Config.WORLD_LENGTH_X*0.7f); x++){
        //0.3\u30010.7\u306f\u300c\u5e8a\u306e\u5e83\u3055\u306f\u3001\u4e16\u754c\u4e38\u3005\u3088\u308a\u5c11\u3057\u3061\u3044\u3055\u3081\u300d\u306e\u610f\u3002\u3053\u306e\u5834\u6240\u306f\u5e8a\u4eee\u8a2d\u7f6e\u306a\u306e\u3067\u3001
        setObj(obDic.export(x,5,z,  4) );//\u7a7a\u4e2d\u5e8a
      }
    }
    setObj(obDic.export(10,2,10,  3) );//\u969c\u5bb3\u7269\u8d64
    setObj(obDic.export(10,1,10,  3) );

    
    setObj(obDic.export(10,1,10,  4));
  }
  
}








public class WorldData{//\u3053\u306e\u30af\u30e9\u30b9\u306f\u89aa\u30af\u30e9\u30b9\u3068\u3057\u3066\u4f7f\u7528\u3002
 
 private ObjectBlock[][][] data;
 private float translate_x=0,translate_y=0,translate_z=0;
 private int wide,high,depth;//\u7bb1\u306e\u6570\u3001\u306a\u306e\u3067\u6271\u3044\u65b9\u306b\u6ce8\u610f\u3002
 ObjectBlocksDictionary obDic=new ObjectBlocksDictionary(this);

 public WorldData(int wide,int high,int depth){
    this.wide=wide;
    this.high=high;
    this.depth=depth;
    
    data=new ObjectBlock[wide][][];
    for(int x=0; x<wide; x++){
      data[x]=new ObjectBlock[high][];
    }
    for(int x=0; x<wide; x++){
      for(int y=0; y<high; y++){
      data[x][y]=new ObjectBlock[depth];
      }
    }
    
    for(int z=0; z<depth; z++){
     for(int y=0; y<high; y++){
      for(int x=0; x<wide; x++){
         data[x][y][z]=new NoObject(x,y,z);
      }
     }
    }

 }
 
 public void draw3D(){
  for(int z=0; z<depth; z++){
    for(int y=0; y<high; y++){
      for(int x=0; x<wide; x++){
        data[x][y][z].draw3DObj(translate_x,translate_y,translate_z);
      }
    }
  }

 }
 public void draw3D(Player player){
  for(int z=player.z-Config.PLAYER_VIEW_Z; z<player.z+Config.PLAYER_VIEW_Z; z++){
    for(int y=player.y-Config.PLAYER_VIEW_Y; y<player.y+Config.PLAYER_VIEW_Y; y++){
      for(int x=player.x-Config.PLAYER_VIEW_X; x<player.x+Config.PLAYER_VIEW_X; x++){
        if(z<0 || y<0 || x<0)continue;
        if(z>=depth || y>=high || x>=wide)continue;
        data[x][y][z].draw3DObj(translate_x,translate_y,translate_z);
      }
    }
  }

 }
 
 public void setObj(ObjectBlock obj){
   data[obj.x][obj.y][obj.z]=obj;
 }
 public ObjectBlock getObj(int x,int y,int z){
   if(x<0 || wide<=x ||     y<0 || high<=y ||    z<0 || depth<=z){
        return data[0][0][0];//\u307e\u3060\u3053\u3053\u306e\u914d\u5217\u30a8\u30e9\u30fc\u306b\u6b63\u3057\u3044\u5bfe\u7b56\u3067\u304d\u3066\u306a\u3044\u3002
      }
   return data[x][y][z];
 }
 public void translateUsedPoint(float x,float y,float z){
   //\u30e1\u30bd\u30c3\u30c9\u540d\u306ePoint\u306fPoint\u578b\u306e\u3053\u3068\u3067\u306f\u306a\u304f\u3001\u79fb\u52d5\u91cf\u3067\u306f\u306a\u304f\u5ea7\u6a19\u3067\u3001\u3068\u3044\u3046\u3053\u3068\u3002
   //player.player_\u307b\u306b\u3083\u3089\u3089 \u306f
   /*
   translate(x-player.player_x,
             y-player.player_y,
             z-player.player_z);
   */
   translate_x=x;
   translate_y=y;
   translate_z=z;
 }
 
 
 public void infoDraw(Player player){
    //\u30ab\u30e1\u30e9\u52d5\u4f5c\u306a\u3069\u306e\u8981\u7d20\u3092\u8003\u616e\u3057\u3066\u3082\u3001\u30a6\u30a4\u30f3\u30c9\u30a6\u306e\u3069\u3053\u3069\u3053\u306b\u56fa\u5b9a\u3057\u3066\u8868\u793a\u3059\u308b\u3002
    //line\u4e8c\u884c\u306e\u3068\u3053\u4ee5\u5916\u306f\u5168\u90e8\u5fc5\u9808(?)
    camera();
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    stroke(0,0,0);
    fill(0,0,0,255);
    strokeWeight(3);
    cursorDraw(width/2, height/2, 10);
    
    FPSDraw( 0, 15,    16);//\u5c11\u3057\u5de6\u4e0a(0,0)\u304b\u3089\u4e0b\u306b\u305a\u3089\u3059\u3002
    PositionDraw( 0, ((height/100)*10),    16,player);
    /*
    itemBarDraw( ((width/100)*5 ), ((height/100)*80), 
                 ((width/100)*90), ((height/100)*10) );//\u30a2\u30a4\u30c6\u30e0\u6b04\u306e\u4f4d\u7f6e
                                                       //\u30c1\u30e3\u30c3\u30c8\u30ed\u30b0\u304b\u3082
    */
    draw2D( ((width/100)*80), ((height/100)*30),  
            ((width/100)*19),-((height/100)*29) );//\u30de\u30c3\u30d7\u306e\u4f4d\u7f6e
                                                  //\u7e26\u5e45\u6307\u5b9a\u3092\u8ca0\u5024\u306b\u3057\u3066
                                                  //"\u7121\u7406\u3084\u308a\u5de6\u4e0b\u3092\u57fa\u6e96\u70b9\u3068\u3057\u3066\u9577\u65b9\u5f62\u3092\u63cf\u753b"
                                                  //\u306b\u3057\u3066\u3044\u308b(data[0][0]\u306f\u5de6\u4e0b\u3060\u304b\u3089)
                                                  
    strokeWeight(1);//\u521d\u671f\u5024\u306b\u623b\u3059(1\u3067\u5408\u3063\u3066\u308b\u304b\u8981\u78ba\u8a8d)
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
 }
 private void cursorDraw(float x,float y,float l){
   line(x-l,  y,x+l,  y);
   line(  x,y-l,  x,y+l);
 }
 private void FPSDraw(float x,float y,float size){
   //rect( (-width/2)*power, (-height/2)*power,5,5);//FPS\u5024\u8868\u793a\u4f4d\u7f6e
   //rect(x,y,5,5);
   textSize(size);
   text("FPS:"+(int)(frameRate),x,y);
 }
 private void PositionDraw(float x,float y,float size,Player player){
   textSize(size);
   text( "Position:("+(int)player.float_x+" , "+(int)player.float_y+" , "+(int)player.float_z+")",
        x,y);
 }
 private void itemBarDraw(float x,float y,float wide,float high){
   //rect( (-width/4)*power, (height/3)*power, (width/2)*power, (height/10)*power );//\u30a2\u30a4\u30c6\u30e0\u6b04\u306e\u4f4d\u7f6e
   rect(x,y,wide,high);
 }
 private void draw2D(float x,float y,float wide,float high){
   //rect( (width/4)*power,(-height/2)*power,  (width/4)*power,(height/4)*power);//\u30de\u30c3\u30d7\u306e\u4f4d\u7f6e
   strokeWeight(1);
   rect(x,y,wide,high);
   strokeWeight(0);
   float obj_w=(float)(wide/this.wide);
   float obj_h=(float)(high/this.depth);
   
   for(int w=0; w<this.wide; w++){
     for(int d=0; d<this.depth; d++){
       for(int h=0; h<this.high; h++){
         if( data[w][h][d].draw2DObj( x+w*obj_w, (y+ d*obj_h),
                                      obj_w, obj_h)==true){
           break;
         }
         
       }
     }
   }
   fill(255,0,0,90);
   rect(x + (player.x*obj_w) - (Config.PLAYER_VIEW_X*obj_w),
        y + (player.z*obj_h) - (Config.PLAYER_VIEW_Z*obj_h),
        (Config.PLAYER_VIEW_X*obj_w)*2,
        (Config.PLAYER_VIEW_Z*obj_h)*2                       );
   
 }
 
 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
