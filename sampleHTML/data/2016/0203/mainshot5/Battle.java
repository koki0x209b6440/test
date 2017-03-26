import java.awt.Container;

import javax.swing.JFrame;

/********
 スタート画面が作りたければ、Menu.javaなどでゲーム開始フラグがたったときのこのBattleを生成させればよいはず。
 
 お世話になったサイト(自分用メモ)
 http://sky.geocities.jp/kmaedam/java2/java2.htm#RPG
 http://web.sfc.keio.ac.jp/~wadari/game/kadai/index.html
 http://web.sfc.keio.ac.jp/~wadari/game/kadai/2011/gp04.html
 http://kaz.cyteen.nagoya-bunri.ac.jp/game/
 http://d.hatena.ne.jp/aidiary/20040918/1251373370 (原型(インベーダーゲーム)をここから拝借)
 http://homepage2.nifty.com/natupaji/DxLib/lecture/lecture1_5.html
 http://codezine.jp/article/detail/94
 
 
 注意
 DataClip.javaとMidiEngine.javaとWaveEngine.javaはネットにあった物をそのままコピペ
 
 メモ
 javac *.javaの後、
 java Battleまたはjar cvfm HelloWorld.jar MANIFEST.MF *.class *.java se/*.wav bgm/*.mid image/*.gif

 ********/
public class Battle extends JFrame {
    public Battle() {
        
        setTitle("べーたバージョン");// タイトルを設定
        setResizable(false);// サイズ変更不可(マジックナンバー使用しているので)

        MainPanel panel = new MainPanel();
        Container contentPane = getContentPane();//フレームに追加
        contentPane.add(panel);

        pack();// パネルサイズに合わせてフレームサイズを自動設定
    }

    public static void main(String[] args) {
        Battle frame = new Battle();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}