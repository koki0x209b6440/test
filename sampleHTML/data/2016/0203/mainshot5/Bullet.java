/******
 氏名:
 　小林祐希
 学生証番号：
 　144524
 演習番号:
 　
 提出日:
 
 実行結果:
 
 プログラムの動作説明:
 
 工夫した点:
 
 考察:
 
 感想:
 
 疑問点：
 
 
 ******/
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import java.awt.Color;
import java.awt.Dimension;


public abstract class Bullet{
    public int SPEED;// ビームのスピード(弾速のほう)(基準)
    public int ATTACK;
    public static final Point STORAGE = new Point(MainPanel.ROW*MainPanel.CS, MainPanel.ROW*MainPanel.CS);// ビームの保管座標（画面に表示されない場所）
    
    public int x;
    public int y;
    public int targetX;
    public int targetY;
    public double vx, vy;
    
    public int type;//通常弾か貫通弾か
    
    public Image image;
    public int width;
    public int height;
    
    public MainPanel panel;
    
    
    void move(){
        if (isInStorage()) // 保管庫に入っているなら何もしない
            return;        //言い換えればプレイヤーの座標に移された瞬間に弾発射される
        
        x += vx;//弾道(誘導弾ではない)
        y += vy;
        
            // 画面外の弾は保管庫行き
        if (y < 0 || y>MainPanel.HEIGHT) {
            store();
        }
        if(x<0 || x>MainPanel.WIDTH)
            store();   
    }//敵に向かってとぶ通常の動き//ホーミングミサイルとか作るならここオーバーライド
    
    
    Point getPos() {
        return new Point(x, y);
    }
    public int getAttack(){
        return ATTACK;   
    }
    public int getType(){
        return type;   
    }
    void setPos(int x, int y,Point target) {
        this.x = x;
        this.y = y;
        targetX=target.x;
        targetY=target.y;
        
        double direction = Math.atan2(targetY - y, targetX - x);//角度計算
        vx = Math.cos(direction) * SPEED;
        vy = Math.sin(direction) * SPEED;
    }
    
    int getWidth() {
        return width;
    }
    int getHeight() {
        return height;
    }
    void store() {
        x = STORAGE.x;
        y = STORAGE.y;
    }
    boolean isInStorage() {
        if (x == STORAGE.x && y == STORAGE.x)
            return true;
        return false;
    }
    void draw(Graphics g) {
        g.drawImage(image, x, y, null);
    }
    
    abstract void loadImage();
    abstract int getNum();
}

