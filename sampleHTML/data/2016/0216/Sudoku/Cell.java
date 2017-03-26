import java.util.List;

public class Cell {
  public static final int ALL = (1 << 9) - 1;
  public static final int NONE = 0;

  private int left_bit;
  private int fix_number;

  public Cell() {
    left_bit = ALL;
    fix_number = NONE;
  }

  private void fixCheck(){
    fix_number = Integer.bitCount(left_bit) == 1 ? Integer.numberOfTrailingZeros(left_bit) + 1 : NONE;
  }

  // セルをn(1-9)で確定する
  public void fix(int n) {
    if (n <= 0 || 10 <= n) return;
    left_bit = 1 << n - 1;
    fix_number = n;
  }

  public boolean isFix(){
    return fix_number != 0;
  }

  public int getNumber(){
    return fix_number;
  }

  public void clear(){
    left_bit = ALL;
    fix_number = NONE;
  }

  public void delete(int bit){
    left_bit &= ~bit;
    fixCheck();
  }

  public void setBit(int bit){
    left_bit = bit;
    fixCheck();
  }

  public int getBit(){
    return left_bit;
  }

  public void toggle(int n){
    if (n <= 0 || 10 <= n) return;
    left_bit ^= 1 << n - 1;
    fixCheck();
  }

}
