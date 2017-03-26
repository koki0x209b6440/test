class Shield extends Bullet
{
  float fromUnitx,fromUnity;
  Shield(Bullet befBullet,Unit fromUnit,int x,int y,float direction)
  {
    super(befBullet,fromUnit,x,y,direction);
    speed=0;
    w=30;
    h=30;
    life=100;
    fromUnit.isShield=true;
    fromUnitx=fromUnit.x;
    fromUnity=fromUnit.y;
    isCannotPene=false;
    damage=0;
  }
  void move()
  {
    fromUnit.x=fromUnitx;
    fromUnit.y=fromUnity;
  }
  
  boolean collision()
  {
    for(int i=0; i<bullets.length; i++)
    {
        if( ( sq(bullets[i].x-x)+sq(bullets[i].y-y) )<=sq(w+bullets[i].w)*0.4 )
        {
          if(i==ID)continue;
          bullets[i].effect();
          return isCannotPene;//effect//は各種bullet系のif分岐に任せる
    }   }
    return false;
  }
  void modeling()
  {
    papp.pushMatrix();
    papp.translate(x,y);
    papp.fill(0,255,0,150);
    papp.ellipse(0,0,w,h);
    papp.popMatrix();
  }
  void effect()//isWork=falseでも稼動しているが、一定時間後消えるエフェクトである事に期待
  {                //(複数ヒットだから)ヒット時のエフェクトでも無いし、固定レーザならここの役割なんだろう
                   //レーザ終わり際の挙動(火線)？　でもそれは描画のdrawの方でlifeと同期して...
    if(isShield);
    else ;
    if(life<=0)dead();
  }
  void dead()
  {
    super.dead();
    fromUnit.isShield=false;
  }
  
}
