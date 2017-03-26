class SphereParticle extends GameObject
{
  private float orientationChange = random(-2, 2);
  
  SphereParticle()
  {
    life = 40;
  }
  
  public void draw()
  {
    strokeWeight(life);
    stroke(Config.General.ForegroundColor, 70);
    
    translate(this.position.x, this.position.y);
    rotate(radians(this.orientation));
    ellipse(0, 0, life/5+2, life/5+2);
  }
  
  public void update()
  {
    this.orientation += this.orientationChange;
    
    PVector vel = this.velocity.get();
    vel.add(new PVector(random(-1, 1), random(-1, 1)));
    this.position.add(vel);

    life--;
    if (life <= 0) currentLevel.removeFromWorld.add(this);
  }
}
class LineParticle extends GameObject
{
  public PVector p1;
  PVector p2;
  
  LineParticle(PVector p1, PVector p2)
  {
    life = 40;
    
    this.position = p1.get();
    this.p1 = p1;
    this.p2 = p2;
  }
  
  private float orientationChange = random(-10, 10);
  
  public void draw()
  {
    strokeWeight(Config.General.LineWidth);
    stroke(255);
    
    //translate(-this.position.x, -this.position.y);
    //rotate(radians(this.orientation));
    //translate(this.position.x, this.position.y);
    
    line(p1.x, p1.y, p2.x, p2.y);
    point(p1.x, p1.y);
  }
  
  public void update()
  {
    this.orientation += this.orientationChange;
    
//    PVector vel = new PVector(this.velocity.x, this.velocity.y);
//    vel.add(new PVector(random(-1, 1), random(-1, 1)));
    this.position.add(velocity);
    
    life--;
  }
}

