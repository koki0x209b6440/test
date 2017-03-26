
//基本的な世界機能と、特にボールの衝突判定を実装
//今後、継承してWorldBoxllで直方体判定実装、WorldBoxlllなどで流体、というように
//継承でバージョンアップ(バージョン管理)して、最新型のEnvを使おう

class WorldBox {
  PApplet ap;
  IntCamera3D cam;
  IntMouse3D m3d;
  boolean isMouse=true,isKey=true;
  float x1, y1, z1, x2, y2, z2;
  float grav;
  float fric_bound;//ボールのバウンドはobj[].conf_rate　じゃあ、こいつは何だ？
                          //ボール同士がぶつかったときの「フワッ」に関わってそう。0にするとよく浮く
  float dt, fps;
  Object3D[] objs;
  
  float scaleValue=1.0f;

  final int TYPE_BALL = 0;
  
  WorldBox(PApplet iap, float ix1, float iy1, float iz1, float ix2, float iy2, float iz2, float framerate){
    ap = iap;
    x1 = ix1;  y1 = iy1;  z1 = iz1;
    x2 = x1+ix2;  y2 = y1+iy2;  z2 = z1+iz2;
    fps = framerate;
    dt = 1 / fps;
    grav = 800;
    fric_bound = 0;
    cam = new IntCamera3D(this, PI/5.7, (x2+x1)/2, (y2+y1)/2, (z2+z1)/2, (x2-x1)*3, HALF_PI, -0.2);
    m3d = new IntMouse3D(this, cam.r);
    objs = new Object3D[1];
    objs[0] = new BasicBall3D(this, (x2+x1)/2, (y2+y1)/2, (z2+z1)/2, 20, color(100, 80, 240));
    objs[0].conf_rate = 0.5;//各ボールのバウンド率
  }
  
  void update(){
    x2 = x1+x2;  y2 = y1+y2;  z2 = z1+z2;
    if(isKey)update_key();
    if(isMouse)update_mouse();
    
    int i, j;
    dt = 1 / frameRate;
    boolean fk = cam.operate();
    if(!fk) m3d.operate();
    
    //マウスクリックによるボ—ルの生成について
   //(生成自体ではなく、生成後、WorldBoxのワールド概念に支配される、という処理)
    for(i=0; i<objs.length; i++)
    {
      //ここのmouseopは、ボール停止として機能する
      if(!fk) fk = objs[i].mouseop(m3d.x, m3d.y, m3d.z, IntMouse.pressed, IntMouse.clicked );
      else break;
    }
    //マウスクリックによるボ—ルの生成
    if( !fk && IntMouse.clicked )
    {
      color cl = color(random(200)+30, random(200)+30, random(200)+30);
      objs = (Object3D[]) append(objs, new ColorfulBall3D(this, m3d.x, m3d.y, m3d.z, random(30)+5, cl));
      //こっちはmouseopはボールが停止してくれなくなる機能
      //「マウスがボールを掴む」ことに関係しているのは間違いないが、この挙動はどういうことだ
      objs[objs.length-1].mouseop(m3d.x, m3d.y, m3d.z, IntMouse.pressed, IntMouse.clicked );
    }
    //既存ボールの挙動(ボールと壁、ボール同士)
    for(i=0; i<objs.length; i++)
    {
      objs[i].update();
    }
    for(i=0; i<objs.length; i++){
      for(j=i+1; j<objs.length; j++){
        collision(objs[i], objs[j]);
      }
      bound(objs[i]);
    }
    disp();
  }
  
  void disp(){
    pushMatrix();
    //ambientLight(255, 255, 255);
    //directionalLight(100, 100, 100, 0, 1, 0);
    //pointLight(100, 100, 100, (x2+x1)/2, (y2+y1)*0.8, (z2+z1)*0.4);
    cam.disp();
    scale(scaleValue,scaleValue,scaleValue);
    
    noFill();
    stroke(200, 100);
    pushMatrix();
    translate( (x2+x1)/2, (y2+y1)/2, (z2+z1)/2 );
    box( (x2-x1), (y2-y1), (z2-z1) );
    popMatrix();
    
    m3d.disp();
    for(int i=0; i<objs.length; i++)objs[i].disp();
    
    popMatrix();
  }

  void setFricBound(float fric_bound){ this.fric_bound=fric_bound; }
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
        b.fric_rate = b.fric_rate_org + fric_bound;
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
  
  void update_mouse(){
    IntMouse.px = IntMouse.x;
    IntMouse.py = IntMouse.y;
    IntMouse.x = box.x1+mouseX;
    IntMouse.y = box.y1+mouseY;
    //�}�E�X�N���b�N�̌��o
    IntMouse.pressed = mousePressed;
    IntMouse.clicked = ( IntMouse.pressed && !IntMouse.p_pressed );
    IntMouse.p_pressed = IntMouse.pressed;
  }
  void update_key(){
    //�L�[�����̌��o
    IntKey.kx_prs = (IntKey.kx && !IntKey.pkx);
    IntKey.kx_rls = (!IntKey.kx && IntKey.pkx);
    IntKey.ky_prs = (IntKey.ky && !IntKey.pky);
    IntKey.ky_rls = (!IntKey.ky && IntKey.pky);
    IntKey.kz_prs = (IntKey.kz && !IntKey.pkz);
    IntKey.kz_rls = (!IntKey.kz && IntKey.pkz);
    IntKey.pkx = IntKey.kx;
    IntKey.pky = IntKey.ky;
    IntKey.pkz = IntKey.kz;
    
    if(keyPressed)
    {
      if(keyCode == SHIFT){ IntKey.shift = true; cursor(); }
      else if(keyCode == CONTROL){ IntKey.ctrl = true; cursor(); }
      else if(key == 'x'){ IntKey.kx = true; }
      else if(key == 'y'){ IntKey.ky = true; }
      else if(key == 'z'){ IntKey.kz = true; }
      else if(key == 'c'){ IntKey.ky = true; }
    }
    else
    {
      if(keyCode == SHIFT){ IntKey.shift = false; noCursor(); }
      else if(keyCode == CONTROL){ IntKey.ctrl = false; noCursor(); }
      else if(key == 'x'){ IntKey.kx = false; }
      else if(key == 'y'){ IntKey.ky = false; }
      else if(key == 'z'){ IntKey.kz = false; }
      else if(key == 'c'){ IntKey.ky = false; }
    }
  }
}


