import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;
import java.awt.Rectangle;

import javax.swing.ImageIcon;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Alien extends Chara{
    /*************
    インベーダーゲームを参考にしたのでAlienという名前(とイラスト)。
    探索はてきとうになってしまった。後悔。通常の座標形式でプレイヤーの位置を読み取り、プレイヤーのいるマス目へ考え方を変換し、飛車の動きでルートを決め、ルートを格納した疑似キューを読み取り動く。
    プレイヤーの弾回避を組みたかったが無理だった。全く形にできん。
     
    動きはここにあるが、弾を撃つタイミングなどはMainPanelの方にある//こちらに移せない(?)
     
     CollidWith系は一つにできるはず。抽象クラスならった。後で直す。
    **************/
    private static int[][] Markingmap;
    
    private static final Point TOMB = new Point(-20, -100);//エイリアンの墓（画面に表示されない場所）
    private int vx,vy;//移動スピード(今回使用している疑似キュー探索でのルート移動の肝)
                      //マス目無視して追わせる場合にも有効(?)

    private boolean isAlive;
    private boolean isBuffer;            //
    public static final int MAX = 100;   //疑似キューたくさん用意
                                         //到着時にキュー再利用させているので不要かも
    private Point[] queue=new Point[MAX];//疑似キュー
    private int in=0,out=1;
    private int pattern=0;//(プレイヤーに)上下からまず合わせるか、左右から合わせるか　のフラグ
    private boolean isdebug=false;//キューの終着点を表示させてたはず(?)
        //private int left;
        //private int right;
    
    
    public Alien(int x, int y, int speed, MainPanel panel) {
        
        for(int i=0; i<MAX; i++){
            queue[i]=new Point(0,0);
        }
        
        this.x = x;
        this.y = y;
        hp=10;
        isCSHit=false;
        this.speed = speed;
        this.panel = panel;
        Markingmap=panel.mapcopy();//探索に使用(重要)。また仮想障害物を置くのに用いる。
        queue[0].x=getPosInMap().x; queue[0].y=getPosInMap().y;//初期位置
        
        isAlive = true;
        isBuffer=false;
        
        loadImage();
    }
    
    
    void move(Chara player){
        if(isAlive){
            while(!isBuffer){
                int i=queue[in].x; int j=queue[in].y;

                in++;
                
                Point target=new Point(player.getPosInMap().x, player.getPosInMap().y );
                int diri=0,dirj=0;
                if(pattern==0){
                    if(i==target.x){ diri=0;  pattern=1;}  //上下合わせてから
                    else if(i<target.x)diri=1;
                    else diri=-1;
                }
                if(pattern==1){                            //左右合わせる
                    if(j==target.y){dirj=0; pattern=0;}
                    else if(j<target.y)dirj=1;
                    else dirj=-1;
                }                                          //現在のpatternによっては優先逆
                
                if(Markingmap[i+diri][j+dirj]==0){
                    queue[in].x=i+diri; queue[in].y=j+dirj;
                }//プレイヤーの方へ向かう(基本これのみ。以降は危機(?)回避)
                
                else if(Markingmap[i+dirj][j+diri]==0){
                    queue[in].x=i+dirj; queue[in].y=j+diri;
                }//間に障害物があれば迂回
                else if(Markingmap[i-dirj][j-diri]==0){
                    queue[in].x=i-dirj; queue[in].y=j-diri;
                }//同文
                else if(Markingmap[i-diri][j-dirj]==0){
                    queue[in].x=i-diri;
                    queue[in].y=j-dirj;
                    Markingmap[i][j]=1;//見た目に反映されない仮想障害物を設置してループ回避
                }//行き止まりにぶち当たったとき、強制的にUndoさせる処理と今のマスに障害物を置かせる
                
                
                if(in>10) isBuffer=true;//この疑似キュー利用探索は、探索を行った瞬間のプレイヤーの位置を
                    //目指すので、そのままではおかしな挙動である。
                    //それっぽくみせるため、10マス移動ごとに再探索させる。(随時変更)
            }       //疑似キュー利用による探索。飛車型の移動法。
            
            if(isBuffer){
                lockon();
                if(vx==0 && vy==0){
                    if(in==out){
                        isBuffer=false; 
                        queue[0]=queue[in]; in=0; out=1; 
                        move(player);//returnにしていたが、敵が一瞬立ち止まってしまうので、再帰して下のx+=vxなどをすぐに生かすことで断続感をなくしてみた
                    }
                    else out++;
                    lockon();
                }
                x+=vx;
                y+=vy;
            }//探索結果から読み取って実際に動くほう
        }
    }
    
    void lockon() {
        Point target=new Point(queue[out].y*MainPanel.CS , queue[out].x*MainPanel.CS);
        int dirx,diry;
        if(x==target.x) dirx=0;
        else if(x<target.x)dirx=1;
        else dirx=-1;
        if(y==target.y)diry=0;
        else if(y<target.y)diry=1;
        else diry=-1;
        
        vx=dirx*speed;
        vy=diry*speed;
    }//プレイヤーの位置を見つける
    
    public void die() {
        setPos(TOMB.x, TOMB.y);
        isAlive = false;
    }//エイリアンの死亡フラグ（マジな方）で墓へ移動
    public boolean isAlive() {
        return isAlive;
    }
    public Point getQ(){
        return queue[in];
    }
    public void setPos(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    void loadImage() {
            // エイリアンのイメージを読み込む
            // ImageIconを使うとMediaTrackerを使わなくてすむ
        ImageIcon icon = new ImageIcon(getClass()
                                       .getResource("image/alien.gif"));
        image = icon.getImage();
        
            // 幅と高さをセット
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    int getNum(){
        return MainPanel.NUM_ALIEN;   
    }
    
    
    
    
        //
    void move(int dir){
    }
    
}