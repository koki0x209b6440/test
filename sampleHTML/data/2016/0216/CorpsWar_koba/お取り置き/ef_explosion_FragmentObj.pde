
// **************************************
//
// 破片の集合クラス
//
// **************************************
class Fragments {
  PImage tex;
  ArrayList<Fragment> f;
  HanyouBuffer now;
  
  Fragments(int nPoints,HanyouBuffer now) {
    this.now=now;
    tex = now.getImage(DRAW_ONLY);
    
    // 破片セット
    f = new ArrayList<Fragment>();
    
    // Delaunay分割
    ArrayList<PVector> pList = new ArrayList<PVector>();
    pList.add(new FPoint(0, 0));
    pList.add(new FPoint(tex.width, 0));
    pList.add(new FPoint(tex.width, tex.height));
    pList.add(new FPoint(0, tex.height));
    for(int i = 0; i < nPoints; i++) {
      pList.add(new FPoint(random(tex.width), random(tex.height)));
    }
    DelaunayTriangles delaunay = new DelaunayTriangles(pList,tex);
    
    // Delaunay三角集合をリスト化
    HashSet tSet = delaunay.getDelaunayTriangulationSet();
    for(Iterator it = tSet.iterator(); it.hasNext();) {
      f.add(new Fragment((FTriangle)it.next(), tex));
    }
  }
  
  void update(PGraphics pg) {
    for(Iterator it = f.iterator(); it.hasNext();) {
      Fragment fragment = (Fragment)it.next();
      fragment.update(pg);
    }
  }
}

// **************************************
//
// 破片クラス
//
// **************************************
class Fragment {
  // PVector[] texCoords;
  PVector[] vertices;
  PImage tex;  // テクスチャ
  
  // 並進成分・回転角
  private float x, y, z, rx, ry, rz;
  private float dx, dy, dz, drx, dry, drz;
  private float ddx, ddy, ddz;
  
  // 与えられた三角形の重心
  private float cx, cy, cz;
  
  Fragment(FTriangle t, PImage tex) {
    this.tex = tex;
    
    // 頂点座標をセット
    vertices = new PVector[3];
    vertices[0] = t.p1;
    vertices[1] = t.p2;
    vertices[2] = t.p3;
    
    // 重心を計算
    cx = (t.p1.x + t.p2.x + t.p3.x)/3.0;
    cy = (t.p1.y + t.p2.y + t.p3.y)/3.0;
    cz = (t.p1.z + t.p2.z + t.p3.z)/3.0;
    
    // 並進・回転の初期値を設定
    x = y = z = 0;
    rx = ry = rz = 0;
    
    // ======================================
    // 速度・加速度を設定（変更可能）
    // ======================================
    dx =  random(-0.5, 0.5);
    dy = -random( 1  , 6  );
    dz =  random(-0.5, 0.5);
    
    ddx = 0;
    ddy = random(0.2, 0.5);
    ddz = 0;

    drx = radians(random(-2, 2));
    dry = radians(random(-2, 2));
    drz = radians(random(-2, 2));    
  }
  
  void update(PGraphics pg) {
    pg.noStroke();
    pg.fill(255);
    pg.lights();

    pg.pushMatrix();
    // 並進
    pg.translate(cx + x, cy + y, cz + z);
    
    // 回転  
    pg.rotateX(rx); rotateZ(rz); rotateY(ry);
    
    // 並進
    pg.translate(-cx, -cy, -cz);

    pg.textureMode(IMAGE);
    pg.beginShape(TRIANGLES);
    pg.texture(tex);
    for(int i = 0; i < vertices.length; i++) {
      pg.vertex(vertices[i].x, vertices[i].y,
                     vertices[i].x, vertices[i].y);
    }
    pg.endShape();
    pg.popMatrix();
    pg.noLights();
    
    x  += dx;  y  += dy;  z  += dz;
    rx += drx; ry += dry; rz += drz;
    dx += ddx; dy += ddy; dz += ddz;
  }
}


// **************************************
//
// Delaunay分割用クラス
//
// **************************************

