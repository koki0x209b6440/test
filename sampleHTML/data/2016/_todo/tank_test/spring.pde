class Spring
{
  float val;     // val
  float mass;    // mass
  float k;       // spring constant
  float damp;    // damping
  float rest;    // rest position
  
  float vel = 0.0;
  
  Spring(float v)
  {
    this(v, v, 5.0, 0.1, .9);
  }
  
  Spring(float v, float r, float m, float _k, float d)
  {
    val = v;
    rest = r;
    mass = m;
    k = _k;
    damp = d;
  }
  
  void addForce(float force)
  {
    // double check...
    vel += ((-k * (val - rest) + force) / mass);
  }
  
  void update()
  {
    float force = -k * (val - rest);
    float accel = force / mass;
    vel = damp * (vel + accel);
    
    val = val + vel;
  }
}

class Spring2D
{
  Spring x;
  Spring y;
  
  Spring2D()
  {
  }
  
  void update()
  {
    x.update();
    y.update();
  }
  
  void addForceX(float force)
  {
    x.addForce(force);
  }
  
  void addForceY(float force)
  {
    y.addForce(force);
  }
  
  void addForce(PVector force)
  {
    y.addForce(force.y);
    x.addForce(force.x);
  }
}
