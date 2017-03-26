/* Car class */
// At the moment, it's only used to create the car
// In the future, we could make some changes in the update function
// for turrets, drivers, etc
class Car {
  /* Parts */
  PointMass front;
  PointMass back;
  PointMass frontBottom;
  PointMass backBottom;
  
  PointMass frontSpring;
  PointMass backSpring;
  
  Circle frontWheel;
  Circle backWheel;
  
  /* Properties */
  int wide;
  int tall;
  int speed;
  
  // Direction the car is moving
  boolean movingForward = true;
  /* Constructor */
  Car (PVector pos, int wid, int tal, int wheelRadius, int speed) {
    wide = wid;
    tall = tal;
    
    // a and b are the spring lengths
    float a = tall;
    float b = 1.7 * tall;
    
    // Create front and back PointMasses
    front = new PointMass(new PVector(pos.x-(wide/2),pos.y));  
    back = new PointMass(new PVector(pos.x+(wide/2),pos.y));
    front.mass = 1.5;
    back.mass = 1.5;
    
    /* Create front and back bottom PointMasses */
    frontBottom = new PointMass(new PVector(pos.x-(wide/2),pos.y+tall));
    backBottom = new PointMass(new PVector(pos.x+(wide/2),pos.y+tall));
    frontBottom.mass = 3;
    backBottom.mass = 3;
    
    /* Create Spring PointMasses (the wheels attach to these */
    frontSpring = new PointMass(new PVector(pos.x-(wide/2),pos.y+40));
    backSpring = new PointMass(new PVector(pos.x+(wide/2),pos.y+40));
    frontSpring.mass = 2;
    backSpring.mass = 2;
        
    /* Attach the springs to each other */     
    front.attachTo(back, wide, 1, true, color(255));
    
    frontBottom.attachTo(front, tall, 1, true, color(255));
    backBottom.attachTo(back, tall, 1, true, color(255));
    
    frontBottom.attachTo(backBottom, wide, 1, true, color(255));
    backBottom.attachTo(frontBottom, wide, 1, true, color(255));
    
    frontBottom.attachTo(back, sqrt(sq(tall) + sq(wide)), 1, true, color(255));
    backBottom.attachTo(front, sqrt(sq(tall) + sq(wide)), 1, true, color(255));
    
    frontSpring.attachTo(frontBottom, a, 0.1, true, color(255));
    frontSpring.attachTo(front, b, 0.1, true, color(255));
    backSpring.attachTo(backBottom, a, 0.1, true, color(255));
    backSpring.attachTo(back, b, 0.1, true, color(255));
    

    // we use some fancy trig to find out the distance between the Springs and the top corners of the car
    // it might be a bit more convenient to just plot out the points on an XY grid and use dist() for the restingDistances
    // oh well!
    double theta = acos( (sq(tall) - sq(a) - sq(b)) / (-2 * a * b) );
    double theta2 = asin((a * sin(new Float(theta))) / tall);
    double theta5 = 90 - theta2 - theta;
    double d = a * cos(new Float(theta5));
    double e = a * sin(new Float(theta5));
    backSpring.attachTo(front, sqrt(sq((float)d + wide) + sq((float)e + tall)), 0.4, true, color(255));
    frontSpring.attachTo(back, sqrt(sq((float)d + wide) + sq((float)e + tall)), 0.4, true, color(255));

    /* Create the wheels */
    frontWheel = new Circle(frontSpring.position, wheelRadius);
    backWheel = new Circle(backSpring.position, wheelRadius);
    frontWheel.wheel = true;
    backWheel.wheel = true;
    frontWheel.force = speed;
    backWheel.force = speed;
    
    frontWheel.attachToPointMass(frontSpring);
    backWheel.attachToPointMass(backSpring);
  }
  /* Update */
  // Used mostly for calculating tilt based on what the user's pressing
  void update() {
    /* Center Of Mass */
    /* 
      The center of mass is calculated by taking each pointmass position,
      multiplying their mass, adding them together, then dividing by total mass
      (P1.pos * P1.mass + P2.pos * P2.mass + ...) / (P1.mass + P2.mass + ...)   
    */
    PVector cent = PVector.mult(frontBottom.position.get(), frontBottom.mass);
    cent.add(PVector.mult(backBottom.position, backBottom.mass));
    cent.add(PVector.mult(front.position, front.mass));
    cent.add(PVector.mult(back.position, back.mass));
    cent.add(PVector.mult(frontSpring.position, frontSpring.mass));
    cent.add(PVector.mult(backSpring.position, backSpring.mass));
    cent.div(frontBottom.mass + backBottom.mass + front.mass + back.mass + frontSpring.mass + backSpring.mass);
    
    if (keys[37]) { // Left
      // The car is tilted based on the direction it's moving
      // if we just moved one pointmass, or both, the car will turn awkwardly and float on some occasions
      if (movingForward) {
        // Calculate the angle perpendicular from the centerOfMass to back.position
        float angle = atan2(back.position.y - cent.y, back.position.x - cent.x) - PI/2;
        // Apply force
        back.applyForce(new PVector(7500 * cos(angle),
                                    7500 * sin(angle)));
      }
      else {
        float angle = atan2(front.position.y - cent.y, front.position.x - cent.x) - PI/2;
        front.applyForce(new PVector(7500 * cos(angle),
                                     7500 * sin(angle)));
      }                      
    }
    else if (keys[39]) { // Right
      if (movingForward) {
        float angle = atan2(back.position.y - cent.y, back.position.x - cent.x) + PI/2;
        back.applyForce(new PVector(7500 * cos(angle),
                                    7500 * sin(angle)));
      }
      else {
         float angle = atan2(front.position.y - cent.y, front.position.x - cent.x) + PI/2;
         front.applyForce(new PVector(7500 * cos(angle),
                                      7500 * sin(angle)));
      }                         
    }
  }
}
