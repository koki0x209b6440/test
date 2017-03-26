

/*
　squareは、たぶん地面の一マス。
　どこまでも続くマップを親子関係で持っている。
　描画のときは、再帰処理的に子(一マス？)に伸びて描画する。

   (車の足下の一点から四方へ伸びて行く感じだろうか)
   
   とりあえずdata[i][j]がとりあえずマップデータ。で、現在位置やら発破位置はどう算出しようか…
   
   ファイル名クラス(一番表題なやつ)のdraw()メソッドにsqr.makeParent(new PVector(car.X.x,car.X.y),10);とある。
　このように、carXを中心に親ノード10で地形生成を子出産させているのだろうか……

　data[i][j]=replaceを倍したら地形変わった。
　data[][]がやはり地形データ。だが、実際の地形のsquareとどこで関連づけている？
   ↑解決。描画処理のとこで普通にdataに頼ってた。問題は、現在位置のdataか。
*/

int nrows=1201,ncols=1201,bytesPerPoint=2;
float[][] data= new float[nrows][ncols];
float maxData, minData;
void getData()
{
  float scaleFactor = .013;
  byte[] all = loadBytes("N35E138.hgt");
  for(int i=0; i<nrows; i++)
  {
    int curOff=(i*nrows)*bytesPerPoint;
    for(int j=0; j<ncols; j++)
    {
      int curPoint = (((all[curOff + 0]) & 0xff) << 8)    |   ((all[curOff + 1]) & 0xff);
      if(curPoint > 0x0fff) data[i][j] = 0;// no data
      else
        data[i][j] = scaleFactor * curPoint;
      curOff += bytesPerPoint;
    }
  }
  // fix hole in side of Fuji//よくわからん
  float holeHeigth = 1;//ここを大きくすると、大きい山しか残らなくなる
  for(int i = 1; i < nrows-1; i++)
  {
    for(int j = 1; j < ncols-1; j++)
    {
      if(data[i][j]<holeHeigth)
      {
        float replace = 0;
        int devide = 0;
        if(data[i+1][j]>holeHeigth){
          replace += data[i+1][j];
          devide++;
        }
        if(data[i][j+1]>holeHeigth){
          replace += data[i][j+1];
          devide++;
        }
        if(data[i-1][j]>holeHeigth){
          replace += data[i-1][j];
          devide++;
        }
        if(data[i][j-1]>holeHeigth){
          replace += data[i][j-1];
          devide++;
        }
        if(devide>1){replace/=devide;}
        data[i][j] = replace;
      }
    }
  }
}
class square
{
  int x1,y1,x2,y2;
  boolean isParent;
  square[] children;
  square(int a, int b, int c, int d)
  {
    x1 = a;
    y1 = b;
    x2 = c;
    y2 = d;
    isParent = false;
  }
  void makeParent(PVector r, float weight)
  {
    PVector mid = new PVector((x2+x1)/2,(y2+y1)/2);
    PVector dx = PVector.sub(r,mid);
    if((x2-x1)*weight>dx.mag())
    {
      if(x2-x1>1)
      {
        isParent = true;
        children = new square[4];
        int xm = (x1+x2)/2;
        int ym = (y1+y2)/2;
        children[0] = new square(x1,y1,xm,ym);
        children[0].makeParent(r, weight);
        children[1] = new square(xm,y1,x2,ym);
        children[1].makeParent(r, weight);
        children[2] = new square(x1,ym,xm,y2);
        children[2].makeParent(r, weight);
        children[3] = new square(xm,ym,x2,y2);
        children[3].makeParent(r, weight);
      }
    }
  }
  void clear(){  isParent = false;  }
  void draw()
  {
    if(isParent) for(int i=0;i<4;i++)  children[i].draw();
    else          drawSector(x1,y1,x2,y2);
  }
}

PVector bound(PVector X)
{
  float k = 0.1;
  PVector force = new PVector();
  if(X.x<sqr.x1) force.x = (sqr.x1-X.x)*k;
  if(X.y<sqr.y1)  force.y = (sqr.y1-X.y)*k;
  if(X.x>sqr.x2) force.x = -(X.x-sqr.x2)*k;
  if(X.y>sqr.y2) force.y = -(X.y-sqr.y2)*k;
  return force;
}

void drawSector(int a, int b, int c, int d)
{
  if((a>=0)&&(a<ncols)&&(b>=0)&&(b<nrows)&&(c>=0)&&(c<ncols)&&(d>=0)&&(d<nrows))
  {   
    beginShape(TRIANGLE_STRIP);
      texture(ground);
      vertex(a*scaleFactor,b*scaleFactor,data[b][a]*scaleFactor,   norm(a*scaleFactor,0,nrows*scaleFactor),   norm(b*scaleFactor,0,ncols*scaleFactor)   );
      vertex(a*scaleFactor,d*scaleFactor,data[d][a]*scaleFactor,   norm(a*scaleFactor,0,nrows*scaleFactor),   norm(d*scaleFactor,0,ncols*scaleFactor)   );
      vertex(c*scaleFactor,b*scaleFactor,data[b][c]*scaleFactor,   norm(c*scaleFactor,0,nrows*scaleFactor),   norm(b*scaleFactor,0,ncols*scaleFactor)   );
      vertex(c*scaleFactor,d*scaleFactor,data[d][c]*scaleFactor,   norm(c*scaleFactor,0,nrows*scaleFactor),   norm(d*scaleFactor,0,ncols*scaleFactor)   );
    endShape();
  }
}
