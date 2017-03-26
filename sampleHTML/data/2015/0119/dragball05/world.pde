//基本的な世界機能と、特にボールの衝突判定を実装
//今後、継承してWorldBoxllで直方体判定実装、WorldBoxlllなどで流体、というように
//継承でバージョンアップ(バージョン管理)して、最新型のEnvを使おう

class WorldBoxll extends WorldBox
{
  WorldBoxll(PApplet iap, float ix1, float iy1, float iz1, float ix2, float iy2, float iz2, float framerate)
  {
    super(iap,ix1,iy1,iz1,ix2,iy2,iz2,framerate);
  }
  void bound(Object3D obj)
  {
     super.bound(obj);
    //if(obj.obj_type==TYPE_RECT)
  }
  float gravX(float ix, float iy, float iz)    { return grav; }
  float gravY(float ix, float iy, float iz)    { return 0; }
  float gravZ(float ix, float iy, float iz)    { return 0; }
  
}
