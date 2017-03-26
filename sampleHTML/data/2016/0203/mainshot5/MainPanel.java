import java.awt.Font;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;

import java.io.IOException;
import java.util.Random;
import java.io.BufferedReader;
import java.io.InputStreamReader;

import javax.sound.midi.InvalidMidiDataException;
import javax.sound.midi.MidiUnavailableException;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.swing.JPanel;

import java.awt.Image;
import javax.swing.ImageIcon;
/*************
 　ウインドウとそこへの描画(音声も)、あと画面内の"物体"と自分自身の移動と敵の処理も。
 　メインのメイン。
 　現在、他クラスへメソッド譲渡中(神オブジェクトにしたくない)
 
 (言い換え)
 　jarをダブルクリックした時にでてくるウインドウのことをメインパネルと呼ぶらしい。（ので、そのウインドウ上におこる処理をこのクラスに分離した）
 ***************/

    //コメントの付け方がemacsの頃のやつなのでxcodeだと見にくい。書き直す予定たてとく。

    //弾の当たり判定が微妙。障害物すり抜けたりする。要デバッグ
public class MainPanel extends JPanel
implements
Runnable,
KeyListener,
MouseMotionListener,
MouseListener {
    
    /*まずマップ関係*/
    public static final int WIDTH = 576; // パネルサイズ//作りたいマップの行列の物体数と相談
    public static final int HEIGHT = 580;//
        //public static int ROW;//ロードメソッドで決めるからここじゃ数値入れてない
        //public static int COL;
    public static final int ROW = 15;    //マップ行数//15
    public static final int COL = 17;    //マップ列数//18
	
    public static final int CS = 32;//画面上の隠し(?)マス目処理
        //敵の移動ルート処理や当たり判定処理の簡単化
        //当たり判定などの正方形分割、その正方形の一辺の長さ
        //CS(チップセット)という名前に少し違和感
    private Image floorImage;
    private Image wallImage;
    private Image shotImage;
    
    private String mapname="map01.dat";
    public static int[][] map={// マップ 0:床 1:壁//グラフィック数にあわせて増やす予定
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,1,0,0,1,1,1,1,0,0,1,0,0,1,0,1},
	{1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1},
	{1,0,1,0,0,0,0,0,0,0,0,1,1,1,1,0,1},
	{1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1},
	{1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1},
	{1,0,0,0,1,0,0,0,1,0,1,0,0,1,0,0,1},
	{1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},
	{1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,1,1,1,0,0,0,1,1,1,1,1,1,1,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}};
	
	/**
	 {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},//こっちがCOL
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,1},
	 {1,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1},
	 {1,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	 {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}};
	 */
        //こっちがROW
    
    
    
    /*キャラ関係*/ //なら抽象クラスCharacterでも引き継がせた方がよくね？//当たり判定管理集約に採用予定
    private static final int LEFT = 0;   //方向の定数(defineの代替)
    private static final int RIGHT = 1;  //(操作関連で使用)
    private static final int UP = 2;     //
    private static final int DOWN=3;     //
    private int count=0;                         //キャラ速度の手抜き管理
    
    private boolean leftPressed  = false;// キーの状態(操作で絶対に使用)
    private boolean rightPressed = false;//
    private boolean upPressed    = false;//
    private boolean downPressed  = false;//
    private boolean firePressed  = false;//
    
	
    /*  「//宣言のみ」は基本initGame()サブルーチンで実際のオブジェクトが生成されているはず*/
    private Chara[] aliens;                       //エイリアン(命名は参考元のまま)//宣言のみ
    private Bullet[] beams;                        
    public static final int NUM_ALIEN =12;      
    public static final int NUM_BEAM = 20;        //ビームの数(連射間隔にも影響を与える)
    private static final int BEAM_INTERVAL = 300;//連射間隔
    private long lastBeam = 0;                    //敵が最後に発射した時間
    
    
    private Item[] items;                         //アイテムの数//宣言のみ
    private static final int NUM_ITEM=5;          //アイテム数
    private static final int ITEM_INTERVAL=30000; //出現確率
    private long lastAppear=0;                    //最後に出現した時間
	
    
    private Chara[] player;                       //宣言のみ
    private Image  playerImage;
    private Bullet[] shots;                        //通常弾(左クリ)//宣言のみ
    private static final int NORMAL=1;
    private static final int ONE_CARTRIGE=12;    //弾1カートリッジ12発
    private static int tama=ONE_CARTRIGE;
    private static final int FIRE_INTERVAL=700;  //長押し時の連射間隔(オート連射)
    public static final int NUM_SHOT = 2;       //連続発射できる弾の数
        //(手動連射はもっと速いけど)
    private long lastFire = 0;                   //自分が最後に発射した時間
    private Bullet[] csstar;                     //チャージショット(右クリ)//宣言のみ
    private static final int PIERCE=1;
    private static final int CSstar_INTERVAL=20000;//連射間隔
    private long lastCSstar=0;                   //自分が最後にCSを発射した時間
    private double size=0;                       //チャージ力
    private static final double CHARGING_SPEED=0.2;//チャージ力が膨らむスピード
    private static final double MAX_SIZE = 15.0; //チャージ力の最大サイズ
    private static final int FALSE = 0;          //チャージのフラグ管理
    private static final int CHARGING = 1;       //
    private static final int TRUE =2;            //
    private int chargePressed=FALSE;             //
    
    private Point target;                        //発射方向管理(返しやすいようにPoint型)
    
    
    private Explosion explosion;
    private static String[] soundNames = {"bom28_a.wav", "puu38.wav", "puu51.wav"};//サウンド
    private Random rand;
    private Thread gameLoop;
    
    private static final boolean DEBUG_MODE = false;
    
    
    public MainPanel() {
        setPreferredSize(new Dimension(WIDTH, HEIGHT));
        
        setFocusable(true);// パネルがキー、マウス入力を受け付けるようにする
        addMouseListener(this);
        addMouseMotionListener(this);
		
        initGame();                                      // ゲームの初期化
        rand = new Random();                             //
		
            //load(mapname);
        loadImage();                                     //イメージをロード
        for (int i=0; i<soundNames.length; i++) {        //サウンドをロード
            try {                                        //
                WaveEngine.load("se/" + soundNames[i]);  //
            } catch (LineUnavailableException e) {       //
                e.printStackTrace();                     //
            } catch (IOException e) {                    //
                e.printStackTrace();                     //
            } catch (UnsupportedAudioFileException e) {  //
                e.printStackTrace();                     //
            }                                            //
        }                                                //
        try {                                            //BGMをロード
            MidiEngine.load("bgm/tam-g07.mid");          //
        } catch (MidiUnavailableException e) {           //エラー処理
            e.printStackTrace();                         //(必要無いように感じるが、
        } catch (InvalidMidiDataException e) {           //(ネットのには大体書いてあった)
            e.printStackTrace();                         //
        } catch (IOException e) {                        //
            e.printStackTrace();                         //
        }                                                //
        MidiEngine.play(0);                              // BGMを再生
		
            // キーイベントリスナーを登録
        addKeyListener(this);
		
            // ゲームループ開始
        gameLoop = new Thread(this);
        gameLoop.start();
    }
	
    
    public void run() {
        while (true) {
			move();
			
                // 発射ボタンが押されたら弾を発射
            if (firePressed) {
                tryToFire();
            }
			else lastFire=0;//長押しじゃなくて連打だったら、待機時間なしで連射できる
			if(chargePressed==CHARGING && size<MAX_SIZE){
				size += CHARGING_SPEED;
			}
			if(chargePressed==TRUE){
				tryToCSstar();
				chargePressed=FALSE;
				size=0;
			}
            alienAttack();// エイリアンの攻撃
            appearItem();//アイテムの出現
            
            collisionDetectionMap(beams);
            collisionDetectionMap(shots);
            collisionDetection(aliens,shots);// 当たり判定
            collisionDetection(aliens,csstar);// 当たり判定
            collisionDetection(player,beams);// 当たり判定
            collisionDetection(items);// 当たり判定
            
			
            WaveEngine.render();
			
            repaint();//描画更新
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            
        }
    }
	
	
    private void initGame() {
		player=new Player[1];
        player[0]=new Player(WIDTH/3,HEIGHT-300,this);// プレイヤーを作成
        shots =new Shot[NUM_SHOT];                // 弾を作成
        csstar =new CSstar[NUM_SHOT];                // 弾を作成
        tama=ONE_CARTRIGE;
        for(int i =0; i<NUM_SHOT; i++) {          ////(for内でint宣言できる。便利)
            shots[i] = new Shot(this);            //
        }                                         //
		for(int i=0; i<NUM_SHOT; i++){            //
            csstar[i] = new CSstar(this);         //
        }
        aliens = new Alien[NUM_ALIEN];            //エイリアンを作成
        for (int i = 0; i < NUM_ALIEN; i++) {     //
            aliens[i] = new Alien(100 + (i % 10) * 40, 50 + (i / 10) * 40, 2, this);
        }
        beams = new Beam[NUM_BEAM];               // ビームを作成
        for (int i = 0; i < NUM_BEAM; i++) {      //
            beams[i] = new Beam(this);            //
        }
        items = new Item[NUM_ITEM];               // アイテムを作成
        for (int i = 0; i < NUM_ITEM; i++) {      //
            items[i] = new Item(this);            //
        }
		
    }//ゲームの初期化(初期値、ではない。ゲームオーバーのときにまた呼び出すから)
	
	
	
    private void move() {
            // プレイヤーを移動する
            // 何も押されていないときは移動しない//ボタンによる操作の処理は別の場所
        if(count%2==0){//移動速度が速すぎるので、強引に速度低下させた//手抜き
			if (leftPressed) {
				player[0].move(LEFT);
			} else if (rightPressed) {
				player[0].move(RIGHT);
			}
			if(upPressed){
				player[0].move(UP);
			}else if(downPressed){
				player[0].move(DOWN);
			}
			for (int i = 0; i < NUM_ALIEN; i++) {// エイリアン移動(AI)//攻撃は別記
				aliens[i].move(player[0]);
			}
			count=0;
        }
		count++;
		
		for (int i = 0; i < NUM_SHOT; i++) {// 弾道(自分の)
			shots[i].move();
		}
        for (int i = 0; i < NUM_SHOT; i++) {// 弾道(自分の)
            csstar[i].move();
        }
        for (int i = 0; i < NUM_BEAM; i++) {// 弾道(敵の)
            beams[i].move();
        }
		
    }
	
	
    private void tryToFire() {
		
        if (tama<=0 || System.currentTimeMillis() - lastFire < FIRE_INTERVAL) {
                //連射速度(長押しのとき一定連射。連打だったら速い連射できるようにしたい)
                //弾切れもこっち
            return;
        }
        lastFire = System.currentTimeMillis();
		
		for(int i = 0; i<NUM_SHOT; i++){//(イメージ)弾倉に弾があるのを確認
			if (shots[i].isInStorage()){//         残弾あれば発射
				
				Point pos = player[0].getPos();//(弾の座標をプレイヤーの座標に
				shots[i].setPos(pos.x + player[0].getWidth() / 2, pos.y,target);//移してから発射
                tama--;
				WaveEngine.play(2);//発砲音
				break;//1つ発射したらbreakでループをぬける
			}
		}
    }
	
	
    private void tryToCSstar() {
        if(System.currentTimeMillis() - lastCSstar<CSstar_INTERVAL){
            return;   
        }
        lastCSstar=System.currentTimeMillis();
        
		for(int i = 0; i<NUM_SHOT; i++){//(イメージ)弾倉に弾があるのを確認
			if (csstar[i].isInStorage()){//         残弾あれば発射
				
				Point pos = player[0].getPos();//(弾の座標をプレイヤーの座標に移してから発射
				csstar[i].setPos(pos.x + player[0].getWidth() / 2, pos.y,target);
				
				WaveEngine.play(2);//発砲音
				break;//1つ発射したらbreakでループをぬける
			}
		}
    }
    
	
    private void alienAttack() {
            // run一回でNUM_BEAMだけ発射する
            // つまりエイリアン1人になってもそいつがNUM_BEAM発射する(擬似的にボス化)
        for (int i = 0; i < NUM_BEAM; i++) {
                // エイリアンの攻撃
                // ランダムにエイリアンを選ぶ
            int n = rand.nextInt(NUM_ALIEN);
                // そのエイリアンが生きていればビーム発射
            if (aliens[n].isAlive()) {
                    // 発射されていないビームを見つける
                    // 1つ見つけたら発射してbreakでループをぬける
                for (int j = 0; j < NUM_BEAM; j++) {
                    if (beams[j].isInStorage()) {
                            // ビームが保管庫にあれば発射できる
                            // ビームの座標をエイリアンの座標にセットすれば発射される
						
                        if (System.currentTimeMillis() - lastBeam < BEAM_INTERVAL) {//連射速度
							return;
                        }
						lastBeam = System.currentTimeMillis();
						
                        Point pos = aliens[n].getPos();
						Point tg=player[0].getPos();
                        beams[j].setPos(pos.x + aliens[n].getWidth() / 2, pos.y,tg);
                        break;
                    }
                }
            }
        }
    }//手抜き
    
    
    private void appearItem(){
        int n = rand.nextInt(NUM_ITEM);
        if (items[n].isInStorage()) {
            if (tama>0 || System.currentTimeMillis() - lastAppear < ITEM_INTERVAL) {//連射速度(長押しのとき一定連射。連打だったら速い連射できるようにしたい)
                return;
            }
            lastAppear = System.currentTimeMillis();
            items[n].appear(n);
        }
    }//汎用性なし。暫定的な弾数補給オブジェ。(てんぷらのRoboの時のようにItemクラスを用意して行いたい)
	
    
    private void collisionDetectionMap(Bullet[] bullets) {
		
        Point pos;
		
		for(int i=0; i<MainPanel.ROW; i++){
			for(int j=0; j<MainPanel.COL; j++){
				if(MainPanel.map[i][j]==1){
					for(int k=0; k<bullets[0].getNum(); k++){
                    if(bullets[k].isInStorage())break;//発射されてない弾の判定は無駄なので。
						pos = bullets[k].getPos();
						if( (j*CS) <pos.x&&pos.x< ( (j+1)*CS)  )
							if( (i*CS) <pos.y&&pos.y<  ( (i+1)*CS)  ){
								bullets[k].store();
								break;
							}
					}
				}
			}
		}
    }//弾とマップ
	
    private void collisionDetection(Chara[] objs,Bullet[] bullets) {
        for(int i =0; i<objs[0].getNum(); i++){        //対CPU//プレイヤーの通常弾
            for(int j =0; j<bullets[0].getNum(); j++){ //j番目の弾と、
                if(bullets[j].isInStorage())break;//発射されてない弾の判定は無駄なので。
                if(objs[i].collideWith(bullets[j])){   //i番目のエイリアン(1vs1以上に対応)
                        //が衝突
					
                    explosion = new Explosion(objs[i].getPos().x, objs[i].getPos().y);// 爆発エフェクト生成してから、
                    if( !objs[i].isCSHit || bullets[j].getType()!=PIERCE){
                        objs[i].damage(bullets[j].getAttack() );
                    }
                    WaveEngine.play(1);//音(タヒ)再生
                    
                    if(bullets[j].getType()!=PIERCE){
                        bullets[j].store();  //弾は保管庫へ
                            //（保管庫へ送らなければ貫通弾になる）
                    }
                    else{
                        objs[i].isCSHit=true;       
                    }//貫通弾の一段ヒット処理
                    
                    if(aliens[i].hp<=0){
                        aliens[i].die();   //敵はタヒぬ(誤差はほとんど無し)
                    }
                    if(player[0].hp<=0){
                        initGame();        //ゲームオーバー
                    }
                    break;
                }
                else if(bullets[j].getType()==PIERCE){
                    objs[i].isCSHit=false;
                }
            }
        }
    }//衝突(対キャラ)
    private void collisionDetection(Item[] bullets){
        for (int i = 0; i < NUM_ITEM; i++) {//プレイヤーの弾数回復//予備弾倉取得に変えたいかも?
            if (player[0].collideWith(bullets[i])) {//プレーヤーとi番目のビームが衝突
                bullets[i].store();  //ビームは保管庫へ
                tama=ONE_CARTRIGE;//弾数マックスに回復
            }
        }   
    }
    
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        
        drawMap(g);
            // 背景を黒で塗りつぶす
            //g.setColor(Color.BLACK);
            //g.fillRect(0, 0, getWidth(), getHeight());
		
        player[0].draw(g);
		
		if(chargePressed==CHARGING){//プレイヤー装飾//チャージ中のパワーたまってる感じ
			g.setColor(Color.WHITE);
			g.fillOval(player[0].getPos().x, player[0].getPos().y,(int) size, (int) size);
		}
        
        for (int i = 0; i < NUM_ALIEN; i++) {
            aliens[i].draw(g);
        }
		
        for (int i = 0; i < NUM_SHOT; i++) {
            shots[i].draw(g);
        }
        for (int i = 0; i < NUM_SHOT; i++) {
            csstar[i].draw(g);
        }
		
        for (int i = 0; i < NUM_BEAM; i++) {
            beams[i].draw(g);
        }
        
        if (explosion != null) {
            explosion.draw(g);
        }
        
        for(int i=0; i<NUM_ITEM; i++){
            items[i].draw(g);   
        }
		
        if (DEBUG_MODE) {
            Font font = new Font("SansSerif", Font.BOLD, 16);
            g.setFont(font);
            g.setColor(Color.BLACK);
            g.drawString("player="+player[0].getPosInMap().x +","+player[0].getPosInMap().y,10,HEIGHT-10);
            g.drawString("enemy="+aliens[0].getPosInMap().x +","+aliens[0].getPosInMap().y,10,HEIGHT-30);
			g.drawString("target="+aliens[0].getQ().x +","+aliens[0].getQ().y,10,HEIGHT-50);
        }
        
        
            //画面下側のメニュー画面(HP表示、弾数表示など)
        int menu_pos=MainPanel.ROW*MainPanel.CS;
        g.setColor(Color.GRAY);
        g.fillRect(0, menu_pos, getWidth()/2, getHeight());//プレイヤー側
        g.fillRect(getWidth()/2, menu_pos, getWidth(), getHeight());//敵側
        g.setColor(Color.darkGray);
        g.drawRect(0, menu_pos, getWidth()/2, getHeight());//プレイヤー
        g.drawRect(getWidth()/2, menu_pos, getWidth(), getHeight());//敵側ウインドウ 
        int span=15;//弾の描画と弾の描画の間隔(時間のことではない)//弾
        for(int i=1; i<=tama; i++){
            g.drawImage(shotImage, 50+(i*span), menu_pos+10, this);
        }
        Font font = new Font("SansSerif", Font.BOLD, 16);//フォントタイプはコピペ元と同様
        g.setFont(font);
        g.setColor(Color.WHITE);
        g.drawString(" "+tama,(50+12*span)+10,menu_pos+20);//マジックナンバー使いまくり
        
        
        for(int i=1; i<=player[0].hp; i++){
            g.drawImage(playerImage, 50+(i*span), menu_pos+70, this);
        }
            //Font font = new Font("SansSerif", Font.BOLD, 16);//フォントタイプはコピペ元と同様
        g.setFont(font);
        g.setColor(Color.WHITE);
        g.drawString(" "+player[0].hp,(50+12*span)+10,menu_pos+80);//マジックナンバー使いまくり        
        if(System.currentTimeMillis() - lastCSstar<CSstar_INTERVAL){
            g.setColor(Color.RED); 
            g.drawString("CS<Empty>",50,HEIGHT);//マジックナンバー使いまくり
        }
        else{
            g.drawString("CS<ENABLE>",50,HEIGHT);//マジックナンバー使いまくり
        }
        
        
    }
	
    public void keyTyped(KeyEvent e) {
    }
    public void keyPressed(KeyEvent e) {
        int key = e.getKeyCode();
		
        if (key == KeyEvent.VK_LEFT) {
            leftPressed = true;
        }
        if (key == KeyEvent.VK_RIGHT) {
            rightPressed = true;
        }
        if (key == KeyEvent.VK_UP) {
            upPressed = true;
        }
        if (key == KeyEvent.VK_DOWN) {
            downPressed = true;
        }
		
    }//十字キー移動
    public void keyReleased(KeyEvent e) {
        int key = e.getKeyCode();
		
        if (key == KeyEvent.VK_LEFT) {
            leftPressed = false;
        }
        if (key == KeyEvent.VK_RIGHT) {
            rightPressed = false;
        }
        if (key == KeyEvent.VK_UP) {
            upPressed = false;
        }
        if (key == KeyEvent.VK_DOWN) {
            downPressed = false;
        }
		
    }//十字キー移動
    public void mousePressed(MouseEvent e){
		int btn = e.getButton();
            //Point target = e.getPoint();
		target = new Point(e.getX(),e.getY());
		if (btn == MouseEvent.BUTTON1){
            firePressed = true;
		}
		if (btn == MouseEvent.BUTTON3){
            chargePressed = CHARGING;
		}
    }//通常弾、CS撃つ(予備動作)
	
    public void mouseReleased(MouseEvent e) {
		int btn = e.getButton();
            //Point target = e.getPoint();
		target = new Point(e.getX(),e.getY());
		if (btn == MouseEvent.BUTTON1){
            firePressed = false;
		}
		if(btn ==MouseEvent.BUTTON3){
			if(size>14)chargePressed=TRUE;
			else{
				chargePressed=FALSE;
				size=0;
			}
		}
    }//通常弾、CS撃つ
    public void mouseDragged(MouseEvent e){
		if(firePressed){
			target = new Point(e.getX(),e.getY());
		}
    }//通常弾オート連射(長押し)させている時も照準動かせるように
    public void mouseClicked(MouseEvent e) {
    }
    public void mouseMoved(MouseEvent e) {
    }
    public void mouseEntered(MouseEvent e) {
    }
	
    public void mouseExited(MouseEvent e) {
    }
	
	
	
    private void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource("image/floor.gif"));
        floorImage = icon.getImage();
        
        icon = new ImageIcon(getClass().getResource("image/wall.gif"));
        wallImage = icon.getImage();
        
        icon = new ImageIcon(getClass().getResource("image/shot.gif"));
        shotImage = icon.getImage();
        
        icon = new ImageIcon(getClass().getResource("image/player.gif"));
        playerImage=icon.getImage();
        
    }
    
    
    private void drawMap(Graphics g) {
        for (int i = 0; i < ROW; i++) {
            for (int j = 0; j < COL; j++) {
                    // mapの値に応じて画像を描く
                switch (map[i][j]) {
                    case 0 : // 床
                        g.drawImage(floorImage, j * CS, i * CS, this);
                        break;
                    case 1 : // 壁
                        g.drawImage(wallImage, j * CS, i * CS, this);
                        break;
                }
            }
        }
    }
	
    public int[][] mapcopy(){
		int[][] mc =new int[ROW][];
		
		for(int i=0; i<ROW; i++){
			mc[i]=new int[COL];
			for(int j=0; j<COL; j++){
				mc[i][j]=map[i][j];
			}
		}
		return mc;
		
    }
	
	
}