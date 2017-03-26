
/*
　エンボスフィルタ適用の実装を試みる。
　[問題点・気になる点]
　・エンボスフィルタ適用後の画像が、黄ばんでいる。->足し算ミスっていた。馬鹿！
　・教科書p96と見た目が違う。どの程度、平行移動させるべきか？
      ->元画像をボヤけさせるなど加工すれば、エンボスフィルタ適用結果の方は品質向上するかも
　環境:processing2.0.3  <-update!
　       java  1.6.0-65
*/

/*変更点 (リファレンスも確認)
  displayWidthに直すのは言わずもがな
  createGraphics(width,height,P2D);からP2D部分の引数指定が変わった模様
  　リファレンスによると、
      createGraphics(w, h)
      createGraphics(w, h, renderer)
      createGraphics(w, h, renderer, path)
    rendererの部分はString: Either P2D, P3D, or PDFとある。あれ、P2D指定可能なのになぜエラーが…
    いじいじしてもエラーだったので、P2D指定をなくして回避
    エラー本文「createGraphics() with P2D requires size() to use P2D or P3D」
    　　　エラー考察：なぜここでsize()の話がでてくるんだ……。
    
    他、以下を削除
    XXX.loadPixels();
    XXX.updatePixels();
    XXX.endDraw();
*/

String inputImageName="kirby.jpg";

PImage f,f_ll;
PGraphics g;
int dx=5,dy=5;

void setup()
{
  size(displayWidth,displayHeight/2);
  initWork();
  fill(0,0,255);
  textSize(64);
  stroke(255,0,0);
  strokeWeight(10);
}

void draw()
{
  initWork();
  background(0,0,0,0);
  image(f,0,0,width/3,height);
  image(f_ll,width/3,0,width/3,height);
  text("dx="+dx+"\ndy="+dy,width/2-50,height/2);
  image(g,(width/3)*2,0,width/3,height);
  
  line(width/3,0,width/3,height);
  line( (width/3)*2,0,(width/3)*2,height);
}



void initWork()
{
    //   init  1/2  fに画像をロード。       f_llにfと同じ画像を、dx,dyだけ平行移動して描画する
    f = loadImage(inputImageName);
    
    PGraphics f_ll_pg=createGraphics(f.width,f.height);
    f_ll_pg.beginDraw();
    f_ll_pg.background(0);
    f_ll_pg.image(f,dx,dy);
    f_ll=f_ll_pg.get();
    
  //   init  2/2  ロードした画像はカラー画像なので、fをグレイスケールに変換。　f_llはネガポジ変換も。
    f=getConvertGray(f);
    f_ll=getConvertGray(f_ll);
    f_ll.filter(INVERT);
    
  //  emboss work
    g=createGraphics(f.width,f.height);
    g.beginDraw();
    g.background(0);
    for(int y=0; y<f.height; y++)
    { for(int x=0; x<f.width; x++)
      {
        float e=red(f.get(x,y))+red(f_ll.get(x,y) )      -128; //f+f_ll-128
        if(e>255) e=255;
        if(e<0)     e=0; 
        g.set(x,y,color(e,e,e) );
    } }
    g.updatePixels();
    g.endDraw();
}
