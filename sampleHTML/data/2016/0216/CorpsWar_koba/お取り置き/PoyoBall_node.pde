class Node{
  PVector x;
  PVector v;
  PVector f;
  Node[] attached;
  PGraphics pg;
  Node(PGraphics pg,PVector xo){
    this.pg=pg;
    x = xo.get();
    attached = new Node[0];
    v = new PVector();
    f = new PVector(); 
  }
  Element attach(Node a){
    attached = (Node[]) append(attached,a);
    a.attached = (Node[]) append(a.attached,this);
    Element e = new Element(this,a);
    return e;
  }
  void update(float colision_area_x_min,float colision_area_x_max,
                    float colision_area_y_min,float colision_area_y_max  )//update(0,pg.width,0,pg.height);
  {
    boolean slip = false;
    if(x.x<colision_area_x_min){
      f.add(new PVector(-x.x*spring,0));
      slip = true;
    }
    if(x.x>colision_area_x_max){
      f.add(new PVector((x.x-pg.width)*-spring,0));
      slip = true;
    }
    if(x.y<colision_area_y_min){
      f.add(new PVector(0,-x.y*spring));
      slip = true;
    }
    if(x.y>colision_area_y_max){
      f.add(new PVector(0,(x.y-pg.height)*-spring));
      slip = true;
    }
    if(x.z>0){
      f.add(new PVector(0,0,-x.z*spring));
      slip = true;
    }
    if(x.z<-depth){
      f.add(new PVector(0,0,(x.z+depth)*-spring));
      slip = true;
    }
    if(slip){f.sub(PVector.mult(v,damp));}
    v.add(f);
    f = new PVector(0,gravity,0);
    x.add(v);
  }
  void grip(){
    v = new PVector(mouseX-pmouseX,mouseY-pmouseY);
    x.x = mouseX;
    x.y = mouseY;
  }
}
