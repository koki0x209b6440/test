
/*
　フレアボール。メタボール亜種のような位置づけ。全pixel処理系であることは変わりない。
　Starが一個のフレアボール。s.updateがフレアの大きさ(小数点以下入力ぽい)

　＊色をオレンジ系にすれば炎亜種かも。
*/
/*

　球の中で魔力がぼんやりしている格好いい感じの。
　いろいろな色の重なりの奇跡によって成り立っているといってもいい。

　割と単純な作りで、一点から基本白色ピクセルを発生させて、減衰しながら伝搬させる
　サイズ等は固定である。
　また、その見た目はSmokeParticleに似ているが、粗雑である。霧っぽくも見えない。
　coffeeのプログラムでも実装できそうな、白ピクセルのランダム全方位波だ。

　しかし工夫はここからで、まずsmooth(…)の処理により、円範囲から染み出す感じや、そもそもの白波の美しさを付ける。
　そこに、縁になるほど透明な白円を被せる。
　するとあら不思議。魔法の水晶の出来上がり。

　coffeeでもSmokeParticleでもできそうで、でも調整方法が具体化できない、でも本プログラムはP3Dではないのでそこまで可用性もない(使いたい方面に活用できない)。
　奇麗だけど身につかないプログラムであった。
　強いて言えば、ちょっとした円はピクセル直書きでできるなと発想をもらった。まあ、ガスも円もピクセル直書きのメタボール方式なのだけど。

　Smokeの方が自由に置けるし、加力もできるし、いいかなぁ。
*/

Gus s;
PImage img;

public void setup(){
  //frameRate(100);
  size(300,300);
  s = new Gus(new PVector(width/2.0, height/2.0), 100, max(width, height));
  img=createEllipse(100,max(width,height) );
}

public void draw(){
  background(0);
  fill(255,0,0);
  ellipse(20,20,30,30);//ここのellipseが描かれない。だから、Starのs.draw()は全ピクセルを弄っていると解る。
  s.update(0.3, 0.14);
  s.draw();
  image(img,0,0);
  
  if(mousePressed){
    //save("pic.png");
  }
}


PImage createEllipse(float radius,int dim)
{
  PImage img= createImage(dim, dim, ARGB);
    img.loadPixels();
      for(int y = 0; y < img.height; y++){
        for(int x = 0; x < img.width; x++){
          float relDistSq = (sq(x - img.width/2.0) + sq(y - img.height/2.0))/sq(radius); 
          img.pixels[x + y*img.width] = color(255, max(0, 255*(0.9 - sq(relDistSq) ) )        );
        }
      }
  img.updatePixels();
  return img;
}
