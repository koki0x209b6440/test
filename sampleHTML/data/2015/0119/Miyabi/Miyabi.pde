/*
　水面処理。
　ただし、近くの水面に映るのではなく、水面に浮いている物の水面描画。

　改良方針：
　例えばpaint(PGraphics pg)メソッド内で描くboxなどが、
　すべて自動的に水面描画されるような、可用性のある物。

　createRefrectionTexture()の都合上、3次元描画メソッドであるbox()などを
　自動水面描画させるのは無理かなぁ……
　(createRefrectionTexture()は、水面で表示するように、四面に置く画像を変形する)
*/
/*
   

　水面反射の絵面を作っているのはcreateRefrectionだと考えていたが、これはコンストラクタで一回しか使用されていない。
　どうやら、箱の四面を分割構築しているようなので、そこで水面反射らしい揺らぎを作っているようだ。
　つまり、安直なリフレクション処理の構築には、このソースは活用できない
*/

int bgColor= 0xFFFFFFFF;
Tourou[] tourouList;// 灯籠の配列

void setup() {
  size(400, 300, P3D);

  refrection = createImage(width, height, RGB);
  blurImage  = createImage(width, height, RGB);
  
  tourouList = new Tourou[1];
  for(int i = 0; i < tourouList.length; i++) {
    float r     = random(4000.0);
    float theta = random(1000.0) * TWO_PI / 1000.0;
    int debug=100;
    tourouList[i] = new Tourou(loadImage("tex"+debug+".png"));
    tourouList[i].angle = random(1000.0) * HALF_PI / 1000.0;
    tourouList[i].x = r * sin(theta);
    tourouList[i].z = r * cos(theta);
  }
  fill(255,255,255);//オブジェクト(灯籠)の基本色として扱われます。
  noStroke();
}

void draw() {
  camera_control();
  
  background(color(#89AFFF) );
  //lights();

  // 更新およびリフレクションの描画(オブジェクト本体はまだ描かない)
  for(Tourou t : tourouList)
  {
    t.update();
    t.renderRefrection(); 
  }

  water_surface_reality();// 乱反射エフェクト
  
  for(Tourou t : tourouList) t.render(); // 灯籠の描画
  
}
