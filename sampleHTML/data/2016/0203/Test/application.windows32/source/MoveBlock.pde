
public class MoveBlock extends ObjectBlock{
  //当たり判定のある胴体のプレイヤーブロックと違って、カメラと移動処理、アクション処理の塊。
  //内部クラスを脱するためのエラー潰しが完了できておらず.javaを付けられないので、
  //辞書に、この派生を登録できない(というか、敵の実装、動く物体の実装は何もイメージをつけておらず、
  //プレイヤークラスからそれらしいものを分離して親クラスにしたのがこれ。行き当たりばったり)
  public float float_x,float_y,float_z;//x,y,zは所属するマス。こちらは更に細かい位置。
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
  

  void move_afterSimulated(float new_x,float new_y,float new_z){
    if(searchColisionAtPoint_And_BodySize(new_x,new_y,new_z)==false){
      world.translateUsedPoint(new_x,new_y,new_z);
      restoreBlockAtMyPosition();
      setBody( (int)new_x, (int)new_y, (int)new_z);
      float_x=new_x;
      float_y=new_y;
      float_z=new_z;
    }
  }
  boolean searchColisionAtPoint_And_BodySize(float x,float y,float z){
    for(int w=0; w<wide; w++){
      for(int h=0; h<high; h++){
        for(int d=0; d<depth; d++){
          if(world.getObj( (int)(x+0.5)+w, (int)(y+0.5)-h, (int)(z+0.5)+d ).isCollisionBlock==true ||
             world.getObj( (int)(x)+w, (int)(y)-h,(int)(z)+d ).isCollisionBlock==true){
            //一行目の条件:2に物があるとする。1から1.5に移動する時、その四捨五入が2なのでそれ以上近づけない感じ。
            //↑座標増加型の移動の場合。
            //座標現象型の移動の場合、3.5から2.9に移動した時、2のグリッド内だが、その四捨五入が3なのでまだ衝突判定は起きない。
            //↑ただしカメラワークに問題が生じるかどうかで、対策するか決める(衝突するブロックに)
            return true;
          }
        }
      }
    }
    return false;
  }

  void restoreBlockAtMyPosition(){
    for(int i=0; i<prevPositionBlockNum; i++){
      world.setObj(prevPositionBlock[i]);
    }
  }
  
  void setBody(int x,int y,int z){
    int i=0;
    for(int w=0; w<wide; w++){
      for(int h=0; h<high; h++){
        for(int d=0; d<depth; d++){
          prevPositionBlock[i++]=world.getObj(x+w,y-h,z+d);
          world.setObj(world.obDic.export(x+w,y-h,z+d,   type) );
          //Player自身の位置のワールド情報も、PlayerBlockで書き換える。(playerはカメラ位置。Testで保持したまま)
        }
      }
    }
    this.x=x;
    this.y=y;
    this.z=z;    
  }


}



