/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/43809*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ClassArrayCircle[] ObjCircle;
CursorPlayer ObjPlayer = new CursorPlayer();
// Settings:
int NumberOfBalls = 200;
int mouseGravity = 50;

//Start & Finish Button Position
float xButton = 320;
float yButton = 410;
float rButton = 60;

boolean newGame = true;
boolean go = false;
boolean gameFinished = false;

int time = 1; int timeTimer = 0; // Timer Vars
int collected = 0; int collectedTimer = 0; boolean count; // Collection Counter Vars
int whichGeometricObject = 1; int whichGeometricObjectTimer = 0;

PFont font_timerText;
PFont font_Numbers;
PFont font_collectedText;
PFont font_Big;

int score = 0;

void setup(){
  size(640, 480);
  frameRate(30);
  noCursor();
  ellipseMode(CENTER);
  rectMode(CENTER);
  smooth();
  colorMode(HSB, 360, 100, 100);
  font_timerText = loadFont("Impact-13.vlw");
  font_Numbers = loadFont("Impact-20.vlw");
  font_collectedText = loadFont("Impact-12.vlw");
  font_Big = loadFont("Impact-48.vlw");
  ObjCircle = new ClassArrayCircle[NumberOfBalls];
}
void draw(){
  background(#144446); 
  
  whichGeometricObjectTimer++;
  if (whichGeometricObjectTimer == 10) {
    whichGeometricObjectTimer = 0;  
    whichGeometricObject++;
    if (whichGeometricObject == 4) {
      whichGeometricObject = 1;
    }
  }
  
  counterDisplay();
  
  testAndSetIfNewGame();
  ObjPlayer.display();
  hub();
  timerLine();
  
  if(go == false && gameFinished == false){
    display_startingInfo();
  } else if (go == true && gameFinished == false){
    counter_timer(); 
   
    for (int i=0;i<NumberOfBalls;i++) {
      //ObjCircle[i].move();      //CANCELING THIS STOPS THEM FROM MOVING ON THEIR OWN!!!
      ObjCircle[i].cursorG();
      ObjCircle[i].display();
      ObjCircle[i].counter();
    }//END OF FOR
    
  } else if (go == true && gameFinished == true){
    display_fail();
  } else if (go == false && gameFinished == true){
    display_score();
  } 
  
}
