
/* 0809
　TiltToLive風のゲームの作りかけ。(傾き操作ではなく普通にやりたくて)
　足りないのは、おおまかに二つ
　1.特殊な敵
　2.攻撃武器(概要は作った感が)
*/



Player player;
EnemyList enemies;

void setup( ) {
  size(800,600);
  background();
  noCursor();
  //cursor(CROSS);
  player=new Player(0,0);
  enemies=new EnemyList(player);
}
void draw( ) {
  if(!player.isDead() )
  {
    background();
    player.collisionEnemy=null;
    enemies.work();
    player.work();
  }
}

void background()
{
  fill(255,200);
  rect(0,0,width,height);
  stroke(230);
  float dx=(width/10),   dy=(height/10);
  for(float y=1;y<height; y+=dy )
  {
    for(float x=1; x<width; x+=dx )
    {
      rect(x,y,dx,dy);
    }
  }
  stroke(0);
}


void keyPressed()
{
  enemies.alldead();
  player.damage(-1);
}
