
class ZoomSlideEffect extends HanyouBuffer
{
  HanyouBuffer now;//next
  private final int FADE_EFFECT_TIME=150;
  private float ZOOM_INOUT_TIME=(FADE_EFFECT_TIME/6);
  private int count=0;
  private float x,total_dx,y,w,h;
  ZoomSlideEffect(HanyouBuffer now,HanyouBuffer next)
  {
    super(now,next);
    this.now=now;
    this.next=next;
    PImage nowimage=now.getImage(NOT_WORK),
                nextimage=next.getImage(NOT_WORK);
    for(int i=0; i<5; i++)
    {
      nowimage=now.getImage(NOT_WORK);
      nextimage=next.getImage(NOT_WORK);
    }
    w=nowimage.width;
    h=nowimage.height;
  }
  void setup()
  {
    size( (int)w, (int)h,"P2D");
  }
  
  void draw()
  {
    pg.background(255);
    if(count<= abs(ZOOM_INOUT_TIME) || (FADE_EFFECT_TIME-abs(ZOOM_INOUT_TIME) )<=count)
    {    //今回はマジックナンバーで「とりあえず動く」ことを目的として、
         //まずcount<=0のときのx+=…等で位置合わせを行い、それをアニメーション時間の場合に調整させた。
      if(count==ZOOM_INOUT_TIME) ZOOM_INOUT_TIME*=-1;
      x+=70/ZOOM_INOUT_TIME;
      y+=70/ZOOM_INOUT_TIME;
      w-=90/ZOOM_INOUT_TIME;
      h-=90/ZOOM_INOUT_TIME;
    }
    else
    {
      x-=3.2;
    }
    pg.image(now.getImage(DRAW_ONLY),x,y,w,h);
    pg.image(next.getImage(DRAW_ONLY),(x+w),y,w,h);
  }
  
  HanyouBuffer sceneWork()
  {
    if(count++>=FADE_EFFECT_TIME) return next;
    return this;
  }
  
}
