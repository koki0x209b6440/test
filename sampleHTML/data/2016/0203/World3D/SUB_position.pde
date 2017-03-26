
PVector cameraPos = new PVector(0, 0, 0);
PVector cameraRot = new PVector(0, 0, 0);
PVector cameraTargetPos = new PVector(0, 0, 0);
float cameraTargetR = 1000.0f;

boolean pmousePressed = mousePressed; // 前回のマウス押下情報


// 現在のカメラパラメータを設定
void setCamera() {
  cameraPos.x = cameraTargetPos.x + sin(cameraRot.y) * cameraTargetR * cos(cameraRot.x);
  cameraPos.y = sin(cameraRot.x) * cameraTargetR;
  cameraPos.z = cameraTargetPos.z + cos(cameraRot.y) * cameraTargetR * cos(cameraRot.x);
  camera(cameraPos.x, cameraPos.y, cameraPos.z, cameraTargetPos.x, cameraTargetPos.y, cameraTargetPos.z, 0,1,0);
  perspective(PI/3.0, (float)width/(float)height, 1, 5000);
}

float mouse3DPosX=0,mouse3DPosZ=0,mouse3DPosY=0;
// マウス位置から見たXZ平面上の交点を取得
PVector getXZPlaneMousePos(boolean isDebugdraw) {
  // スクリーン座標をモデル座標に変換
  PVector lineBegin = unprojectScreen(new PVector(mouseX, mouseY, 0));
  PVector lineEnd = unprojectScreen(new PVector(mouseX, mouseY, 1));
  // XZ平面上の位置を計算
  PVector planePos = new PVector(0,mouse3DPosY,0);
  PVector planeNormal = new PVector(0,-1, 0);
  PVector mousePlanePos = getPlaneIntersection(planePos, planeNormal, lineBegin, lineEnd, false);
  if(mousePlanePos!=null)
  {
    //mouse3DPosY=mousePlanePos.y;
    mouse3DPosX=mousePlanePos.x;
    mouse3DPosZ=mousePlanePos.z;
  }
  //drawXZGrid( (int)planePos.y,color(255,0,0),   200, 20);
  if(mousePlanePos!=null && isDebugdraw)
  {
    strokeWeight(2);
    pushMatrix();
    translate(mousePlanePos.x,mousePlanePos.y,mousePlanePos.z);
    stroke(200, 0, 0, 128); 
    line(-200, 0, 0, 200, 0, 0);
    stroke(0, 200, 0, 128); 
    line(0, -200, 0, 0, 200, 0);
    //noStroke(); fill(0, 255, 0, 255); box(100);
    popMatrix();
  }
  return mousePlanePos;
}
PVector getXYPlaneMousePos(boolean isDebugdraw) {
  // スクリーン座標をモデル座標に変換
  PVector lineBegin = unprojectScreen(new PVector(mouseX, mouseY, 0));
  PVector lineEnd = unprojectScreen(new PVector(mouseX, mouseY, 1));
  // XZ平面上の位置を計算
  PVector planePos = new PVector(mouse3DPosX,0,mouse3DPosZ);
  PVector planeNormal = new PVector(-1,0, 0);
  PVector mousePlanePos = getPlaneIntersection(planePos, planeNormal, lineBegin, lineEnd, false);
  if(mousePlanePos!=null)
  {
    mouse3DPosY=mousePlanePos.y;
  }
  if(mousePlanePos!=null && isDebugdraw)
  {
    strokeWeight(2);
    pushMatrix();
    translate(mousePlanePos.x,mousePlanePos.y,mousePlanePos.z);
    stroke(0, 200, 0, 128); 
    line(0, -200, 0, 0, 200, 0);
    stroke(0, 0, 200, 128); 
    line(0, 0, -200, 0, 0, 200);
    //noStroke(); fill(0, 255, 0, 255); box(100);
    popMatrix();
  }
  return mousePlanePos;
}

// モデル座標をスクリーン座標に変換する行列を取得
// MODEが大事
PMatrix3D getModelToScreenMatrix() {
  PMatrix3D projection = new PMatrix3D();
  matrixMode(PROJECTION); getMatrix(projection);//おそらくここで、絶対座標と等価の変換行列(カメラ位置を考慮していない物)をゲット
  
  PMatrix3D modelview = new PMatrix3D();
  matrixMode(MODELVIEW); getMatrix(modelview);//おそらくここで、相対座標と等価の変換行列(translate…などの適用先の座標)をゲット

  PMatrix3D viewport = new PMatrix3D();
  viewport.m03 = viewport.m00 = width * 0.5f;
  viewport.m13 = viewport.m11 = height * 0.5f;

  PMatrix3D m = new PMatrix3D(modelview);
  m.preApply(projection);
  m.preApply(viewport);
  return m;
}

// (行列をwで)割ったものを返す
PVector matrixCMult(PMatrix3D m, PVector v) { 
  PVector ov = new PVector();
  ov.x = m.m00*v.x + m.m01*v.y + m.m02*v.z + m.m03;
  ov.y = m.m10*v.x + m.m11*v.y + m.m12*v.z + m.m13;
  ov.z = m.m20*v.x + m.m21*v.y + m.m22*v.z + m.m23;
  float w = m.m30*v.x + m.m31*v.y + m.m32*v.z + m.m33;
  if(w!=0) ov.mult(1.0f / w);
  return ov;
}

// モデル座標をスクリーン座標に変換
PVector projectScreen(PVector v) {
  PMatrix3D m = getModelToScreenMatrix();
  return matrixCMult(m, v);
}

// スクリーン座標をモデル座標に変換
PVector unprojectScreen(PVector v) {
  PMatrix3D m = getModelToScreenMatrix();
  m.invert();
  return matrixCMult(m, v);
}

// 平面と点の距離を取得
float getPlaneDistance(PVector planePos, PVector planeNormal, PVector pointPos) {
  return PVector.dot(planeNormal, PVector.sub(pointPos, planePos));
}

// 平面と線分の交差判定・交点計算
PVector getPlaneIntersection(PVector planePos, PVector planeNormal, PVector lineBegin, PVector lineEnd, boolean useRangeCheck) {
  PVector lineDirVec = PVector.sub(lineEnd, lineBegin);
  float distanceEnd = -PVector.dot(planeNormal, lineDirVec);
  if(0.0f==distanceEnd) return null; // 面と平行？

  float distancePlane = getPlaneDistance(planePos, planeNormal, lineBegin);
  if(distancePlane<=0.0f) return null; // 面の裏側？

  float lineDirVecParameter = distancePlane / distanceEnd;
  if(useRangeCheck) {
    if(lineDirVecParameter<0.0f || lineDirVecParameter>1.0f) return null; // 線分の範囲外？
  }

  PVector intersectionPos = PVector.add(lineBegin, PVector.mult(lineDirVec, lineDirVecParameter));
  return intersectionPos;
}
