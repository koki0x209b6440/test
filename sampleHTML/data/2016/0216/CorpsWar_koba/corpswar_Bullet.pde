

class Bullet
{
  PApplet papp;
  Unit fromUnit=null;
  Corp[] corps;
  Bullet[] bullets;
  
  boolean isWork=false;//当たり判定ONなど。false時点ではeffect行う
  boolean isShield=false;//防がれたほう
  boolean isCannotPene=true;
  int ID;
  int x=0,y=0,w=10,h=10;
  float direction=0,speed=0;
  int life=-1;
  int damage=-1;
  Bullet(int ID,Corp[] corps,Bullet[] bullets,PApplet papp)
  {
    this.ID=ID;
    this.corps=corps;
    this.bullets=bullets;
    this.papp=papp;
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
  void draw()
  {
    if(isWork)
    {
      move();
      if(!collision() )modeling();
      else             isWork=false;
      if(life--<0)   isWork=false;
    }
    else effect();
  }
  
  boolean collision()
  {
    for(int i=0; i<corps.length; i++)
    { 
      if(i==fromUnit.CorpID)continue;
      for(int j=0; j<corps[i].units.length; j++)
      { if( ( sq(corps[i].units[j].x-x)+sq(corps[i].units[j].y-y) )<=sq(w+corps[i].units[j].r)*0.4 )
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
  void move()
  {
    float radians = (float) ((Math.PI * (direction)) / 180);
    x += speed * Math.cos(radians);
    y += speed * Math.sin(radians);
  }
  void modeling()
  {
    papp.pushMatrix();
    papp.translate(x,y);
    if(fromUnit!=null)papp.fill(fromUnit.uColor, 255 - fromUnit.uColor, 255, 150);
    else                   papp.fill(255,0,0,150);
    papp.ellipse(0,0,w,w);
    papp.popMatrix();
  }
  
  int effectCount=0;
  void effect()//isWork=falseでも稼動しているが、一定時間後消えるエフェクトである事に期待
  {
    if(isShield);
    else ;
    if(effectCount++>10)dead();
  }
  void dead()
  {
    x=0;
    y=0;
    isWork=false;
    if(life>0)isWork=!isCannotPene;
  }
  
}
