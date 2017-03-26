

class Point {

  PVector position;
  PVector previous;
  PVector acceleration;

  Point(float x, float y) {
    position = new PVector(x, y);
    previous = new PVector(x, y);
    acceleration = new PVector(0, 0);

  }

  void accelerate(PVector vector) {
    acceleration.add(vector);
  }

  void correct(PVector vector) {
    position.add(vector);
  }

  void simulate(float delta) {
    acceleration.mult(delta*delta);

    PVector pos = PVector.mult(position, 2);
    pos.sub(previous);
    pos.add(acceleration);
    
    previous = position;
    position = pos;
    acceleration.set(0, 0, 0);
  }

  void draw() {
    fill(128, 128, 128);
    ellipse(position.x, position.y, 2.5, 2.5);
  }

  void draw_highlighted() {
    fill(255, 0, 0);
    ellipse(position.x, position.y, 5, 5);
  }
}


class FixedPoint extends Point {
  /*
  We have FixedPoint extend Point so they can live in the same ArrayLists.
  */

  FixedPoint(float x, float y) {
    super(x,y);
  }

  void accelerate(PVector vector) {
  }

  void simulate() {
  }

  void correct(PVector vector) {
  }

  void draw() {
    fill(255, 128, 21);
    ellipse(position.x, position.y, 2.5, 2.5);
  }

  void draw_highlighted() {
    fill(255, 0, 0);
    ellipse(position.x, position.y, 5, 5);
  }
}

