
/*
　布。旗のはためく感じを作るもの。
　＊サイズの変え方わからない。   <-解決
　＊布の物理シミュレーションにグレードアップしたい(どこに力を加えるか、詳細化したい)(←マウスでクリックした部分がペコってなる感じというか？)
*/
/*
参考[http://www.openprocessing.org/sketch/8691]
      [http://nehe.gamedev.net/tutorial/flag_effect_(waving_texture)/16002/]
*/


class ClothObject
{
  //布の配列
  float gravity,wind;
  int numw,numh;
  float elementSize;
  PVector[][] X,V,F;
  PVector[] constraint;
  PImage img;
  int[][] slate;                                       //colid
  int nodeCount = 0;                           //
  boolean hasBeen = false;                  //
  int w,h;
  Cloth c;

  
/*
  ClothObject
  +-----ClothObject[コンストラクタ]
  |          +----------------------reset();
  |          +----------------------setupConstraint();
  +-----work();
  +-----update();
             +----------------------normalForce();
             |                                        +--------------force2();
             +----------------------windForce();
             |                                        +--------------wind2();
             +----------------------colide();
             |                                        +--------------collisionSetup();
             |                                        +--------------testAdjacency
             +----------------------useConstraint();

*/

  ClothObject(Cloth c,PImage img,float x, float y,      int w,int h,            float gravity, float wind)
  {
    this.c=c;
    this.w=w;
    this.h=h;
    img.resize(w,h);
    this.img=img.get();
    this.gravity=gravity;
    this.wind=wind;
    elementSize=c.elementSize;
    numw=(int)(this.img.width   /elementSize);
    numh=(int)(this.img.height /elementSize);
    X = new PVector[numw][numh];
    V = new PVector[numw][numh];
    F = new PVector[numw][numh];
    constraint = new PVector[numh];
    slate = new int[numw*numh][2];
    reset();
    setupConstraint();
  }
  void setImage(PImage img)
  {
    img.resize(w,h);
    this.img=img.get();
  }
  void setImage(PGraphics pg)
  {
    setImage(pg.get() );
  }
  
