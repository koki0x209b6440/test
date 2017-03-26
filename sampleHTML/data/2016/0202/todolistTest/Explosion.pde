class Explosion
{
  float posX, posY;
  PVector vitesse=new PVector(),   acceleration=new PVector();
  color couleur;
  float tempsPasse = millis(), tempsAffichage=random(500,2000);
  float angle;
  Explosion(float posX, float posY, color couleur)
  {
    this.posX=posX;
    this.posY=posY;
    this.couleur=couleur;
    angle=random(2*PI);
    acceleration.x=0;
    acceleration.y=0;
    vitesse.x=random(1,3);
    vitesse.y=random(1,3);
  }
  boolean draw()
  {   
    if (millis()-tempsPasse > tempsAffichage) return false;
    else
    {
      vitesse.x=vitesse.x+acceleration.x;
      vitesse.y=vitesse.y+acceleration.y;
      posX=posX+cos(angle)*vitesse.x;
      posY=posY+sin(angle)*vitesse.y;
      stroke(couleur);
      point(posX,posY);
      acceleration.x=random(0.1);
      acceleration.y=random(0.1);
    }
    return true;
  }

}


