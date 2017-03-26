class Prepare implements State {
  private List<RectFraction> peacesList;
  
  public Prepare() {
    peacesList = new ArrayList<RectFraction>();
  
    int w = 10;
    int h = 20;
  
    for(int x = w / 2; x < width; x += w) {
      for(int y = h / 2; y < height; y += h) {
        // 開始時間（遅延）の設定
        int delay = (int)sqrt( (x - width/2) * (x - width/2) + (y - height/2) * (y - height /2));
        
        // 破片の追加
        peacesList.add(new RectFraction(x, y, w, h, delay));
      }
    }
  }
  
  public State update() {
    boolean isFinished = true;    
    for(int i = 0; i < peacesList.size(); ++i)
      if(!peacesList.get(i).render()) isFinished = false;
    
    if(isFinished) return new Display();
    return this;
  }
}
