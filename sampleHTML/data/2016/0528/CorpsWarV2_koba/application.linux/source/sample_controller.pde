/*
　This program is
　このプログラムは、HanyouBuffer”””活用”””例その1。オフスクリーンバッファリングというやつ。
　CGをblendで混ぜ合わせたり、単に複数オブジェクトのレンダリングを管理したり。

　ボール程度なら、blend()メソッドとかpixels加算よりも、drawの中のソースを組み合わせて混ぜる方が楽かつ奇麗。悲しい。
　x,y座標持ってwork()のあるボールを作るが定石だとは、頭の片隅に置いておくべき。HanyouBuffer系は絶対に利用するべきというものでもない(もしくはHanyouBuffer系のものを、ここControllerのようなものを一つだけ噛ませる)

*/
class Controller extends HanyouBuffer
{
  HanyouBuffer ball;
  Controller(PApplet papp)
  {
    super(papp);
  }
  Controller(PApplet papp,Scene mypointer)
  {
    super(papp,mypointer);
  }
  
  void setup()
  {
    size(300,300,"P2D");//high-graphic : main-window(w,h= 500,400)
    //size(100,100,"P2D");//low-graphic //but work-cost cannot low. (smalling or bigging image is high work-cost?)
    ball=new BoundBall(papp);
  }
  
  void draw()
  {
    pg.background(0);
    pg.blend(ball.getBuffer(NOT_WORK),0,0,ball.pg.width,ball.pg.height,        0,0,pg.width,pg.height,ADD);
  }
  
  HanyouBuffer sceneWork()
  {
    if(keyPressed && key=='p') return new CrossFadeEffect(this,next);
    return this;
  }
}
