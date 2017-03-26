
/* 0806
　参考[http://openprocessing.org/sketch/25359]
　todoリスト。爆破できる。
　まだtodo機能は一切無い(強いて言えば、todoを表示する機能と削除爆破はある)

メモ：
　思いつきでつけたif(listExplosion.get(i).draw()== false) listExplosion.remove(i);が良い感じ。
　描画しつつ「描画が終わったら」の判定ができる。
*/

ArrayList<Brick> listBrick = new ArrayList<Brick>();
ArrayList<Explosion> listExplosion = new ArrayList<Explosion>();

void setup()
{
  size(400,600);
  smooth();
  frameRate(30);
  PFont font = createFont("MS Gothic",48,true);
  textFont(font);
  
  color[] couleurBrick =  new color[4];
  String[] message={"進捗作成","家事","働かねば","飲み会"};
  Brick brickTemp;
  for (int i=0; i<4; i++)
  {
    couleurBrick[0]=color(random(100,200),random(15,50),random(125,160));  
    couleurBrick[1]=color(random(80,130),random(70,120),random(160,220)); 
    couleurBrick[2]=color(random(220,255),random(210,250),0); 
    couleurBrick[3]=color(random(40,100));
    brickTemp=new Brick(0,i*100,couleurBrick[floor(random(4))] ).setContent(message[i]);
    listBrick.add(brickTemp);
  }

}

void draw()
{
  background(255);
  for (int i=0; i<listBrick.size(); i++) 
  {
    listBrick.get(i).draw();
  }
  for(int i=0; i<listExplosion.size(); i++)
  {
    if(listExplosion.get(i).draw()== false) listExplosion.remove(i);
  }
}



