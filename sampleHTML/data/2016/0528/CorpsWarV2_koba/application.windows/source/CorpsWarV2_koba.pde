import java.awt.*;
public final float WINDOW_ALPHA=0.8;
public final boolean IS_ALWAYS_ON_TOP=true;
public int mainwinX=200,mainwinY=200;
char controlKey=' ';
public char FullscreenKey='F';
public int Menu_FPS_MIN=10;
//AppletD sapp;
Scene scene;

CorpsWarApp cwapp;
int corpNum=3, unitNum=15,bulletNum=unitNum*2;
Corp[] corps;
Bullet[]  bullets;

void setup()
{
  //size(screen.width,screen.height,P2D);
  size(500,400,P2D);
  Key_setApplet(this);
  smooth();
  noFill();
  //sapp=new AppletD(0.8);
  cwapp=new CorpsWarApp(1.0);
  createApp( (HanyouApplet)cwapp ,200,100);

  scene=new Scene(new NoneContentScene(this),new CoverflowGUI(this,'m') );
  scene.optionGUI.setSampleList(new SampleListTest(this) );
  scene.loadSceneList("0005");
}
void draw()
{
  background(0,0,0,0);
  image(scene.getScene().getImage(),0,0,width,height);
  //image(sapp.outputSync(scene).getScene().getImage(),0,0,width,height);//remocon ver(when sapp=AppletD)
  work();
}
void work()//  system-work etc
{
  /*
  fill(255);
  rect(0,0,120,50);
  fill(0);
  textSize(32);
  text("FPS:" + int(frameRate), 10, 40);
  */
  window_control_mousesystem();
  window_size_control_system();
  window_control_system();
  Key_update();
}





int pressTime[]=null;
void Key_setApplet(PApplet applet)
{
  pressTime = new int[Character.MAX_VALUE];
  applet.addKeyListener( new java.awt.event.KeyAdapter()
                         {
                          public void keyPressed(java.awt.event.KeyEvent e)
                          {
                            if (pressTime[e.getKeyCode()] <= 0)
                              pressTime[e.getKeyCode()] = 1;
                          }
                          public void keyReleased(java.awt.event.KeyEvent e)
                          {
                            pressTime[e.getKeyCode()] = -1;
                          }
                         }
                       );
}
int Key_get(int code){  return pressTime[code]; }
boolean Key_pressed(int code){  return Key_get(code)==1; }
boolean Key_released(int code){  return Key_get(code)==-1; }
boolean Key_pushed(int code, int n, int m){  return Key_get(code)>=n&&Key_get(code)%m==0; }
void Key_update()
{  
   for (int i=0; i<pressTime.length; i++)
     pressTime[i]+=pressTime[i]!=0?1:0; 
}


/*  0124
　色選択機能実装。マウスの少し下にポップアップみたいに出すようにしたい

*/
/*同日更新。
　とりあえず、マウスの近くにカラーウィジェット出現は実装。
　メインタブがどんどん増えて行きそうだったので、initメソッドがあるタブに移した。

　他、HanyouApplet先でのkeyPressed、keyの挙動に違和感。
　“一回だけ発動”を行うなら、終わりに、その判定のkeyにダミー数値を書き込むべきかも。

　とりあえずダミー数値は¥
　colorcontrolというメソッドで纏めた。
   colorwidgetで管理させてー、と投げた色の元値を反映するようにしたかったが、十字マークの最適位置が導き出せていない。
*/

