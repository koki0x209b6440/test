







//---------------------------------------------------------------------------------------
//Vector Operations ---------------------------------------------------------------------
//---------------------------------------------------------------------------------------

float[] normalize3(float[] v){        //Normalize 3-Vector
  float L = sqrt(dot3(v,v));
  return mul3c(v, 1.0/L);
}

float[] sub3(RayObject sphere, float[] b){   //Subtract 3-Vectors
  float[] result = {sphere.x - b[0], sphere.y - b[1], sphere.z - b[2]};
  return result;
}
float[] sub3(float[] a,RayObject sphere){   //Subtract 3-Vectors
  float[] result = {a[0] - sphere.x, a[1] - sphere.y, a[2] - sphere.z};
  return result;
}
float[] sub3(float[] a, float[] b){   //Subtract 3-Vectors
  float[] result = {a[0] - b[0], a[1] - b[1], a[2] - b[2]};
  return result;
}

float[] add3(float[] a, float[] b){   //Add 3-Vectors
  float[] result = {a[0] + b[0], a[1] + b[1], a[2] + b[2]};
  return result;
}

float[] mul3c(float[] a, float c){    //Multiply 3-Vector with Scalar
  float[] result = {c*a[0], c*a[1], c*a[2]};
  return result;
}

float dot3(float[] a, float[] b){     //Dot Product 3-Vectors
  return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

float[] rand3(float s){               //Random 3-Vector
  float[] rand = {random(-s,s),random(-s,s),random(-s,s)};
  return rand;
}



//---------------------------------------------------------------------------------------
// User Interaction and Display ---------------------------------------------------------
//---------------------------------------------------------------------------------------
boolean empty = true, view3D = false; //Stop Drawing, Switch Views
PFont font; PImage img1, img2, img3;  //Fonts, Images
int pRow, pCol, pIteration, pMax;     //Pixel Rendering Order
boolean odd(int x) {return x % 2 != 0;}

