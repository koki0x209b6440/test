
import remixlab.proscene.*;

square sqr;
int scaleFactor = 1024;
Car car;
PImage ground;
Scene scene;
void setup()
{
  size(600,400,P3D);
  cursor(CROSS);
  sphereDetail(10);
  textureMode(NORMAL);
  getData();
  int offset = 128;
  sqr = new square(offset,offset,1024+offset,1024+offset);
  car = new CustomCar(new PVector(784.0194, 671.03815, 20.022648));
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
  
  directionalLight(255, 255, 255, 1, -1, -1);
  directionalLight(red(sky)/2, green(sky)/2, blue(sky)/2,   -1, 1, -1);
  noStroke();
  fill(#F1BB93);//地形の色
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

