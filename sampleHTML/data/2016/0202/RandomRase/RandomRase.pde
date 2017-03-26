
/* 0809
　あみだくじ系のレースゲー。できるだけ短く。
　なんというか、単純に"進む権利"FINALNUM回分をどのレーサーに与えるかランダム分配する感じ。
　可愛い絵に走らせて、風景を野原にしたいね。
*/

int[] rNums = new int[10];
int[] lNums = new int[10];
int total = 0;
float xoff = 0.0;
final int RASENUM=1000;

void setup() {
  size(600, 600);
  background(255); 
  frameRate(500);
  line(50, 500, 550, 500);
  fill(0);
  text("goal", 20, 503);
}

void draw() {
  noStroke();
  float rnum = random(10);
  textSize(9);
  
  if (rnum > 0)
  {
    int i = int(rnum);
    rNums[i]++;
    if (rNums[i]>rNums[1] && 
        rNums[i]>rNums[2] && 
        rNums[i]>rNums[3] && 
        rNums[i]>rNums[4] && 
        rNums[i]>rNums[5] && 
        rNums[i]>rNums[6] && 
        rNums[i]>rNums[7] && 
        rNums[i]>rNums[8] && 
        rNums[i]>rNums[9])
        {
          //normal version.//ちょっと特殊な動き(ばたばたする。頻度をどう調整すれば良いかわからんが)
          fill(255,255,255);
          rect(50*(i+1), 0, 50, rNums[i]/2,0,0,10,10);
          fill(250, 50, 50);
          ellipse( (50*(i+1))+25, rNums[i]/2, 25,25);
          /* // another version.
          fill(250, 50, 50);
          rect(50*(i+1), 0, 50, rNums[i]/2,0,0,10,10);
          */
          if(lNums[i]>=lNums[1] && 
             lNums[i]>=lNums[2] && 
             lNums[i]>=lNums[3] && 
             lNums[i]>=lNums[4] && 
             lNums[i]>=lNums[5] && 
             lNums[i]>=lNums[6] && 
             lNums[i]>=lNums[7] && 
             lNums[i]>=lNums[8] && 
             lNums[i]>=lNums[9])
             {
               lNums[i]++;
             }
        } 
        else
        {
          //normal version.//普通に進軍。
          fill(255,255,255);
          rect(50*(i+1), 0, 50, rNums[i]/2,0,0,10,10);
          fill(100, 100, 100);
          ellipse( (50*(i+1))+25, rNums[i]/2, 25,25);
          /* //another version.
          fill(100, 100, 100);
          rect(50*(i+1), 0, 50, rNums[i]/2,0,0,10,10);
          */
        }
      //fill(255, 255, 255);
      fill(0);
      text(" #"+(i+1),(50*(i+1))+5, rNums[i]/2-20);//レーサー名
      if (rNums[i] == RASENUM)
      {
        fill(0);
        textSize(20);
        text("the winner is #"+(i+1), 50, 520);
        noLoop();
      }
  }
}



