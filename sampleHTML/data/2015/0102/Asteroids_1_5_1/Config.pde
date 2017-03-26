static class Config
{ 
  static class General
  {
    public static color BackgroundColor = #000000;
    public static color ForegroundColor = #FFFFFF;
    public static float GlobalScale = 1;
    public static float LineWidth = 2;
    public static boolean ShowCollisionBounds = false;
    public static boolean ShowExplosions = true;
    public static boolean ShowVelocityVector = false;
  }

  static class Ship
  {
    public static float RotationSpeed = 4;
    public static float Acceleration = 0.05;
    public static float FireDelay = 30;
    public static boolean ReactionOnFire = true;
    public static boolean CanBeDestroyed = true;
  }

  static class Bullet
  {
    public static float Speed = 2.5;
    public static float LifeSpan = 100;
    public static boolean AddShipVelocity = true;
  }

  static class Asteroid
  {
    public static boolean AddBulletVelocityOnDestroy = true;
  }
}


