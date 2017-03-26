//---------------------------------------------------------------------------------------
// Raytracing ---------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

boolean isRaytrace=false;
void raytrace(float[] ray, float[] origin)
{
  gIntersect = false; //No Intersections Along This Ray Yet
  gDist = 999999.9;   //Maximum Distance to Any Object
  
   int targettype=0,j=0;  
   if(!isRaytrace)println("rayrace()");
   for(int i=0; i<rayObjs.size(); i++)//Initialize Photon Count to Zero for Each Object
   {
         if(targettype==rayObjs.get(i).type)
         {
           if(!isRaytrace)println("\t rayObject(..."+rayObjs.get(i).type+"..."+i+","+j+")");
           rayObject(rayObjs.get(i).type,j++,ray,origin,i);
         }
         else{ targettype++; i--; j=0; }
   }
   isRaytrace=true;
}

//描画(設置)処理   影付けとかは全く全然
void rayObject(int type, int idx, float[] r, float[] o,int total_object_idx){
  if (type == 0) raySphere(idx,r,o,total_object_idx);
  else rayPlane(idx,r,o,total_object_idx);
}

void raySphere(int idx, float[] r, float[] o,int total_object_idx) //Ray-Sphere Intersection: r=Ray Direction, o=Ray Origin
{ 
  float[] s = sub3( rayObjs.get(total_object_idx),o);  //s=Sphere Center Translated into Coordinate Frame of Ray Origin
  float radius = rayObjs.get(total_object_idx).z;    //radius=Sphere Radius
  
  //Intersection of Sphere and Line     =       Quadratic Function of Distance
  float A = dot3(r,r);                       // Remember This From High School? :
  float B = -2.0 * dot3(s,r);                //    A x^2 +     B x +               C  = 0
  float C = dot3(s,s) - sq(radius);          // (r'r)x^2 - (2s'r)x + (s's - radius^2) = 0
  float D = B*B - 4*A*C;                     // Precompute Discriminant
  
  if (D > 0.0){                              //Solution Exists only if sqrt(D) is Real (not Imaginary)
    float sign = (C < -0.00001) ? 1 : -1;    //Ray Originates Inside Sphere If C < 0
    float lDist = (-B + sign*sqrt(D))/(2*A); //Solve Quadratic Equation for Distance to Intersection
    checkDistance(lDist,0,idx,total_object_idx);}             //Is This Closest Intersection So Far?
}

void rayPlane(int idx, float[] r, float[] o,int total_object_idx){ //Ray-Plane Intersection
  int axis = (int)(rayObjs.get(total_object_idx).axisType);            //Determine Orientation of Axis-Aligned Plane
  if (r[axis] != 0.0){                        //Parallel Ray -> No Intersection
    float lDist = (rayObjs.get(total_object_idx).distance - o[axis]) / r[axis]; //Solve Linear Equation (rx = p-o)
    checkDistance(lDist,1,idx,total_object_idx);}
}

void checkDistance(float lDist, int p, int i,int total_object_idx){
  //println(total_object_idx);
  if (lDist < gDist && lDist > 0.0){ //Closest Intersection So Far in Forward Direction of Ray?
    gType = p; gIndex = i; gTotal_object_idx=total_object_idx;  gDist = lDist; gIntersect = true;} //Save Intersection in Global State
}

float[] reflect(float[] ray, float[] fromPoint){                //Reflect Ray
  float[] N = surfaceNormal(gType, gTotal_object_idx, gPoint, fromPoint);  //Surface Normal
  return normalize3(sub3(ray, mul3c(N,(2 * dot3(ray,N)))));     //Approximation to Reflection
}
