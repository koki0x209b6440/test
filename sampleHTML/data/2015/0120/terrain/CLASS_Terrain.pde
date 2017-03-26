class Terrain {
  int seed = 30;
  int grid = 24;
  float elevation = 400.0;
  float sc = 300.0;
  ArrayList vec;

  PImage ground;


  Terrain() {
    computeVertexes();
    ground = loadImage("ground.jpg");

    textureMode(NORMAL);
  }
  
  void computeVertexes() {
    vec = new ArrayList();
    for (int y=  0; y < W;y+=grid) {
      for (int x=  0; x < H;x+=grid) {
        vec.add(new PVector(x, y, (noise(x/sc, y/sc))*elevation));
      }
    }
  }

  void drawVec() {
    noStroke();
    for (int i = 0 ; i < vec.size()-W/grid-1;i+=1) {
      fill(255);
      if (i % (W/grid) != W/grid-1) {
        PVector v1 = (PVector)vec.get(i);
        PVector v2 = (PVector)vec.get(i+1);
        PVector v3 = (PVector)vec.get(1+i+(W/grid));
        PVector v4 = (PVector)vec.get(i+(W/grid));   
        beginShape();
          texture(ground);
            vertex(v1.x, v1.y, v1.z, norm(v1.x, 0, W), norm(v1.y, 0, H));
            vertex(v2.x, v2.y, v2.z, norm(v2.x, 0, W), norm(v2.y, 0, H));
            vertex(v3.x, v3.y, v3.z, norm(v3.x, 0, W), norm(v3.y, 0, H));
            vertex(v4.x, v4.y, v4.z, norm(v4.x, 0, W), norm(v4.y, 0, H));
        endShape(CLOSE);
        println("norm1:"+norm(v2.x, 0, W) );
        println("norm2:"+norm(v2.y, 0, H)  );
      }
    }
    
  }
  
}
