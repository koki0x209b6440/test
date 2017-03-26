
static class IntMouse {
  static boolean clicked, pressed, p_pressed;
  static float x, y; 
  static float px, py; 
}

static class IntKey {
  static boolean shift, ctrl, kx, ky, kz;
  static boolean kx_prs, ky_prs, kz_prs; 
  static boolean kx_rls, ky_rls, kz_rls; 
  static boolean pkx, pky, pkz; 
}



class IntMouse3D {
  WorldBox box;      //��
  float x, y, z, px, py, pz;
  float d;
  float d_org;
  float fix_x, fix_y, fix_z;

  IntMouse3D(WorldBox in_box, float in_d){
    box = in_box;
    d = d_org = in_d;
    x = px = IntMouse.x;
    y = py = (box.y1 + box.y2) / 2;
    z = pz = IntMouse.y;
    fix_x = fix_y = fix_z = 0;
  }
  
  boolean operate(){
    px = x;  py = y;  pz = z;
    if(IntKey.kz){
      x = IntMouse.x;
      y = IntMouse.y;
      return true;
    }
    else if(IntKey.kx){
      z = IntMouse.x;
      y = IntMouse.y;
      return true;
    }
    else{
      x = IntMouse.x;
      z = IntMouse.y;
    }
    x = constrain(x, box.x1, box.x2);
    y = constrain(y, box.y1, box.y2);
    z = constrain(z, box.z1, box.z2);
    return false;
  }
  
  void disp(){
    if( !IntKey.shift && !IntKey.ctrl ){
      noFill();
      stroke(255, 150, 150);
      if(IntKey.kz){
        beginShape();
        vertex( box.x1, box.y1, z);
        vertex( box.x2, box.y1, z);
        vertex( box.x2, box.y2, z);
        vertex( box.x1, box.y2, z);
        endShape(CLOSE);
      }
      else if(IntKey.kx){
        beginShape();
        vertex( x, box.y1, box.z1);
        vertex( x, box.y1, box.z2);
        vertex( x, box.y2, box.z2);
        vertex( x, box.y2, box.z1);
        endShape(CLOSE);
      }
      else{
        beginShape();
        vertex( box.x1, y, box.z1);
        vertex( box.x1, y, box.z2);
        vertex( box.x2, y, box.z2);
        vertex( box.x2, y, box.z1);  
        endShape(CLOSE);
      }
      stroke(255, 150, 150);
      beginShape(LINES);
      vertex( box.x1,      y,      z);
      vertex( box.x2,      y,      z);
      vertex(      x, box.y1,      z);
      vertex(      x, box.y2,      z);
      vertex(      x,      y, box.z1);
      vertex(      x,      y, box.z2);
      endShape();
    }
  }
}
