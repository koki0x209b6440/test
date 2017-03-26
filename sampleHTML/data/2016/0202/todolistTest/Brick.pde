
class Brick
{
  float posX,posY,   largeur=width,  hauteur = 100;
  String content;
  color couleur;
  
  Brick(float posX, float posY,color couleur)
  {
    this.posX=posX;
    this.posY=posY;
    this.couleur=couleur;
  }
  void draw()
  {
    stroke(200);
    strokeWeight(2);
    fill(couleur);
    rect(posX,posY, largeur, hauteur);
    fill(255);
    textSize(60);
    text(content,posX+8,posY+hauteur-10);
  }
  Brick setContent(String content) {
    this.content=content;
    return this;
  }
  boolean click() {
    boolean flag = mouseX > posX && mouseX < posX+largeur && mouseY > posY && mouseY < posY+hauteur;
    return flag;
  }
  
}
