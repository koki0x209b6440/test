/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/30117*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
// =============================================================
// iTunes や iPod の CoverFlow をまねっこしてみた。
// -------------------------------------------------------------
// マウスドラッグで操作できるよ。
// =============================================================
// import processing.opengl.*;
 
final float MAX_ANGLE = radians(70);  // ジャケットの最大傾斜角
final float interval = 500;           // 間隔
final int   offsetZ  = 400;           // Z方向の移動分
final int   bgColor  = color(255, 255, 255);
int target=0;

Photo[] p;
void setup() {
  size(400, 250, P3D);  // テクスチャの歪みが気になるときは OpenGL を指定
  p = new Photo[10];
  target=p.length/2;
  for(int i = 0; i < p.length; i++) {
    p[i] = new Photo("tex" + i + ".jpg");
    p[i].nX = (i - p.length / 2) * interval;
  }
}
 
void draw() {
  camera(0, 0, 1200, 0, 0, 0, 0, 1, 0);
  background(bgColor);
  
  for(int i = 0; i < p.length; i++) p[i].update();
  if(!mousePressed)keycontrol();
  else mousecontrol();
}
int getTarget()
{
  return target;
}


boolean Nkey=false,Pkey=false;
void keycontrol()
{
  if(keyPressed)
  {
    if(keyCode==RIGHT && Nkey==false)
    {
      Nkey=true;
      if(target<p.length-1)target++;
    }
    if(keyCode==LEFT && Pkey==false)
    {
      Pkey=true;
      if(target>0)target--;
    }
  }
  else
  {
    Nkey=false;
    Pkey=false;
  }
  double offsetX=-p[target].nX * 0.1;
  for(int i = 0; i < p.length; i++) p[i].nX += offsetX;
}

void mousecontrol()
{
  double minX = 9999;
  for(int i = 0; i < p.length; i++)
  { 
    if(abs((float)p[i].nX) < abs((float)minX))
    {
      minX = p[i].nX;
      target=i;
    }
  }
  double offsetX;
  if(mousePressed) offsetX = 6*(mouseX - pmouseX);
  else offsetX = -minX * 0.1;
  for(int i = 0; i < p.length; i++) p[i].nX += offsetX;
}
