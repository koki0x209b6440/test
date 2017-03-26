
PVector mouse3DPos=new PVector(0,200,0);

void position_system()
{
  setCamera();
  if(keyPressed && keyCode==CONTROL) mouse_camera_work();
  else getMouse3DPos();
  
}

void getMouse3DPos()
{
  if(keyPressed && key=='z') mouse3DPos=getXYPlaneMousePos(true);
  else mouse3DPos=getXZPlaneMousePos(true);
  if( mouse3DPos!=null)
  {
    pushMatrix();
    translate(mouse3DPos.x, mouse3DPos.y, mouse3DPos.z);
    //stroke(255,0,0,255); line(-width,0,0,width,0,0); line(0,-height,0,0,height,0);
    popMatrix();
  }
}
void mouse_camera_work()
{
  // マウス操作
  if(mousePressed)
  {
    float moveX = mouseX-pmouseX;
    float moveY = mouseY-pmouseY;
    if(abs(moveX)>0 || abs(moveY)>0 || !pmousePressed)
    {
      if(keyPressed && keyCode==CONTROL)
      {
        // カメラ位置をターゲットを中心に回転
        cameraRot.y += radians(-moveX);
        cameraRot.x += radians(-moveY);
        cameraRot.x = constrain(cameraRot.x, radians(-89), radians(89));
        setCamera();
      }
    }
  }
  pmousePressed = mousePressed;
  
}
