
public class Robot{
  Mundo m1 = new Mundo(15);
  Coord raiz;
  Coord actual;
  Coord target;
  Stack anteriores;

  float rotacion = HALF_PI;
  int estado = 0;
  float px, py;
  float diametro = m1.getLado();
  float radio = m1.getLado()/2;


  public Robot() {
    raiz = m1.getOrigen();
    target = null;
    px = raiz.px;
    py = raiz.py;
    actual = raiz;
    anteriores = new Stack();
  }

  public void draw() {
    //Llantas
    pushMatrix();
    translate(px, py, 0);
    rotateZ(rotacion);
    fill(255, 255, 0);
    scale(1, .6, 1);
    box(m1.lado);
    
    fill(0, 100, 0);
    scale(1, 1/.6, 1);
    translate(8, 0, 0);
    scale(.3, .8, .9);
    box(m1.lado);
    translate(-60, 0, 0);
    box(m1.lado);
    
    popMatrix();
 
  }

  public void pensar() {
    if (estado==0) {

      if (sensorDerecho()!=null && sensorDerecho().visitable()) {
        target = sensorDerecho();
        actual.setEstado(-2);
        estado = 1;
        anteriores.push(actual);
        rotacion = 0;
      }
      else  if (sensorAbajo()!=null && sensorAbajo().visitable()) {
        target = sensorAbajo();
        actual.setEstado(-2);
        estado = 1;
        anteriores.push(actual);
        rotacion = HALF_PI;
      }
      else  if (sensorIzquierda()!=null && sensorIzquierda().visitable()) {
        target = sensorIzquierda();
        actual.setEstado(-2);
        estado = 1;
        anteriores.push(actual);
        rotacion = PI;
      }
      else  if (sensorArriba()!=null && sensorArriba().visitable()) {
        target = sensorArriba();
        actual.setEstado(-2);
        estado = 1;
        anteriores.push(actual);
        rotacion = HALF_PI + PI;
      }
      else {
        if (anteriores.size()>0){
          target = (Coord) anteriores.pop();
          if (target.plx == actual.plx && target.ply>actual.ply) {
            rotacion = HALF_PI;
          }
          else if (target.plx == actual.plx && target.ply<actual.ply) {
            rotacion = HALF_PI+PI;
          }
          else if (target.ply == actual.ply && target.plx<actual.plx) {
            rotacion = PI;
          }
          else if (target.ply == actual.ply && target.plx>actual.plx) {
            rotacion = 0;
          }
          actual.setEstado(-2);
          estado = 1;
        }
      }

    }

    if (estado==1) {
      float dx = target.px - px;
      float dy = target.py - py;
      float dis = sqrt(dx*dx + dy*dy);

      px += dx*.25;
      py += dy*.25;


      if (dis<=.1) {
        actual = target;
        estado = 0;
        target = null;
      }

    }
  }


  public Coord sensorDerecho() {
    return m1.getDerecha(actual.plx, actual.ply);
  } 
  public Coord sensorIzquierda() {
    return m1.getIzquierda(actual.plx, actual.ply);
  } 
  public Coord sensorArriba() {
    return m1.getArriba(actual.plx, actual.ply);
  } 
  public Coord sensorAbajo() {
    return m1.getAbajo(actual.plx, actual.ply);
  } 


}







