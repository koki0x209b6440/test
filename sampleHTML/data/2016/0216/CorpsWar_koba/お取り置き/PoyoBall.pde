/*
　This program is
　このプログラムは、カービィを目的とした柔らかい系モデルの作成(openprocessing参考)

　作り方としては、まずバネ的な動きをする点の作成を目指す(Node)
　その後、その点でできた面積element,polygon(形を崩さない挙動と)(……全体像PoyoBall(重力など)…と大きくしていって、演算をリアルそう・複雑そうな実装していく。
　と言いつつも、polygon辺りは参考そのまま。

*/

/*
//移植の関係で(bufferとマウスクリックするウインドウのサイズ差)上手く動かない、「掴み」処理
void mousePressed(){
  for(int i=0;i<bbl.nodes.length;i++){
    PVector dx = new PVector();
    dx.x = bbl.nodes[i].x.x - mouseX;
    dx.y = bbl.nodes[i].x.y - mouseY;
    dx.z = 0;
    if(dx.mag()<elementLength/2){
      if(hold!=-1){
        if(bbl.nodes[i].x.z>
          bbl.nodes[hold].x.z){
          hold = i;
        }
      }else{
        hold = i;
      }
    }
  }
}
void mouseReleased(){
  hold = -1;
}
*/
class PoyoBall extends HanyouBuffer
{
  ColorObject ballcolor=new ColorObject(247,201,221,255);
  Model model;
  PoyoBall(PApplet papp)
  {
    super(papp);
  }
  
  void setup()
  {
    size(500,400,"P3D");
    pg.ortho(-pg.width/2, pg.width/2, -pg.height/2, pg.height/2, -10, 10);
    pg.noStroke();
    model = new Model(pg);
  }
  
  void draw()
  {
    pg.fill(ballcolor.getColor() );
    pg.background(0);
    for(int m=0;m<16;m++){model.update(0,pg.width,0,pg.height);}
    //pg.directionalLight(255, 255, 255, -1, 1, -1);
    //pg.directionalLight(128, 128, 128, 1, -1, 1);
  
    pg.beginShape(TRIANGLES);
        for(int i=0;i<model.polygons.length;i++){
          pg.vertex(model.polygons[i].a.x.x,    model.polygons[i].a.x.y,    model.polygons[i].a.x.z);
          pg.vertex(model.polygons[i].b.x.x,    model.polygons[i].b.x.y,    model.polygons[i].b.x.z);
          pg.vertex(model.polygons[i].c.x.x,    model.polygons[i].c.x.y,    model.polygons[i].c.x.z);
        }
    pg.endShape();
    colorcontrol(name,ballcolor,'p');
  }
  
}
