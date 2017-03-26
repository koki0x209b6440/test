

void render(){ //Render Several Lines of Pixels at Once Before Drawing
  int x,y,iterations = 0;
  float[] rgb = {0.0,0.0,0.0};
  
  pg.beginDraw();
  while (iterations < (mouseDragging ? 1024 : max(pMax, 256) ))
  {
  
    //Render Pixels Out of Order With Increasing Resolution: 2x2, 4x4, 16x16... 512x512
    //描画の処理。まずは解像度が低い。
    if (pCol >= pMax)
    {
      pRow++; pCol = 0; 
      if (pRow >= pMax)
      {
        pIteration++; pRow = 0; pMax = int(pow(2,pIteration));
      }
    }
    boolean pNeedsDrawing = (pIteration == 1 || odd(pRow) || (!odd(pRow) && odd(pCol)));
    x = pCol * (szImg/pMax); y = pRow * (szImg/pMax);
    pCol++;
    
    if (pNeedsDrawing){
      iterations++;
      rgb = mul3c( computePixelColor(x,y), 255.0);               //All the Magic Happens in Here!
      pg.stroke(rgb[0],rgb[1],rgb[2]); fill(rgb[0],rgb[1],rgb[2]);  //Stroke & Fill
      pg.strokeWeight(1);
      //pg.strokeWeight((szImg/pMax)-1);
      pg.point(x,y);
      pg.rect(x,y,(szImg/pMax)-1,(szImg/pMax)-1);
    }                  //Draw the Possibly Enlarged Pixel
  }
  pg.updatePixels();
  pg.endDraw();
  if (pRow == szImg-1) {empty = false;}
  
  image(pg,0,0,width,height);
}

float[] computePixelColor(float x, float y){
  float[] rgb = {0.0,0.0,0.0};
  float[] ray = {  x/szImg - 0.5 ,       //Convert Pixels to Image Plane Coordinates
                 -(y/szImg - 0.5), 1.0}; //Focal Length = 1.0
  raytrace(ray, gOrigin);                //Raytrace!!! - Intersected Objects are Stored in Global State

  if (gIntersect){                       //Intersection                    
    gPoint = mul3c(ray,gDist);           //3D Point of Intersection
    
    //gType==0(=球)の一番目を、鏡面処理する
    if (gType == 0 && gIndex >=0){      //Mirror Surface on This Specific Object
      ray = reflect(ray,gOrigin);        //Reflect Ray Off the Surface
      raytrace(ray, gPoint);             //Follow the Reflected Ray
      if (gIntersect){ gPoint = add3( mul3c(ray,gDist), gPoint); }//特にここが鏡面反射の肝
    } //3D Point of Intersection 
    
    if (lightPhotons){                   //Lighting via Photon Mapping
     rgb = gatherPhotons(gPoint,gType,gIndex,gTotal_object_idx);
    }else{                                //Lighting via Standard Illumination Model (Diffuse + Ambient)
      int tType = gType, tIndex = gIndex;//Remember Intersected Object
      float i = gAmbient;                //If in Shadow, Use Ambient Color of Original Object
      //raytrace( sub3(gPoint,Light) , Light);  //Raytrace from Light to Object
      if (tType == gType && tIndex == gIndex) //Ray from Light->Object Hits Object First?
        //i = lightObject(gType, gIndex, gPoint, gAmbient); //Not In Shadow - Compute Lighting
      rgb[0]=i; rgb[1]=i; rgb[2]=i;
      rgb = getColor(rgb,tType,tIndex);}
      
  }
  return rgb;
}

/////////////////////////////////////////////////////////////////////////////





