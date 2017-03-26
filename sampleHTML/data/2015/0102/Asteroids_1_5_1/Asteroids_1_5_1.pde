class Asteroid extends GameObject
{
  private float orientationChange;
  private int size;

  Asteroid()
  {
    this((int)random(1, 4));
  }
  Asteroid(int size)
  {
    this.size = size;

    if (size == 1)
      radius = random(7, 12);
    else if (size == 2)
      radius = random(20, 25);
    else if (size == 3)
      radius = random(35, 45);

    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(random(-2, 2), random(-2, 2));

    orientation = random(0, 359);
    orientationChange = random(-3, 3);

    generateAsteroid();
  }

  public void draw()
  {
    drawVelocityVector();

    translate(position.x, position.y);
    rotate(radians(orientation));
    scale(Config.General.GlobalScale);

    drawCollisionBounds();
    drawVertices();
  }
  public void update()
  {
    position.add(velocity);
    orientation += orientationChange;

    wrapAroundScreen();
  }

  private void generateAsteroid()
  {
    for (int i = 0; i < 360; i += random(20, 40))
    {
      float x = sin(radians(i)) * radius * random(0.8, 1.2);
      float y = cos(radians(i)) * radius * random(0.8, 1.2);

      PVector v = new PVector(x, y);
      vertices.add(v);
    }
  }

  public void collidedWith(GameObject other)
  {
    if (other instanceof Bullet)
    {
      collisionWithBullet((Bullet)other);
    }
    else if (other instanceof Ship)
    {
      collisionWithShip((Ship)other);
    }
  }
  private void moveToPointOfContact(GameObject other)
  {
    PVector collisionNormal = PVector.sub(this.position, other.position);
    float distance = this.radius + other.radius - collisionNormal.mag();

    collisionNormal.normalize();
    this.position.add(PVector.mult(collisionNormal, distance));
  }

  private void collisionWithBullet(Bullet other)
  {
    if (Config.Asteroid.AddBulletVelocityOnDestroy)
    {
      this.velocity.add(PVector.div(other.velocity, 4));
    }

    destroy();
  }
  private void collisionWithShip(Ship other)
  {
    if (this.size == 1 && Config.Ship.CanBeDestroyed)
    {
      currentLevel.removeFromWorld.add(this);
    }
  }

  public void destroy()
  {
    play(sfxExplosion);
    currentLevel.removeFromWorld.add(this);

    if (Config.General.ShowExplosions)
    {
      Explosion explosion = new Explosion(this.position);
    }
    if (this.size == 3)
    {
      generateAsteroids((int)random(2, 4), 2);
    }
    else if (this.size == 2)
    {
      generateAsteroids((int)random(2, 3), 1);
    }
  }

  private void generateAsteroids(int quantity, int size)
  {
    for (int i = 0; i < quantity; i++)
    {
      Asteroid ast = new Asteroid(size);
      ast.position = this.position.get();
      ast.velocity = PVector.div(this.velocity.get(), 2);
      ast.velocity.add(new PVector(random(-1, 1), random(-1, 1)));

      currentLevel.addToWorld.add(ast);
    }
  }
}

