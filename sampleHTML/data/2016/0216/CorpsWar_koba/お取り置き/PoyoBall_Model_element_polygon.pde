

float r=(1.0+sqrt(5))/2;
int subdivisions = 4;
float elementLength;
float areaLimiter;
float radius = 96;
float depth = 400;
float gravity = 0.002;
float spring = 0.15;
float damp = 0.05;
float nominalVolume;
float gas = 0.00000001;

class Model{
  Node[] nodes;
  Element[] elements;
  Polygon[] polygons;
  PGraphics pg;
  Model(PGraphics pg){
    this.pg=pg;
    nodes = new Node[12];
    nodes[0] = new Node(pg,new PVector(0,1,r));
    nodes[1] = new Node(pg,new PVector(0,-1,r));
    nodes[2] = new Node(pg,new PVector(0,1,-r));
    nodes[3] = new Node(pg,new PVector(0,-1,-r));
    nodes[4] = new Node(pg,new PVector(1,r,0));
    nodes[5] = new Node(pg,new PVector(-1,r,0));
    nodes[6] = new Node(pg,new PVector(1,-r,0));
    nodes[7] = new Node(pg,new PVector(-1,-r,0));
    nodes[8] = new Node(pg,new PVector(r,0,1));
    nodes[9] = new Node(pg,new PVector(r,0,-1));
    nodes[10] = new Node(pg,new PVector(-r,0,1));
    nodes[11] = new Node(pg,new PVector(-r,0,-1));
    PVector dx;
    elementLength = 2;
    if(subdivisions>0){
      //println("subdividing nodes...");
      for(int m=0;m<subdivisions;m++){
        Node[] newNodes = new Node[0];
        for(int i=1;i<nodes.length;i++){
          for(int j=0;j<i;j++){
            dx = PVector.sub(nodes[j].x,nodes[i].x);
            if(dx.mag()<elementLength*1.001){
              newNodes = (Node[]) append(newNodes,new Node(pg,PVector.add(nodes[i].x,PVector.mult(dx,0.5)) )   );
            }
          }
        }
        int nodesLength = nodes.length;
        nodes = (Node[]) expand(nodes,
          nodesLength+newNodes.length);
        for(int i=0;i<newNodes.length;i++){
          nodes[nodesLength+i] = newNodes[i];
        }
        elementLength/=2;
      }
    }
    //println("attaching elements...");
    elements = new Element[0];
    for(int i=1;i<nodes.length;i++){
      for(int j=0;j<i;j++){
        dx = PVector.sub(nodes[j].x,nodes[i].x);
        if(dx.mag()<elementLength*1.001){
          elements = (Element[]) append(elements,nodes[i].attach(nodes[j]) );
        }
      }
    }
    //println("knitting polygons...");
    polygons = new Polygon[0];
    for(int i=0;i<nodes.length;i++){
      for(int j=0;j<nodes[i].attached.length;j++){
        for(int k=0;k<nodes[i].attached[j].attached.length;k++){
          for(int h=0;h<nodes[i].attached[j]
            .attached[k].attached.length;h++){
            if(nodes[i].attached[j]
              .attached[k].attached[h]==nodes[i]){
              boolean isDuplicate = false;
              if(polygons.length>0){
                for(int m=0;m<polygons.length;m++){
                  if(nodes[i]==polygons[m].a
                    ||nodes[i]==polygons[m].b
                    ||nodes[i]==polygons[m].c){
                    if(nodes[i].attached[j]==polygons[m].a
                      ||nodes[i].attached[j]==polygons[m].b
                      ||nodes[i].attached[j]==polygons[m].c){
                      if(nodes[i].attached[j].attached[k]==polygons[m].a
                        ||nodes[i].attached[j].attached[k]==polygons[m].b
                        ||nodes[i].attached[j].attached[k]==polygons[m].c){
                        isDuplicate = true;
                      }
                    }
                  }
                }
              }
              if(isDuplicate==false){
                polygons = (Polygon[]) append(polygons,
                  new Polygon(nodes[i],
                    nodes[i].attached[j],
                    nodes[i].attached[j].attached[k]));
              }
            }
          }
        }
      }
    }
    float radDenominator = sqrt(r*sqrt(5));
    elementLength *= radius/radDenominator;
    areaLimiter = (sqrt(3)/4*sq(elementLength))*4;
    PVector center = new PVector(pg.width/2,pg.height/2,-depth/2);
    for(int i=0;i<nodes.length;i++){
      nodes[i].x.normalize();
      nodes[i].x.mult(radius);
      nodes[i].x.add(center);
    }
    for(int i=0;i<elements.length;i++){
      elements[i].setLength();
    }
    nominalVolume = 4.0/3*PI*pow(radius,3);
  }
  float volume(){
    float vol = 0;
    for(int i=0;i<polygons.length;i++){
      Polygon poly = polygons[i];
      float area = 0;
      area += poly.a.x.x*poly.b.x.y-poly.b.x.x*poly.a.x.y;
      area += poly.b.x.x*poly.c.x.y-poly.c.x.x*poly.b.x.y;
      area += poly.c.x.x*poly.a.x.y-poly.a.x.x*poly.c.x.y;
      area /= 2;
      vol += area*poly.centroid().z;
    }
    return vol;
  }
  
  
  int hold = -1;
  void update(float colision_area_x_min,float colision_area_x_max,
                    float colision_area_y_min,float colision_area_y_max  )//update(0,pg.width,0,pg.height);
  {
    float pressure = (nominalVolume-volume())*gas;
    for(int i=0;i<polygons.length;i++){
      Polygon poly = polygons[i];
      PVector F = PVector.mult(poly.normalVector(),
        pressure*poly.hydrostaticArea());
      poly.a.f.add(F);
      poly.b.f.add(F);
      poly.c.f.add(F);
    }
    for(int i=0;i<elements.length;i++){
      elements[i].update();
    }
    for(int i=0;i<nodes.length;i++){
      nodes[i].update(0,pg.width,0,pg.height);
      if(hold==i){
        nodes[i].grip();
      }
    }
  }
  float kineticEnergy(){
    float sum = 0;
    for(int i=0;i<nodes.length;i++){
      sum += 0.5*sq(nodes[i].v.mag());
    }
    return sum;
  }
}

