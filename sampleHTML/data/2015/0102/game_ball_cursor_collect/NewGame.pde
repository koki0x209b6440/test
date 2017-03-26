void testAndSetIfNewGame(){ 
  
  if(newGame){
    
    for (int i=0;i<NumberOfBalls;i++) {
      ObjCircle[i] = new ClassArrayCircle(
      random(5, 585), //STARTING X POSITION
      random(5, 475), // STARTING Y POSITION
      10, // BALL DIAMETER
      color(random(0, 360), 47, 88), // STARTING COLOR
      random(0.1, 3.0), // STARTING X SPEED (xspeed)
      random(0.1, 3.0), // STARTN Y SPEED (yspeed)
      random(-5, 5), // X DIRRECTION (xdirection)
      random(-5, 5), // Y DIRRECTION (ydirection)
      i // THE UNIQ ID!
      );
    }//END OF FOR 
   newGame = false;   
  }  
  
}
