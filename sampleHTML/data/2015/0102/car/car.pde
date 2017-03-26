/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/27884*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*
 Car
 Made by Jared "BlueThen" Counts on April 30, 2011
 Updated May 4, 2011.
 www.bluethen.com
 www.twitter.com/BlueThen
 www.openprocessing.org/portal/?userID=3044
 www.hawkee.com/profile/37047/
 bluethen ( @ ) gmail.com
 
 Up/Down to accelerate or deaccelerate
 Left/Right to tilt
 Click and drag to pick up the car
 
 To get a higher score, drive on one wheel for as far as possible
*/

// World world: object where physics is handled
World world;

// scoreBoard: the onscreen text displaying the score
// we use a separate PGraphics for this because P2D (the main renderer) 
// draws crappy text
PGraphics scoreBoard;
PFont font;

/* Surface and surface properties */
// "Map" object is actually Java's interface for storing objects and retrieving them using keys
// in our case, the key will be the x coordinate, and the object returned is the surface's height
Map surface;
// higher amplitude for higher hills
float surfaceAmplitude = 300;
// higher frequency for rougher/jagged hills
float surfaceFrequency = 0.0025;

// The player's car
Car car;

/* Mouse stuff */
float mouseInfluenceSize = sq(8); 
// Tearing isn't really necessary, but we keep it anyways
// this is leftover from the Curtain applet @ http://bluethen.com/wordpress/index.php/processing-apps/curtain/
float mouseTearSize = sq(8);
boolean mouseAttachedToSomething = false;
PointMass attachedPM;

// translated mouse X position
int tmouseX;
//  firstX and lastX are the screen's first and last X coordinates, for translating
float firstX = width/2;
int lastX;

long seed = (long)random(1000000000);
/* Setup */
// Here everything is initialized (or set up) for the simulation
void setup () {
  /* rendering stuff */
  size(640, 480, P2D); 
  colorMode(HSB, 255);
  smooth();
  
  /* Initialize the scoreboard */
  // populationSign is rendered with JAVA2D because text renedered in P2D is ugly
  scoreBoard = createGraphics(300,200, JAVA2D);
  //font = loadFont("data\\ShowcardGothic-Reg-24.vlw");
  scoreBoard.beginDraw();
  //scoreBoard.textFont(font, 24);
  scoreBoard.endDraw();
  
  /* The object that handles all of the physics */
  // Parameters: TimeStep size (smaller is more accurate, but slower), constraint solve iterations (bigger is more accurate, but slower)
  // Feel free to experiment with different parameters
  world = new World(15, 3);

  /* Generate the surface for our vehicle */
  // Make sure the noise seed is consistent.
  surface = new HashMap();
  // if you ever want to play the same track twice, use this with seed equalling any long integer
  noiseSeed(seed);
  // only generate a surface for 0 to width
  for (int i = 0; i < width; i++) {
    // we use a "surfaceGenerate" function found at the bottom of car.pde (this file).
    surfaceGenerate(i); // surface.put(i, height - 300*noise(i*0.0025));
  }
  
  /* The player's car */
  // Parameters: PVector spawnPosition, int width (in pixels), int height (in pixels), int wheelRadius, int speed (as a force)
  car = new Car(new PVector(width/2, 100), 60, 30, 20, 10000);
  
  /* Race! This generates 20 vehicles, all simultaneously controlled by your Up/Down arrow keys */
  // Uncomment to race!
//  for (int i = 0; i < 20; i++) {
//    Car car = new Car(new PVector(random(width), random(height)), (int)random(10,100), (int)random(5,50), (int)random(5,30), (int)random(5000,20000));  
//  }
}
/* Draw */
// This function is iterated over and over by processing. It's our frame for the game
void draw () {
  // Erase everything with black
  background(0);

  // Make sure the noise seed is consistent.
  noiseSeed(seed);
  
  /* Translating */
  // Move the screen towards the car
  firstX += 0.2 * (((width/2 - (car.back.position.x + car.front.position.x)/2) - width/2) - firstX);
  lastX = (int)firstX + width;
  translate(firstX + width/2, 0);
  // Set a variable for the mouseX with translation applied, so the user can pick up the car
  tmouseX = mouseX + width/2 - lastX;

  /* Surface generating and displaying */
  for (int i = (int)firstX; i < lastX; i++) {
    int xPos = width/2-i;
    
    // Check if the surface at this point exists
    // if it doesn't, we generate one for it
    if (surface.containsKey(xPos) == false)
      surfaceGenerate(xPos);
    if (surface.containsKey(xPos-1) == false)
      surfaceGenerate(xPos-1);
      
    // Make it colorful
    stroke(abs(xPos) % 255, 255, 255);
    line(xPos, (Float)surface.get(xPos), xPos, height);
  }
  /* Update the physics */
  world.update();
  
  /* Update the on-screen score */
  updateScoreBoard();
  
  /* For the developer to keep track of the frameRate and surface size 
     The surface grows indefinitely, but it does not slow down the program, even after 1 million points
     so nothing is done about it for now. 
  */
  if (frameCount % 60 == 0)
    println("Frame Rate: " + frameRate + ", Surface size: " + surface.size());
}
/* Generate the surface at a single point */
void surfaceGenerate (int xPos) {
  // translation + amplitude * noise(iteration * frequency)
  surface.put(xPos, height - surfaceAmplitude * noise(xPos * surfaceFrequency));
}

