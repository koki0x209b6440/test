class Player
{
  float x,y,r=20,   life=1;
  float dir=0;//muki
  Enemy collisionEnemy=null;
  Item haveItem=null;
  Player(float x,float y)
  {
    this.x=x;
    this.y=y;
  }
  void work()
  {
    fill(255,255,255);
    x=mouseX;
    y=mouseY;
    float b = atan2(mouseY-pmouseY,mouseX-pmouseX);
    if(b!=0) dir=b;
    if(collisionEnemy!=null) dead();
    if(haveItem!=null)       haveItem.use(this);
    display();
  }
  void display()
  {
    pushMatrix();
      translate(x,y);
      //ellipse(0,0,r,r);
      rotate(dir);
      beginShape();
        vertex(-10,-10);
        vertex(20,0);
        vertex(-10,10);
      endShape(CLOSE);
    popMatrix();
  }
  void usedAfterReleaseItem(){ haveItem=null; }
  void dead(){ fill(0,0,0); life=-1; }
  void damage(float d){ life-=d; }
  boolean isDead(){ if(life<=0)return true; return false; }
}
