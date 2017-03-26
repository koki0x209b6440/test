


PGraphics pg;

void setup(){
  size(640, 360, P2D);
  pg = createGraphics(width, height, P2D);
  setup_freespace();
}

void draw() {

  pg.beginDraw();
  pg.background(0);
  pg.stroke(128);
  //pg.noFill();
  pg.ellipse(width/2,height/2,100,100);
  pg.endDraw();

  fire[width/2][height/2]=int(random(0,190) );//点を適当に入力。これもeffect()によって炎を纏う。(火の出力は乱数で適当に)

  loadPixels();
  effect();
  updatePixels();
}
