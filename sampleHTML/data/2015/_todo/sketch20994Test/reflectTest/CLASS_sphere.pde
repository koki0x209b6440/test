
class RayObjectList //自由に配置できる「エディットモード」で使えるだろうし、他にもちょっと役立つ。
{
   ArrayList<RayObject> sampleList=new ArrayList<RayObject>();
   int types=0;
   RayObjectList()
   {
      addList(new RaySphere(this) );
      addList(new RayPlane(this) );
   }
   void addList(RayObject obj)
   {
      sampleList.add(obj);
      types++;
   }
   RayObject findObj(String target_name)
   {
      for(int i=0; i<sampleList.size(); i++)
      {
        if(target_name.equals(sampleList.get(i).name) ) return sampleList.get(i);
      }
      return null;
   }
}
class RayObject
{
   int type;
   String name="RayObject";
   float x,y,z,r;
   float axisType,distance;//distance=(center to Plane) distance
   
   RayObject(){ }
   RayObject(RayObjectList rayObjList){   type=rayObjList.types;   }//addList()の処理により、typeにはちゃんとクラス名毎に別の値が入ることになるはず。
   RayObject syncSampleList(RayObjectList rayObjList)
   {
      type=rayObjList.findObj(name).type;
      return this;
   }
   String getClassName()
   {
      String str=""+this;//ProjectionTest_koba$SceneList@1931579
      String[] strArray1=str.split("Test");
      String[] strArray2=strArray1[1].split("@");
      return strArray2[0];
   }
}


class RaySphere extends RayObject
{
   
   RaySphere(RayObjectList rayObjList,float x,float y, float z,float r)
   {
      //RaySphere(1.0,   1.0,   4.0,   0.5)
      //RaySphere(-0.6, -1.0,  4.5,   0.5)
      super();
      this.name=getClassName();//this.name=name wo uketukeru?
      syncSampleList(rayObjList);
      this.x=x;
      this.y=y;
      this.z=z;
      this.r=r;
   }
   RaySphere(RayObjectList rayObjList){   super(rayObjList);  this.name=getClassName(); }
}
