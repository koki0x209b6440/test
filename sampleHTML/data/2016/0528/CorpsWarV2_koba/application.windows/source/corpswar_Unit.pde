
public final int R_UNIT_SIZE=22;
public final int R_CORPCORE_SIZE=40;

class Unit
{
  PApplet papp;
  PGraphics pg;
  Corp[] corps;

  boolean isWork=true,isFreeMove=true,isShield=false;
  boolean isPlayer=false;
  boolean isSelected;

  float direction;
  int uColor;//unit Color
  int life;
  float x, y, speed,defaultspeed;
  int CorpID, unitID;
  int r=R_UNIT_SIZE;
  int chargeCount=0;
  Unit(PApplet papp,PGraphics pg,Corp[] corps, float x2, float y2,int groupIDi, int unitIDi, int uColori)
  {
    this.pg=pg;
    this.papp = papp;
    this.corps=corps;
    direction = papp.random(-180, 180);
    CorpID = groupIDi;
    uColor = uColori;
    life = 100;
    unitID = unitIDi;
    defaultspeed=0.7;
    speed = defaultspeed;
    x = papp.random(x2 - papp.width * .1f, x2+ papp.width * .1f);
    y = papp.random(y2 - papp.height * .1f, y2 + papp.height * .1f);
    isSelected = false;
    isPlayer=false;
    
    keyUp=-1;
    keyLeft=-1;
    keyDown=-1;
    keyRight=-1;
  }
  void run()
  {
    isFreeMove=true;
    if(isWork==false)return;
    if(isPlayer) keycontrol();
    move();
    fight();
    draw();
  }
  void draw()
  {
    pg.fill(uColor,255,255-uColor, 255);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.stroke(255 - life * 2.5f, life * 2.5f, 0, 255);
    pg.line(-life / 4, -10, life / 4, -10);
    pg.stroke(255);
    if(isFreeMove)pg.rotate(papp.radians(direction));
    else          pg.rotate(papp.radians(direction-90));
    if (isSelected)
    {
      pg.ellipse(0, 0, r, r);
    }
    if(isPlayer)
    {
      pg.fill(255,0,0, 55);
      pg.ellipse(0, 0, r, r);
      pg.fill(uColor, 255 - uColor, 255, 255);
    }
    pg.beginShape();
      pg.vertex(-5,-5);
      pg.vertex(10,0);
      pg.vertex(-5,5);
    pg.endShape(CLOSE);
    pg.noStroke();
    pg.fill(255, 255, 255, 55);
    pg.ellipse(0, 0, r, r);
    pg.popMatrix();
  }
  
  void fight()
  {
    boolean canShoot = true;
    speed = defaultspeed;
    for (int i = 0; i < corps.length; i++)
    {
      for (int j = 0; j < corps[i].units.length; j++)
      {
        if(corps[i].units[j].isWork==false) continue;
        if (!(i == CorpID && j == unitID))
        {
          float tx = corps[i].units[j].x, ty = corps[i].units[j].y, vx, vy;
          float radius = papp.dist(x, y, tx, ty);
          if (radius < 135)
          {
            float angle = papp.atan2(y - ty, x- tx)* 180 / papp.PI + 180;
            if (i != CorpID && canShoot)
            {
              pg.stroke(uColor,255,255-uColor, 255);
              speed = defaultspeed;
              canShoot = false;
              
              if(chargeCount++==0)
              { for(int k=0; k<bullets.length; k++)
                { if(bullets[k].isWork==false)
                  {
                    int rp=(int)(random(0,5) );//rp=random-pattern//random(0,3)
                    if       (rp==0) bullets[k]=new Bullet(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==1) bullets[k]=new Shield(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==2) bullets[k]=new RectBullet(bullets[k],this,(int)x,(int)y,angle);
                    else if(rp==3){ if( (int)(random(0,5) ) ==2 )bullets[k]=new Lazer(bullets[k],this,(int)x,(int)y,angle); }
                    else if(rp==4) bullets[k]=new Beam(bullets[k],this,(int)x,(int)y,angle);
                    break;
              } } }
              else if(chargeCount>100){chargeCount=0;}
              
              pg.fill(uColor, 255 - uColor, 255, 55);
              pg.line(x, y, tx, ty);
              direction = angle+90;
              isFreeMove=false;
              if(!isPlayer) { if(life<=50)direction+=90;}
            }
        } }
        pg.stroke(255);
        pg.strokeWeight(1);
      }
    }
  }
  
  int dm=0;
  void move()
  {
    float radians= (float) ((Math.PI * (direction)) / 180);
    if(!isPlayer)
    {
      x += speed * Math.cos(radians);
      y += speed * Math.sin(radians);
      if(dm++==100){direction += papp.random(-50, 50); }
    }
    if (x < 10)
    {
      x = 10;
      direction += papp.random(-100, 100);
    }
    if (x > papp.width - 10)
    {
      x = papp.width - 10;
      direction += papp.random(-100, 100);
    }
    if (y < 10)
    {
      y = 10;
      direction += papp.random(-100, 100);
    }
    if (y > papp.height - 10)
    {
      y = papp.height - 10;
      direction += papp.random(-100, 100);
    }
  }  
  
  void isPlayerON(int upkey,int leftkey,int downkey,int rightkey)
  {
    isPlayer=true;
    keyUp=upkey;
    keyLeft=leftkey;
    keyDown=downkey;
    keyRight=rightkey;
  }
  int keyUp,keyLeft,keyDown,keyRight;
  void keycontrol()
  {
    HanyouApplet happ=(HanyouApplet)papp;
      if(happ.Key_get(keyUp)>0 )    y-=2;
      if(happ.Key_get(keyLeft)>0 )  x-=2;
      if(happ.Key_get(keyDown)>0 )  y+=2;
      if(happ.Key_get(keyRight)>0 ) x+=2;
  }
}
