import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import javax.swing.JPanel;
public class MainPanel extends JPanel implements Runnable {
    public static final int WIDTH=480;//ウインドウサイズの方
    public static final int HEIGHT=480;
    private BufferedImage bufImage;//画像関係//←はピクセル操作が可能(要検証)
    private WritableRaster raster;
    private Graphics bufG;
    private Image dbImage=null;  //ダブルバッファ(リング?)用。
    //↑ダブルバッファは理工学実験の「刺激文字出した時の反応速度計測するやつ(手書きレポートの)」を参考にjavadocで。
    private Graphics dbg;
    private static final int NUM_BALL=2;
    private Metaball[] metaball;
    
    
    public MainPanel() {
        setPreferredSize(new Dimension(WIDTH, HEIGHT));//合ってるか不安
        metaball=new Metaball[NUM_BALL];
        metaball[0]=new Metaball(WIDTH/2, HEIGHT/2, 3, 0);//動き(てきとう)
        metaball[1]=new Metaball(WIDTH/2, HEIGHT/2, -3, 0);
        Thread thread = new Thread(this);
        thread.start();
    }

    
    public void run() {
        while (true) {
            Update();  //ゲーム状態更新
            gameRender();  //レンダリング
            paintScreen(); //画面描画
            try {
                Thread.sleep(50);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }


    private void Update() {
        for (int i=0; i<NUM_BALL; i++) {
            metaball[i].move();
        }
    }


    private void gameRender() {
        if (dbImage==null) {// ダブルバッファリング用オブジェクトの生成
            dbImage=createImage(WIDTH, HEIGHT);
            if (dbImage==null) {
                return;
            } else {
                dbg=dbImage.getGraphics();
            }
        }
        //↓ネット参考(ちゃんと書いてあるものはなかったから試行錯誤)
        if (bufImage==null) {//ボール内を1ピクセルごとに細かく管理する(準備)(合ってるか解らん)
            bufImage=new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
            bufG=bufImage.getGraphics();
            raster=bufImage.getRaster();
        }
        
        bufG.setColor(Color.BLACK);         //背景//なぜか白にするとバグる(計算に影響でてる？)
        bufG.fillRect(0, 0, WIDTH, HEIGHT);
        for (int i=0; i<NUM_BALL; i++) {
            metaball[i].draw(raster); //rasterを渡してdraw()内でピクセル操作を行う
        }
        dbg.drawImage(bufImage, 0, 0, this);//バッファ使う
    }

    
    //↓ネット参考にした。(Graphicsが筆だとはじめて教えてくれた尊敬できるソースコード)
    private void paintScreen() {
        Graphics g;//筆
        try {
            g = getGraphics();
            if ((g != null) & (dbImage != null)) {
                g.drawImage(dbImage, 0, 0, null);
            }
            Toolkit.getDefaultToolkit().sync();
            g.dispose();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
