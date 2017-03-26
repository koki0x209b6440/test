public class SolveAll extends SolveDelete {
  // 再帰で一個ずつ見てく
  boolean dfs(int idx){
    if (!field.checkwithreturn()) return false;
    if (idx == 0) {
      return true;
    }else{
      idx--;
      int x = idx % 9;
      int y = idx / 9;
      int pre = field.getBit(x, y);
      for(int i = 0; i < 9; i++) {
        if ((pre & (1 << i)) != 0) {
          field.fix(x, y, i + 1);
          if (dfs(idx)) return true;
          field.setBit(x, y, pre);
        }
      }
    }
    return false;
  }

  protected void works(){
    super.works();
    dfs(81);
  }
}
