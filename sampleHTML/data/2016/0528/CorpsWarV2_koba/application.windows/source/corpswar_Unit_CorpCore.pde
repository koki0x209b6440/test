

class CorpCore extends Unit
{
   CorpCore(PApplet papp,PGraphics pg,Corp[] corps, float x2, float y2,int groupIDi, int unitIDi, int uColori)
   {
      super(papp,pg,corps,x2,y2,groupIDi,unitIDi,uColori);
      speed=0;//拠点は動かない。とりあえず念のため0に。
     defaultspeed=0;//拠点は動かない。とりあえず念のため0に。
     r=R_CORPCORE_SIZE;
     life*=2;
   }
  void draw()
  {
    pg.fill(uColor,255,255-uColor, 255);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.stroke(255);
    //if(isFreeMove)papp.rotate(papp.radians(direction));
    //else              papp.rotate(papp.radians(direction-90));
    if (isSelected)
    {
      pg.ellipse(0, 0, r, r);
    }
    pg.ellipse(0, 0, r, r);
    pg.stroke(255 - life * 2.5f, life * 2.5f, 0, 255);
    pg.line(-life / 4, -10, life / 4, -10);
    pg.popMatrix();
  }
}
