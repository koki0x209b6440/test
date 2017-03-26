
//基本的な世界機能と、特にボールの衝突判定を実装
//今後、継承してWorldBoxllで直方体判定実装、WorldBoxlllなどで流体、というように
//継承でバージョンアップ(バージョン管理)して、最新型のEnvを使おう

class WorldBox {
  boolean isMouse=true,isKey=true;
  float x1, y1, z1,w,h,d,
         x2, y2, z2;
  float grav;
  float dt, fps;
  Object3D[] objs;
  
  float scaleValue=1.0f;

  final int TYPE_BALL = 0;
  
  WorldBox(float ix1, float iy1, float iz1,float iw, float ih,float id, float framerate){
    x1 = ix1;  y1 = iy1;  z1 = iz1;
    w=iw;  h=ih; d=id;
    x2 = ix1+iw;  y2 = iy1+ih;  z2 = iz1+id;
    fps = framerate;
    dt = 1 / fps;
    grav = 800;
    objs = new Object3D[1];
    objs[0] = new BasicBall3D(this, x1+w/2, y1+h/2, z1+d/2, 50, color(100, 80, 240));
    objs[0].conf_rate = 1.0;//各ボールのバウンド率
  }
  
  void update(){
    x2 = x1+w;  y2 = y1+h;  z2 = z1+d;
    if(keyPressed && keyCode==CONTROL) ;
    else mousework();
    //既存ボールの挙動(ボールと壁、ボール同士)
    for(int i=0; i<objs.length; i++)   objs[i].update();
    for(int i=0; i<objs.length; i++)
    {
      for(int j=i+1; j<objs.length; j++) collision(objs[i], objs[j]);
      bound(objs[i]);
    }
    disp();
  }
  
  //
  void mousework()
  {
    int i, j;
    dt = 1 / frameRate;
    boolean isWorkfinish=false;//ボールは一つしか掴まない、とかの判定
    
    
    //マウスがボールを掴む
    for(i=0; i<objs.length; i++)
    {
      //ここのmouseopは、ボール停止として機能する
      if(!isWorkfinish) isWorkfinish = objs[i].mouseop(mouseX, mouseY, mouseX, mousePressed);
      else break;
    }
    
    
    //if(objs.length>2)return;
    //マウスクリックによるボ—ルの生成
    //(生成自体ではなく、生成後、WorldBoxのワールド概念に支配される、という処理)
    if(keyPressed&&key=='b')//if( !isWorkfinish && mousePressed)//((mousePressed&&!pmousePressed)? true:false)
    {
      color c = color(random(200)+30, random(200)+30, random(200)+30);
      objs = (Object3D[]) append(objs, new ColorfulBall3D(this, x1+random(w/2), y1+random(h), z1+random(d/2), random(30)+40, c));
      objs[objs.length-1].conf_rate = 1.0;//各ボールのバウンド率
      //こっちはmouseopはボールが停止してくれなくなる機能
      //「マウスがボールを掴む」ことに関係しているのは間違いないが、この挙動はどういうことだ
      objs[objs.length-1].mouseop(mouseX, mouseY, mouseX,mousePressed);
    } 
    
    
    
  }
  
  
  void disp(){
    pushMatrix();
    //ambientLight(255, 255, 255);
    //directionalLight(100, 100, 100, 0, 1, 0);
    //pointLight(100, 100, 100, (x2+x1)/2, (y2+y1)*0.8, (z2+z1)*0.4);
    
    noFill();
    stroke(200, 100);
    translate( x1+(w/2), y1+(h/2), z1+(d/2) );
    box(w,h,d);
    popMatrix();
    
    for(int i=0; i<objs.length; i++)
    {
      if(objs[i].isWork)objs[i].disp();
    }
  }

