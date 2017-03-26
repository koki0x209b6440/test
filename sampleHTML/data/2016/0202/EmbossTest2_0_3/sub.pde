PImage getConvertGray(PImage img)
{
  PImage gray_img = createImage( img.width, img.height, RGB );
  img.loadPixels();
  for ( int y = 0; y < img.height; y++)
  {
    for ( int x = 0; x < img.width; x++)
    {
      int pos = x + y*img.width;
      color c = img.pixels[pos];
      float r = red( c );
      float g = green( c );
      float b = blue( c );
      float gray = 0.3 * r + 0.59 * g + 0.11 * b;
      gray_img.pixels[pos] = color(gray);
    }
  }
  gray_img.updatePixels();
  return gray_img;
}


