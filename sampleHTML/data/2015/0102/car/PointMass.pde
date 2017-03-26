// PointMass
// This is pretty much the Particle class used in Curtain
// http://www.openprocessing.org/visuals/?visualID=20140
class PointMass {
  // for calculating position change (velocity)
  PVector lastPosition;
  PVector position;
  PVector acceleration; 

  float mass = 1;

  // An ArrayList for links, so we can have as many links as we want to this PointMass
  ArrayList links = new ArrayList();

  // For pinning the PointMass
  // This isn't used in this code
  boolean pinned = false;
  PVector pinLocation = new PVector(0, 0);

  
  boolean attachedToMouse = false;

  boolean touchingGround = false;
  /* PointMass constructor */
  PointMass (PVector pos) {
    position = pos.get();
    lastPosition = pos.get();
    acceleration = new PVector(0, 0);
    
    // add the PointMass to the world object
    world.addPointMass(this);
  }
  
  /* Physics */
  // The update function is used to update the physics of the particle.
  // motion is applied, and links are drawn here
  void updatePhysics (float timeStep) { 
    // gravity:
    // f(gravity) = m * g
    PVector fg = new PVector(0, mass * world.gravity, 0);
    this.applyForce(fg);
  
    /*
       We use Verlet Integration to simulate the physics
       In Verlet Integration, the rule is simple: any change in position will result in a change of velocity
       Therefore, things in motion will stay in motion. If you want to push a PointMass towards a direction,
       just move its position and it'll continue going that way.   
    */
    // velocity = position - lastPosition
    PVector velocity = PVector.sub(position, lastPosition);
    // Slight friction is applied
    velocity.mult(0.999); 
    // newPosition = position + velocity + 0.5 * acceleration * deltaTime * deltaTime
    PVector nextPos = PVector.add(PVector.add(position, velocity), PVector.mult(PVector.mult(acceleration, 0.5), timeStep * timeStep));
    // reset the variables
    lastPosition.set(position);
    position.set(nextPos);
    acceleration.set(0, 0, 0);
  
    // make sure the particle stays in its place if it's pinned
    // (This isn't used for this simulation, but it's there anyways.)
    if (pinned)
      position.set(pinLocation);
  }
  
  /* Interaction updating */
  void updateInteractions () {
    // this is where our interaction comes in.
    if (mousePressed) {
      if (mouseAttachedToSomething == false) {
        float distanceSquared = sq(tmouseX - position.x) + sq(mouseY - position.y);
        if (mouseButton == LEFT) {
          // if (dist * dist < radius * radius), 
          // remember mouseInfluenceSize was squared in setup()
          if (distanceSquared < mouseInfluenceSize) { 
            // Attach to mouse
            attachedToMouse = true;
            mouseAttachedToSomething = true;
            attachedPM = this;
          }
        }
        else { // if the right mouse button is clicking, we tear this by removing links
          if (distanceSquared < mouseTearSize) 
            links.clear();
        }
      }
    }
    // if the player isn't clicking, we make sure the PointMass isn't still attached to the cursor
    else if (attachedToMouse) {
      mouseAttachedToSomething = false;
      attachedToMouse = false;
    }
  }
  
  /* Draw */
  void draw () {
    // draw the links and points
    stroke(0);
    if (links.size() > 0) {
      for (int i = 0; i < links.size(); i++) {
        Link currentLink = (Link) links.get(i);
        // Use the link's draw function
        currentLink.draw();
      }
    }
    else
      point(position.x, position.y);
  }
  
  /* Constraint Solving */
  // here we tell each Link to solve constraints
  void solveConstraints () {
    touchingGround = false;
    
    for (int i = 0; i < links.size(); i++) {
      Link currentLink = (Link) links.get(i);
      currentLink.solveConstraints();
    }

    // Make sure the particle isn't intersecting the ground
    // First we generate the surface if it doesn't exist
    if (surface.containsKey((int)position.x) == false)
      surfaceGenerate((int)position.x);
    // Then we move the PointMass up if it's below the surface at the PointMass's x position
    float ground = (Float)surface.get((int)position.x);
    if (position.y > ground-1) {
      position.y = 2 * (ground - 1) - position.y;
      lastPosition.x = (position.x + lastPosition.x)/2;
      touchingGround = true;
    }
      
    // Make sure the PointMass isn't above the screen
    if (position.y < 1)
      position.y = 2 - position.y;
    
    // Move the PointMass to the cursor if it's attached
    if (attachedToMouse)
      position.set(tmouseX, mouseY, 0);
  }

  /* Attaching Links */
  // attachTo can be used to create links between this particle and other particles
  Link attachTo (PointMass P, float restingDist, float stiff, boolean drawThis) {
    Link lnk = new Link(this, P, restingDist, stiff, drawThis);
    
    links.add(lnk);
    return lnk;
  }
  // same as the first attachTo, but with colors!
  Link attachTo (PointMass P, float restingDist, float stiff, boolean drawThis, color col) {
    Link lnk = new Link(this, P, restingDist, stiff, drawThis);
    lnk.col = col;

    links.add(lnk);
    return lnk;
  }
  
  /* Removing Links */
  void removeLink (Link lnk) {
    links.remove(lnk);
  }  
  void removeLink (PointMass P) {
    for (int i = 0; i < links.size(); i++) {
      Link lnk = (Link) links.get(i);
      if ((lnk.p1 == P) || (lnk.p2 == P))
        links.remove(i);
    }
  }

  void applyForce (PVector f) {
    // acceleration = (1/mass) * force
    // or
    // acceleration = force / mass
    acceleration.add(PVector.div(f, mass));
  }

  void pinTo (PVector location) {
    pinned = true;
    pinLocation.set(location);
  }
}

