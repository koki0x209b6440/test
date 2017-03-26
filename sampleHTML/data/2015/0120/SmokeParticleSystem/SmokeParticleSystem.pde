/*
　煙体のシミュレート(もやもや、風力影響)
　画像の変色、変形によって実現している。
　★色はプログラム内で指定できるが、大きさはtexturebasic.pngの画像サイズを変えなければならない。
　やや不都合があるが、pixel単位で扱わないからプログラム綺麗。
　★FireSunのように上手くTestObject継承できる気がしない。プログラムが完成されている
　(こちらの形式に上手く変形できない。崩しにくい)
　☆自分のに組み込むとしたら、sun内の変数に入れて、フラグ立った時にps.runを動かすようにする。TestObject継承などは考えない。

　課題：尾ひれの大きさの変化ができない
*/


ParticleSystem ps;

void setup() {

  size(640, 200);
  ps = new ParticleSystem(1, new PVector(width/2,height-20 ) );
}

void draw() {
  background(75);
  ps.run();
  
  
  //煙体に、意図的な風力の影響を加える
  //float dx=(float)( (float)mouseX/ (float)width)-0.5;
  float dx=0.1;
  println(dx);
  PVector wind = new PVector(dx,0,0);
  ps.displayVector(wind,width/2,50,500);
  ps.add_force(wind);
  
  
  fill(255);
  textSize(16);
  text("Frame rate: " + int(frameRate), 10, 20);
}
