import java.util.HashSet;
import java.util.Set;

public class SolveDelete extends Solve {
  protected void works(){
    Set<Integer> delete = new HashSet<Integer>();
    Set<Integer> check = new HashSet<Integer>();
    boolean[][] used = new boolean[9][9];

    // 提示盤面での確定セルをdeleteに挿入する
    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        if (field.isFix(x, y)) {
          delete.add((y << 4) + x);
        }
      }
    }

    while(delete.size() + check.size() > 0) {
      // 確定セルと同グループのセルから可能性を消していく
      // 削除の対象になったセルをcheckに挿入する
      for(int p : delete) {
        int x = p & 0xf, y = p >> 4;
        used[y][x] = true;
        int[][] groups = getGroup(x, y);
        for(int[] group : groups) {
          for(int q : group) {
            int sx = q & 0xf, sy = q >> 4;
            if (used[sy][sx]) continue;
            if (!field.isFix(sx, sy))
              field.delete(sx, sy, x, y);
            check.add(q);
          }
        }
      }
      delete.clear();

      // 同グループ中から唯一のセルかどうかを判断し確定する
      // 確定セルになった場合はdeleteに挿入する
      for(int p : check) {
        int x = p & 0xf, y = p >> 4;
        int[][] groups = getGroup(x, y);
        for(int[] group : groups) {
          int bit = Cell.ALL;
          for(int q : group) {
            int sx = q & 0xf, sy = q >> 4;
            int b = field.getBit(sx, sy);
            bit &= p == q ? b : ~b;
          }
          if(bit != 0) {
            field.setBit(x, y, bit);
            delete.add(p);
          }
        }
      }
      check.clear();
    }
  }
}
