
/*
　画像に対する一次元フーリエ変換     高速フーリエFFTではなく、遅いが単純？な離散フーリエDFTの方
   処理がごつくて時間かかるので、printlnだが、途中経過も示せるようにしておいた
*/

PImage img;
void setup(){
  img = loadImage("sample.jpg");
  size(img.width, img.height);
  oneDFT(img);  
}
void draw()
{
  background(0);
  image(img,0, 0);
}



void oneDFT(PImage img)//一次元フーリエ変換
{
  //画像imgのRGB値のRのみを取得
  float[][] X_imag = new float[img.width][img.height];
  float[][] X_real = new float[img.width][img.height];
  int[][] colorArray = new int[img.width][img.height];
  for(int y=0; y < img.height; y++)
  { for(int x = 0; x < img.width; x++)
    {
      colorArray[x][y] = (int)red(img.get(x,y));
  } }
  println("DFT start");
  //DFT
  for(int y=0; y < img.height; y++)
  { for(int x = 0; x < img.width; x++)
    { for(int k = 0; k < img.width; k++)//  k=x方向の周波数制御 
      {
        //Rに関してフーリエ変換
        X_real[k][y] += colorArray[x][y] *   cos( (2.0 * PI/img.width)  * k * x);
        X_imag[k][y] += colorArray[x][y] * -1*sin((2.0 * PI/img.width)  * k * x); 
      } 
    } 
    println("DFT "+y+"/"+img.height);
  }
  println("DFT finish");
  for(int y=0; y < img.height; y++)
  { for(int x=0; x < img.width; x++)
    {
      //フーリエ変換によって得られた実数値のみを画像にセット
      color c = color(X_real[x][y],X_real[x][y],X_real[x][y]);
      img.set(x,y,c);
  } }
}
