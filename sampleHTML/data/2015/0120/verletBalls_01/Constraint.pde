
class Constraint {

  Point point1;
  Point point2;
  float target;

  Constraint(Point p1, Point p2) {
    point1 = p1;
    point2 = p2;
    target = PVector.dist(point1.position, point2.position);
  }

  void draw() {
    PVector pos1 = point1.position; 
    PVector pos2 = point2.position;
    float deviation = target - PVector.dist(pos1, pos2);
    int color_diff = round(deviation * deviation * 512);
    stroke((128+color_diff), (128-color_diff), (128-color_diff));
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }

  void resolve() {
    PVector direction = PVector.sub(point2.position, point1.position);
    float len = direction.mag();
    float factor = (len - target) / (len * TIGHTNESS);
    PVector correction = PVector.mult(direction, factor);
    
    point1.correct(correction);
    correction.mult(-1);
    point2.correct(correction);
  }
}

