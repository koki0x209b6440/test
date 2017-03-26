import java.awt.Graphics;
import java.awt.Image;

import javax.swing.ImageIcon;

/**********
 アニメーション。一コマ一コマずらーっと並んでいる画像を用意し、表示する位置(横スクロールゲームのオフセットと同様(?) )を順にずらしていく。
 
 
 *********/
public class Explosion extends Thread {
    private static final int SIZE = 20;// 爆発イメージのサイズ//画像サイズと要相談
    private Image explosionImage;
    private int count;//アニメーション用のカウンター//無理矢理すぎるかも
    
    private int x;
    private int y;

    
    public Explosion(int x, int y) {
        this.x = x;
        this.y = y;

        count = 0;

        ImageIcon icon = new ImageIcon(getClass()
                .getResource("image/explosion.gif"));
        explosionImage = icon.getImage();
        
        start();
    }
    

    public void draw(Graphics g) {
        g.drawImage(explosionImage, x, y, x + SIZE, y + SIZE, count * SIZE, 0, count * SIZE + SIZE, SIZE, null);
    }

    
    public void run() {
        while (true) {
            count++;
            if (count == 15) {//コマ数と要相談
                return;
            }
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
