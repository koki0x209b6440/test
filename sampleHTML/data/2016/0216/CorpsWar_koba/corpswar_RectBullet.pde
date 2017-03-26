
class RectBullet extends Bullet
{
  /*
  RectBullet(int ID,Corp[] corps,Bullet[] bullets,PApplet papp)
  {
    super(ID,corps,bullets,papp);
  }
  */
  RectBullet(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=2;
    w=20;
    h=20;
    life=100;
    damage=30;
    isCannotPene=true;
  }
  boolean collision()
  {
    for(int i=0; i<corps.length; i++)
    { 
      if(i==fromUnit.CorpID)continue;
      for(int j=0; j<corps[i].units.length; j++)
      { if( x<=corps[i].units[j].x && corps[i].units[j].x <=(x+w) )
        { if(y<=corps[i].units[j].y && corps[i].units[j].y <=(y+h) )
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
    } } } }
    return false;
  }

  void modeling()
  {
    papp.pushMatrix();
    papp.translate(x,y);
    if(fromUnit!=null)papp.fill(fromUnit.uColor, 255 - fromUnit.uColor, 255, 150);
    else                   papp.fill(255,0,0,150);
    papp.rect(0,0,w,h);
    papp.popMatrix();
  }
  
  int effectCount=0;
  void effect()//isWork=falseでも稼動しているが、一定時間後消えるエフェクトである事に期待
  {                //(複数ヒットだから)ヒット時のエフェクトでも無いし、固定レーザならここの役割なんだろう
                   //レーザ終わり際の挙動(火線)？　でもそれは描画のdrawの方でlifeと同期して...
    if(isShield);
    else ;
    if(life<=0)dead();
  }
}
