/*
　This program is
　このプログラムは、玄関投影プロジェクションマッピングの範囲をdata/positionほにゃらら.txtから取得するプログラム。
*/
/*
このタブの追加で、以下のsetup(); draw();への追加(変数も)で、玄関投影用に適化できる。

//外
DrawSettingData CENTER_FLOOR,RIGHT_WALL,LEFT_WALL;
ProjImage centerimg,leftimg,rightimg;

void setup()
{
     
     //textureMode(NORMALIZED);
  //CENTER_FLOOR = new DrawSettingData("positions1.txt","CENTER_FLOOR");
  //RIGHT_WALL     = new DrawSettingData("positions2.txt","RIGHT_WALL");
  //LEFT_WALL        = new DrawSettingData("positions3.txt","LEFT_WALL");

  //centerimg=new ProjImage(CENTER_FLOOR);
  //leftimg=new ProjImage(LEFT_WALL);
  //rightimg=new ProjImage(RIGHT_WALL);
}

void draw()
{
     //centerimg.renderANDworkANDimg_update(scene.getScene().getImage()  );
}

*/


class DrawSettingData
{
 int pos[][]={{0,0},{screen.width/2,0},{screen.width/2,screen.height/2},{0,screen.height/2}}; 
 float texpos[][]={{0,0},{screen.width/2,0},{screen.width/2,screen.height/2},{0,screen.height/2}};
 String[] loadPositions = new String[8];
 
 DrawSettingData(String importname,String name)
 {
   loadPositions = loadStrings(importname);
   int h = 0;
   for(int i = 0; i < 4; i++) {
     for(int j = 0; j < 2; j++) {
         pos[i][j] = int(loadPositions[h]);
         h++;
     }
   }
   
   if(name.equals("CENTER_FLOOR") )
   {
     texpos[0][0]=0.0;    texpos[0][1]=0.0;
     texpos[1][0]=1.0;    texpos[1][1]=0.0;
     texpos[2][0]=1.0;    texpos[2][1]=1.0;
     texpos[3][0]=0.0;    texpos[3][1]=1.0;
   }
   if(name.equals("LEFT_WALL") )
   {
     texpos[0][0]=0.2;    texpos[0][1]=0.0;
     texpos[1][0]=1.0;    texpos[1][1]=0.0;
     texpos[2][0]=0.5;    texpos[2][1]=1.0;
     texpos[3][0]=0.0;    texpos[3][1]=1.0;
   }
   if(name.equals("RIGHT_WALL") )
   {
     texpos[0][0]=0.0;    texpos[0][1]=0.0;
     texpos[1][0]=0.85;  texpos[1][1]=0.0;
     texpos[2][0]=1.0;    texpos[2][1]=1.0;
     texpos[3][0]=0.5;    texpos[3][1]=1.0;
   }
   if(name.equals("NORMAL") )
   {
     texpos[0][0]=0.0;    texpos[0][1]=0.0;
     texpos[1][0]=1.0;    texpos[1][1]=0.0;
     texpos[2][0]=1.0;    texpos[2][1]=1.0;
     texpos[3][0]=0.0;    texpos[3][1]=1.0;
   }
 }
}









class ProjImage
{
  int   selected = -1;  // 選択されている頂点
  PImage buff;
  DrawSettingData setting;
  ProjImage(DrawSettingData setting)
  {
    PGraphics buffpg=createGraphics(200,200,P2D);
    buffpg.beginDraw();
    buffpg.loadPixels();
    buffpg.background(255,0,0,255);
    buffpg.updatePixels();
    buffpg.endDraw();
    buff=buffpg.get();
    
    this.setting=setting;
  }
  
  
  void renderANDworkANDimg_update(PImage buff)
  {
    setImage(buff);
    renderANDwork();
  }
  void renderANDwork()
  {
    render();
    work();
  }
  void setImage(PImage buff)
  {
    this.buff=buff;
  }
  void render()
  {
    // テクスチャの描画
    beginShape();
      texture(buff);  
      vertex(setting.pos[0][0], setting.pos[0][1],     setting.texpos[0][0],setting.texpos[0][1]);
      vertex(setting.pos[1][0], setting.pos[1][1],     setting.texpos[1][0],setting.texpos[1][1]);
      vertex(setting.pos[2][0], setting.pos[2][1],     setting.texpos[2][0],setting.texpos[2][1]);
      vertex(setting.pos[3][0], setting.pos[3][1],     setting.texpos[3][0],setting.texpos[3][1]);
    endShape(CLOSE);
  }
  void work()
  {
      // マウスによる頂点操作
    if ( mousePressed && selected >= 0 ) {
      setting.pos[selected][0] = mouseX;
      setting.pos[selected][1] = mouseY;
    }
    else {
      float min_d=20;// この値が頂点への吸着の度合いを決める
      selected = -1;
      for (int i=0; i<4; i++) {
        float d = dist( mouseX, mouseY, setting.pos[i][0], setting.pos[i][1] );
        if ( d < min_d ) {
          min_d = d;
          selected = i;
        }      
      }
    }
    if ( selected >= 0 ) {
      fill(255);
      ellipse( mouseX, mouseY, 20, 20 );
    }
  }
  
}
