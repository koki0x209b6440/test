
import processing.core.PApplet;
import java.io.Serializable;

public class ObjectBlock implements Serializable{
  
  int x,y,z;
  int type=0;
  boolean isCollisionBlock;//衝突する"ブロックである"かどうか。現在の衝突状態ではない。
  static PApplet pApplet;
  public ObjectBlock(int x,int y,int z,boolean flag){
    this.x=x;
    this.y=y;
    this.z=z;
    isCollisionBlock=flag;
  }
  public static void init(PApplet main){
    pApplet=main;
  }
  
  public void draw3DObj(float x,float y,float z){
    
  }
  public boolean draw2DObj(float x,float y,float w,float h){
    return false;//プレイヤーはエネミーはオーバーライド時にここをtrueで返すようにする。
                 //横x,縦zの2Dマップを描画するのに使うメソッド、
                 //プレイヤーがy=2にいて青色でも、y=3以上にブロックがあればその色に塗り替えられてしまう。
                 //それを、trueを返すことで「この高さで色塗り終わり」とする。(WorldDataのdraw2Dメソッド)
  }
  public int getObjectType(){
    return type; 
  }
  public ObjectBlock getCopy(int x,int y,int z){
    ObjectBlock buff=(ObjectBlock)(Utility.deepClone(this) );
    buff.x=x;//座標更新
    buff.y=y;
    buff.z=z;
    return buff;
  }
}




class NoObject extends ObjectBlock{//空気ブロックの立ち位置
  
   public NoObject(int x,int y,int z){
     super(x,y,z,false);
   }
    
}

class ColorfulBox extends ObjectBlock{
   private int r,g,b;
    
   public ColorfulBox(int x,int y,int z,   int r,int g,int b){
     super(x,y,z,true);
     this.r=r;
     this.g=g;
     this.b=b;
   }
    
   public void draw3DObj(float x,float y,float z){
     pApplet.stroke(0);//不透過(のはず)
     pApplet.fill(r,g,b); //OBJの色  
     pApplet.pushMatrix();
     pApplet.translate((this.x-x)*Test.Config.OBJ_SIZE,
                       (this.y-y)*Test.Config.OBJ_SIZE, 
                       (this.z-z)*Test.Config.OBJ_SIZE);
     pApplet.box(Test.Config.OBJ_SIZE);
     pApplet.popMatrix();
   }
   public boolean draw2DObj(float x,float y,float w,float h){
     pApplet.fill(r,g,b); //OBJの色
     pApplet.rect(x,y,w,h);
     return false;
   }
    
}
/*=======================================================================*/
/*=======================================================================*/
/*=======================================================================*/
/*=======================================================================*/
/*=======================================================================*/

class PlayerBlock extends ObjectBlock{
    
   public PlayerBlock(int x,int y,int z){
     super(x,y,z,false);
   }
   
   public boolean draw2DObj(float x,float y,float w,float h){
     pApplet.fill(0,0,255); //OBJの色
     pApplet.rect(x,y,w,h);
     return true;
   }
    
}
