
/*
　座標云々の面での考察は文尾にて。
　三次元の雛形として調整。例として、箱を置く機能と、dragball5をこの三次元で稼働させる事を試した。
　HanyouTestみたいに簡単に組み合わせる仕様の実現は難しい(描画を移すだけでは駄目なので、x,y,zを色々弄らねば……)が、一応、置けるようにしたという話。

　内部設置したdragball5のは、カメラを動かしても、ちゃんとクリック位置にボールが生成される。
　しかし「球四つ以上でガクガク」「箱の外に球が生成されない(worldのmouseopとかの辺り？)」
　などの少々の不具合(読んでない部分)が残っているので、のちのち改善したい。

　とにかく、物を置けた。
　一つのボールに視点を依存して、自分もボールみたいに跳ねたり。
　マイクラみたいに一定距離にしか物を置けなかったり、球を射出したり。
　補正グリッドを実装したり。(プログラムraycastの移植も)
　いろいろ三次元を謳歌したい。

*/

// 描画
ArrayList<PVector> boxies = new ArrayList<PVector>();
WorldBox box;

// 初期化
void setup() {
  size(512, 512, P3D);
  box = new WorldBoxll(0, -height, 0, width, height, width, 10 );
  hint(ENABLE_DEPTH_SORT);
}

// 毎フレームの描画
void draw() {
  background(255);
  position_system();
  drawXZGrid(0, color(0, 0, 200), 10, 300 );//y=0  //  getXZPlane…の座標面の可視化

  //if (mousePressed && mouse3DPos!=null && mouseButton==LEFT)  boxies.add(mouse3DPos);

  // 描画登録された箱を描画
  fill(255);
  for (PVector pos: boxies) {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(255,0,0,255); 
    stroke(0, 255); 
    box(100);
    popMatrix();
  }
  if(mouse3DPos!=null)box.update();

  // 2D描画例
  drawGUI();
}

// グリッド描画
void drawXZGrid(int h, color c, int gridStep, int gridNum) {
  int gridMax = gridStep * gridNum;
  pushMatrix();
  translate(0, h, 0);
  /*
  strokeWeight(1);
  stroke(c, 80);
  for (int i=-gridMax; i<=gridMax; i+=gridStep)  //  lineで描いた疑似地面は、Z軸を気にせず、ピーッと線を引きやがるです
  {
    if (i==0) continue;
    line(-gridMax, 0, i, gridMax, 0, i);
    line(i, 0, -gridMax, i, 0, gridMax);
  }
  */
  stroke(100);
  strokeWeight(1);
  fill(c,80);  // ←変更  
  beginShape(QUAD_STRIP);
    vertex(-gridMax, 0, -gridMax);  
    vertex(-gridMax, 0,   gridMax);
    vertex(  gridMax, 0, -gridMax);
    vertex(  gridMax, 0,   gridMax);    
  endShape(); 
  
  
  
  strokeWeight(2);
  stroke(200, 0, 0, 128); 
  line(-gridMax, 0, 0, gridMax, 0, 0);
  stroke(0, 200, 0, 128); 
  line(0, -gridMax, 0, 0, gridMax, 0);
  stroke(0, 0, 200, 128); 
  line(0, 0, -gridMax, 0, 0, gridMax);
  noStroke();
  popMatrix();
}

void drawGUI()
{
  camera();
  noLights();
  hint(DISABLE_DEPTH_TEST);
  fill(0, 255); 
  rect(0, height-30, width, 30);
  textMode(SCREEN); 
  textSize(20); 
  textAlign(LEFT, TOP);
  noStroke();
  fill(255, 255); 
  text("fps:"+frameRate, 20, height-25);
  hint(ENABLE_DEPTH_TEST);
}

/*
//　マウスカーソル座標をP3Dで活用するための仕様
//　dragballは「マウスの移動量」に焦点を当てていた。
//こちらの仕様は、マウスの座標を使えて嬉しいが、PMatrix3Dの仕様を理解というかprocessingがSCREENとかでデータくれてるから、別言語への転用は難しい。
*/
/*
//[http://www.c3.club.kyutech.ac.jp/gamewiki/index.php?3D%BA%C2%C9%B8%CA%D1%B4%B9]
//[http://hideapp.cocolog-nifty.com/blog/2013/05/unity-tips-a5d8.html]
//[http://cafe.eyln.com/cgi-bin/wiki/wiki.cgi?page=Diary%2F2011-12-2]
//　スクリーン座標とワールド座標間の変換(変換行列の処理。)、カメラのビューポーと座標空間なども忘れてはならない。
//processingの元々の機能に頼り切っているから、嫌だなぁ……と思っていたが、DirectXで実装する3Dも、Unityで実装する3Dも、この変換行列云々は搭載してくれているようだ。
//というか自分が今後触るであろう3DCGのプログラムの方面では、既にサンプルがあるのを確認
//3D処理には絶対あるとは言えない……。行列取得処理を確実に用意してくれているかは、不安に思うが……)
//　　ワールド座標
//　　モデル座標(transform等後のローカルな座標)
//　　ジオメトリ処理(3D的に座標入力したものを、ディスプレイ画面という二次元画面に表示する、所謂ゲーム的3Dのための処理)
//の三ワード(+Matrix)を知っていれば、どんな言語上でもこじつけれるかも。
//先駆者に感謝を。
*/

/*
[http://capa.jugem.cc/?eid=144]
[http://web-prog.com/opengl-es/screen-world-zahyou_henkan/]
processing[http://tkitao.hatenablog.com/entry/2014/12/21/225600]
*/
