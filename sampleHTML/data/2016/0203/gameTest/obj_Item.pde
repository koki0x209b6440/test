
class Item
{
  float x,y;
  Item()
  {
    x=0;
    y=0;
  } 
  
  boolean work()
  {
    
    return true;
  }
  
  void use(Player player)
  {
    
    //player.usedAfterReleaseItem();//効果時間をこのuseでカウントして、0になったらこのメソッドで「手持ちアイテム消去」
  }
  
}
