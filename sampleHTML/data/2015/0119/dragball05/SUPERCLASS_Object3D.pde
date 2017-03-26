
class Object3D {
  WorldBox box;
  int obj_type;
  float x, y, z,vx, vy, vz,ax, ay, az;
  float m;
  float eng;
  boolean strk,fil;
  color col_strk,col_fill;
  boolean enable_drag,enable_collision;
  boolean fixed;
  float conf_rate,fric_rate,fric_rate_org,stop_vel;
  boolean on_drag, on_collision, stopped;
  float px, py, pz, pvx, pvy, pvz;
  float mdiffx, mdiffy, mdiffz;

  Object3D (WorldBox box, float in_x, float in_y, float in_z, float in_m
               , boolean in_strk, color in_col_strk, boolean in_fil, color in_col_fill
               , int type){
    init_param();
    this.box=box;
    x = px = in_x;
    y = py = in_y;
    z = pz = in_z;
    m = in_m;
    strk = in_strk;
    fil = in_fil;
    col_strk = in_col_strk;
    col_fill = in_col_fill;
    obj_type = type;
    calc_eng();
  }

  void init_param(){
    box = null;
    x = y = z = vx = vy = vz = ax = ay = az = 0;
    m = 1;
    eng = 0;
    col_strk = color(128);
    col_fill = -1;
    enable_drag = enable_collision = true;
    fixed = false;
    conf_rate = 0.9;
    fric_rate = fric_rate_org = 50;
    stop_vel = 1;
    on_drag = on_collision = stopped = false;
    pvx = pvy = pvz = px = py = pz = 0;
    mdiffx = mdiffy = mdiffz = 0;
  }
  
  void calc_eng(){
    eng = m * box.gravMag(x, y, z) * box.altitude(x, y, z)
        + m * ( vx*vx + vy*vy + vz*vz ) / 2;
  }

  boolean mouseop(float mx, float my, float mz, boolean pressed, boolean clicked){
    if(enable_drag){
      if( over(mx, my, mz) && clicked && !on_drag ){
        on_drag = stopped = true;
        box.boundX(this);
        box.boundY(this);
        box.boundZ(this);
        px = x;
        py = y;
        pz = z;
        vx = vy = vz = pvx = pvy = pvz = 0;
        mdiffx = mx - x;
        mdiffy = my - y;
        mdiffz = mz - z;
      }
      else if( pressed && on_drag ){
        //�ʒu�̍X�V
        x = mx - mdiffx;
        y = my - mdiffy;
        z = mz - mdiffz;
        box.boundX(this);
        box.boundY(this);
        box.boundZ(this);
        //���x�̍X�V
        if( box.dt != 0 ){
          float cvx = (x - px) / box.dt;
          float cvy = (y - py) / box.dt;
          float cvz = (z - pz) / box.dt;
          //��O�̑��x�ƕ��ς����
          vx = (cvx + pvx) / 2;
          vy = (cvy + pvy) / 2;
          vz = (cvz + pvz) / 2;
          pvx = cvx;
          pvy = cvy;
          pvz = cvz;
        }
        else{ vx = vy = vz = 0; }
        px = x;
        py = y;
        pz = z;
      }
      else if( !pressed && on_drag ){
        on_drag = stopped = false;
        calc_eng();
      }
      else return false;
      return true;
    }
    else return false;
  }
  
  void update(){
    if( !fixed && !on_drag && !stopped ){
      update_accel();
      
      vx += ax * box.dt;
      vy += ay * box.dt;
      vz += az * box.dt;
      
      x += vx * box.dt;
      y += vy * box.dt;
      z += vz * box.dt;
      //println(x+" "+y+" "+z);
      if( mag(vx, vy, vz) < stop_vel
          && ( box.gravMag(x, y, z) == 0 || on_collision ) ){
        stopped = true;
        vx = vy = vz = 0;
        ax = ay = az = 0;
      }
    }
    on_collision = false;
  }

  void update_accel(){
    float fric = box.fric(x, y, z, vx, vy, vz) + ( on_collision ? fric_rate : 0 );
    float vv = mag(vx, vy, vz);
    if( vv > 0 ){
      ax = box.gravX(x, y, z) - (fric * vx / vv) ;
      ay = box.gravY(x, y, z) - (fric * vy / vv) ;
      az = box.gravZ(x, y, z) - (fric * vz / vv) ;
    }
    else{
      ax = box.gravX(x, y, z);
      ay = box.gravY(x, y, z);
      az = box.gravZ(x, y, z);
    }
    //println("a "+ax+" "+ay+" "+az);
  }

  //当たり判定の拡張性の余地
  boolean over(float mx, float my, float mz){
    return false;
  }
  void disp(){   }
}
