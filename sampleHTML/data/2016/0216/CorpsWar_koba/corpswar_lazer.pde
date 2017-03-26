
/*
[http://nameniku.blog71.fc2.com/blog-entry-635.html]
*/

class Beam extends Lazer
{
  Beam(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=2;
    w=20;
    h=20;
    life=100;
    isColisionDebug=false;
    isCannotPene=true;
    damage=30;
  }
  void move()
  {
    super.move();
    w-=10;
  }
}

class Lazer extends RectBullet
{
  boolean isColisionDebug=false;//斜めレーザとunit点xyの当たり判定//0,0を基準にしてレーザ真横変換、unit点変換したものを表示
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
  boolean collision()
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
        if(0<=rx&&rx<=w*0.8)
        { if(0<=ry&&ry<=h*0.8)
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
            return isCannotPene;//ここfalseで貫通
    } } } }
    return false;
  }
  void move()
  {
    super.move();
    w+=10;
  }
    void modeling()
  {
    float radians = (float) ((Math.PI * (direction)) / 180);
    papp.pushMatrix();
      papp.translate(x,y);
      papp.rotate(radians);
      if(fromUnit!=null)papp.fill(fromUnit.uColor, 255 - fromUnit.uColor, 255, 150);
      else                   papp.fill(255,0,0,150);
      papp.rect(0,0,w,h);
    papp.popMatrix();
    if(isColisionDebug){ papp.fill(fromUnit.uColor, 255 - fromUnit.uColor, 255, 150); papp.rect(0,0,w,h); }
  }
  
}