class DelaunayTriangles {
  private ArrayList<PVector> pointList;
  PImage tex;
  // ======================================
  // コンストラクタ
  // 与えられた点のリストを基にDelaunay分割を行う
  // ======================================
  public DelaunayTriangles(ArrayList<PVector> pointList,PImage tex) {
    this.pointList = pointList;
    this.tex=tex;
  }
  
  
  // ======================================
  // Delaunay三角分割を行う
  // ======================================
  public HashSet<FTriangle>
      getDelaunayTriangulationSet() {
    
    // 三角形リストを初期化
    HashSet<FTriangle> triangleSet = new HashSet<FTriangle>();
    
    // 巨大な外部三角形をリストに追加
    FTriangle hugeTriangle = getHugeTriangle(tex);
    triangleSet.add(hugeTriangle);

    try {
      // --------------------------------------
      // 点を逐次添加し、反復的に三角分割を行う
      // --------------------------------------
      for(Iterator pIter = pointList.iterator(); pIter.hasNext();) {
        Object element = pIter.next();
        FPoint p = element instanceof FPoint ? 
            (FPoint)element : new FPoint((PVector)element);
        
        // --------------------------------------
        // 追加候補の三角形を保持する一時ハッシュ
        // --------------------------------------
        // 追加候補の三角形のうち、「重複のないものだけ」を
        // 三角形リストに新規追加する
        //          → 重複管理のためのデータ構造
        // tmpTriangleSet
        //  - Key   : 三角形
        //  - Value : 重複していないかどうか
        //            - 重複していない : true
        //            - 重複している   : false
        // --------------------------------------
        HashMap<FTriangle, Boolean> tmpTriangleSet 
          = new HashMap<FTriangle, Boolean>();

        // --------------------------------------
        // 現在の三角形リストから要素を一つずつ取り出して、
        // 与えられた点が各々の三角形の外接円の中に含まれるかどうか判定
        // --------------------------------------
        for(Iterator tIter=triangleSet.iterator(); tIter.hasNext();){
          // 三角形リストから三角形を取り出して…
          FTriangle t = (FTriangle)tIter.next();
              
          // その外接円を求める。
          FCircle c = getCircumscribedCirclesOfTriangle(t);
              
          // --------------------------------------
          // 追加された点が外接円内部に存在する場合、
          // その外接円を持つ三角形をリストから除外し、
          // 新たに分割し直す
          // --------------------------------------
          if (FPoint.dist(c.center, p) <= c.radius) {
            // 新しい三角形を作り、一時ハッシュに入れる
            addElementToRedundanciesMap(tmpTriangleSet,
              new FTriangle(p, t.p1, t.p2));
            addElementToRedundanciesMap(tmpTriangleSet,
              new FTriangle(p, t.p2, t.p3));
            addElementToRedundanciesMap(tmpTriangleSet,
              new FTriangle(p, t.p3, t.p1));
            
            // 旧い三角形をリストから削除
            tIter.remove();            
          }
        }
        
        // --------------------------------------
        // 一時ハッシュのうち、重複のないものを三角形リストに追加 
        // --------------------------------------
        for(Iterator tmpIter = tmpTriangleSet.entrySet().iterator();
            tmpIter.hasNext();) {

          Map.Entry entry = (Map.Entry)tmpIter.next();
          FTriangle t = (FTriangle)entry.getKey();
          
          boolean isUnique = 
              ((Boolean)entry.getValue()).booleanValue();

          if(isUnique) {
            triangleSet.add(t);
          }
        }
      }
      
      // 最後に、外部三角形の頂点を削除
      for(Iterator tIter = triangleSet.iterator(); tIter.hasNext();){
        // 三角形リストから三角形を取り出して
        FTriangle t = (FTriangle)tIter.next();
        // もし外部三角形の頂点を含む三角形があったら、それを削除
        if(hugeTriangle.hasCommonPoints(t)) {
          tIter.remove();
        }
      }
      
      return triangleSet;
    } catch (Exception ex) {
      return null;
    }
  }

  // ======================================
  // 一時ハッシュを使って重複判定
  // hashMap
  //  - Key   : 三角形
  //  - Value : 重複していないかどうか
  //            - 重複していない : true
  //            - 重複している   : false
  // ======================================
  private void addElementToRedundanciesMap
      (HashMap<FTriangle, Boolean> hashMap, FTriangle t) {
    if (hashMap.containsKey(t)) {
      // 重複あり : Keyに対応する値にFalseをセット
      hashMap.put(t, new Boolean(false));
    } else {
      // 重複なし : 新規追加し、
      hashMap.put(t, new Boolean(true));
    }
  }
  
  // ======================================
  // 最初に必要な巨大三角形を求める
  // ======================================
  // 画面全体を包含する正三角形を求める
  private FTriangle getHugeTriangle(PImage tex) {
    return getHugeTriangle(new PVector(0, 0), 
                           new PVector(tex.width, tex.height));    
  }
  // 任意の矩形を包含する正三角形を求める
  // 引数には矩形の左上座標および右下座標を与える
  private FTriangle getHugeTriangle(PVector start, PVector end) {
    // start: 矩形の左上座標、
    // end  : 矩形の右下座標…になるように
    if(end.x < start.x) {
      float tmp = start.x;
      start.x = end.x;
      end.x = tmp;
    }
    if(end.y < start.y) {
      float tmp = start.y;
      start.y = end.y;
      end.y = tmp;
    }
    
    // 1) 与えられた矩形を包含する円を求める
    //      円の中心 c = 矩形の中心
    //      円の半径 r = |p - c| + ρ
    //    ただし、pは与えられた矩形の任意の頂点
    //    ρは任意の正数
    FPoint center = new FPoint( (end.x - start.x) / 2.0,
                              (end.y - start.y) / 2.0 );
    float radius = FPoint.dist(center, start) + 1.0;
    
    // 2) その円に外接する正三角形を求める
    //    重心は、円の中心に等しい
    //    一辺の長さは 2√3･r
    float x1 = center.x - sqrt(3) * radius;
    float y1 = center.y - radius;
    FPoint p1 = new FPoint(x1, y1);
    
    float x2 = center.x + sqrt(3) * radius;
    float y2 = center.y - radius;
    FPoint p2 = new FPoint(x2, y2);
    
    float x3 = center.x;
    float y3 = center.y + 2 * radius;
    FPoint p3 = new FPoint(x3, y3);

    return new FTriangle(p1, p2, p3);    
  }
  
