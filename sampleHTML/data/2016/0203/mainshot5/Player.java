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
public class Player extends Chara{
    private static final int LEFT = 0;
    private static final int RIGHT = 1;
    private static final int UP = 2;
    private static final int DOWN = 3;
    
    public Player(int x, int y, MainPanel panel) {
        this.x = x;
        this.y = y;
        hp=10;
        speed = 3;
        this.panel = panel;
        
        loadImage();
    }
    
    
    public void move(int dir) {
        int newX=x;
        int newY=y;
        if (dir == LEFT) {
            newX-=speed;
        } else if (dir == RIGHT) {
            newX+=speed;
        }
        if(dir==UP){
            newY-=speed;
        }else if(dir==DOWN){
            newY+=speed;
        }
        
        if(isHitInMap(newX,newY)==false){
            x=newX;
            y=newY;
        }
        
    }//キー入力を受けて、移動できそうなら移動する
    
    void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource(
                                                              "image/player.gif"));
        image = icon.getImage();
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    int getNum(){
        return 1;   
    }
    
    
        //使わないけどabstractだから置いとかなきゃいけないもの
    void move(Chara player){
    }
    void lockon(){
    }
    void die(){
    }
    Point getQ(){
        return new Point(0,0);   
    }
    boolean isAlive(){
        return true;
    }
}