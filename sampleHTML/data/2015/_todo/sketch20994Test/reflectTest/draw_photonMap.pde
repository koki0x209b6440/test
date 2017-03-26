//---------------------------------------------------------------------------------------
//Photon Mapping ------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

float[] gatherPhotons(float[] p, int type, int id,int gTotal_object_idx){// gType,gID
  float[] energy = {0.0,0.0,0.0};  
  float[] N = surfaceNormal(type, gTotal_object_idx, p, gOrigin);                   //Surface Normal at Current Point
  for (int i = 0; i < numPhotons[type][id]; i++){                    //Photons Which Hit Current Object
    if (gatedSqDist3(p,photons[type][id][i][0],sqRadius)){           //Is Photon Close to Point?
      float weight = max(0.0, -dot3(N, photons[type][id][i][1] ));   //Single Photon Diffuse Lighting
      weight *= (1.0 - sqrt(gSqDist)) / exposure;                    //Weight by Photon-Point Distance
      energy = add3(energy, mul3c(photons[type][id][i][2], weight)); //Add Photon's Energy to Total
   }} 
  return energy;
}

boolean isEmitPhotons=false;
void emitPhotons(){
  randomSeed(0);                               //Ensure Same Photons Each Time     
   int targettype=0,j=0;  
   if(!isEmitPhotons)println("emitPhotons()   size()"+rayObjs.size() );
   for(int i=0; i<rayObjs.size(); i++)//Initialize Photon Count to Zero for Each Object
   {
     if(targettype==rayObjs.get(i).type || i==(rayObjs.size()-1) )
     {
       if(!isEmitPhotons)println(i+"\t numPhotons["+targettype+"]["+j+"]");
       numPhotons[targettype][j++]=0;
     }
     else{ targettype++; i--; j=0; }
   }
   isEmitPhotons=true;

  for (int i = 0; i < (view3D ? nrPhotons * 3.0 : nrPhotons); i++){ //Draw 3x Photons For Usability
    int bounces = 1;
    float[] rgb = {1.0,1.0,1.0};               //Initial Photon Color is White
    float[] ray = normalize3( rand3(1.0) );    //Randomize Direction of Photon Emission
    float[] prevPoint = Light;                 //Emit From Point Light Source
    
    //Spread Out Light Source, But Don't Allow Photons Outside Room/Inside Sphere
    while (prevPoint[1] >= Light[1]){ prevPoint = add3(Light, mul3c(normalize3(rand3(1.0)), 0.75));}
    if (abs(prevPoint[0]) > 1.5 || abs(prevPoint[1]) > 1.2 ||
        gatedSqDist3(prevPoint,rayObjs.get(0),rayObjs.get(0).z*rayObjs.get(0).z)) bounces = nrBounces+1;
    
    raytrace(ray, prevPoint);                          //Trace the Photon's Path
    
    while (gIntersect && bounces <= nrBounces){        //Intersection With New Object
        gPoint = add3( mul3c(ray,gDist), prevPoint);   //3D Point of Intersection
        rgb = mul3c (getColor(rgb,gType,gIndex), 1.0/sqrt(bounces));
        storePhoton(gType, gIndex, gPoint, ray, rgb);  //Store Photon Info 
        drawPhoton(rgb, gPoint);                       //Draw Photon
        shadowPhoton(ray);                             //Shadow Photon
        ray = reflect(ray,prevPoint);                  //Bounce the Photon
        raytrace(ray, gPoint);                         //Trace It to Next Location
        prevPoint = gPoint;
        bounces++;}
  }
}

void storePhoton(int type, int id, float[] location, float[] direction, float[] energy){
  photons[type][id][numPhotons[type][id]][0] = location;  //Location
  photons[type][id][numPhotons[type][id]][1] = direction; //Direction
  photons[type][id][numPhotons[type][id]][2] = energy;    //Attenuated Energy (Color)
  numPhotons[type][id]++;
}

void shadowPhoton(float[] ray){                               //Shadow Photons
  float[] shadow = {-0.25,-0.25,-0.25};
  float[] tPoint = gPoint; 
  int tType = gType, tIndex = gIndex;                         //Save State
  float[] bumpedPoint = add3(gPoint,mul3c(ray,0.00001));      //Start Just Beyond Last Intersection
  raytrace(ray, bumpedPoint);                                 //Trace to Next Intersection (In Shadow)
  float[] shadowPoint = add3( mul3c(ray,gDist), bumpedPoint); //3D Point
  storePhoton(gType, gIndex, shadowPoint, ray, shadow);
  gPoint = tPoint; gType = tType; gIndex = tIndex;            //Restore State
}

float[] filterColor(float[] rgbIn, float r, float g, float b){ //e.g. White Light Hits Red Wall
  float[] rgbOut = {r,g,b};
  for (int c=0; c<3; c++) rgbOut[c] = min(rgbOut[c],rgbIn[c]); //Absorb Some Wavelengths (R,G,B)
  return rgbOut;
}

void drawPhoton(float[] rgb, float[] p){           //Photon Visualization
  if (view3D && p[2] > 0.0){                       //Only Draw if In Front of Camera
    int x = (szImg/2) + (int)(szImg *  p[0]/p[2]); //Project 3D Points into Scene
    int y = (szImg/2) + (int)(szImg * -p[1]/p[2]); //Don't Draw Outside Image
    if (y <= szImg) {stroke(255.0*rgb[0],255.0*rgb[1],255.0*rgb[2]); point(x,y);}}
}

float[] getColor(float[] rgbIn, int type, int index){ //Specifies Material Color of Each Object
  if      (type == 1 && index == 0) { return filterColor(rgbIn, 0.0, 1.0, 0.0);}
  else if (type == 1 && index == 2) { return filterColor(rgbIn, 1.0, 0.0, 0.0);}
  else                              { return filterColor(rgbIn, 1.0, 1.0, 1.0);}
}
