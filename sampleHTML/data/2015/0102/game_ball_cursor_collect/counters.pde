
void counter_timer(){
  timeTimer++;
  if (timeTimer == 10) {
    timeTimer = 0;  
    time++;
    println(time);
    if(time >= 40){
      gameFinished = true;
    }
  }
}
