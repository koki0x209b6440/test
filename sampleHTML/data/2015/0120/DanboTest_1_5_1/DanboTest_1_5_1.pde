/*
0116

　ダンボーの骨組みとテクスチャ張りも気になるが(相当面倒そうだったので敬遠して)、リフレクションの処理を読む。

　反対向きに通常ダンボー描画をして、背景色の薄いものを上から被せている。
　「反対向きに」の辺りとか、なぜかカメラの処理がとても複雑に描かれている(グラフィックのバッファを使わずに実現しようとしたからか？　バッファを使えば、逆向きとかスグだったはずだ)

　pushStyleとかapplyMatrixとかは参考にしなくていいだろう。「反対向き本体描画」「背景色の薄いのの取り方」「被せる」がポイント。

　バッファでの実現も、試せるときに試したい物だ。
*/

final int BACKGROUND_COLOR = 0xFFF0F0F0; // 背景色
Danbo danbo;                             // ダンボー
float time;                              // 経過時間の制御用変数

void setup() {
  size(400, 300, P3D);
  frameRate(30);
  
  noStroke();
  danbo = new Danbo(); 
}
void draw() {
  camera(); lights();
  float angle = 0;//radians(time += .05);
  //if(angle >= TWO_PI) angle = time = 0;
  camera(700 * sin(angle), -600, -700 * cos(angle), 
                                    0, -300,                        0, 
                                    0,       1,                        0);
  background(BACKGROUND_COLOR);

  danbo.update();
  danbo.refrection();
  danbo.render();
}
