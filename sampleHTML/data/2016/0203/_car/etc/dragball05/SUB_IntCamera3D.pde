
class IntCamera3D {
  WorldBox box;      //��
  float angA, angE;  //��ʊp�A�p
  float cx, cy, cz;  //�J�������S
  float r;           //�J�����ړ����a
  float fov;         //�J��������p
  float x, y, z;     //�J�����ʒu
  
  float cosE, sinE, cosA, sinA;
  int tb;
  
  IntCamera3D (WorldBox ibox, float ifov, float icx, float icy, float icz, float ir, float ia, float ie){
    box = ibox;
    fov = ifov;
    cx = icx;  cy = icy;  cz = icz;
    r = ir;
    angA = ia;
    angE = ie;
    calc_cam_xyz();
  }
  
  //�p�x����J�������W���v�Z
  void calc_cam_xyz(){
    cosE = cos(angE);
    sinE = sin(angE);
    cosA = cos(angA);
    sinA = sin(angA);
    if( angE == HALF_PI ) tb = -1;
    else if( angE == -HALF_PI ) tb = 1;
    else tb = 0;
    x = r * cosA * cosE   + cx;
    y = r * sinE          + cy;
    z = r * sinA * cosE   + cz;
  }

  //�J�����̑���
  boolean operate(){
    if( IntKey.shift && IntMouse.pressed ){
      angA += ((IntMouse.x - IntMouse.px)/float(width) * PI);
      angA %= TWO_PI;
      angE -= ((IntMouse.y - IntMouse.py)/float(height) * PI);
      angE = constrain(angE, -HALF_PI+0.01, HALF_PI-0.01);
      calc_cam_xyz();
      return true;
    }
    else if( IntKey.ctrl && IntMouse.pressed ){
      float prod = (IntMouse.x - width/2)*(IntMouse.x - IntMouse.px)
                 + (IntMouse.y - height/2)*(IntMouse.y - IntMouse.py);
      float d1 = mag(IntMouse.x - width/2, IntMouse.y - height/2);
      float d2 = mag(IntMouse.x - IntMouse.px, IntMouse.y - IntMouse.py);
      float dd = d2 * cos( acos( prod / (d1*d2) ) );
      if( dd > -100 && dd < 100 ) fov -= dd/150;
      fov = constrain(fov, PI/16, PI*0.9);
      return true;
    }
    else return false;
  }

  //�J�����̕\���ݒ�  
  void disp(){
    perspective(fov, 1, r/10.0, r*2);
    camera( x, y, z, cx, cy, cz, cosA*tb, 1, sinA*tb);
    //println("camera("+x+","+y+","+z+",     "+cx+","+cy+","+cz+",     "+(cosA*tb)+","+(sinA*tb)+");" );
  }
}
