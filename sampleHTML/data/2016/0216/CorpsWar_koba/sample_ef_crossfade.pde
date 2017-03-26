/*
　This program is
　このプログラムは、HanyouBuffer間を遷移させるトランジションの実装例。
　各種HanyouBuffer系は、sceneWork(このトランジションを起こすためのメソッド)と、遷移前後(自分自身とnext)を持つので、やりやすいはず。
*/
class CrossFadeEffect extends HanyouBuffer
{
  HanyouBuffer now;//next
  private final int FADE_EFFECT_TIME=70;
  private int count=0,alpha=255;
  CrossFadeEffect(HanyouBuffer now,HanyouBuffer next)
  {
    super(now,next);
    this.now=now;
    this.next=next;
  }
  void setup()
  {
    size(300,300,"P2D");
    
    PImage buff=next.getImage(NOT_WORK);
  }
  
  void draw()
  {
    pg.background(0);
    pg.tint(255,255,255,alpha);
    pg.image(now.getImage(NOT_WORK),0,0,pg.width,pg.height);
    pg.tint(255,255,255,255-alpha);
    pg.image(next.getImage(NOT_WORK),0,0,pg.width,pg.height);

    
    alpha-=(255/FADE_EFFECT_TIME);
  }
  
  HanyouBuffer sceneWork()
  {
    if(alpha<120) return next;
    return this;
  }
  
}