  void reset(){
    for (int i=0; i<numw; i++){
      for (int j=0; j<numh; j++){
        X[i][j] = new PVector(elementSize * (i),
                                       elementSize * (j),
                                       random(-0.1,0.1));
        V[i][j] = new PVector();
      }
    }
  }
  void setupConstraint(){
    for (int j=0; j<numh; j++){
      constraint[j] = new PVector(X[0][j].x,
                                              X[0][j].y,
                                              X[0][j].z);
    }
  }
  
  
  
  
  void effect(PGraphics pg)
  {
    work();
    update(pg);
  }
  void work()
  {
    //風力調節とか。
    //wind=0.05;
  }
  void update(PGraphics pg)
  {
    //ここに実際の物理演算？
    for (int i=0; i<numw; i++){
      for (int j=0; j<numh; j++){
        F[i][j] = new PVector(0.0,gravity,0.0);
      }
    }
    for (int i=0; i<numw; i++){
      for (int j=0; j<numh; j++){
        normalForce(i,j);
        windForce(i,j);
      }
    }
    collide();
    for (int i=0; i<numw; i++){
      for (int j=0; j<numh; j++){
        V[i][j].add(F[i][j]);
        X[i][j].add(V[i][j]);
      }
    }
    useConstraint();
  }
  void normalForce(int i, int j){
    int a = i+1;
    int b = j;
    force2(i,j,a,b,1);
    a = i-1;
    b = j;
    force2(i,j,a,b,1);
    a = i;
    b = j+1;
    force2(i,j,a,b,1);
    a = i;
    b = j-1;
    force2(i,j,a,b,1);
    a = i+1;
    b = j+1;
    force2(i,j,a,b,pow(2,0.5));
    a = i-1;
    b = j+1;
    force2(i,j,a,b,pow(2,0.5));
    a = i+1;
    b = j-1;
    force2(i,j,a,b,pow(2,0.5));
    a = i-1;
    b = j-1;
    force2(i,j,a,b,pow(2,0.5));
    boolean jump = true;
    if (jump == true){
      int jumper = 2;
      a = i+jumper;
      b = j;
      force2(i,j,a,b,jumper);
      a = i-jumper;
      b = j;
      force2(i,j,a,b,jumper);
      a = i;
      b = j+jumper;
      force2(i,j,a,b,jumper);
      a = i;
      b = j-jumper;
      force2(i,j,a,b,jumper);
      a = i+jumper;
      b = j+jumper;
      force2(i,j,a,b,jumper*pow(2,0.5));
      a = i-jumper;
      b = j+jumper;
      force2(i,j,a,b,jumper*pow(2,0.5));
      a = i+jumper;
      b = j-jumper;
      force2(i,j,a,b,jumper*pow(2,0.5));
      a = i-jumper;
      b = j-jumper;
      force2(i,j,a,b,jumper*pow(2,0.5));
    }
  }
  void force2(int i,int j,int a,int b,float distMult){
    float eW2 = elementSize * distMult;
    if ((a>=0)&&(b>=0)&&(a<numw)&&(b<numh)){
      PVector dx = PVector.sub(X[a][b], X[i][j]);
      float bufferWidth = 0.01 * elementSize;
      float delta = 0;
      if ((dx.mag() < eW2 - bufferWidth/2)||
          (dx.mag() > eW2 + bufferWidth/2)){
        delta = abs(dx.mag() - eW2)
                     - bufferWidth/2;
      }
      int sighn = 0;
      if (dx.mag() < eW2 - bufferWidth/2){
        sighn = -1;
      }else if (dx.mag() > eW2 + bufferWidth/2){
        sighn = +1;
      }
      dx.normalize();
      float v1 = dx.dot(V[i][j]);
      float v2 = dx.dot(V[a][b]);
      float dv = v2 - v1;
      float fmag = 0.1 * delta * sighn + 0.01 * dv;//////////////////////////////////////////////
      PVector df = PVector.mult(dx,fmag);
      F[i][j].add(df);
      F[a][b].sub(df);
    }
  }
  void windForce(int i,int j){
    // NOTE: vector selected based on right hand rule
    int a = i+1;
    int b = j;
    int c = i;
    int d = j+1;
    wind2(i,j,a,b,c,d);
    a = i;
    b = j+1;
    c = i-1;
    d = j;
    wind2(i,j,a,b,c,d);
    a = i-1;
    b = j;
    c = i;
    d = j-1;
    wind2(i,j,a,b,c,d);
    a = i;
    b = j-1;
    c = i+1;
    d = j;
    wind2(i,j,a,b,c,d);
  }
  void wind2(int i,int j,int a,int b,int c,int d){
    PVector windV = new PVector(wind,0.0,0.0);
    if ((a>=0)&&(b>=0)&&(a<numw)&&(b<numh)){
      if ((c>=0)&&(d>=0)&&(c<numw)&&(d<numh)){
        PVector ab = PVector.sub(X[a][b], X[i][j]);
        PVector cd = PVector.sub(X[c][d], X[i][j]);
        PVector un = ab.cross(cd);
        un.normalize();
        float fmag = un.dot(windV);
        F[i][j].add(PVector.mult(un,fmag));
      }
    }
  }
  void collide()
  {
    float bumpRad = 1.5;
    if (hasBeen == false)
    {
      collisionSetup();
      hasBeen = true;
    }
    for (int i=1; i<nodeCount; i++)
    {
      for (int j=0; j<i; j++)
      {
        if (testAdjacency(i,j))
        {
          PVector dx = PVector.sub(X[slate[j][0]][slate[j][1]],
                                   X[slate[i][0]][slate[i][1]]);
          if (abs(dx.x)<bumpRad)
          {
            if (abs(dx.y)<bumpRad)
            {
              if (abs(dx.z)<bumpRad)
              {
                if (dx.mag()<bumpRad)
                {
                  float delta = (bumpRad - dx.mag()) * 0.1;//////////////////////////////////////
                  dx.normalize();
                  F[slate[j][0]][slate[j][1]].add(PVector.mult(
                                                    dx,delta));
                  F[slate[i][0]][slate[i][1]].sub(PVector.mult(
                                                    dx,delta));
    } } } } } } }
              
  }
  void collisionSetup(){
    for (int i=0; i<numw; i++){
      for (int j=0; j<numh; j++){
        slate[nodeCount][0] = i;
        slate[nodeCount][1] = j;
        nodeCount++;
      }
    }
  }
  boolean testAdjacency(int i,int j){
    int a = slate[i][0];
    int b = slate[i][1];
    int c = slate[j][0];
    int d = slate[j][1];
    boolean val = false;
    if (((abs(a-c)<2)&&(abs(b-d)<2))==false){
      val = true;
    }
    return val;
  }
  void useConstraint(){
    for (int j=0; j<numh; j++){
      X[0][j] = new PVector(constraint[j].x,
                            constraint[j].y,
                            constraint[j].z);
      V[0][j] = new PVector();
    }
  }

}

