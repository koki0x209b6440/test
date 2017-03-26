float  angle;

void camera_control()
{
  if(mousePressed) angle += radians(mouseX - pmouseX);
  if(angle >= TWO_PI) angle -= TWO_PI;
  if(angle < 0) angle += TWO_PI;
  camera(5000.0*cos(angle), -300, 5000.0*sin(angle), 0, 0, 0, 0, 1, 0);
}

