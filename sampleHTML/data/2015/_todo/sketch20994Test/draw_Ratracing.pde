//---------------------------------------------------------------------------------------
// Raytracing ---------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

void raytrace(float[] ray, float[] origin)
{
  gIntersect = false; //No Intersections Along This Ray Yet
  gDist = 999999.9;   //Maximum Distance to Any Object
  
  for (int t = 0; t < nrTypes; t++)
    for (int i = 0; i < nrObjects[t]; i++)
      rayObject(t,i,ray,origin);
}


float[] reflect(float[] ray, float[] fromPoint){                //Reflect Ray
  float[] N = surfaceNormal(gType, gIndex, gPoint, fromPoint);  //Surface Normal
  return normalize3(sub3(ray, mul3c(N,(2 * dot3(ray,N)))));     //Approximation to Reflection
}
