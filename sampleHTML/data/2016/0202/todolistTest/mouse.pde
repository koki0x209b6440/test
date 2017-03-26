



void mousePressed()
{
  Brick brickTemp;
  int numParticule=200/2;
  for(int i=0; i<listBrick.size(); i++)
  {  
    brickTemp=listBrick.get(i);
    if(brickTemp.click() )
    {
      listBrick.remove(i);
      for(float dx=0; dx<brickTemp.largeur; dx+=(brickTemp.largeur/10) )
      {
        for(float dy=0; dy<brickTemp.hauteur; dy+=(brickTemp.hauteur/10) )
        {
          for(int k =0; k<numParticule; k++) listExplosion.add(new Explosion(brickTemp.posX+dx,brickTemp.posY+dy, brickTemp.couleur) );
        }
      }
    }
  }
  
}

