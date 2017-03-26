
int gridSize=30;
float xoff,zoff,dx=0,dz=0,ns=0.25,zs=130,power = 0, st = 3*gridSize;//power=0 ->no wave
PImage tex;
PVector v1,v2,v3,v4,v5;
PImage a;
PGraphics pg;

void setup_freespace()
{
     v1 = new PVector();
     v2 = new PVector(); 
     v3 = new PVector();
     v4 = new PVector(); 
     a = loadImage("marble_Test.png");
     pg = createGraphics(900, 500, P2D);//write
     a.resize(pg.width, pg.height);
}

void work()
{
  power=2.5;
  dz=0.045;
  dx=0.06;
  /*
  dz=0.045*10;
  dx=0.06*10;
  */
}

void water() {
  
  work();
  
  pg.beginDraw();
  pg.background(0,0,200);
  pg.endDraw();
  background(0,0,0);
  
  noStroke();
    //　水面の中に映すもの
  for(int y=0; y<=height; y+=gridSize) {
    beginShape(TRIANGLE_STRIP);
    texture(pg);
    for(int x=0; x<=width; x+=gridSize) {
      vertex(-1.5*st+((width+st+1.5*st)/width)*x,-1.5*st+((1.5*st+height+0.5*st)/height)*y,0,x,height-y);
      vertex(-1.5*st+((width+st+1.5*st)/width)*x,-1.5*st+((1.5*st+height+0.5*st)/height)*(y+gridSize),0,x,height-(y+gridSize));
    }
    endShape();
  }
  //　水面揺らぎをそれらしくする(処理の部分)
  colorMode(RGB, 255);
  pointLight(255, 255, 255, width, height/2, -100);
  pointLight(255, 255, 255, width/2, height, -100);
  ambientLight(30, 30, 30);
  lightSpecular(95, 95, 95);
  directionalLight(115, 115, 115, 1, 1, -1);
  directionalLight(115, 115, 115, -1, -1, -1);
  specular(255, 255, 255);
  shininess(50);
  spotLight(45, 45, 45, -100, height/2, 800, 1, 0, -1, PI/3, 5);
  colorMode(HSB, 360);
  noiseDetail(8,  200*(0.6/height) );
  //println(200*(0.6/height));
  float nx,ny=0,z1,z2;
  //揺らぎの処理(実際の描画)
  fill(255,0,0,128);
  for(int y=0; y<=height; y+=gridSize) {
    nx=xoff;
    beginShape(TRIANGLE_STRIP);
    for(int x=0; x<width; x+=gridSize) {
      z1=pow(noise(nx,ny,zoff),power);
      z2=pow(noise(nx,ny+ns,zoff),power);
      surfnorm(x,y,nx,ny);
      normal(v5.x,v5.y,v5.z);
      vertex(x,y,z1*zs);
      surfnorm(x,y+gridSize,nx,ny+ns);
      normal(v5.x,v5.y,v5.z);
      vertex(x,y+gridSize,z2*zs);
      nx+=ns;
    }
    endShape();
    ny+=ns;
  }
  zoff+=dz;//sokudo
  xoff-=dx;//
}

void surfnorm(int x, int y, float nx, float ny){
  float z0 = pow(noise(nx,ny,zoff),power);
  float z1 = pow(noise(nx,ny+ns,zoff),power);
  float z2 = pow(noise(nx+ns,ny,zoff),power);
  float z3 = pow(noise(nx,ny-ns,zoff),power);
  float z4 = pow(noise(nx-ns,ny,zoff),power);
  v1.set(0, gridSize, (z1-z0)*zs);
  v2.set(gridSize, 0, (z2-z0)*zs);
  v3.set(0, -gridSize, (z3-z0)*zs);
  v4.set(-gridSize, 0, (z4-z0)*zs);
  v5 = PVector.add(PVector.add(v1.cross(v2),v2.cross(v3)),PVector.add(v3.cross(v4),v4.cross(v1)));
  v5.normalize();
}
