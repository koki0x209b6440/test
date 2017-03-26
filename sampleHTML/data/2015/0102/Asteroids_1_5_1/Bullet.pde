class Bullet extends GameObject
{ 
  Bullet()
  {
    life = Config.Bullet.LifeSpan;
    radius = 1;
  }

  public void draw()
  {
    noFill();
    strokeWeight(1);
    stroke(Config.General.ForegroundColor);
    ellipse(position.x, position.y, getRadius()*2, getRadius()*2);
  }

  public void update()
  {
    position.add(velocity);

    wrapAroundScreen();

    life--;
    if (life <= 0)
    {
      currentLevel.removeFromWorld.add(this);
    }
  }

  public void collidedWith(GameObject other)
  {
    if (other instanceof Asteroid)
    {
      currentLevel.removeFromWorld.add(this);
    }
  }
}


