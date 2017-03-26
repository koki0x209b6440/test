
int W = 1200;
int H = 1200;

float tras = 0;

Terrain terrain;

void setup() {
  size(800, 600, P3D);

  terrain = new Terrain();
  
  float R = noise(frameCount/5000.0)*1400+200;
  camera(R*sin(frameCount/300.0), R*cos(frameCount/300.0), R,
  (noise(frameCount/200.0,0,0)-0.5)*tras, (noise(0,frameCount/200.0,0)-0.5)*tras,(noise(0,0,frameCount/1000.0)-0.5)*tras,
  0, 0, -1);
}
void draw() {
  background(0);
  
  pointLight(255, 250, 200, 0, 0, 1000);
  ambientLight(50, 60, 90);
  
  translate(-W/2, -H/2, -terrain.elevation/2);
  terrain.drawVec();
}
