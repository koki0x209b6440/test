/*
  NormalWorldクラス
     WorldDataクラス
*/


class NormalWorld extends WorldData{
  NormalWorld(int wide,int high,int depth){
    super(wide,high,depth);

    for(int z=0; z<Config.WORLD_LENGTH_Z; z++){//仮設置(地面)
      for(int x=0; x<Config.WORLD_LENGTH_X; x++){
        int a=Config.WORLD_LENGTH_Y-1;
        setObj(obDic.export(x,0,z,  2) );//天井
        //setObj(x,a,z,   new ColorfulBox(x,a,z,255,255,255) );//地面
      }
    }
    for(int z=(int)(Config.WORLD_LENGTH_Z*0.3); z<(int)(Config.WORLD_LENGTH_Z*0.7); z++){
      for(int x=(int)(Config.WORLD_LENGTH_X*0.3); x<(int)(Config.WORLD_LENGTH_X*0.7); x++){
        //0.3、0.7は「床の広さは、世界丸々より少しちいさめ」の意。この場所は床仮設置なので、
        setObj(obDic.export(x,5,z,  4) );//空中床
      }
    }
    setObj(obDic.export(10,2,10,  3) );//障害物赤
    setObj(obDic.export(10,1,10,  3) );

    
    setObj(obDic.export(10,1,10,  4));
  }
  
}








public class WorldData{//このクラスは親クラスとして使用。
 
 private ObjectBlock[][][] data;
 private float translate_x=0,translate_y=0,translate_z=0;
 private int wide,high,depth;//箱の数、なので扱い方に注意。
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
        return data[0][0][0];//まだここの配列エラーに正しい対策できてない。
      }
   return data[x][y][z];
 }
 public void translateUsedPoint(float x,float y,float z){
   //メソッド名のPointはPoint型のことではなく、移動量ではなく座標で、ということ。
   //player.player_ほにゃらら は
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
    //カメラ動作などの要素を考慮しても、ウインドウのどこどこに固定して表示する。
    //line二行のとこ以外は全部必須(?)
    camera();
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    stroke(0,0,0);
    fill(0,0,0,255);
    strokeWeight(3);
    cursorDraw(width/2, height/2, 10);
    
    FPSDraw( 0, 15,    16);//少し左上(0,0)から下にずらす。
    PositionDraw( 0, ((height/100)*10),    16,player);
    /*
    itemBarDraw( ((width/100)*5 ), ((height/100)*80), 
                 ((width/100)*90), ((height/100)*10) );//アイテム欄の位置
                                                       //チャットログかも
    */
    draw2D( ((width/100)*80), ((height/100)*30),  
            ((width/100)*19),-((height/100)*29) );//マップの位置
                                                  //縦幅指定を負値にして
                                                  //"無理やり左下を基準点として長方形を描画"
                                                  //にしている(data[0][0]は左下だから)
                                                  
    strokeWeight(1);//初期値に戻す(1で合ってるか要確認)
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
 }
 private void cursorDraw(float x,float y,float l){
   line(x-l,  y,x+l,  y);
   line(  x,y-l,  x,y+l);
 }
 private void FPSDraw(float x,float y,float size){
   //rect( (-width/2)*power, (-height/2)*power,5,5);//FPS値表示位置
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
   //rect( (-width/4)*power, (height/3)*power, (width/2)*power, (height/10)*power );//アイテム欄の位置
   rect(x,y,wide,high);
 }
 private void draw2D(float x,float y,float wide,float high){
   //rect( (width/4)*power,(-height/2)*power,  (width/4)*power,(height/4)*power);//マップの位置
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
