float EqTriangle( float x, float y, float a, char whichPoint, char whichDimension) {
  float pointAx, pointBx, pointCx, pointAy, pointBy, pointCy;
  float h = sqrt(sq(a)-sq(a/2));
  float g = h/3;

  pointAx = x-(a/2);
  pointAy = y+g;

  pointBx = x;
  pointBy = y-(g*2);

  pointCx = x+(a/2);
  pointCy = y+g;

  if (whichPoint == 'A') {
    if (whichDimension == 'x') {
      return pointAx;
    } 
    else if (whichDimension == 'y') {
      return pointAy;
    }
  } 
  else if (whichPoint == 'B') {
    if (whichDimension == 'x') {
      return pointBx;
    } 
    else if (whichDimension == 'y') {
      return pointBy;
    }
  } 
  else if (whichPoint == 'C') {
    if (whichDimension == 'x') {
      return pointCx;
    } 
    else if (whichDimension == 'y') {
      return pointCy;
    }
  }
  return 0;
}
