class Fusee {

     ArrayList trajet;
     InteractiveFrame rampe0, rampe1, fusee;
     PVector vitesse;
     float masse0, masse1, tempo;//les masses des attracteurs sont identiques (à modifier?)
     Fusee() {
          rampe0=new InteractiveFrame(scene);
          rampe1=new InteractiveFrame(scene);
          fusee=new InteractiveFrame(scene);
          rampe0.setPosition(new PVector(640, 260, -200));
          rampe1.setPosition(new PVector(820, -100, -110));
          fusee.setPosition(rampe1.position().get());
          vitesse=comb(0.01, rampe1.position(), -0.01, rampe0.position());
          masse0=10000;
          masse1=10 ;
          tempo=4;
          trajet= new ArrayList();
     }

     void draw() {
          PVector v=fusee.position();
          PVector at1, ww;
          PVector force=new PVector(0, 0, 0);
          for (int i=0;i<lista.size();i++) {
               InteractiveFrame frame=((Attracteur)lista.get(i)).repere;
               if (frame.grabsMouse()&&mousePressed) {
                    initialiser();
               }
               ww=comb(-1, v, 1, frame.position());
               force=comb(1, force, masse0*masse1/(ww.dot(ww)), ww);
          }
          vitesse=comb(1, vitesse, tempo/masse0, force);
          fusee.setPosition(comb(1, fusee.position(), tempo, vitesse));
          pushMatrix();
          fusee.applyTransformation();
          noStroke();
          fill(255, 0, 0);
          sphere(5);
          popMatrix();
          pushMatrix();
          rampe0.applyTransformation();
          fill( 0, 0, 255); 
          noStroke();
          sphere(20);
          popMatrix();
          pushMatrix();
          rampe1.applyTransformation();
          sphere(20);
          popMatrix();
          trajet.add(fusee.position().get());
          dessineTrajet();

          stroke(0);
          ligne( rampe0.position(), rampe1.position());
          if ((rampe1.grabsMouse()|| rampe0.grabsMouse())&&mousePressed)initialiser();
         // println(rampe0.position()+"  "+rampe1.position());
     }
     void dessineTrajet() {
          if (trajet.size()>5000)trajet.remove(0);
          stroke(0, 0, 150); 
          strokeWeight(1);
          if (trajet.size()>1) {
               for (int i=0;i<trajet.size()-1;i++)ligne((PVector)trajet.get(i), (PVector)trajet.get(i+1));
          }
     }

     void initialiser() { 
          trajet.clear();
          vitesse=comb(0.01, rampe1.position(), -0.01, rampe0.position());
          fusee.setPosition(comb(0.5, rampe1.position(), 0.5, rampe0.position()));
     }
}

