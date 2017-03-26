import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.ImageIcon;


public class Shot extends Bullet{
    private static final int NORMAL=0;
    
    public Shot(MainPanel panel) {
        x = STORAGE.x;
        y = STORAGE.y;
        SPEED = 10;
        ATTACK=1;
        type=NORMAL;
        vx=vy=0;
        this.panel = panel;
        
        loadImage();
    }
    
    
    void loadImage() {
        ImageIcon icon = new ImageIcon(getClass().getResource("image/shot.gif"));
        image = icon.getImage();
        width = image.getWidth(panel);
        height = image.getHeight(panel);
    }
    
    
    int getNum(){
        return MainPanel.NUM_SHOT;   
    }
}