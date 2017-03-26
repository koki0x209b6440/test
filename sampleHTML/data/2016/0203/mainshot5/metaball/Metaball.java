import java.awt.image.WritableRaster;

public class Metaball {
    private int x;
    private int y;
    private int vx;
    private int vy;
    private Pixel[] pixels; // ボールの各ピクセル情報(四角形)
    private Palette palette; // パレット
    private static final int RADIUS=70; // ボールの半径
    
    private static final int MAX_PIXELS=(2 * RADIUS) * (2 * RADIUS); // 円を囲む四角形のピクセル数//ネットからの受け売り＆試行錯誤

    
    
    public Metaball(int x, int y, int vx, int vy) {
        this.x=x;
        this.y=y;
        this.vx=vx;
        this.vy=vy;
        pixels=new Pixel[MAX_PIXELS];
        for(int i=0; i<MAX_PIXELS; i++) {
            pixels[i]=new Pixel();
        }
        palette=new Palette();
        init();
    }


    public void init() {
        int no;//実際の色0~255

        int c = 0;

        // 円の中身の処理(z= r^2-x^2-y^2 >0)
        for(int i=-RADIUS; i < RADIUS; i++) {//注:“左端(-半径)から右端(+半径)まで"
            for (int j=-RADIUS; j<RADIUS; j++) {
                double z=RADIUS*RADIUS-i*i-j*j;//
                if(z<0){ //
                    no=0;
                }
                else{    //
                    //色決め。下三行はネットから受け売り。
                    z = Math.sqrt(z);
                    double t = z / RADIUS;
                    no = (int) (Palette.MAX_PAL * (t*t*t*t*t));//ここのtの数でメタボールらしさが変わる(多くしすぎると円が小さくなる(下の条件判定が原因)、少ないと)
                    
                    if(no>255){
                        no=255;
                    }
                    if(no<0){
                        no=0;
                    }
                }
                pixels[c].dx=i; //決めた(計算した)円内の色を記憶させる。
                pixels[c].dy=j; //パッと見解りづらい。二次元配列にすべきだっただろうか。
                pixels[c].no=no;//でもそれだと以降のdraw等で取り出しづらい(forが増える等)
                c++;
            }
        }
    }


    public void draw(WritableRaster raster) {
        for (int i=0; i<MAX_PIXELS; i++) {      //移動処理
            int newX=x+pixels[i].dx;
            if (newX<0 || newX>MainPanel.WIDTH){
                continue;
            }
            int newY=y+pixels[i].dy;
            if (newY<0 || newY>MainPanel.HEIGHT){
                continue;
            }

            int no=pixels[i].no;                //ボールの持つ色(重なってる部分にも対応)
            int[] color=palette.getColor(no);   //の一部分(1ピクセル)ををRGBで取り出す。
            int[] screen=new int[3];            //スクリーンの色をpに取り出す(R,G,B)
            raster.getPixel(newX,newY,screen);  //(=移動先の[現在の色])。
            
            for (int j=0; j<3; j++) {           // スクリーンの色pにボールの色を加算する
                screen[j]+=color[j];            // ([ボールの割当の色値])
                if (screen[j]>255)              
                    screen[j]=255;              
            }
            
            raster.setPixel(newX, newY, screen);//描画更新
        }
    }


    public void move() {
        x += vx;
        y += vy;

        if (x < RADIUS) {
            x = RADIUS;
            vx = -vx;
        }
        if (y < RADIUS) {
            y = RADIUS;
            vy = -vy;
        }
        if (x > MainPanel.WIDTH - RADIUS) {
            x = MainPanel.WIDTH - RADIUS;
            vx = -vx;
        }
        if (y > MainPanel.HEIGHT - RADIUS) {
            y = MainPanel.HEIGHT - RADIUS;
            vy = -vy;
        }
    }

    
    //以下、別クラス//構造体みたいな使い方//インナークラスって名称で合ってる？
    class Pixel {
        public int dx; // ボールの中心からの偏差
        public int dy;
        public int no; // パレット番号
    }

    class Palette {
        public static final int MAX_PAL = 256;
        private int[] red;
        private int[] green;
        private int[] blue;

        public Palette() {
            red=new int[MAX_PAL];     //ここ配列むっちゃ用意してるのは無駄かな？
            green=new int[MAX_PAL];
            blue=new int[MAX_PAL];

            init();
        }

        
        public void init() {
            int r,g,b;//計算用RGB。とある一カ所の。
            for (int i=0; i<MAX_PAL; i++) {
                r=g=b=0;             //各パレット番号にRGBを設定
                                     //ここのr,g,bの順番を変えると違う色のメタボールができる
                                     //案外てきとー。具体値指定するのは奇麗じゃなくなるかも。
                                     //弄るなら(i/4)の辺り。
                if(i>=0)b=4*i;       
                if(i>=2)g=4*i;       
                if(i>=4)r=4*(i/4);   
                if(r>255){           //上限
                    r=255;
                }
                if(g>255){
                    g=255;
                }
                if(b>255){
                    b=255;
                }
                red[i]=r;           //適応
                green[i]=g;         //
                blue[i]=b;          //
            }
        }


        public int[] getColor(int no) {
            int[] color=new int[3];
            color[0]=red[no];
            color[1]=green[no];
            color[2]=blue[no];
            return color;
        }//RGBは配列三番で表現。Point型みたいなの無いかな
    }
}
