class Enemy
{
  float x,y,speed;
  float r=1,dr=1,limit_r=20;
  float life=random(200,300);
  Player player;
  Enemy(Player player,float x,float y,float speed)
  {
    this.player=player;
    this.x=x;
    this.y=y;
    this.speed=speed;
  }
  boolean work()
  {
    if(r<limit_r)r+=dr;
    if(life--<0) r-=(limit_r/3);
    if(r<0) return false;
    if(r>=limit_r)
    {
      x+=(player.x-x) *speed;//horming
      y+=(player.y-y) *speed;//
    }
    if( ( sq(x-player.x)+sq(y-player.y) )<=sq(r+player.r) ) player.collisionEnemy=this;
    display();
    return true;
  }
  void display()
  {
    fill(255,0,0);
    ellipse(x,y,r,r);
  }
  
}
