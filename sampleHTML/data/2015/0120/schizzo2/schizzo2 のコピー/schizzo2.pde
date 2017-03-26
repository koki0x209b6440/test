/*
　手書き風に建物が建つ。
　建物は長方形の組み合わせ。長方形は、box3dというオブジェクトによって定義されている。
　box3dでは、長方形の一辺一辺(辺の両端)をlistaに登録する。
　(その後、たぶんlistaの登録情報を二つずつ取り出して、線を引いてっててる)

　よって、このプログラムの流用では、手書き風のカービィはできない。
　(実際、手書きっぽい満月は、描画途中が無い)
　ぎりぎり取り組める所があるとすれば、この満月のメソッドを三日月等に対応させる(扇形に対応させ、角度の入力を受け付ける)
　それでも、カービィは作れんだろう。
　(あと、手書きっぽい塗りつぶしも欲しいなぁ。これは「円の中」「長方形の中」の判定で、ピクセルではなくellipse(…5,5)で塗り塗りさせれば、実現できそうか？)
*/
/*
　lista周りがわからんくて、満月の大きさ変えることすら困難。//　←これはさすがにできたわ
(なぜ全部ベクター管理なんだ……agg()とは……変数mat[][]とは……)
　とりあえずbox3dで新しい建物作るところからはじめるべきか？(もしくは、その支援機構作りから)
*/
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/12878*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
int penx = 0;
int peny = 0;
int de = 2;
cLista lista = new cLista();
int el0 = 0;
int by;
void setup() { 
  size(800, 600);
  //  size(1024, 768);
  //  size(screen.width, screen.height);
  smooth();
  frameRate(30);
  colorMode(HSB, 1);
  ellipseMode(CENTER);
  stroke(0, 0, 0, 0.7);
  background(0, 0, 1);
  //  strokeWeight(0.3 * de + 1);
  strokeWeight(2);

  city();
}
void draw() {
  int t = 0;
  while ( (t++ < 50) && (el0 < lista.nr)) {
    lista._draw(el0++);
  }
  if (el0 == lista.nr) {
    noLoop();
  }
}
void city() {
  //rettf(0, 0, width, int(0.95*height));
  
  //albero(new PVector(220, 0, -2));//x=220に手書き草を配置
  //semaforox(new PVector( 100, 0, 162));//x=100に手書き……橋？
  //palazzo(new PVector(0, 0, 40));//x=40? 手書きオブジェ(建物、植木等)全てからランダムで設置
  
   /*
   //ここ数行、地面っぽい手書き線を引く。
   PVector p1;
   PVector p2;
   p1 = proietta(new PVector(-10, 0, 240));
   p2 = proietta(new PVector(-10, 0, -60));
   linea(p1, p2);
   
   p1 = proietta(new PVector(-20, 0, 240));
   p2 = proietta(new PVector(-20, 0, -60));
   linea(p1, p2);
   
   p1 = proietta(new PVector(-40, 0, -5));
   p2 = proietta(new PVector(240, 0, -5));
   linea(p1, p2);
   p1 = proietta(new PVector(-40, 0, -15));
   p2 = proietta(new PVector(240, 0, -15));
   linea(p1, p2);
   */
  
   //ここ数行、手書き円を引く。
   int rag = 100;//円の大きさ
   lista.agg(0,(int)(0.5*width),(int)(0.3*height) );
   //↑座標間理系  lista.agg(?,x,y);    //?を0以外にすると、x,yが反映されなくなる。なぜだ。
   lista.agg(6, rag, 1);
  //実際の円の追加　lista.agg(?,ellipseSize,?);   //6は変えると描画されなくなる。1は変えても影響無し。
}

void mouseClicked() {
  lista.nr = 0;
  el0 = 0;
  city();
  background(0, 0, 1);
  loop();
}
void keyPressed()
{
  if ( key == 's') {
    save("city.tif");
  }
}


// ------------------------------------------------------------



