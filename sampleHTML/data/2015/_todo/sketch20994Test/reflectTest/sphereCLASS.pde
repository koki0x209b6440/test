

//---------------------------------------------------------------------------------------
//Ray-Geometry Intersections  -----------------------------------------------------------
//---------------------------------------------------------------------------------------








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
boolean gatedSqDist3(float[] a,RayObject sphere, float sqradius){ //Gated Squared Distance
  float c = a[0] - sphere.x;          //Efficient When Determining if Thousands of Points
  float d = c*c;                  //Are Within a Radius of a Point (and Most Are Not!)
  if (d > sqradius) return false; //Gate 1 - If this dimension alone is larger than
  c = a[1] - sphere.y;                //         the search radius, no need to continue
  d += c*c;
  if (d > sqradius) return false; //Gate 2
  c = a[2] - sphere.z;
  d += c*c;
  if (d > sqradius) return false; //Gate 3
  gSqDist = d;      return true ; //Store Squared Distance Itself in Global State
}

