import java.awt.Container;
import javax.swing.JFrame;

public class Main extends JFrame {
    public Main() {
        setTitle("目標:ヌルヌル");
        setResizable(false);//
        MainPanel panel=new MainPanel();
        Container contentPane=getContentPane();
        contentPane.add(panel);
        pack();
    }
    public static void main(String[] args) {
        Main frame = new Main();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}
