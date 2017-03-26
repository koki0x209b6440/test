class Explosion
{
  private ArrayList<GameObject> particles = new ArrayList<GameObject>();

  Explosion(PVector position)
  {
    for (int i = 0; i < 360; i += 30)
    {
      SphereParticle p = new SphereParticle();
      p.position = position.get();
      p.velocity = p.getVelocity(random(i-10, i+10), 1);
      currentLevel.addToWorld.add(p);
    }
  }
}
class Explosion2 extends GameObject
{
  private ArrayList<LineParticle> particles = new ArrayList<LineParticle>();

  Explosion2(GameObject obj)
  {
    this.position = obj.position.get();
    this.velocity = obj.velocity.get();
    this.orientation = obj.orientation;

    PVector lastVertex = null;
    for (int i = 0; i <= obj.vertices.size(); i++)
    {
      PVector v = obj.vertices.get(i % obj.vertices.size());

      if (lastVertex != null)
      {
        LineParticle p = new LineParticle(lastVertex, v);
        p.velocity = lastVertex.get();
        p.velocity.div(20);
        particles.add(p);
      }

      lastVertex = v;
    }
  }

  public void draw()
  {
    translate(this.position.x, this.position.y);
    rotate(radians(this.orientation));

    for (LineParticle p : particles)
    {
      pushMatrix();
      if (p.life > 0)
        p.draw();
      popMatrix();
    }
  }
  public void update()
  {
    this.position.add(this.velocity);

    for (LineParticle p : particles)
    {
      if (p.life > 0)
        p.update();
    }
  }
}


