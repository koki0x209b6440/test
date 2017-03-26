
class EnemyList
{
  ArrayList<Enemy> enemylist=new ArrayList<Enemy>();
  int intervalLimit=100,count=0;
  Player player;
  EnemyList(Player player)
  {
    this.player=player;
  }
  void work()
  {
    for(int i=0; i<enemylist.size(); i++)
    {
      if(!enemylist.get(i).work() ) enemylist.remove(i);
    }
    enemies.spawn();
  }
  void spawn()
  {
    if(count++>intervalLimit) count=0;
    if(count==intervalLimit)
    {
      for(int i=0; i<3; i++)
      {
        enemylist.add(new Enemy(player,random(0,width),random(0,height),random(0,0.02) ));
      }
    }
  }
  void alldead()
  {
    for(int i=0; i<enemylist.size(); i++)enemylist.remove(i);
  }
  
}
