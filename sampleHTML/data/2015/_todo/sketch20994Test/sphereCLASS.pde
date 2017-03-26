

//---------------------------------------------------------------------------------------
//Ray-Geometry Intersections  -----------------------------------------------------------
//---------------------------------------------------------------------------------------


int nrTypes;                  //2 Object Types (Sphere = 0, Plane = 1)
int[] nrObjects;          //2 Spheres, 5 Planes
float[][] spheres;         //Sphere Center & Radius
float[][] planes; //Plane Axis & Distance-to-Origin
void Hairetu_List_sync()
{
  nrTypes=rayObjList.types;
  int targettype=0,j=0;
  ArrayList<Integer> nrObjectsNum=new ArrayList<Integer>();
   for(int i=0; i<rayObjs.size(); i++)//Initialize Photon Count to Zero for Each Object
   {
     if(targettype==rayObjs.get(i).type) j++;
     if(targettype!=rayObjs.get(i).type || i==(rayObjs.size()-1) )
     {
       if(i==(rayObjs.size()-1)) j++;
       if(targettype==0)   spheres=new float[j][4];
       if(targettype==1)   planes=new float[j][2];
       nrObjectsNum.add(new Integer(j) );
       targettype++;
       j=0;
     }
   }
   nrObjects=new int[nrObjectsNum.size()];
   for(int i=0; i<nrObjectsNum.size(); i++)  nrObjects[i]=nrObjectsNum.get(i).intValue(); 
   
   j=0;
   targettype=0;
   RayObject obj;
   for(int i=0; i<rayObjs.size(); i++)//Initialize Photon Count to Zero for Each Object
   {
     if(targettype==nrTypes+1) break;
     if(targettype==rayObjs.get(i).type)
     {
       if(targettype==0){obj=rayObjs.get(i); spheres[j][0]=obj.x; spheres[j][1]=obj.y; spheres[j][2]=obj.z; spheres[j][3]=obj.r;}
       if(targettype==1){obj=rayObjs.get(i); planes[j][0]=obj.axisType;   planes[j][1]=obj.distance;   }
       j++;
     }
     else{   targettype++; i--; j=0;   }
   }
}



//描画(設置)処理   影付けとかは全く全然
void rayObject(int type, int idx, float[] r, float[] o){
  if (type == 0) raySphere(idx,r,o);
  else rayPlane(idx,r,o);
}

void raySphere(int idx, float[] r, float[] o) //Ray-Sphere Intersection: r=Ray Direction, o=Ray Origin
{ 
  float[] s = sub3(spheres[idx],o);  //s=Sphere Center Translated into Coordinate Frame of Ray Origin
  float radius = spheres[idx][3];    //radius=Sphere Radius
  
  //Intersection of Sphere and Line     =       Quadratic Function of Distance
  float A = dot3(r,r);                       // Remember This From High School? :
  float B = -2.0 * dot3(s,r);                //    A x^2 +     B x +               C  = 0
  float C = dot3(s,s) - sq(radius);          // (r'r)x^2 - (2s'r)x + (s's - radius^2) = 0
  float D = B*B - 4*A*C;                     // Precompute Discriminant
  
  if (D > 0.0){                              //Solution Exists only if sqrt(D) is Real (not Imaginary)
    float sign = (C < -0.00001) ? 1 : -1;    //Ray Originates Inside Sphere If C < 0
    float lDist = (-B + sign*sqrt(D))/(2*A); //Solve Quadratic Equation for Distance to Intersection
    checkDistance(lDist,0,idx);}             //Is This Closest Intersection So Far?
}

void rayPlane(int idx, float[] r, float[] o){ //Ray-Plane Intersection
  int axis = (int) planes[idx][0];            //Determine Orientation of Axis-Aligned Plane
  if (r[axis] != 0.0){                        //Parallel Ray -> No Intersection
    float lDist = (planes[idx][1] - o[axis]) / r[axis]; //Solve Linear Equation (rx = p-o)
    checkDistance(lDist,1,idx);}
}

void checkDistance(float lDist, int p, int i){
  if (lDist < gDist && lDist > 0.0){ //Closest Intersection So Far in Forward Direction of Ray?
    gType = p; gIndex = i; gDist = lDist; gIntersect = true;} //Save Intersection in Global State
}


/*
　マウスとsperesの当たり判定。
　しかし、マウス以外との当たり判定にも使っているようだ……？
*/
boolean gatedSqDist3(float[] a, float[] b, float sqradius){ //Gated Squared Distance
  float c = a[0] - b[0];          //Efficient When Determining if Thousands of Points
  float d = c*c;                  //Are Within a Radius of a Point (and Most Are Not!)
  if (d > sqradius) return false; //Gate 1 - If this dimension alone is larger than
  c = a[1] - b[1];                //         the search radius, no need to continue
  d += c*c;
  if (d > sqradius) return false; //Gate 2
  c = a[2] - b[2];
  d += c*c;
  if (d > sqradius) return false; //Gate 3
  gSqDist = d;      return true ; //Store Squared Distance Itself in Global State
}
