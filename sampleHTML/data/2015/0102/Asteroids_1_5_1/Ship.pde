class Ship extends GameObject implements AcceptInput
{
  private ArrayList<Integer> keys = new ArrayList<Integer>();
  private float fireDelay = 0;

  Ship()
  {
    radius = 10;
    orientation = 0;
    life = 1;

    PVector v1 = new PVector(radius * sin(radians(0)), -radius * cos(radians(0)));
    PVector v2 = new PVector(radius * sin(radians(135)), -radius * cos(radians(135)));
    PVector v3 = new PVector(radius*0.5 * sin(radians(180)), -radius*0.5 * cos(radians(180)));
    PVector v4 = new PVector(radius * sin(radians(225)), -radius * cos(radians(225)));
    vertices.add(v1);
    vertices.add(v2);
    vertices.add(v3);
    vertices.add(v4);
  }

  public void draw()
  {
    translate(position.x, position.y);
    rotate(radians(orientation));
    scale(Config.General.GlobalScale);

    drawCollisionBounds();
    drawVertices();

    if (keys.contains(UP))
    {
      PVector vL = vertices.get(3).get();
      vL.sub(vertices.get(2));
      vL.div(2);
      vL.add(vertices.get(2));
      PVector vR = vertices.get(1).get();
      vR.sub(vertices.get(2));
      vR.div(2);
      vR.add(vertices.get(2));

      line(vL.x, vL.y, 0, radius);
      line(vR.x, vR.y, 0, radius);
    }
  }
  public void update()
  {
    if (keys.contains(LEFT))
    {
      orientation -= Config.Ship.RotationSpeed;
    }
    if (keys.contains(RIGHT))
    {
      orientation += Config.Ship.RotationSpeed;
    }
    if (keys.contains(UP))
    {
      velocity.add(getVelocity(this.orientation, Config.Ship.Acceleration));
    }

    position.add(velocity);

    if (fireDelay > 0)
    {
      incrementFireDelay();
    }
    if (keys.contains(CONTROL) && fireDelay == 0)
    {
      fire();
      incrementFireDelay();
    }

    wrapAroundScreen();
  }

  private void fire()
  {
    play(sfxBullet);
    
    Bullet bullet = new Bullet();
    bullet.position = this.position.get();
    bullet.position.add(getVelocity(this.orientation, getRadius()));

    PVector bulletVelocity = getVelocity(this.orientation, Config.Bullet.Speed);
    
    if (Config.Ship.ReactionOnFire)
    {
      this.velocity.sub(PVector.div(bulletVelocity, 4));
    }
    
    if (Config.Bullet.AddShipVelocity) bullet.velocity = this.velocity.get();
    bullet.velocity.add(bulletVelocity);

    currentLevel.addToWorld.add(bullet);
  }
  private void incrementFireDelay()
  {
    fireDelay++;

    if (fireDelay == Config.Ship.FireDelay) fireDelay = 0;
  }

  public void keyPressed()
  {
    if (!keys.contains(keyCode))
    {
      keys.add(keyCode);
    }
  }
  public void keyReleased()
  {
    keys.remove((Object)keyCode);
  }
  public void keyTyped()
  {
  }

  public void collidedWith(GameObject other)
  {
    if (other instanceof Asteroid)
    {
      if (Config.Ship.CanBeDestroyed)
      {
        play(sfxExplosion);
        currentLevel.removeFromWorld.add(this);
        this.life = 0;

        if (Config.General.ShowExplosions)
        {
          Explosion explosion = new Explosion(this.position);
        }
      }
    }
  }
}


