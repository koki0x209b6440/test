
/*

*/


// ----- Scene Description -----
float gAmbient = 0.1;             //Ambient Lighting
float[] gOrigin = {0.0,0.0,0.0};  //World Origin for Convenient Re-Use Below (Constant)
float[] Light = {0.0,1.2,3.75};   //Point Light-Source Position

// ----- Photon Mapping -----
int nrPhotons = 1000;             //Number of Photons Emitted
int nrBounces = 3;                //Number of Times Each Photon Bounces
boolean lightPhotons = true;      //Enable Photon Lighting?
float sqRadius = 0.7;             //Photon Integration Area (Squared for Efficiency)
float exposure = 50.0;            //Number of Photons Integrated at Brightest Pixel
int[][] numPhotons = {{0,0},{0,0,0,0,0}};              //Photon Count for Each Scene Object
float[][][][][] photons = new float[2][5][5000][3][3]; //Allocated Memory for Per-Object Photon Info

// ----- Raytracing Globals -----
boolean gIntersect = false;       //For Latest Raytracing Call... Was Anything Intersected by the Ray?
int gType;                        //... Type of the Intersected Object (Sphere or Plane)
int gIndex;                       //... Index of the Intersected Object (Which Sphere/Plane Was It?)
int gTotal_object_idx;       //sphere[gIndex]  =rayObj[gTotal_object_idx]     (gIndex=hoge+gTotal_object_idx)
float gSqDist, gDist = -1.0;      //... Distance from Ray Origin to Intersection
float[] gPoint = {0.0, 0.0, 0.0}; //... Point At Which the Ray Intersected the Object





//float[][] spheres=...
//float[][] planes=...
RayObjectList rayObjList;
ArrayList<RayObject> rayObjs;

int szImg = 512;                  //Image Size
PGraphics pg;
void setup(){
  size(512,560);
  pg=createGraphics(512,560,P2D);
  pg.beginDraw();
  pg.background(0);
  pg.updatePixels();
  pg.endDraw();
  frameRate(9999);
  
  rayObjList=new RayObjectList();
  rayObjs=new ArrayList<RayObject>();
  rayObjs.add(new RaySphere(rayObjList,1.0,   1.0,   4.0,   0.5)    );
  rayObjs.add(new RaySphere(rayObjList,-0.6, -1.0,  4.5,   0.5)    );
  rayObjs.add(new RayPlane(rayObjList,0, 1.5)                              );
  rayObjs.add(new RayPlane(rayObjList,1, -1.5)                            );
  rayObjs.add(new RayPlane(rayObjList,0, -1.5)                            );
  rayObjs.add(new RayPlane(rayObjList,1, 1.5)                              );
  rayObjs.add(new RayPlane(rayObjList,2,5.0)                               );
  emitPhotons();
  resetRender();
}

void draw(){  
    if (empty){frameRate(9999); render(); }
    else frameRate(10);//} //Only Draw if Image Not Fully Rendered
}




/*

　鏡面反射の施された球とか、球の作る影とかが描画される機構。
　jなんちゃらloaderのインポートの方が便利(あっちは普通にdrawに書いた物が加工される形式だし)だが、それでは鏡面反射の実体が見えない。
　よってこちらを読解する。

　しかし、実体の核がよく見えない
　raytraceのメソッド、特にrayObjectのメソッド、更にその中でタイプに分けられて物体描画がなされているようだ。
　ということは、mirrorsphereメソッドなど自作してその中でrayObjectメソッドを使って、と考えたいが、sphereの位置情報の管理が掴めない。
　あとmirrorsphereとnormalsphereの差がどこで生まれてるのか

　また、raytraceなどによってどこかのバッファcomputePixelColorにデータが出来上がるようで、実際の描画はバッファに従って点打ちになっている。
　↑訂正。どうやらcomputePixelColorでは、計算と取得の両方をこなしているようだ。
　　ここにgType==0&&gIndex==1　reflect(…)　つまり一番目の球はリフレクションさせると、雑な指定が書かれていた。


中身の処理が見えるようにはしたいけど、利用・活用は難しそうだなぁ

*/

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/20994*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//Ray Tracing & Photon Mapping
//Grant Schindler, 2007


/*
0908

　drawタブやその類、etcタブは、処理内容が洗練されていて、読み解くのが目的になるだろう。
　(ここにraytrace等もあるので)

　弄れるようになるべきは、sphereCLASSにまとめた、球生成・描画(設置)の類。
　これをクラスのインスタンスでできるようにしたり、別の形に対応させたり(影処理させたり)、弄れるようになれば御の字。
　ただし、リアルタイムで無いな……
*/
/*
　鏡面的ボールの処理。SphereやPlaneのクラスを用意して扱いやすくしたもの。
　しかし、現在、上手く動かない。
　sphere[n][x,y,z,r]で管理されていた処理を、sphereArrayListと互換があるように上手く置き換えられなかったのだと思う。
　初期値代入は上手くinputされているようなのだが……ううむ……。
　どう見ても、変更した処理構造　例えばplane二番目のxがplane[1][0]とrayObj.get(3).xというように異なっていることが、上手く書けていなさそう。
　こちらの方が当然可用なのだし、改善したいorz

　尚、元は何かのライブラリの中身だったのだが名前ど忘れた……要追記
*/


