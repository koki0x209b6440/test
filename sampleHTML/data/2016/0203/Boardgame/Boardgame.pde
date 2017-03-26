/*
boll_x:ボールのx座標
boll_y:ボールのy座標
speedx:x方向の速度
speedy:y方向の速度
a:ボールのx軸移動判定
b:ボールのy軸移動判定
point:得点
GAMEOVER_count:何回落ちたかのカウント
GAMEOVER_number:何回落ちて大丈夫な数
LIFE:残りライフ
startWordCount:スタートカウントの数え
mouseClickCount:クリックされた回数
quiteNumber:終了カウント
*/


float boll_x,boll_y,speedx,speedy;
int a,b,point,GAMEOVER_count,GAMEOVER_number,LIFE,startWordCount,mouseClickCount,quiteNumber;
String[] startWord = {"","ARE","YOU","READY?"};

/*-------Setup-------*/
void setup(){
  size(400,600);
  a=0;//初期ではx軸右側に
  b=0;//初期ではy軸下軸
  boll_x=0;//初期のボールx座標
  boll_y=0;//初期のボールy座標
  point=0;
  GAMEOVER_count=0;
  GAMEOVER_number=2;
  mouseClickCount=0;
  quiteNumber=0;
  speedx=1.0;
  speedy=5.0;
  rectMode(CENTER);//長方形の基準を真ん中に
}

/*-------Draw-------*/
void draw(){
  background(0);
  if(mouseClickCount==0) startWindow();
  else goGame();

}

/*-------スタート画面-------*/
void startWindow(){
  title();
  drawStar(width/2,height/2);
  startWord();
}

/*-------GAME開始のコメント(1):タイトル-------*/
void title(){
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("BOARD GAME",width/2,height/3);
}

/*-------GAME開始のコメント(2):ゲーム開始方法の指示-------*/
void startWord(){
  fill(255);
  textAlign(CENTER);
  textSize(12);
  text("Click Schreen and you start game",width/2,height*2/3);
}

/*-------ゲーム開始時に表示させる"ARE YOU READY"に関するメソッド-------*/
void goGame(){
  if(startWordCount >= startWord.length){
    aboutBall();
    game();
  }else{
    areYouReady();
    startWordCount++;
  }
}

/*-------ゲーム開始時に表示させる"ARE YOU READY"について-------*/
void areYouReady(){
  frameRate(1);
  textSize(100);
  textAlign(CENTER);
  text(startWord[startWordCount], width/2, height/2);
}

/*-------実際のゲームに関してのメイン-------*/
void game(){
  frameRate(100);
  /*-------壁とのあたり判定-------*/

  //aが0なら右方向へ
  if(a==0) boll_x+=speedx;
  //ｘ座標が壁ギリギリになったら左へ5は半径（スピード変速システム搭載）
  if(boll_x>=width-5){
    a=1;
    speedx=random(3);
  }

  //aが0なら左方向へ
  if(a==1) boll_x-=speedx;
  //ｘ座標が壁ギリギリになったら右へ(スピード変速システム搭載)
  if(boll_x<=5){
    a=0;
    speedx=random(3);
  }

  //bが0なら下へ
  if(b==0) boll_y+=speedy;
  //ボールが下に落ちた時
  if(boll_y>=height){
    boll_y=0;//上に戻ってくる
    GAMEOVER_count++;//GameOverカウント追加
  }

  //bが1の時上へ
  if(b==1) boll_y-=speedy;
  //ボールが天井なら下へ(スピード変速システム搭載)
  if(boll_y<=5){
    b=0;
    speedy=random(3,5);//random(min,max):min~maxの範囲の乱数
  }

  /*-------長方形とのあたり判定とポイントの加算-------*/
  if(boll_x>=mouseX-30 && boll_y>=565 && boll_y<=575 && boll_x<=mouseX+30){//バーの長さとボールの軸からのあたり判定
    b=1;
    /*--加点について--*/
    if(GAMEOVER_count<=GAMEOVER_number){
      point+=100;
      speedx=random(3);
      speedy=random(3,5);
    }
  }

  if(boll_x>=mouseX-30 && boll_y>=565 && boll_y<=585 && boll_x<mouseX-10) a=1;//バーの長さとボールの軸からのあたり判定
  if(boll_x>mouseX+10 && boll_y>=565 && boll_y<=585 && boll_x<=mouseX+30) a=0;//バーの長さとボールの軸からのあたり判定
  if(boll_y>=575 && boll_x==mouseX-30 && boll_y<=585){
   a=0;
   b=1;
   if(GAMEOVER_count<=GAMEOVER_number) point+=100;
  }
  if(boll_y>=575 && boll_x==mouseX+30 && boll_y<=585){
    a=1;
    b=1;
    if(GAMEOVER_count<=GAMEOVER_number) point+=100;
  }
  /*-------特定回数以上落ちたらゲームオーバー-------*/
  GAMEOVER();
}

/*-------ボールの描画-------*/
void aboutBall(){
  noStroke();
  ellipse(boll_x,boll_y,10,10);
  fill(255);
  rect(mouseX,580,50,10);
}

/*-------星の描画-------*/
void drawStar(int px,int py) {
  noStroke();
  smooth();
  fill(255, 255, 0);
  beginShape();
    vertex(px      , py - 20);
    vertex(px - 12 , py + 15);
    vertex(px + 18 , py -  8);
    vertex(px - 18 , py -  8);
    vertex(px + 12 , py + 15);
  endShape(CLOSE);
}

/*-------GAMEのポイントとLIFEの表示-------*/
void beforeGAMEOVER_Display(){
  LIFE = GAMEOVER_number-(GAMEOVER_count-1);
  textSize(16);
  text("POINT:",40,20);
  text(point,100,20);
  text("LIFE:",140,20);
  text(LIFE,170,20);
}

/*-------GAME終了後-------*/
void afterGAMEOVER(){
  background(0);
  GAMEOVER_Comment();
  finishStar();
  reStartGame();
}

/*-------GAME終了を取得してafterGAMEOVERへ-------*/
void GAMEOVER(){
  if(GAMEOVER_count > GAMEOVER_number) afterGAMEOVER();
  else beforeGAMEOVER_Display();
}

/*-------GAME終了後のコメント(1):合計獲得ポイント-------*/
void GAMEOVER_Comment(){
  textAlign(CENTER);
  textSize(30);
  text("GAME OVER",width/2,height/3);
  text("GET",width/2-100,height/3+28);
  text(point,width/2,height/3+28);
  text("POINT",width/2+100,height/3+28);
}

/*-------GAME終了後のコメント(2):終了後のゲーム終了方法の指示-------*/
void reStartGame(){
  fill(255);
  textAlign(CENTER);
  textSize(12);
  text("You click schreen and finish this game",width/2,height*2/3);
  quiteNumber=1;
}

/*-------GAME終了後に表示するスターのアニメーション-------*/
void finishStar(){
  frameRate(60);
  drawStar(width/2,height/2);
}

/*-------GAME終了後の終了のメソッド------*/
void mouseClicked(){
  mouseClickCount++;
  println(mouseClickCount);
  if(quiteNumber==1){
    exit();
  }
}