  // ======================================
  // 三角形を与えてその外接円を求める
  // ======================================
  private FCircle getCircumscribedCirclesOfTriangle(FTriangle t) {
    // 三角形の各頂点座標を (x1, y1), (x2, y2), (x3, y3) とし、
    // その外接円の中心座標を (x, y) とすると、
    //     (x - x1) * (x - x1) + (y - y1) * (y - y1)
    //   = (x - x2) * (x - x2) + (y - y2) * (y - y2)
    //   = (x - x3) * (x - x3) + (y - y3) * (y - y3)
    // より、以下の式が成り立つ
    //
    // x = { (y3 - y1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
    //     + (y1 - y2) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1)} / c
    //
    // y = { (x1 - x3) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
    //     + (x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1)} / c
    //
    // ただし、
    //   c = 2 * {(x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)}
    
    float x1 = t.p1.x;
    float y1 = t.p1.y;
    float x2 = t.p2.x;
    float y2 = t.p2.y;
    float x3 = t.p3.x;
    float y3 = t.p3.y;
    
    float c = 2.0 * ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1));
    float x = ((y3 - y1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
             + (y1 - y2) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    float y = ((x1 - x3) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
             + (x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    FPoint center = new FPoint(x, y);
    
    // 外接円の半径 r は、半径から三角形の任意の頂点までの距離に等しい
    float r = FPoint.dist(center, t.p1);
    
    return new FCircle(center, r);
  }
}

// **************************************
//
// 三角形クラス
//
// **************************************

class FTriangle{
  public FPoint p1, p2, p3;  // 頂点
  
  // ======================================
  // コンストラクタ
  // 3頂点を与えて三角形をつくるよ
  // 頂点はFPointで与えてもOK
  // ======================================
  public FTriangle(PVector p1, PVector p2, PVector p3){
    this.p1 = p1 instanceof FPoint ? (FPoint)p1 : new FPoint(p1);
    this.p2 = p2 instanceof FPoint ? (FPoint)p2 : new FPoint(p2);
    this.p3 = p3 instanceof FPoint ? (FPoint)p3 : new FPoint(p3);
  }
  
  // ======================================
  // 同値判定
  // ======================================
  public boolean equals(Object obj) {
    try {
      FTriangle t = (FTriangle)obj;
      // ※ 同値判定に頂点を用いると、
      // 三角形の頂点の順番を網羅的に考慮する分条件判定が多くなる。
      return(p1.equals(t.p1) && p2.equals(t.p2) && p3.equals(t.p3) ||
             p1.equals(t.p2) && p2.equals(t.p3) && p3.equals(t.p1) ||
             p1.equals(t.p3) && p2.equals(t.p1) && p3.equals(t.p2) ||
              
             p1.equals(t.p3) && p2.equals(t.p2) && p3.equals(t.p1) ||
             p1.equals(t.p2) && p2.equals(t.p1) && p3.equals(t.p3) ||
             p1.equals(t.p1) && p2.equals(t.p3) && p3.equals(t.p2) );
    } catch (Exception ex) {
      return false;
    }
  }
    
  // ======================================
  // ハッシュ表で管理できるよう、hashCodeをオーバーライド
  // ======================================
  public int hashCode() {
    return 0;
  }
  
  // ======================================
  // 他の三角形と共有点を持つか
  // ======================================  
  public boolean hasCommonPoints(FTriangle t) {
    return (p1.equals(t.p1) || p1.equals(t.p2) || p1.equals(t.p3) ||
            p2.equals(t.p1) || p2.equals(t.p2) || p2.equals(t.p3) ||
            p3.equals(t.p1) || p3.equals(t.p2) || p3.equals(t.p3) );
  }
}

// **************************************
//
// 円クラス
//
// **************************************

class FCircle {
  // 中心座標と半径
  FPoint center;
  float radius;
  
  // ======================================
  // コンストラクタ
  // 中心座標と半径を与えて円をつくるよ
  // ======================================
  public FCircle(PVector c, float r){
    this.center = c instanceof FPoint ? (FPoint) c : new FPoint(c);
    this.radius = r;
  }
}

// **************************************
//
// 点クラス
//
// **************************************

class FPoint extends PVector {
  // ======================================
  // コンストラクタ
  // ======================================
  public FPoint() {
    super();
  }
  public FPoint(float x, float y) {
    super(x, y);
  }
  public FPoint(float x, float y, float z) {
    super(x, y, z);
  }
  public FPoint(PVector v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }
  
  // ======================================
  // 同値判定
  // ======================================
  public boolean equals(Object o) {
    boolean retVal;
    try {
      PVector p = (PVector)o;
      return (x == p.x && y == p.y && z == p.z);
    } catch (Exception ex) {
      return false;
    }
  }
}
