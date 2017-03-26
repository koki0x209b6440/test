
int[][] fire;
color[] palette;
int[] calc1,calc2,calc3,calc4,calc5;


void setup_freespace()
{
  colorMode(HSB);

  //palletは火用の色配列。計算でもとめた濃度の値(火のゆらめき)を、実際の色に変換する。
  //pallet(2)→赤(火の中心部)、pallet(10)→橙(火の外縁部)　みたいなイメージ。
  //Hue goes from 0 to 85: red to yellow
  //Saturation is always the maximum: 255
  //Lightness is 0..255 for x=0..128, and 255 for x=128..255
  palette = new color[255];
  for(int x = 0; x < palette.length; x++) palette[x] = color(x/4, 255, constrain(x*3, 0, 255));
  
  
  // Precalculate which pixel values to add during animation loop
  // this speeds up the effect by 10fps
  calc1 = new int[width];
  calc3 = new int[width];
  calc4 = new int[width];
  calc2 = new int[height];
  calc5 = new int[height];
  fire = new int[width][height];
  for (int x = 0; x < width; x++) {
    calc1[x] = x % width;
    calc3[x] = (x - 1 + width) % width;
    calc4[x] = (x + 1) % width;
  }
  for(int y = 0; y < height; y++) {
    calc2[y] = (y + 1) % height;
    calc5[y] = (y + 2) % height;
  }
  
  colorMode(RGB);//カラーモードをデフォルトに戻す意
}


void effect()
{
  int counter = 0;
  for (int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      //火のメラメラ作る部分
      fire[x][y] =
          ((fire[calc3[x]][calc2[y]]
          + fire[calc1[x]][calc2[y]]
          + fire[calc4[x]][calc2[y]]
          + fire[calc1[x]][calc5[y]]) << 5) / 129;
      pixels[counter] = palette[fire[x][y]];// Output
      if ((pg.pixels[counter++] >> 16 & 0xFF) >= 128) fire[x][y] = 128;//長方形等、物の輪郭線を識別する(炎を付ける位置というか)
    }
  }
  
}
