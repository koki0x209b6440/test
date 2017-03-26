import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;
import java.awt.Rectangle;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.ImageIcon;


/*
 * プレイヤー関連をここへ。MainPanelクラスのキー受付ルーチンなんかと関連が深く、Hitルーチン（移動した場合にマップのオブジェクトとぶつかるかシミュレーションする）の判別を経てから移動を行う仕組み。Hitルーチンがtrueのとき
 * 
 *
 *  
 */
public abstract class Chara {    
    public static final int PIERCE=1;
    
    public int speed;// 移動スピード(基準)
    
    public int hp;//暫定版なのでpublic。ソースには変数名で処理直書きな感じ。
    public int x;
    public int y;
    public boolean isCSHit=false;
    
    public Image image;
    public int width=0;
    public int height=0;
    public MainPanel panel;
    
    
    abstract void move(int dir);//プレイヤー側//キー入力を受けて、移動できそうなら移動する
    abstract void move(Chara player);//敵キャラが使用
    abstract void lockon();          //
    
    public boolean collideWith(Bullet bullet) {
            // プレイヤーの矩形を求める
        Rectangle rectOBJ = new Rectangle(x, y, width, height);
            // ビームの矩形を求める
        Point pos = bullet.getPos();
        Rectangle rectBullet = new Rectangle(pos.x, pos.y, 
                                           bullet.getWidth(), bullet.getHeight());
        
            // 矩形同士が重なっているか調べる
            // 重なっていたら衝突している
        return rectOBJ.intersects(rectBullet);
    }
    public boolean collideWith(Item bullet) {
            // プレイヤーの矩形を求める
        Rectangle rectOBJ = new Rectangle(x, y, width, height);
            // ビームの矩形を求める
        Point pos = bullet.getPos();
        Rectangle rectBullet = new Rectangle(pos.x, pos.y, 
                                             bullet.getWidth(), bullet.getHeight());
        
            // 矩形同士が重なっているか調べる
            // 重なっていたら衝突している
        return rectOBJ.intersects(rectBullet);
    }
    
    public void damage(int power){
        hp-=power;   
    }
    abstract void die();
    
    public Point getPos() {
        return new Point(x, y);
    }
    public Point getPosInMap() {
        int i,j;
        for(i=0; i<MainPanel.ROW; i++){
            for(j=0; j<MainPanel.COL; j++){
                if(MainPanel.map[i][j]==0)
                    if(  (j*MainPanel.CS)-width <x&&x< ( (j+1)*MainPanel.CS) )
                        if(  (i*MainPanel.CS)-height <y&&y<  ( (i+1)*MainPanel.CS) )
                            return new Point(i,j);
                
            }
        }
        return new Point(0,0);
    }
    public boolean isHitInMap(int newX, int newY){
        for(int i=0; i<MainPanel.ROW; i++){//対マップ
            for(int j=0; j<MainPanel.COL; j++){
                if(MainPanel.map[i][j]==1)
                    if(  ( j*MainPanel.CS)-width <newX&&newX< ( (j+1)*MainPanel.CS)  )
                        if(  ( i*MainPanel.CS)-height <newY&&newY<  ( (i+1)*MainPanel.CS)  )
                            return true;
            }
        }
        
        return false;
    }//移動先は障害物に当たる、という意味で
    public int getWidth() {
        return width;
    }
    public int getHeight() {
        return height;
    }
    abstract Point getQ();
    abstract boolean isAlive();

    
    
    public void draw(Graphics g) {
        g.drawImage(image, x, y, null);
    }
    abstract void loadImage();
    abstract int getNum();
    
}