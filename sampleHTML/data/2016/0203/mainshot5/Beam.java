import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import javax.swing.ImageIcon;

/***************
 敵が撃つビーム
 どれくらい撃つかとかはMainPanelの方で管理(←よくない)
 通常弾。貫通無し(MainPanelで管理)。ダメージ1(MainPanelで管理)
 
 **************/

public class Beam extends Bullet{
    private static final int NORMAL=0;
    
    public Beam(MainPanel panel) {
        x = STORAGE.x;
        y = STORAGE.y;
        SPEED =5;
        ATTACK=1;
        type=NORMAL;
        this.panel = panel;
        
        loadImage();
    }
    

    void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource("image/beam.gif"));
        image = icon.getImage();
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    int getNum(){
        return MainPanel.NUM_BEAM;   
    }
}