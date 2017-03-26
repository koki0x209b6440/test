/*
　This program is
　このプログラムは、HanyouBuffer利用例その1。ただのバウンドボール。
　CG混ぜ合わせたい(このボールと別のCGを同時描画したい)なら、このボール程度なら、blend()メソッドとかpixels加算よりも、drawの中のソースを組み合わせて混ぜる方が楽かつ奇麗。悲しい。
　x,y座標持ってwork()のあるボールを作るが定石だとは、頭の片隅に置いておくべき。HanyouBuffer系は絶対に利用するべきというものでもない(もしくはHanyouBuffer系のものを一つだけ噛ませる)

*/
class BoundBall extends HanyouBuffer
{
  ColorObject ballcolor=new ColorObject(255,0,0,255);
  int x,y,dx=1,dy=(int)(random(1,5) );
  BoundBall(PApplet papp)
  {
    super(papp);
  }
  void setup()
  {
    size(papp.width,papp.height,"P2D");//controller-width,height copy
    x=pg.width/3;
    y=pg.height/2;
  }
  void draw()
  {
    pg.background(0);
    pg.fill(ballcolor.getColor() );
    pg.ellipse(x,y,50,50);
    x+=dx;
    y+=dy;
    if( x<0 || pg.width<x) dx*=-1;
    if( y<0 || pg.height<y) dy*=-1;
    colorcontrol(name,ballcolor,'b');
  } 
}


/*
//normal (bound-ball only ) mode
      ColorObject ballcolor=new ColorObject(255,0,0,255);
      int x,y,dx=1,dy=(int)(random(1,5) );
      void setup()
      {
        size(300,300,P2D);//controller-width,height copy
        x=width/3;
        y=height/2;
      }
      void draw()
      {
        background(0);
        fill(ballcolor.getColor() );
        ellipse(x,y,50,50);
        x+=dx;
        y+=dy;
        if( x<0 || width<x) dx*=-1;
        if( y<0 || height<y) dy*=-1;
      }
*/



