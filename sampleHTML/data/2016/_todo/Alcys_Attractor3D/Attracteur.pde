class Attracteur {
     InteractiveFrame repere;

     Attracteur() {
          repere=new InteractiveFrame(scene);
          repere.setPosition(new PVector(random(-1000, 1000), random(-1000, 1000), random(-1000, 1000)));
     }
     Attracteur(PVector pos) {
          repere=new InteractiveFrame(scene);
          repere.setPosition(pos);
     }
}

