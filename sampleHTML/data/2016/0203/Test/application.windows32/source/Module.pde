
/*
  Configクラス
  KeyControlクラス
  MouseControlクラス
*/



public static class Config{
  
  ////////////3D空間の情報

  public static final int WIN_WIDE=1000;
  public static final int WIN_HIGH=600;

  public static final int WORLD_LENGTH_X=50;//オブジェがいくつ並ぶ世界か
  public static final int WORLD_LENGTH_Y=20;
  public static final int WORLD_LENGTH_Z=50;
  
  public static final float OBJ_SIZE = 100; //設置オブジェ一つのサイズ(凹凸のあるテクスチャでも、
                                           //当たり判定と存在位置は長方体扱い)

  public static final int SEARCH_RENGE=10;
  ////////////プレイヤー関連(ほぼ、ブロックの個数換算(？) )

  public static final int FIRST_X=3;//座標換算(WorldDataの尺度における升目で)
  public static final int FIRST_Y=5;
  public static final int FIRST_Z=3;
  
  public static final int PLAYER_HEIGHT=2;//大きさを升目換算で。
  public static final int PLAYER_WIDTH=1;
  public static final int PLAYER_DEPTH=1;

  public static final float PLAYER_SPEED_X=0.3;
  public static final float GRAVITY=0.3;
  public static final float PLAYER_SPEED_Y=0.3+GRAVITY;
  public static final float PLAYER_SPEED_Z=0.3;
  
  public static final int PLAYER_PLACE_RENGE=5;//手の届く範囲//まだ使ってない。
  public static final int PLAYER_VIEW_X=10;//<-左右片側だけなので、実質二倍ブロック分読み込み
  public static final int PLAYER_VIEW_Y=10;
  public static final int PLAYER_VIEW_Z=10;
  
  
  public static final int MOUSE_POSITION_X=500;
  public static final int MOUSE_POSITION_Y=500;
  
  public static final float CAMERA_ROTATE_SPEED_W=0.03;
  public static final float CAMERA_ROTATE_SPEED_H=0.03;
  public static final float CAMERA_ROTATE_DEAD_ZONE=5;//<-マウスの移動量で指定。
}



public static class KeyControl{//1ゲームで共通なのでstatic。//一ゲームで共通なのでstatic。
  public static boolean FOWARD_Pressed=false;
  public static boolean BACK_Pressed=false;
  public static boolean RIGHT_Pressed=false;
  public static boolean LEFT_Pressed=false;
  public static boolean LAND_Pressed=false;
  public static boolean FLY_Pressed=false;
  
  //処理本体はTestにあるkeyPressedメソッド系
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






import java.awt.AWTException;
import java.awt.Robot;

import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.PointerInfo;

public static class MouseControl{//1ゲームで共通なのでstatic。
  
  private static Robot robot;//マウスポインター制御のみを担当。
  private static PointerInfo pi=MouseInfo.getPointerInfo();
  private static Point nowMousePoint=new Point(Config.MOUSE_POSITION_X, Config.MOUSE_POSITION_Y);
  private static int mouseMoveDir_w=0,mouseMoveDir_h=0;
  public static boolean PUT_Pressed  =false;
  public static boolean BREAK_Pressed=false;
  
  private static void init(){
    if(robot!=null)robot.mouseMove(Config.MOUSE_POSITION_X, Config.MOUSE_POSITION_Y);
  }
  
  public static void listenMousePoint(){//TestのMouseMoveメソッド(スレッド)で常に発動したはる。
                                        //↑での実行がない限り、このクラスに求めてる機能は発現しない。
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
      
    init();//マウスを初期位置に戻す。(じゃないとウインドウ外にでたら方向取得が効かなくなってしまう)

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
