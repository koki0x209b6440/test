
Scene scene;

void setup() {
  size(400*2, 300*3, P3D);
  scene = new Scene1();
}
void draw() {
  scene = scene.sceneWork();
}
