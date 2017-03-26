/*
パーティクルの練習。生命時間を数字で表現する。
アイデア元はopen processing。使いやすいようにした(particle各々にlifeを持たせる等)
*/

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/10039*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */


ArrayList particles;

void setup() {
  size(1000,700);
  particles = new ArrayList();
  smooth();
  textSize(32);
  //noCursor();
}

void draw() {
  // A new Particle object is added to the ArrayList every cycle through draw().
  particles.add(new Particle(60)); 

  background(255);
  // Iterate through our ArrayList and get each Particle
  // The ArrayList keeps track of the total number of particles.
  for (int i = 0; i < particles.size(); i++ ) { 
    Particle p = (Particle) particles.get(i);
    p.fallen();
    p.gravity();
    p.render();
    if(p.life<0) particles.remove(i);
  }
}
