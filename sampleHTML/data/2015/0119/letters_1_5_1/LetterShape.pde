class LetterShape
{
  PImage charImage;
  ArrayList positions = new ArrayList();
  String s;
  float minX, minY, maxX, maxY, altezza, larghezza, diff;

  
  LetterShape(String _s)
  {
    s = _s;
    charImage = createImg();    
  }

  PImage createImg()
  {
    PGraphics pg = createGraphics(20,20,JAVA2D);
    pg.beginDraw();
    pg.background(255);
    pg.fill(240);
    pg.textAlign(CENTER);
    pg.textFont(ff, 16);
    pg.text(s, 0, 0, 20, 20);
    pg.endDraw();
    PImage w = createImage(20,20,RGB);
    copy(pg, 0, 0, 20, 20, 0, 0, 20, 20);
    return w;
  }
  
  void scanImage()
  {
    positions.clear(); 
    for(int x = 0; x < charImage.width; x++) {
      for(int y = 0; y < charImage.height; y++) {
        if(get(x,y) != -65794){          
          positions.add(new PVector(x,y,0));
        }
      }
     }
     getShapeDimensions();
   }
  
  void render()
  {
    pushMatrix();
    translate(-9.5, -9.5, 0); //align grid
    pushMatrix();
    translate(0.5,diff,0);
    for(int i = 0; i < positions.size()-1; i++)
    {
      PVector ps = (PVector) positions.get(i);
      pushMatrix();
      translate(ps.x, ps.y, 0);
      noStroke();
      //stroke(0);
      fill(250);
      box(1, 1, 5);
      popMatrix();
    }  
    popMatrix();
    popMatrix();
  }

  
  void getShapeDimensions()
  {
     float[] xs = new float[positions.size()-1];
     float[] ys = new float[positions.size()-1];
     
     for(int i = 0; i < positions.size()-1; i++)
     {      
        PVector ps = (PVector) positions.get(i);
        xs[i] = ps.x;
        ys[i] = ps.y;      
     }
      minX = min(xs);
      maxX = max(xs);
      minY = min(ys);
      maxY = max(ys);
    
      altezza = (maxY-minY)+1;
      larghezza = (maxX-minX)+1;

      float temp = (20-altezza)/2;
      if(temp >= 2)
        diff = temp-4;
      else
        diff = temp;
  }

  float w()
  {
   return larghezza/2;   
  }

  float h()
  {
   return altezza/2;     
  }
}
