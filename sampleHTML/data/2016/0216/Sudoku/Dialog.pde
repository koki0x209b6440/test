public class Dialog extends Logger {
  int x, y, t;
  String txt = "";

  public Dialog(int x, int y){
    this.x = x;
    this.y = y;
  }

  public void draw() {
    if (t-- > 0) {
      text(txt, x, y);
    }
  }

  // txtを120sec表示する
  public void show(String txt) {
    super.show(txt);
    this.txt = txt;
    t = 120;
  }
}
