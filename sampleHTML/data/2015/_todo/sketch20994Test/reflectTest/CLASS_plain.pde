

class RayPlane extends RayObject
{
   RayPlane(RayObjectList rayObjList,float axisType,float distance)
   {
      //RayPlane(0, 1.5)
      //RayPlane(1, -1.5)
      //RayPlane(0, -1.5)
      //RayPlane(1, 1.5)
      //RayPlane(2,5.0)
      super();
      this.name=getClassName();//this.name=name wo uketukeru?
      syncSampleList(rayObjList);
      this.axisType=axisType;
      this.distance=distance;
   }
   RayPlane(RayObjectList rayObjList){   super(rayObjList);  this.name=getClassName(); }
}

