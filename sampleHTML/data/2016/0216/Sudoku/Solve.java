public abstract class Solve implements Runnable {
  protected Field field;
  private Logger logger;
  private int [][] group = new int[3][9];
  private boolean running;

  public void solve(Field field, Logger logger){
    this.field = field;
    this.logger = logger;
    if (!running)
      new Thread(this).start();
  }

  /**
    * xyの位置のセルと同じグループのセルのxyを返す
    * 上位4bitにy,下位4bitにxの情報を入れる
    */
  protected int[][] getGroup(int x, int y){
    for (int i = 0; i < 9; i++) {
      group[0][i] = (y << 4) + i;   // horizontal
      group[1][i] = (i << 4) + x;   // vertical
      group[2][i] = (y / 3 * 3 + i / 3 << 4) + x / 3 * 3 + i % 3; //box
    }
    return group;
  }

  // この中に実装する
  protected abstract void works();

  public void run(){
    running = true;
    works();
    logger.show(field.check() ? "Correct!" : "Incorrect.");
    running = false;
  }
}
