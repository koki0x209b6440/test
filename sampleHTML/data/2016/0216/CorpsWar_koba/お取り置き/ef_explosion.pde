

//ガラスが割れるような破砕エフェクト。
//画面サイズくらいのバッファに適用すると重い。また、小さいバッファ適用でも、描画が画面全体サイズだと、3D処理なので、重い。
//原本では、シーンnowが割れるって感じだった気がしたんだけどなぁ。

class ExplosionEffect extends HanyouBuffer
{
  HanyouBuffer now;//next
  private final int EXPLOSION_EFFECT_TIME=70;
  private final int FADE_DELAY = 80;
  
  private int count=0;
  Fragments fragments;
  
  ExplosionEffect(HanyouBuffer now,HanyouBuffer next)
  {
    super(now,next);
    this.now=now;
    this.next=next;
  }
  void setup()
  {
    size(300,300,"P3D");
    pg.camera();
    pg.noStroke();
    PImage buff=next.getImage(NOT_WORK);
    fragments = new Fragments(50,now);
  }

  void draw()
  {
    
    pg.background(0);
    pg.image(next.getImage(NOT_WORK),0,0,pg.width,pg.height);
    fragments.update(pg);// 破片の描画
  }

  HanyouBuffer sceneWork()
  {
    if(count++<EXPLOSION_EFFECT_TIME) return this;
    return next;
  }
  
}
