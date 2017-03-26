
PImage sampleimg;
PImage[] imgs;
final int IMG_NUM=5;

void setup()
{
  sampleimg=loadImage("1.png");
  size(sampleimg.width,sampleimg.height);
 
  int i=0;
  imgs=new PImage[IMG_NUM];
  for(i=0; i<IMG_NUM; i++) imgs[i]=loadImage( (i+1)+".png");
  
  background(0);
  tint(255,255,255,100);
  for(i=0; i<IMG_NUM; i++) blend(imgs[i], 0, 0, imgs[i].width, imgs[i].height, 0, 0, width, height, ADD);//image(imgs[i],0,0);
}


/*
動画記録のminimapの動きを足し合わせたい。blend引数理解も進んだ
*/
