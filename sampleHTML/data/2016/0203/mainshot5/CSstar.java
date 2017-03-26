import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.ImageIcon;

/***************
 プレイヤーが撃つチャージショット
 貫通弾(MainPanelで管理)。ダメージ5(MainPanelで管理)。右クリックでチャージ後撃つ(MainPa)、一度撃つとしばらく撃てない(Mai)
 
 **************/
public class CSstar extends Bullet{
    private static final int PIERCE=1;
    
    public CSstar(MainPanel panel) {
        x = STORAGE.x;
        y = STORAGE.y;
        SPEED =3;
        ATTACK=5;
        type=PIERCE;
        vx=vy=0;
        this.panel = panel;
        
        loadImage();
    }

    
    void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource("image/CSstar.gif"));
        image = icon.getImage();
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    int getNum(){
        return MainPanel.NUM_SHOT;
    }
    
}