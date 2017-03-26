//---------------------------------------------------------------------------------------
// Lighting -----------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

float[] surfaceNormal(int type, int total_object_idx, float[] P, float[] Inside){
  if (type == 0) {return sphereNormal(total_object_idx,P);}
  else           {return planeNormal(total_object_idx,P,Inside);}
}

float lightDiffuse(float[] N, float[] P){  //Diffuse Lighting at Point P with Surface Normal N
  float[] L = normalize3( sub3(Light,P) ); //Light Vector (Point to Light)
  return dot3(N,L);                        //Dot Product = cos (Light-to-Surface-Normal Angle)
}

float[] sphereNormal(int total_object_idx, float[] P){
  return normalize3(sub3(P,rayObjs.get(total_object_idx) )); //Surface Normal (Center to Point)
}

float[] planeNormal(int total_object_idx, float[] P, float[] O){
  int axis = (int)( rayObjs.get(total_object_idx).axisType );
  float [] N = {0.0,0.0,0.0};
  N[axis] = O[axis] - rayObjs.get(total_object_idx).distance;      //Vector From Surface to Light
  return normalize3(N);
}



float lightObject(int type, int total_object_idx, float[] P, float lightAmbient){
  float i = lightDiffuse( surfaceNormal(type, total_object_idx, P, Light) , P );
  return min(1.0, max(i, lightAmbient));   //Add in Ambient Light by Constraining Min Value
}