/*



「シーンチェンジのソースが奇麗に書けないから、研究抜きでも便利だろうから、ストーリーボード的なGUIを作る」を目標に、まずはカバーフロウを利用した「選択肢」を実装した。
　ここから【シーンチェンジの連なりへ、インプット】【朝昼晩的に設定した方のシーンリストのセーブ&ロード】【どの壁の面か選択するGUI】とか煮詰める感じ。

　尚、玄関投影の研究は「天気情報と連携してシーンを決定する」ので、このカバーフロウの選択肢とかは脱線であることに留意。

　シーンリストが良い感じ。新マインクラフトみたいにMap(ID代わりの名前、実物)で登録していくのだが、クラス名の取得ができた。但し「ProjectionTest_koba$Ball@14cc1」的なものからクラス名部分を抽出した。「koba」をキーとしているので、適時変更が必要。


　カバーフロウをずっと出してるリモコン的ウインドウと、その操作される側ウインドウに分けることもできる。
　但し、このためのoverflowや前のcolor widgetは、インナークラスの利点を生かして「引数にせずに引き継いでいる」　忘れない方が良い気がする。

*/

/*
　This program is
　このプログラムは、まあ、いわゆるmainメソッドみたいなもんで、実際の中身はscene変数の中身みたいなもん。
　scene変数をimage()するのが主な仕事で、後は、グローバル変数を明示的に置く部分(隠れて置くならinit()があるタブの方)
　プログラムの元が玄関投影だったので、DrawSettingDataがある。まあ、また投影するかもしれないし、残しておこう。
*/

/*

　理想通りの構造(シーンチェンジやセレクトやロード)を実装できたが、めちゃくちゃ重い。
　重い原因は、Hanyoubufferのsize()のバッファ用意が、全部別だからだろう。
バッファをリスト管理して同一サイズ要求はシェアさせよう。
(描画最初にbackground()しない子たちはエラー出しそうだが)

　セレクト画面はともかく、ボールが移動してるだけの描画中に重いのは腑に落ちない。
裏でバッファに無駄に書き込み行っていないか？
　->裏で動いてやがる……SampleListのadd減らしたら劇的に軽くなったわ
　　要解決
*/
/*
　速度問題解決。optionGUIがisVisible=-1の時にcoverflow描画だけ明示的に行わせてた。バッファが無駄に更新されるだけ。意味不明。
   だが、バッファ個別に用意してるのはメモリ食い過ぎ問題もきっと起きるはず。要注意

　一応todo(そこまで必要でもないなー、というよりこのkoba構造を実際運用してみたいなー)

・シーン連なりのセーブ機能
・トランジションを、optionGUIでも選べるように(ごつい改修)

*/
/*
　近しい課題。

　・HanyouBufferの有効利用ということで、FireCube(pixels単位で全体弄ってるやつ)とそのblend()をControllerで試す。
　・optionGUIの利用について。sceneWorkで設定せずに、なぜisVisibleでオンオフしてしまったんだろう。
　　　->ひとつ考えるなら、optionGUIは描画領域をどこにも依存せず小さくするとか、かな。しかしそれも、coverflowGUIを包んで小さく描画するようにすればいい。まあ、標準装備しようとしてる割にはバッファ用意大杉かなぁ……
　　　->更に一つ考えた。本来描画とoptionGUI描画を切り替えるのはSceneクラスで、ここにsceneWorkはない。
　　　　尚且つ、通常シーン遷移のようにoptionGUIをHanyouBufferのSceneWorkで扱わせようとすれば、各シーンでoptionGUIを共有しなければならない手間。
　　　　だから現状態は妥当。
*/
/*
　上記から別問題。option画面なんて一つじゃないだろうし、それ全部Sceneクラスに詰め込むわけにはいかない(そもそもラッパーのつもりだったのに)
　option画面への遷移構造はシーン構造とは別に考えなければ。それか、「シーン遷移のoption画面じゃない」ならsceneWorkメソッドでのシーン遷移でいいか？　いい気もするな
*/

/*
　フルスクリーンモード関連とテクスチャマッピング機能の共存可能化。size変更の方のsize()にP2D入れてなかった。
　実稼動上の問題は、フルスクリーンにすると重い事(特にカバーフロウ。こいつサイズ固定化しよ)
*/

