/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/45363*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

/*------------------------------------------------
* Evelyne Dufresne
* EDM4610-20
* TP2 - Engin permormatif
*
* 2011-10-04
--------------------------------------------------*/

//Importation de la librairie audio Minim.
  import ddf.minim.*;
  import ddf.minim.signals.*;
  import ddf.minim.analysis.*;
  import ddf.minim.effects.*;

//Variables Minim
  Minim minim;
  AudioPlayer music;
  AudioInput input; 
  
  FFT fftMusic;
  int nbrBand=20;
  int widthBand;
  
 //Explosions 
 ArrayList listExplosion = new ArrayList(); // List pour stocker les explosions
 Explosion explosionTemp;
 int nbrParticule=50; // Nombre de particules qui seront projetées lors de l'impact
 
 //Temps
 int tempsPasse;
  
void setup()
{ 
 //Paramètres généraux
    size(720,480); 
    background(255);
    smooth();
    //Modes
    colorMode(HSB,255);
    rectMode(CORNERS);
    
  //Setup des éléments Minim
    minim = new Minim(this);
    music = minim.loadFile("The xx - Infinity-Flufftronix Remix.mp3",2048);
    input = minim.getLineIn();
    
    fftMusic = new FFT(music.bufferSize(), music.sampleRate());
    fftMusic.logAverages(10,2);
    
    
  //Jouer la musique
    music.play();
} 
 
void draw()
{ 
  background(255);
  stroke(255);  
  int teinte = 200;


 /*for(int i = 0; i < music.bufferSize() - 1; i++)
  {
   
    stroke(0,0,180);
    //line(i, 100 + music.left.get(i)*100, i+2, 100 + music.left.get(i+1)*100);
    line(i, height-30 + music.right.get(i)*50, i+2, height-30 + music.right.get(i+1)*50);
     
  }*/
 
 fftMusic.forward(music.mix); 
 for(int i = 0; i < fftMusic.avgSize(); i++)
  {
   
    color c = color(teinte,200,255);
    fill(c);
    stroke(255);
    strokeWeight(1);
    widthBand = width/nbrBand-5;
    float heightBand = height - map(fftMusic.getAvg(i),0,10,10,20)-60;
    rect(i*widthBand,height-60, i*widthBand+widthBand,heightBand );
    ellipse(i*widthBand+widthBand/2,heightBand,6,6);
    //println(fftMusic.getAvg(i));  
    teinte = teinte-7;
    
    if(fftMusic.getAvg(i) > 130)
    {
         //Stocker l'explosion au point d'impact dans la liste associée
         for(int k =0; k<nbrParticule; k++)
         {
          explosionTemp = new Explosion(i*widthBand+widthBand/2,heightBand, c);
          listExplosion.add(explosionTemp);
          }

        
    }
    
 //Afficher les explosions qui survienne lors des collisions projectile-brique
  for(int k =0; k<listExplosion.size(); k++)
  {
    Explosion explosionTemp2 = (Explosion) listExplosion.get(k);
    // Après un certain temps écouler, retirer la particule de l'explosion.
    if(explosionTemp2.draw()== false) listExplosion.remove(k);
  }



/////////////////////  
//TEST
////////////////////

  
if(keyPressed) fermerAudio();

}
}

void fermerAudio()
{
  music.close();
  input.close();
  minim.stop();
  
  super.stop(); 
  
}
