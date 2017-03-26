class Tank
{
  PVector loc;    
  float r; // lenght of cannon
  float br; //turret radius
  float x, y;
  

  Tank(PVector loc, float br, float r)
  {
    this.loc = loc;
    this.br = br;
    this.r = r;
    
  }
  void operate()
  {
    noStroke();
    fill(#ffffff);
    ellipse(loc.x, loc.y, br*2, br);

    rectMode(CENTER);
    fill(#ffffff);
    rect(loc.x, loc.y+4, 36, 4); // tank body
    for(int i=0; i<8; i++){
      fill(#ffffff, 150);
      ellipse(17+(loc.x-5*i), loc.y+10, 8, 8); // tank wheels
    }
    
    float angle = atan2(mouseY - loc.y, mouseX - loc.x);
    x = r * cos(angle);
    y = r * sin(angle);
    x += loc.x;
    y += loc.y;
    stroke(#ffffff);
    line(loc.x, loc.y, x, y);
  }
  
  void run(int dir)
    {
      if(dir == 1){
      loc.x += 3.0f;
      }
      else loc.x -= 3.0f;
    }
    
}
