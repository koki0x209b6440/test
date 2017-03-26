// The Link class is used for handling distance constraints between particles.
class Link {
  float restingDistance;
  float stiffness;
  
  PointMass p1;
  PointMass p2;
  
  // the scalars are how much "tug" the particles have on each other
  // this takes into account masses and stiffness, and is calculated in the Link constructor
  float scalarP1;
  float scalarP2;
  
  // set drawThis to false to make the link invisible
  boolean drawThis;
  color col = color(0);
  
  // Tearing isn't necessary, so I set it to a ridiculously high number.
  int tearThreshold = 100000;
  
  /* Constructor */
  Link (PointMass which1, PointMass which2, float restingDist, float stiff, boolean drawMe) {
    // When an object is ='d to another object, it's actually a reference, rather than a copy.
    // so stuff done to p1 and p2 here is actually done to the PointMasses in the World ArrayList
    p1 = which1;
    p2 = which2;
    
    restingDistance = restingDist;
    stiffness = stiff;
    
    // Masses are accounted for. If you remember the cloth simulator,
    // http://www.openprocessing.org/visuals/?visualID=20140
    // we added this ability in anticipation of future applets that might use mass
    float im1 = 1 / p1.mass; 
    float im2 = 1 / p2.mass;
    scalarP1 = (im1 / (im1 + im2)) * stiffness;
    scalarP2 = (im2 / (im1 + im2)) * stiffness;
    
    drawThis = drawMe;
  }
  
  /* Constraint solving */
  void solveConstraints () {
    // calculate the distance between the two particles
    PVector delta = PVector.sub(p1.position, p2.position);  
    float d = sqrt(delta.x * delta.x + delta.y * delta.y);
    float difference = (restingDistance - d) / d;
    
    // Tearing
    // In previous codes (Curtain, Ragdoll Aquarium), the link is removed
    // Here, (although not used), the link is split in half
    if (d > tearThreshold)  {
      p1.removeLink(this);
      if (drawThis) {
        this.snap(PVector.div(PVector.add(p2.position, p1.position),2));
      }
    }

    // P1.position += delta * ((1 / p1.mass) / ((1 / p1.mass) + (1 / p2.mass))) * stiffness * difference
    // P2.position -= delta * ((1 / p2.mass) / ((1 / p1.mass) + (1 / p2.mass))) * stiffness * difference
    p1.position.add(PVector.mult(delta, scalarP1 * difference));
    p2.position.sub(PVector.mult(delta, scalarP2 * difference));
  }
  
  /* Snap */
  // This function snaps the link at a certain position
  // Snap isn't used in this simulator, but it can be used in the future
  void snap (PVector pos) {
    /* If there's too many PointMasses, the link is just removed and the code is stopped */
    if (world.pointMasses.size() > 2500) {
      p1.removeLink(this);
      return;
    }

    // Remove the link so we can create 2 smaller links
    p1.removeLink(this);

    // Find the distances between each PointMass and the pos and use it as a ratio for the restingDistance
    float dist1 = dist(pos.x, pos.y, p1.position.x, p1.position.y);
    float dist2 = dist(pos.x, pos.y, p2.position.x, p2.position.y);
    
    // if the link's already really small, we just keep it removed
    if (dist1 + dist2 > 4) {
      // Calculate the distances for each side
      float p1OwnerLength = (dist1/(dist1+dist2)) * restingDistance;
      float p2OwnerLength = (dist2/(dist1+dist2)) * restingDistance;
      
      // Create link on one side
      PointMass p1Owner = new PointMass(pos);
      p1Owner.lastPosition = pos.get();
      p1Owner.mass = p2.mass/2;
      p2.mass = p2.mass/2;
      p1Owner.attachTo(p1, p1OwnerLength, stiffness, drawThis, color(0,0,0));
      
      // Create link on the other side
      PointMass p2Owner = new PointMass(pos);
      p2Owner.lastPosition = pos;
      p2Owner.mass = p1.mass/2;
      p1.mass = p1.mass/2;
      p2Owner.attachTo(p2, p2OwnerLength, stiffness, drawThis, color(0,0,0));
      
      // Set the links' tearThresholds
      Link newLink = (Link) p1Owner.links.get(p1Owner.links.size()-1);
      newLink.tearThreshold = tearThreshold;
      Link newLink2 = (Link) p2Owner.links.get(p2Owner.links.size()-1);
      newLink2.tearThreshold = tearThreshold;
    }
  }
  /* Draw */
  void draw () {
    // Make sure the line will be 1 pixel wide
    strokeWeight(1);
    if (drawThis) { // some links are invisible
      stroke(col);
      line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
    }
  }
}
