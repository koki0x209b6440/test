import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.ImageIcon;

/*まだテキトウ。Shotの丸コピしてきただけだし。*/
//　↑継承とか使おうよ

public class Item {
    private static final int SPEED = 10;// 弾のスピード
    private static final Point STORAGE = new Point(MainPanel.ROW*MainPanel.CS, MainPanel.ROW*MainPanel.CS);// 弾の保管座標（画面に表示されない場所）
    
    private int x;
    private int y;
    private int width;
    private int height;
    
    private Image image;
    private MainPanel panel;// メインパネルへの参照//使わなかった気がする
    
    
    public Item(MainPanel panel) {
        x = STORAGE.x;
        y = STORAGE.y;
        this.panel = panel;
        
        loadImage();
    }
    
    
    public void appear(int n){
        Point target;
        if(n%2==0){
            target=new Point(2*MainPanel.CS,12*MainPanel.CS);
        }
        else{
            target=new Point(13*MainPanel.CS,2*MainPanel.CS);   
        }
        setPos(target);
        
    }
    
    
    public Point getPos() {
        return new Point(x, y);
    }
    public void setPos(Point target) {
        this.x = target.x;
        this.y = target.y;
    }
    public int getWidth() {
        return width;
    }
    public int getHeight() {
        return height;
    }
    public void store() {//弾を保管庫へ
        x = STORAGE.x;
        y = STORAGE.y;
    }
    public boolean isInStorage() {//弾が
        if (x == STORAGE.x && y == STORAGE.x){
            return true;
        }
        return false;
    }
    public void draw(Graphics g) {
        g.drawImage(image, x, y, null);
    }
    private void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource("image/shot.gif"));
        image = icon.getImage();
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    
}