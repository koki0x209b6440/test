class GrassObject
{
  PGraphics pg;
  PVector position;//xyz
  color c;
  float flop; //風が無い時のだらーん。(初期値的な。草毎にランダムに)
  PVector v, //草の動き・角度に関するベクトル。(だらーんの向き)
                     //(演算部では、flopと風を考慮して、だらーんの向きを逐一変化させ、"草の揺らぎ"を演出する)
             windVector,windDirection;

  final float GRASS_OBJECT_START_WIDTH = 30;
  final int GRASS_OBJECT_PARTS_NUM = 15;//草の揺らぎを実現するために、草はパーツ毎に分かれているイメージ。
  final PVector GRAVITY = new PVector(0,-0.98,0);
  final float DW=GRASS_OBJECT_START_WIDTH /GRASS_OBJECT_PARTS_NUM;

  GrassObject(PGraphics pg,float x,float y,float z,     PVector windVector,PVector windDirection)
  {
    this.pg=pg;
    position=new PVector(x,y,z);
    c=color(random(0,40),random(200,255),random(0,50));//緑(深緑)〜黄緑
    flop=random(0,20);
    this.windVector=windVector;
    this.windDirection=windDirection;

    float fVelocitySpread  = 5;
    float fVX=(random(10)-5) * fVelocitySpread;
    float fVZ=(random(10)-5) * fVelocitySpread;    
    v=new PVector(fVX,1.0,fVZ);
    v.normalize();
    v.mult(random(8,13));
  }
  

  PVector vEnd = new PVector();
  PVector vVel = new PVector();
  PVector vTangent = new PVector();
  PVector vAddMe = new PVector();
  float GrassWidth;
  /*    草のイメージ  
               ___          GrassWidth-dw-dw-dw
              /   /
            _/   /_         GrassWidth-dw-dw
           /       /
        _/       /_        GrassWidth-dw
      /            /
     /________/          GrassWidth(草の根もと)
       　    この例だと,
　           台形が三つを連続で描くように、vertexで四点(・)を指定していく。
                              ___  
                            ・   ・ 
                           /     /
                        _/      /_
                      ・          ・ 
                     /            /
                  _/             /_ 
                ・                ・
               /                  /
              /                  /
             ・__________・ 
           　その四点の座標に、風等の影響を加えて応用する。
           
　           この考えを三次元に拡張する。(風の影響等による点決めががベクトルのadd、mult、crossで行うことになる)
  */
  void effect()
  {
    vEnd.set(position); 
    vVel.set(v);
    vTangent = vVel.cross(new PVector(0,10,0));
    vTangent.normalize();
    vAddMe.set(vTangent);
    GrassWidth = GRASS_OBJECT_START_WIDTH;
    vAddMe.mult(GrassWidth);
    for(int i=0; i<GRASS_OBJECT_PARTS_NUM; i++)
    {
      if(i<=-1)//草の一部分だけ色かえ
      {
        pg.stroke(255,0,0);
        pg.fill(255,0,0);
      }
      else
      {
        pg.stroke(c);
        pg.fill(c);
      }
      pg.beginShape(QUADS);
      render1();//草の根もと(に近い方)
      work();
      render2();//workによって、草の葉先(に近い方)
      pg.endShape();
    }
  }
  void work()
  {
    vEnd.add(vVel);
    vVel.add(GRAVITY);
    vVel.x += windVector.x * flop;
    vVel.y += windVector.y * flop;
    vVel.z += windVector.z * flop;   
    GrassWidth-=DW;//草の形状(根元ほど太く、先っちょほど細い)
    vAddMe.set(vTangent);
    vAddMe.mult(GrassWidth);
  }
  void render1()
  {
    pg.vertex(vEnd.x + vAddMe.x,vEnd.y + vAddMe.y,vEnd.z + vAddMe.z);
    pg.vertex(vEnd.x - vAddMe.x,vEnd.y - vAddMe.y,vEnd.z - vAddMe.z);
  }
  void render2()
  {
    pg.vertex(vEnd.x - vAddMe.x,vEnd.y - vAddMe.y,vEnd.z - vAddMe.z);
    pg.vertex(vEnd.x + vAddMe.x,vEnd.y + vAddMe.y,vEnd.z + vAddMe.z);
  }

}
