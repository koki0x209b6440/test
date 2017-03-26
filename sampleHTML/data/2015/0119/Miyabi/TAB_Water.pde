
PImage refrection;
PImage blurImage;
double noiseCount;
void   water_surface_reality()
{
  // 乱反射エフェクト
  PImage  _refrection = refrection;    // パフォーマンス向上のため局所変数にロード
  PImage  _blurImage  = blurImage; //
  float xnoise = 0.0;
  float ynoise = -(float)(noiseCount+=random(1));
  float xinc   = 0.05;
  float yinc   = 0.3;
  loadPixels();
  _refrection.loadPixels();
  for(int y = 0; y < height; y++) {
    float rate = (float) y / height;
    for(int x = 0; x < width; x++) {
      float refNoise = min(0, 0.5-noise(xnoise , ynoise)) * rate;
      xnoise += xinc;
      
      int xoffset = (int)(0.1 * refNoise * (x - 0.5 * width));
      int yoffset = (int)(refNoise * 50);
      int row = min(height - 1, max(0, y + yoffset));
      int col = min(width  - 1, max(0, x + xoffset));
      _refrection.pixels[y * width + x] = pixels[row * width + col];
    }
    xnoise = 0.0;
    ynoise += yinc;
  }
  _refrection.updatePixels();
  updatePixels();
  pushMatrix();
  camera();
  background(_refrection);
  popMatrix();
  
}
