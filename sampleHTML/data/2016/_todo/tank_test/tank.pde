class Tank
{
  // The 3D meshes that make up the tank
  Object turret;
  Object body;
  Object tracks;
  Object gun;
  Object gears;
  
  float max_vel = 6.0;       // max forward velocity
  float min_vel = -3.5;      // max reverse velocity
                             
  float max_rot = 0.025;     // rotation at full velocity
  float min_rot = 0.005;     // rotation at 0 velocity
  
  PVector loc;               // 3D location
  float vel;                 // velocity
  
  // 2D spring of X and Y rotations to simulate
  // the tank's suspension
  Spring2D rot = new Spring2D();
  float rotZ;                // Z rotation in 3D space
  
  // Camera targeting. Use a spring to give a smooth feel
  Spring camZ = new Spring(-HALF_PI, -HALF_PI, 8, .3, .6);
  float offset = 0.0;        // offset so we can look around easier
  
  // Easy way to handle input for now
  HashMap<Character, Boolean> keys = new HashMap<Character, Boolean>();
  
  Tank(PApplet _applet, String model_name)
  {
    // instead of hard coding this, read in 
    // a model file in the future 
    
    // Load in the objects
    turret = new Object(_applet, "turret.obj");
    body = new Object(_applet, "body.obj");
    tracks = new Object(_applet, "tracks.obj");
    gears = new Object(_applet, "gears.obj");
    gun = new Object(_applet, "gun.obj");
    gun.model.translateToCenter();
    
    // Set up world coordinates
    loc = new PVector(0,0,0);
    
    // Go ahead and set up keyboard input to false
    keys.put('w', false);
    keys.put('a', false);
    keys.put('s', false);
    keys.put('d', false);
    
    // Set up values for the suspension
    rot.x = new Spring(0.0, 0.0, 8, .1, .9);
    rot.y = new Spring(0.0, 0.0, 8, .1, .9);
  }
  
  void draw()
  {
    // Setup the camera
    translate(width / 2, height / 2, 0);  // center of screen
    rotateX(QUARTER_PI * 1.5);            // move camera up
    rotateZ(camZ.val + offset);           // rotate around turret
    
    // Draw the gun, do some extra manipulations here
    // since the gun does not rotate around its center
    pushMatrix();
    rotateY(map(mouseY, 0, height, -.2, .2));
    translate(65, 0, 0);
    gun.model.draw();
    popMatrix();
    
    // Draw the turret
    translate(-75, 0, -75);
    turret.model.draw();
    
    // Rotate the body
    rotateZ(map(mouseX, 0, width, 2.5, -2.5));
    body.model.draw();
    
    // Adjust the suspension
    rotateY(rot.y.val);
    rotateX(rot.x.val);
    translate(0, 0, -4);  // minor adjustment
    gears.model.draw();
    tracks.model.draw();
    
    // Set up tank in world coords
    rotateZ(t.rotZ);
    translate(-t.loc.x, t.loc.y, 0);
  }
  
  void update(float delta)
  {
    PVector rotvel;
    float prevrotZ = rotZ;
    float prevvel = vel;
    
    // update internal vals based on input
    input_update();
    
    // Move the tank forward (relative to rotZ)
    rotvel = new PVector(vel, 0, 0);
    rotvel.rotate(rotZ);
    loc.add(rotvel);
  
    // loose velocity
    if(!keys.get('w') && !keys.get('s'))
      vel *= .98;
    
    // Side to side suspension. Adjust by rate of rotation
    // and a little by the velocity
    rot.addForceX((rotZ - prevrotZ) * vel * .075);
    
    // Front to back suspension. Adjust by rate of velocity change
    // and keep a little of the velocity even when acceleration is 0
    rot.addForceY((vel - prevvel) * .08 + vel * .0015);
    
    // Now that forces have been added, update the values
    rot.update();
    
    // constrain rotations
    rot.x.val = constrain(rot.x.val, radians(-6), radians(6));
    rot.y.val = constrain(rot.y.val, radians(-6), radians(7));
    
    // Handle camera
    float rotdiff = map(pmouseX, 0, width, 2.5, -2.5) - map(mouseX, 0, width, 2.5, -2.5);
    rotdiff -= ((rotZ - prevrotZ) * 2.5);
    camZ.addForce(rotdiff);
    camZ.update();
    
    if(vel >= -0.001 && vel <= 0.001)
      vel = 0.0;
    
    //println(vel);
  }

  void input_update()
  {
    boolean is_turning = false;
    
    // The faster the tank is going, the faster it can rotate
    // Reverse rotation direction based on forward or reverse direction
    float rotval = map(abs(vel), 0.0, max_vel, min_rot, max_rot);
    rotval = (vel >= 0.0 ? rotval : -rotval);
    
    // Scale down the acceleration as velocity increases
    float accel = map(abs(vel), 0.0, max_vel, 0.15, .01);
    //accel = (keys.get('s') == false ? accel : accel * abs(min_vel/max_vel));
    
    // Check input
    if(keys.get('w'))
    {
      vel += accel;
    }
    if(keys.get('s'))
    {
      vel -= accel;
    }
    
    if(keys.get('a'))
    {
      rotZ += rotval;
      is_turning = true;
    }
    else if(keys.get('d'))
    {
      rotZ -= rotval;
      is_turning = true;
    }
    
    // max and min velocity
    // TODO: come up with something better to slow down while turning
    // assumably cant have full speed when turning
    //if(is_turning && vel > max_vel - 2.0)
    //  vel *= .98;
    //else
      vel = constrain(vel, min_vel, max_vel);
  }
  
  void keyInput(char k, boolean val)
  {
    keys.put(k, val);
  }
  
  void mouseInput(boolean dragged)
  {
    if(mouseButton == LEFT && !dragged)
      shoot();
    if(mouseButton == CENTER && dragged)
      offset += ((mouseX - pmouseX) * .005);
  }
  
  void shoot()
  {
    // Add a force to the tank to simulate the main gun shooting
    // A force is applied at the guns angle
    PVector force = new PVector(0, 0.2);
    
    // The angle of the gun is directly related to the position of the mouse
    float angle = map(mouseX, 0, width, 2.5, -2.5);
    
    // Rotate it by the angle of the main gun
    force.rotate(-angle);
    
    // Add the pvector to the 2D spring
    rot.addForce(force);
  }
}
