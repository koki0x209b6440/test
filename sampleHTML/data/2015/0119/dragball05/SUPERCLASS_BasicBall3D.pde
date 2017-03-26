class BasicBall3D extends Object3D
{
  float r;
  boolean is_over;//

  BasicBall3D (WorldBox box, float in_x, float in_y, float in_z, float in_r, color in_col)
  {
    super(box, in_x, in_y, in_z, pow(in_r, 3), false, 0, true, in_col, box.TYPE_BALL);
    r =in_r;
    is_over = true;
    conf_rate = 0.9;
    fric_rate = fric_rate_org = 50;
    stop_vel = 1;
  }
  boolean over(float mx, float my, float mz)  //円球的当たり判定の実装
  {
    float a = mx - box.cam.x;
    float b = my - box.cam.y;
    float c = mz - box.cam.z;
    float k = ( a*x + b*y + c*z - ( a*box.cam.x + b*box.cam.y + c*box.cam.z ) ) / ( a*a + b*b + c*c );
    if( k > 0 && dist( box.cam.x + k*a, box.cam.y + k*b, box.cam.z + k*c, x, y, z) <= r ) is_over = true;
    else is_over = false;
    return is_over;
  }
  
  int arpha_animation_count=110,
      d_arpha_animation_count=2;
  void disp()
  {
    r= 50;   //DEBUG
    
    //球状の当たり判定だけ可視化
    stroke(0,0,255,arpha_animation_count+=d_arpha_animation_count);
    fill(0,0,255,arpha_animation_count);
    if(arpha_animation_count     <=100||200<=     arpha_animation_count)  d_arpha_animation_count*=-1;
    pushMatrix();
    translate(x, y, z);
    sphere(r);
    popMatrix();
    
    //影   3次元の底に描かれるが、ここでは、2D画面で描くイメージでおk
    noStroke();
    fill(0,0,0, 100);
    pushMatrix();
    rotateX(HALF_PI);
    translate(0, 0, -box.z2);
    ellipse(x, z, 2*r, 2*r);
    popMatrix();
  }
}