/*

　日本語使うなら
    PFont myFont=createFont("HiraginoSansGB-W6-48.vlw",32);
    pg.textFont(myFont);

　の後に、text()メソッド
*/
/*

「フルスクリーンに拡大する」「カバーフロウ」が重い理由は、Imageの拡大縮小処理が重いのが原因のようだ。
　例えば最初からフルスクリーンで、size(100,100)ではなくsize(width,height)としていれば、めっちゃ軽い。

　拡大縮小処理だけでもGPU通して(シェーダー言語で)やった方がいいかもなぁ。

　カバーフロウのサムネイル表示(縮小処理)に合わせて、size()は小さく設定した。これでカバーフロウは比較的軽い。しかし、現状の設定では、フルスクリーンが重い。

　あとカバーフロウの軽量化。サムネイルのレンダリング(更新)の間隔を弄れるように。gifアニメサムネイルっぽくなった。

*/

/*0716

　プロジェクションマッピングの手動位置合わせに対応(ProjImage)
　後は、セーブ機能が欲しいな……

*/

/*
0823
　PoyoBallを実装というか移植。個体だったときのグローバル変数をそのまま扱っているので、複数インスタンスを作るとバグる。
　PoyoBallのメインの部分setup-drawがクラスになった事を考慮してフィールド変数に置き換えるべき。
　(複数インスタンス：　SampleListを二カ所でロードした場合)
*/

/*
0827
　複数ウインドウを作れるが、どこまで活用できるか(スレッドの同期云々問題にどれほど衝突するか)確認のため、片側をoutputウインドウ、もう片方をリモコンCoverflowウインドウとするAppletDをサンプルとして作る。
　結果、カラーピッカーのAppletのように、オブジェクトをsyncするような処理原理となった。(outputウインドウのsceneと、リモコン窓のsceneのメインのやつを等しくする)

　また、「別ウインドウからデータを受け取る」ような処理は、今回のAppletDを参考に、構造体的なクラス(Object)を作ってソレの書き換え更新、という形になるだろう。
　(カラーピッカーのAppletがその原本にあたるが、簡単化は出来ていないので見にくいだろう)
*/
/*
　いろいろ試してみると、草原やPoyoBallのendShape()でエラーを吐くようだ。
　なので、それを検証するDoubleWintest_kobaとして複製する。
*/

HanyouApplet hacw=new ColorWidget(new ColorObject(100,0,0,255) );
ColorWidget colorwidget=(ColorWidget)hacw;
boolean resizingFlag=false;//win_control


