
/*
　nodesを新しく配置しなおすことで、車のモデル(の頂点)を決める。
　nodesには当たり判定処理も自動付属する。
　このときは、draw_body();はメソッド毎なくすか、super…の行だけにする。

　頂点以外で見た目をモデリングするなら、車本体はdraw_body()、ホイールのdraw_custom()でsphereとかboxとか。
　当たり判定はnodesの方。見た目には依存しない。
*/

class CustomCar extends Car
{
   Lamp lamp;
   CustomCar(PVector xo)
   {
      super(xo,0.1,1.0,1.0);//xyz,  speed,  body,  carheight(wheel)     //ただしbodyは実体がばがば。地面にめりこむ事多々。
   }
   void custom_body()
   {
     super.custom_body();
     /*
     nodes[0] = new PVector(0.24,-0.18,0.225);
     nodes[1] = new PVector(-0.24,-0.18,0.225);
     nodes[2] = new PVector(0.36,-0.18,0.045);
     nodes[3] = new PVector(-0.36,-0.18,0.045);
     nodes[4] = new PVector(0.36,-0.9,0.045);
     nodes[5] = new PVector(-0.36,-0.9,0.045);
     nodes[6] = new PVector(0.36,-0.9,-0.225);
     nodes[7] = new PVector(-0.36,-0.9,-0.225);
     */
   }
   void draw_body_custom()
   {
     if(lamp==null) lamp=new Lamp(nodes[0].x,nodes[0].y,nodes[0].z,20);
     lamp.x=nodes[0].x;
     lamp.y=nodes[0].y;
     lamp.z=nodes[0].z;
     lamp.draw();
     
     
     //fill(200,0,0,150);
     //pushMatrix();
     //translate(nodes[0].x,nodes[0].y,nodes[0].z);
     super.draw_body_custom();
     //popMatrix();
   }
   void setWheel(PVector xo)
   {
     wheel=new CustomWheel[wheelR.length];
     for(int i=0; i<wheelR.length; i++) wheel[i]=new CustomWheel(PVector.add(wheelR[i],xo) );
   }
}
class CustomWheel extends Wheel
{
   CustomWheel(PVector xo)
   {
      super(xo);
   }
   void draw_custom()
   {
      fill(200,0,0,150);
      //super();   //はしない。
      //pushMatrix()  not need.
      //sphere(car.wheelRad*2*scaleFactor);//templete
      sphere(car.wheelRad*2*scaleFactor   *1.5);
      //popMatrix()  not need.
   }
}