class Element{
  Node a;
  Node b;
  float L;
  Element(Node ao,Node bo){
    a = ao;
    b = bo;
  }
  void setLength(){
    L = PVector.sub(b.x,a.x).mag();
  }
  void update(){
    PVector dx = PVector.sub(b.x,a.x);
    if(dx.mag()>L){
      float restore = (dx.mag()-L)*spring;
      dx.normalize();
      PVector dv = PVector.sub(b.v,a.v);
      float damper = dx.dot(dv)*damp;
      b.f.sub(PVector.mult(dx,restore+damper));
      a.f.add(PVector.mult(dx,restore+damper));
    }
  }
}




class Polygon{
  Node a;
  Node b;
  Node c;
  Polygon(Node ao,Node bo,Node co){
    a = ao;
    b = bo;
    c = co;
    if(normalVector().dot(centroid())<0){
      a = ao;
      b = co;
      c = bo;
    }
    if(normalVector().dot(centroid())<0){
      println("normal inverted");
    }
  }
  PVector normalVector(){
    PVector N = PVector.sub(b.x,a.x).cross(
      PVector.sub(c.x,a.x));
    N.normalize();
    return N;
  }
  PVector centroid(){
    PVector oid = new PVector();
    oid.add(a.x);
    oid.add(b.x);
    oid.add(c.x);
    oid.mult(1.0/3);
    return oid;
  }
  float hydrostaticArea(){
    float A = PVector.sub(b.x,a.x).mag();
    float B = PVector.sub(c.x,b.x).mag();
    float C = PVector.sub(a.x,c.x).mag();
    float s = (A+B+C)/2;
    float area = s*(s-A)*(s-B)*(s-C);
    if(area>areaLimiter){area=areaLimiter;}
    return area;
  }
}