/*
　0217
　OpenProcessingのParticleWarを参考に、多種射撃やシールド、戦闘用に牽制的に動く事、自分プレイヤーを実装。
　(TotalWar路線というよりは、TiltToLive路線(あの一画面で収まり、シンプルデザインで、格好いいというのは、…手が届きたい)  )
　「一画面で完結している(画面遷移も極力無しに)」「NPCとワチャワチャしている実装にしたい(テイルズ戦闘部分や、GodEaterみたいに、役に立つかどうかはともかくNPCと共闘でうるさい、というのが欲しい)」という目論みがここで一端は実現で、今までの単純系の試作よりはゲームっぽく楽しいので、他の実装も進めていこうかと思う。
　TotalWarの「斉射」が格好いいから、そんな戦術指揮の実装も検討するか…

　なので、各種実装を備忘録的に記録する。
　まず、Simple_kobaを基に、バッファ管理等を(自分なりに)容易にして試作している。

　本体はcorps warタブ、CorpsWarのHanyouApplet。
　corps(駒の群)の配列にインスタンス生成。その中でunits(駒)の配列にインスタンス生成
　corpsにはxyがあるが、リスポーン位置として使える。また、このCorpクラスでは生存者の把握(表示)や、unitsへの指示(範囲選択->指示)を実装している。
　なお、指示は今は移動のみ。この指示可能の有無はisPlayerフラグ(範囲選択の枠とunitsの色が同じ)。
　全体としてはCorpsクラスはcorps.draw内で、units[i].run();の実行、handle();の実行で指揮、

　unitsは駒ひとつひとつの配列。Unitクラスは駒。
　これは全体処理はdraw();ではなくrun();　接敵の有無をisFreeMoveフラグで管理。
　また、生きているかどうかisWorkフラグで管理。falseなら描画無し、当たり判定無し、他からもターゲットされない。
　isPlayer=trueならkeycontrol　尚、corpのisPlayerフラグとは別(自軍を操作出来ないプレイのときとか)
　移動処理を行う。フリーでは、定期的に方向転換しつつ索敵的移動。
　次に、射撃等統合してfight();処理。敵をターゲットすると横へ回避行動を取りながら、敵に射撃する。(ターゲットは線でつないでいる)　この判定はisFreeMoveフラグ。
　そして、draw。本体三角と、当たり判定目安の薄い円、指揮対象を示す濃い円

　bullets…units
　corpとは別駆動。corps生成と同じタイミングで、とりあえず全部normalのbulletで用意。
　その後、射撃のときに引き継ぎ、書き換える形でレーザー等を活動させ始める。
　また、射撃主を保持するので、射撃後硬直などもこの弾丸クラスの方で制御出来る。(ただしキャラ個性を反映するなら、unitの方で反動処理するべきか。もしくは、こちらで反動するが、unitのウェイトなど考慮するとか？)
　draw();に全体処理があるが、まず移動処理して、その後collision();
　円や長方形で当たり判定、trueならヒット処理(ダメージ)も行う。そして、貫通なら、isCannnotPeneフラグの指定で、抜け方が変わる。
　だいたいは、当たると、isWork=falseして、後処理effect();に。爆発エフェクトとか。その時間カウントを経過してから、dead();する。ちゃんとfalseにしているし、modeling();されないが、いちおうx=0;y=0;とかする。
　ただし、貫通弾isCannotPene=false;だと処理が異なる。effect();は後処理じゃないし複数対象が考えられる。なので、ヒット処理のところでeffectのemitterしよう。
　ガードのカキンについては、まだ検討中。弾扱いのガードの方でガードエフェクトして消える(一発ガード)ようにするか、ガードは一定時間残るから、弾の方でisShieldフラグでエフェクト変えるか(unitがisShield=シールドなうだから、当たった弾もシールドされなう)。

*/

/*
　今後は「射撃時に発煙(廃莢)」「ddff皇帝のようなメテオ」「ガンダムvs(特にユニコ)みたいなガードエフェクト」
　など、個人的なロマンデザインとサウンドの実装
　「武器が変形展開」「武器部分的に折って、リロードして、再結合」みたいなロマンは簡易に実装できないかしら。
　(矢印の簡素さを引き継いで、スケルトンな武器な感じ？)
*/

/*
　レーザ、というか角度ある長方形の当たり判定が少々不安。要検証。
*/

/*
　再確認。やっぱり角度あり長方形の当たり判定が怪しい。最悪、w=10;h=10;なら奇麗な判定だから数本束ねる。
*/

/*
  key同時押しに対応。HanyouAppletも。従来のも使えるので、既存置き換えは全然。
  if (Key_pushed('C', 50, 20))
    background(#aaaaff);
  if (Key_get(SHIFT)>0)
  {
    fill(255);
    rect(width/2, height/2, width/2, height/2);
  }

  if (Key_pressed('X'))
    println("X:"+frameCount);
  text(Key_get('Z'), width/2, height/2);
  
  Editorの件で、HanyouAppletのextends JFrame採用を試運転中。
*/

/*0624
  unityで色々できるようになってひと段落、こちらに少しゲーム性を用意。
  拠点CorpCoreの大きな丸を倒したら部隊が壊滅するから、守るように戦う感じ。
  
  ところで、斜めビームと自分の当たり判定を、角度無しで確認するようなデバッグてどこにやったかな。if(isColisionDebug)?
*/

