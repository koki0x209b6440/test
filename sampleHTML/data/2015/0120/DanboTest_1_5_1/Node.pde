class Node {
  public PVector pos;   // 親からの相対位置
  public PVector org;   // 回転の原点座標
  public PVector size;  // 幅、高さ、奥行き
  public PVector rot;   // 各軸まわりの回転角
  
  private List<Node>          child;        // 子ノードの参照
  private Map<String, PImage> texMap;       // テクスチャ
  private PVector[]           localCoords;  // 頂点のローカル座標
  private PVector[]           globalCoords; // 頂点のグローバル座標
  
  private final int NUM_VERTICES   = 8;  // 頂点数
  private final int NUM_PARTITIONS = 5;  // 分割数
  
  
  // ========================================
  // コンストラクタ
  // ========================================
  public Node() {
    pos          = new PVector(0, 0, 0);
    org          = new PVector(0, 0, 0);
    size         = new PVector(1, 1, 1);
    rot          = new PVector(0, 0, 0);
    
    child        = new ArrayList<Node>();
    texMap       = new HashMap<String, PImage>();
    
    localCoords  = new PVector[NUM_VERTICES];
    globalCoords = new PVector[NUM_VERTICES];
    
    for(int i = 0; i < NUM_VERTICES; ++i) {
      localCoords [i] = new PVector();
      globalCoords[i] = new PVector();
    }
  }
  
  
  // ========================================
  // 子要素追加
  // ========================================
  public void addChild(Node child) {
    this.child.add(child);
  }
  
  
  // ========================================
  // テクスチャ設定
  // ========================================
  public void applyTexture(String name, PImage tex) {
    this.texMap.put(name, tex);
  }
  
  
  // ========================================
  // 最も地面に近い頂点の y 座標値を得る
  // ========================================
  public float getGlobalMaxYCoord() {
    return getGlobalMaxYCoord(Float.MIN_VALUE);
  }
  private float getGlobalMaxYCoord(float maxY) {
    float ret = maxY;
    
    // 箱のローカル頂点をセット
    localCoords[0].set(-.5*size.x, -.5*size.y, -.5*size.z);
    localCoords[1].set(-.5*size.x, -.5*size.y,  .5*size.z);
    localCoords[2].set( .5*size.x, -.5*size.y,  .5*size.z);
    localCoords[3].set( .5*size.x, -.5*size.y, -.5*size.z);
    localCoords[4].set(-.5*size.x,  .5*size.y, -.5*size.z);
    localCoords[5].set(-.5*size.x,  .5*size.y,  .5*size.z);
    localCoords[6].set( .5*size.x,  .5*size.y,  .5*size.z);
    localCoords[7].set( .5*size.x,  .5*size.y, -.5*size.z);    
    
    // ----------------------------------------
    // ワールド行列の計算
    // ----------------------------------------
    pushMatrix();
    
    // 並進
    translate(pos.x, pos.y, pos.z);
    
    // 回転
    translate(org.x, org.y, org.z);
    rotateY(rot.y); rotateX(rot.x); rotateZ(rot.z);
    translate(-org.x, -org.y, -org.z);
    
    // ワールド行列を計算
    PMatrix3D worldMat = (PMatrix3D)getMatrix();
    worldMat.preApply(iViewMat);
    
    // ----------------------------------------
    // ローカル座標から世界座標に変換
    // ----------------------------------------
    for(int i = 0; i < NUM_VERTICES; i++)
      worldMat.mult(localCoords[i], globalCoords[i]);
    
    // ----------------------------------------
    // y座標値で世界座標配列をソート（降順）
    // ----------------------------------------
    Arrays.sort(globalCoords, new java.util.Comparator() {
      public int compare(Object p1, Object p2) {
        return ((PVector)p1).y == ((PVector)p2).y ?  0 :
               ((PVector)p1).y >  ((PVector)p2).y ? -1 : 1;
      }
    });
    // 配列の先頭には最もy座標の大きなベクトルが格納されている
    float tmp = globalCoords[0].y;
    
    if(ret < tmp) ret = tmp;
    
    // ----------------------------------------
    // 再帰的に木をトラバース
    // ----------------------------------------
    for(Node n : child) {
      tmp = n.getGlobalMaxYCoord(ret);
      if (ret < tmp) ret = tmp;
    }
    
    popMatrix();
    return ret;
  }
  
  
  // ========================================
  // ノードのレンダリング
  // ========================================
  void render() {
    pushMatrix();
    
    // 並進
    translate(pos.x, pos.y, pos.z);
    
    // 回転
    translate(org.x, org.y, org.z);
    rotateY(rot.y); rotateX(rot.x); rotateZ(rot.z);
    translate(-org.x, -org.y, -org.z);
    
    float dx = size.x / NUM_PARTITIONS;
    float dz = size.z / NUM_PARTITIONS;
    
    
    // ----------------------------------------
    // 前面の描画
    // ----------------------------------------
    PImage tex = texMap.get("FRONT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 背面の描画
    // ----------------------------------------
    tex= texMap.get("BACK");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x + i * dx, -.5 * size.y, .5 * size.z, texdx * i, 0);
        vertex(-.5 * size.x + i * dx,  .5 * size.y, .5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x + i * dx, -.5 * size.y, .5 * size.z);
        vertex(-.5 * size.x + i * dx,  .5 * size.y, .5 * size.z);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 天面の描画
    // ----------------------------------------
    tex= texMap.get("TOP");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y,  .5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx, -.5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, -.5 * size.y,  .5 * size.z);
        vertex(.5 * size.x - i * dx,  .5 * size.y, -.5 * size.z);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 底面の描画
    // ----------------------------------------
    tex= texMap.get("BOTTOM");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, .5 * size.y,  .5 * size.z, texdx * i, 0);
        vertex(.5 * size.x - i * dx, .5 * size.y, -.5 * size.z, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x - i * dx, .5 * size.y,  .5 * size.z);
        vertex(.5 * size.x - i * dx, .5 * size.y, -.5 * size.z);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 左面の描画
    // ----------------------------------------
    tex= texMap.get("LEFT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x, -.5 * size.y, -.5 * size.z + i * dz, texdx * i, 0);
        vertex(-.5 * size.x,  .5 * size.y, -.5 * size.z + i * dz, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(-.5 * size.x, -.5 * size.y, -.5 * size.z + i * dz);
        vertex(-.5 * size.x,  .5 * size.y, -.5 * size.z + i * dz);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 右面の描画
    // ----------------------------------------
    tex= texMap.get("RIGHT");
    if(tex == null) tex = texMap.get("DEFAULT");
    
    beginShape(QUAD_STRIP);
    if(tex != null) {
      float texdx = (float)(tex.width-1) / NUM_PARTITIONS;
      texture(tex);
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x, -.5 * size.y, .5 * size.z - i * dz, texdx * i, 0);
        vertex(.5 * size.x,  .5 * size.y, .5 * size.z - i * dz, texdx * i, tex.height-1);
      }
    } else {
      for(int i = 0; i <= NUM_PARTITIONS; ++i) {
        vertex(.5 * size.x, -.5 * size.y, .5 * size.z - i * dz);
        vertex(.5 * size.x,  .5 * size.y, .5 * size.z - i * dz);
      }
    }
    endShape();
    
    
    // ----------------------------------------
    // 再帰的に木をトラバース
    // ----------------------------------------
    for(Node n : child) {
      n.render();
    }
    popMatrix();
  }
}
