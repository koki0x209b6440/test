/*
  Playerクラス
 */

import java.lang.Math;

public class Player extends MoveBlock {
  //ブロックのように配置するためObjectBlockを継承、しかしすぐにその地点は
  //プレイヤーブロックに置き換えられるので、ディープクローン対応の意味での継承は不必要。
  //(よって、扱いやすい、processing内部クラスのままにしてある)
  //(.javaに分離できなかった言い訳。けっこう、その名残が残っている。デフォのsinを使ってない等)
  private float dir_w=0, dir_h=0;//真正面を向いているのを基準に。0~2。(計算時はPIをかける)
  private boolean prevPUT_Pressed=false;
  private boolean prevBREAK_Pressed=false;
  //private float center_x=0,center_y=0,center_z=0;

  public Player(int x, int y, int z, int w, int h, int d, Test.WorldData world) {
    super(x, y, z, w, h, d, world);
    pApplet.camera(0, 0, 0, 0, 0, 3*Test.Config.OBJ_SIZE, 0, -1, 0);//yを0を下側にして"積み上げ"方式に変えることがメイン目的。
    pApplet.noCursor();
    type=1;

    //world.setObj(world.obDic.export(10,1,10,  3));//試し
  }

  public void control() {//視点を考慮した画像処理(ウインドウ内での見え方に大きく影響)
    Test.MouseControl.listenMouseMoveDir();//getMouseMoveDirのWとHが最新情報に更新される。

    dir_h+=Test.MouseControl.getMouseMoveDirH()*Test.Config.CAMERA_ROTATE_SPEED_H;
    if (dir_h>=0.5)dir_h=0.5;
    if (dir_h<=-0.5)dir_h=-0.5;

    pApplet.camera(0, 0, 0, 
                   0, 
                   Test.Config.OBJ_SIZE*(float)(Math.sin(dir_h*PI) ), 
                   Test.Config.OBJ_SIZE*(float)(Math.cos(dir_h*PI) ), 
                   0, -1, 0);
    //yを0を下側にして"積み上げ"方式に変えることがメイン目的1。
    //上下視点移動にも影響。メイン目的2。

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
    if (Test.KeyControl.RIGHT_Pressed==true) {//おかしい挙動
      new_x+=Test.Config.PLAYER_SPEED_X*(float)(Math.cos(dir_w*PI) );
      new_z-=Test.Config.PLAYER_SPEED_Z*(float)(Math.sin(dir_w*PI) );
    }
    if (Test.KeyControl.LEFT_Pressed==true) {//おかしい挙動
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

  void move_afterSimulated(float new_x, float new_y, float new_z) {
    if (searchColisionAtPoint_And_BodySize(new_x, new_y, new_z)==false) {
      world.translateUsedPoint(new_x, new_y, new_z);//<-追加。これ無しでいける(カメラワークのみ)なら、親クラスのでいける。
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
    float dspeed=Config.PLAYER_PLACE_RENGE*0.1;//レンジそのままだと5マス先にしか設置できない。
    //より手前に物があったらその手前に設置。弾の着弾と同じイメージ。
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
          strokeWeight(5);
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
          box(Config.OBJ_SIZE*1.1);
          popMatrix();
          strokeWeight(1);
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

