
class ColorfulBall3D extends BasicBall3D
{

  ColorfulBall3D(WorldBox box, float in_x, float in_y, float in_z, float in_r, color in_col)
  {
    super(box, in_x,in_y,in_z,in_r,in_col);
  }
  void disp()
  {
    if( strk ) stroke(col_strk);
    else      noStroke();
    if( fil )    fill(col_fill);
    else      noFill();
    if( is_over ) fill(255, 0, 0);
    //本体
    pushMatrix();
    translate(x, y, z);
    sphere(r);
    popMatrix();
    //影   3次元の底に描かれるが、ここでは、2D画面で描くイメージでおk
    fill(255,0,0, 100);
    pushMatrix();
    rotateX(HALF_PI);
    translate(0,0,-box.y2);
    ellipse(x, z, 2*r, 2*r);
    popMatrix();
  }
  
}
