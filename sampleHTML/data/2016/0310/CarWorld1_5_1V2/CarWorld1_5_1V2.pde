
import remixlab.proscene.*;

square sqr;
int scaleFactor = 1024;
Car car;
PImage ground;
Scene scene;

WorldBox box;
SpotlightTest slt;

void setup()
{
  size(600,400,P3D);
  cursor(CROSS);
  sphereDetail(10);
  textureMode(NORMAL);
  getData();
  int offset = 128;
  sqr = new square(offset,offset,1024+offset,1024+offset);
  box = new WorldBoxll(220*scaleFactor, 200*scaleFactor,20, width*2, height*2, width*2, 10 );
  slt=new SpotlightTest(210*scaleFactor, 200*scaleFactor,1000);
  car = new CustomCar(new PVector(200,200, 20.022648));
  ground = loadImage("ground.jpg");
  camX = new PVector(car.X.x,car.X.y,car.X.z);
  
  scene = new Scene(this);
  scene.setAxisIsDrawn(false);
  scene.setGridIsDrawn(false);
  scene.setHelpIsDrawn(false);
  scene.setFrameSelectionHintIsDrawn(false);//ランプについてる[+]みたいなマーク
}
void draw()
{
  //println("( "+(int)(car.X.x)+", "+(int)(car.X.y)+", "+(int)(car.X.z)+")" );//DEBUG
  //println("Height?:"+(int)(data[(int)car.X.x][(int)car.X.y])   );//DEBUG
  //println("( "+(int)(sqr.x1)+", "+(int)(sqr.x2)+", "+(int)(sqr.y1)+", "+(int)(sqr.y2)+")");//DEBUG
  color sky = color(#89AFFF);
  background(sky);
  car.cam();
  
  box.update();
  slt.draw();
  
  directionalLight(255, 255, 255, 1, -1, -1);
  directionalLight(red(sky)/2, green(sky)/2, blue(sky)/2,   -1, 1, -1);
  noStroke();
  sqr.clear();
  sqr.makeParent(new PVector(car.X.x,car.X.y),10);
  sqr.draw();
  fill(0);
  beginShape(TRIANGLE_STRIP);//地形描画の穴埋め？
    vertex(0,0,-2.0*scaleFactor);
    vertex(0,nrows*scaleFactor,-2.0*scaleFactor);
    vertex(ncols*scaleFactor,0,-2.0*scaleFactor);
    vertex(ncols*scaleFactor,nrows*scaleFactor,-2.0*scaleFactor);
  endShape();
  
  
  for(int i=0;i<2;i++)car.iterate();
  car.draw();
}




/*0312
　基本理念は、「World3Dなんか重いな、そういえば同じ三次元上のCarWorldにballbox配置しても重いのかな？」という感じ。
　world3dでは見渡すことができるが、こちらでは坂道も設置できる・ぴょんぴょん自由に跳ね回れる　という三次元自由空間なので、せっかくだからprocessingの他の(自作の)3dcgオブジェクトも置けるようにしてみる(CarWorldではmodel試作もしていたし)。

　そして置いてみた結果。原因が判明できないのだが(‘三次元位置クリックが重い？)、こちらはボール数増やしても重くない。
　変更点や留意点としては、terrain上にbox置くために*scaleFactorを施す(carは内部的に施している)　ボール一個一個も、boxの位置をoffsetにしたxyz数値。toranslate関数だけboxに合わせたわけではないから車とボールの衝突も実装可能。
　あと、グラビティを見てもらえば一目瞭然だが、軸が違うようだった。これは他の3dcgを置くときも大変かも。

　todo:2d物も透明板に貼り付ける感じで置けるように。
　　　  そしてカメラ注視を車・特定場所などへ移せるように
　このtodoをこなすことで「三次元空間上にあるゲームボードでカードで遊びはじめる」みたいなことが可能に。
　Simple_koba系とはまた別の意味で便利かなと。

　しかしその辺りのことはunityなら「ひょいっ」でできる。うーん、やはり三次元関連でprocessingで取り組むのは、この辺りまででいいかなぁ…

*/