  float getFricBound(){ return 0; }//ボールのバウンドはobj[].conf_rate　じゃあ、こいつは何だ？
                                              //ボール同士がぶつかったときの「フワッ」に関わってそう。0にするとよく浮く 
  float gravX(float ix, float iy, float iz)    { return 0; }
  float gravY(float ix, float iy, float iz)    { return grav; }
  float gravZ(float ix, float iy, float iz)    { return 0; }
  float gravMag(float ix, float iy, float iz){ return grav;}
  float fric(float ix, float iy, float iz, float ivx, float ivy, float ivz){ return 0; }
  float altitude(float ix, float iy, float iz){ return (y2 - iy); }
  /*
   +bound
    |      +-----boundX
    |      +-----boundY
    |      +-----boundZ
   +colidision
  */
  void bound(Object3D obj){
    if( obj.obj_type == TYPE_BALL ){
      BasicBall3D b = (BasicBall3D) obj;
      float adj_vel = 1;
      boolean bx = boundX(b);
      boolean by = boundY(b);
      boolean bz = boundZ(b);
      if(bx || by || bz){
        float v = mag(b.vx, b.vy, b.vz);
        float vv = 2 * ( b.eng / b.m - gravMag(b.x, b.y, b.z) * altitude(b.x, b.y, b.z) ) ;
        if(v > 0 && vv > 0) adj_vel = sqrt(vv) / v;
      }
      if(bx) b.vx *= - b.conf_rate * adj_vel;
      if(by) b.vy *= - b.conf_rate * adj_vel;
      if(bz) b.vz *= - b.conf_rate * adj_vel;
      if(bx || by || bz){
        b.calc_eng();
        b.on_collision = true;
        b.fric_rate = b.fric_rate_org + getFricBound();
      }
    }
  }
  boolean boundX(Object3D obj){
    if( obj.obj_type == TYPE_BALL ){
      BasicBall3D b = (BasicBall3D) obj;
      if( b.x <= x1 + b.r || x2 - b.r <= b.x ){
        b.x = constrain( b.x, x1 + b.r, x2 - b.r );
        return true;
      }
    }
    return false;
  }
  boolean boundY(Object3D obj){
    if( obj.obj_type == TYPE_BALL ){
      BasicBall3D b = (BasicBall3D) obj;
      if( b.y <= y1 + b.r || y2 - b.r <= b.y ){
        b.y = constrain( b.y, y1 + b.r, y2 - b.r );
        return true;
      }
    }
    return false;
  }
  boolean boundZ(Object3D obj){
    if( obj.obj_type == TYPE_BALL ){
      BasicBall3D b = (BasicBall3D) obj;
      if( b.z <= z1 + b.r || z2 - b.r <= b.z ){
        b.z = constrain( b.z, z1 + b.r, z2 - b.r );
        return true;
      }
    }
    return false;
  }
  void collision(Object3D o1, Object3D o2){
    if( !o1.enable_collision || !o2.enable_collision ) return;
    BasicBall3D b1, b2;
    if( o1.obj_type == TYPE_BALL && o2.obj_type == TYPE_BALL ){
      b1 = (BasicBall3D) o1;
      b2 = (BasicBall3D) o2;
      float px = b2.x - b1.x;
      float py = b2.y - b1.y;
      float pz = b2.z - b1.z;
      float dd = dist(0, 0, 0, px, py, pz);
      if( dd <= b1.r + b2.r ){
        b1.on_collision = b2.on_collision = true;
        b1.fric_rate = b2.fric_rate = b1.fric_rate_org + b2.fric_rate_org;
        b1.stopped = b2.stopped = false;
        float angA = atan2(pz, px);
        float angE = atan2(py, dist(0,0,px,pz));
        float sinA = sin(angA);
        float cosA = cos(angA);
        float sinE = sin(angE);
        float cosE = cos(angE);
        float tvx1 =   cosA*cosE*b1.vx + sinE*b1.vy + sinA*cosE*b1.vz;
        float tvy1 = - cosA*sinE*b1.vx + cosE*b1.vy - sinA*sinE*b1.vz;
        float tvz1 = -      sinA*b1.vx              +      cosA*b1.vz;
        float tvx2 =   cosA*cosE*b2.vx + sinE*b2.vy + sinA*cosE*b2.vz;
        float tvy2 = - cosA*sinE*b2.vx + cosE*b2.vy - sinA*sinE*b2.vz;
        float tvz2 = -      sinA*b2.vx              +      cosA*b2.vz;
        float m1 = b1.m;
        float m2 = b2.m;
        float conf = b1.conf_rate * b2.conf_rate;
        float tvx1n = ( ( m1 - conf*m2 ) * tvx1 + m2 * ( 1 + conf ) * tvx2 ) / ( m1 + m2 );
        float tvx2n = ( m1 * ( 1 + conf ) * tvx1 + ( m2 - conf*m1 ) * tvx2 ) / ( m1 + m2 );
        b1.vx =   cosA*cosE*tvx1n - cosA*sinE*tvy1 - sinA*tvz1;
        b1.vy =        sinE*tvx1n +      cosE*tvy1 ;
        b1.vz =   sinA*cosE*tvx1n - sinA*sinE*tvy1 + cosA*tvz1;
        b2.vx =   cosA*cosE*tvx2n - cosA*sinE*tvy2 - sinA*tvz2;
        b2.vy =        sinE*tvx2n +      cosE*tvy2 ;
        b2.vz =   sinA*cosE*tvx2n - sinA*sinE*tvy2 + cosA*tvz2;
        if(b1.fixed){
          b2.x += (b1.r + b2.r - dd) * px / dd;
          b2.y += (b1.r + b2.r - dd) * py / dd;
          b2.z += (b1.r + b2.r - dd) * pz / dd;
          b1.vx = b1.vy = b1.vz = 0;
        }
        else if(b2.fixed){
          b1.x += (b1.r + b2.r - dd) * (-px) / dd;
          b1.y += (b1.r + b2.r - dd) * (-py) / dd;
          b1.z += (b1.r + b2.r - dd) * (-pz) / dd;
          b2.vx = b2.vy = b2.vz = 0;
        }
        else{
          b1.x += (b1.r + b2.r - dd) * m2 / (m1 + m2) * (-px) / dd;
          b1.y += (b1.r + b2.r - dd) * m2 / (m1 + m2) * (-py) / dd;
          b1.z += (b1.r + b2.r - dd) * m2 / (m1 + m2) * (-pz) / dd;
          b2.x += (b1.r + b2.r - dd) * m1 / (m1 + m2) * px / dd;
          b2.y += (b1.r + b2.r - dd) * m1 / (m1 + m2) * py / dd;
          b2.z += (b1.r + b2.r - dd) * m1 / (m1 + m2) * pz / dd;
        }
        b1.calc_eng();
        b2.calc_eng();
      }
    }
  }
}


