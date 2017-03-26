abstract class GameObject
{
  public PVector position = new PVector(0, 0);
  public PVector velocity = new PVector(0, 0);
  public float orientation = 0;
  public float radius = 0;
  public ArrayList<PVector> vertices = new ArrayList<PVector>();
  public float life = 0;

  public abstract void draw();
  public abstract void update();

  protected void wrapAroundScreen()
  {
    if (position.x < -getRadius())
    {
      position.x = width+getRadius();
    }
    if (position.x > width+getRadius())
    {
      position.x = -getRadius();
    }
    if (position.y < -getRadius())
    {
      position.y = height+getRadius();
    }
    if (position.y > height+getRadius())
    {
      position.y = -getRadius();
    }
  }

  public PVector getVelocity(float orientation, float speed)
  {
    float velX = sin(radians(orientation)) * speed;
    float velY = -cos(radians(orientation)) * speed;

    return new PVector(velX, velY);
  }

  public boolean collidingWith(GameObject other)
  {
    float distance = PVector.dist(this.position, other.position);

    if (distance > getRadius() + other.getRadius())
      return false;
    else
      return true;
  }
  public void collidedWith(GameObject other)
  {
  }

  protected void drawCollisionBounds()
  {
    if (Config.General.ShowCollisionBounds)
    {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(1);
      ellipse(0, 0, radius*2, radius*2);
    }
  }
  protected void drawVelocityVector()
  {
    if (Config.General.ShowVelocityVector)
    {
      stroke(255, 0, 0);
      strokeWeight(1);
      
      PVector tmp = PVector.add(this.position, PVector.mult(this.velocity, 10));
      
      line(this.position.x, this.position.y, tmp.x, tmp.y);
    }
  }

  public float getRadius()
  {
    return this.radius * Config.General.GlobalScale;
  }

  public void drawVertices()
  {
    strokeWeight(Config.General.LineWidth);
    stroke(Config.General.ForegroundColor);
    
    PVector lastVertex = null;
    for (int i = 0; i <= vertices.size(); i++)
    {
      PVector v = vertices.get(i % vertices.size());

      if (lastVertex != null)
      {
        line(lastVertex.x, lastVertex.y, v.x, v.y);
      }

      lastVertex = v;
    }
  }
}


